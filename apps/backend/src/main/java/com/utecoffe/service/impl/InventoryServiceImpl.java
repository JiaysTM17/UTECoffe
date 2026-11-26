package com.utecoffe.service.impl;

import com.utecoffe.entity.*;
import com.utecoffe.enums.InventoryTransactionType;
import com.utecoffe.repository.*;
import com.utecoffe.service.InventoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class InventoryServiceImpl implements InventoryService {

    @Autowired
    private StoreInventoryRepository storeInventoryRepository;

    @Autowired
    private InventoryLogRepository inventoryLogRepository;

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Override
    public boolean verifyStockForOrder(Order order) {
        List<OrderItem> items = orderItemRepository.findByOrderId(order.getId());
        for (OrderItem item : items) {
            List<Recipe> recipes = recipeRepository.findByProductId(item.getProduct().getId());
            for (Recipe recipe : recipes) {
                BigDecimal needed = recipe.getQuantityRequired().multiply(BigDecimal.valueOf(item.getQuantity()));
                StoreInventory inventory = storeInventoryRepository
                        .findByStoreIdAndIngredientId(order.getStore().getId(), recipe.getIngredient().getId())
                        .orElse(null);
                if (inventory == null || inventory.getCurrentStock().compareTo(needed) < 0) {
                    return false;
                }
            }
        }
        return true;
    }

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(InventoryServiceImpl.class);

    @Override
    @Transactional
    public void deductStockForOrder(Order order) {
        if (order == null || order.getId() == null) {
            return;
        }

        // Idempotency check: Do not deduct multiple times for the same order
        if (inventoryLogRepository.existsByReferenceOrderIdAndTransactionType(order.getId(), InventoryTransactionType.EXPORT_ORDER)) {
            log.info("Stock already deducted for order #{}, skipping duplicate deduction.", order.getOrderCode());
            return;
        }

        List<OrderItem> items = orderItemRepository.findByOrderId(order.getId());
        for (OrderItem item : items) {
            List<Recipe> recipes = recipeRepository.findByProductId(item.getProduct().getId());
            for (Recipe recipe : recipes) {
                BigDecimal needed = recipe.getQuantityRequired().multiply(BigDecimal.valueOf(item.getQuantity()));
                StoreInventory inventory = storeInventoryRepository
                        .findByStoreIdAndIngredientId(order.getStore().getId(), recipe.getIngredient().getId())
                        .orElse(null);

                if (inventory != null) {
                    BigDecimal updatedStock = inventory.getCurrentStock().subtract(needed);
                    if (updatedStock.compareTo(BigDecimal.ZERO) < 0) {
                        log.warn("Stock for ingredient {} in store {} fell below zero (current: {})", 
                                recipe.getIngredient().getName(), order.getStore().getName(), updatedStock);
                    }
                    inventory.setCurrentStock(updatedStock);
                    storeInventoryRepository.save(inventory);

                    InventoryLog invLog = InventoryLog.builder()
                            .store(order.getStore())
                            .ingredient(recipe.getIngredient())
                            .quantityChange(needed.negate())
                            .transactionType(InventoryTransactionType.EXPORT_ORDER)
                            .referenceOrderId(order.getId())
                            .note("Tự động trừ nguyên liệu cho đơn hàng #" + order.getOrderCode())
                            .build();
                    inventoryLogRepository.save(invLog);
                }
            }
        }
    }

    @Override
    @Transactional
    public void restoreStockForOrder(Order order) {
        if (order == null || order.getId() == null) {
            return;
        }

        // Only restore if stock was previously deducted
        boolean wasDeducted = inventoryLogRepository.existsByReferenceOrderIdAndTransactionType(
                order.getId(), InventoryTransactionType.EXPORT_ORDER);
        if (!wasDeducted) {
            log.info("No stock deduction recorded for order #{}, skipping stock restore.", order.getOrderCode());
            return;
        }

        // Check if already restored
        boolean alreadyRestored = inventoryLogRepository.existsByReferenceOrderIdAndTransactionType(
                order.getId(), InventoryTransactionType.ADJUSTMENT);
        if (alreadyRestored) {
            log.info("Stock already restored for order #{}, skipping duplicate restore.", order.getOrderCode());
            return;
        }

        List<OrderItem> items = orderItemRepository.findByOrderId(order.getId());
        for (OrderItem item : items) {
            List<Recipe> recipes = recipeRepository.findByProductId(item.getProduct().getId());
            for (Recipe recipe : recipes) {
                BigDecimal restoreQty = recipe.getQuantityRequired().multiply(BigDecimal.valueOf(item.getQuantity()));
                StoreInventory inventory = storeInventoryRepository
                        .findByStoreIdAndIngredientId(order.getStore().getId(), recipe.getIngredient().getId())
                        .orElse(null);

                if (inventory != null) {
                    inventory.setCurrentStock(inventory.getCurrentStock().add(restoreQty));
                    storeInventoryRepository.save(inventory);

                    InventoryLog invLog = InventoryLog.builder()
                            .store(order.getStore())
                            .ingredient(recipe.getIngredient())
                            .quantityChange(restoreQty)
                            .transactionType(InventoryTransactionType.ADJUSTMENT)
                            .referenceOrderId(order.getId())
                            .note("Hoàn trả nguyên liệu do đơn hàng #" + order.getOrderCode() + " bị hủy")
                            .build();
                    inventoryLogRepository.save(invLog);
                }
            }
        }
        log.info("Successfully restored inventory ingredients for cancelled order #{}", order.getOrderCode());
    }

    @Override
    public List<StoreInventory> getLowStockAlerts(Long storeId) {
        return storeInventoryRepository.findLowStockAlerts(storeId);
    }
}
