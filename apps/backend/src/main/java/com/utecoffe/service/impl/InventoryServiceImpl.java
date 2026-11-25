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

    @Override
    @Transactional
    public void deductStockForOrder(Order order) {
        List<OrderItem> items = orderItemRepository.findByOrderId(order.getId());
        for (OrderItem item : items) {
            List<Recipe> recipes = recipeRepository.findByProductId(item.getProduct().getId());
            for (Recipe recipe : recipes) {
                BigDecimal needed = recipe.getQuantityRequired().multiply(BigDecimal.valueOf(item.getQuantity()));
                StoreInventory inventory = storeInventoryRepository
                        .findByStoreIdAndIngredientId(order.getStore().getId(), recipe.getIngredient().getId())
                        .orElse(null);

                if (inventory != null) {
                    inventory.setCurrentStock(inventory.getCurrentStock().subtract(needed));
                    storeInventoryRepository.save(inventory);

                    InventoryLog log = InventoryLog.builder()
                            .store(order.getStore())
                            .ingredient(recipe.getIngredient())
                            .quantityChange(needed.negate())
                            .transactionType(InventoryTransactionType.EXPORT_ORDER)
                            .referenceOrderId(order.getId())
                            .note("Tu dong tru nguyen lieu cho don hang #" + order.getOrderCode())
                            .build();
                    inventoryLogRepository.save(log);
                }
            }
        }
    }

    @Override
    public List<StoreInventory> getLowStockAlerts(Long storeId) {
        return storeInventoryRepository.findLowStockAlerts(storeId);
    }
}
