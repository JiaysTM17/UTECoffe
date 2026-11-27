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

    @Autowired(required = false)
    private StoreRepository storeRepository;

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
                    BigDecimal current = inventory.getCurrentStock() != null ? inventory.getCurrentStock() : BigDecimal.ZERO;
                    // Never drive physical stock negative: deduct only what is actually on hand
                    BigDecimal actualDeducted = needed.min(current.max(BigDecimal.ZERO));
                    if (actualDeducted.compareTo(needed) < 0) {
                        log.warn("Insufficient stock for ingredient {} in store {}: needed {}, available {}",
                                recipe.getIngredient().getName(), order.getStore().getName(), needed, current);
                    }
                    inventory.setCurrentStock(current.subtract(actualDeducted));
                    storeInventoryRepository.save(inventory);

                    InventoryLog invLog = InventoryLog.builder()
                            .store(order.getStore())
                            .ingredient(recipe.getIngredient())
                            .quantityChange(actualDeducted.negate())
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

        // Preferred path: replay the exact ledger entries (handles recipe edits & partial deductions)
        List<InventoryLog> exportLogs = inventoryLogRepository.findByReferenceOrderIdAndTransactionType(
                order.getId(), InventoryTransactionType.EXPORT_ORDER);
        if (exportLogs != null && !exportLogs.isEmpty()) {
            for (InventoryLog exp : exportLogs) {
                if (exp.getIngredient() == null || exp.getQuantityChange() == null) continue;
                BigDecimal restoreQty = exp.getQuantityChange().abs();
                if (restoreQty.signum() == 0) continue;
                StoreInventory inventory = storeInventoryRepository
                        .findByStoreIdAndIngredientId(order.getStore().getId(), exp.getIngredient().getId())
                        .orElse(null);
                if (inventory == null) continue;
                BigDecimal cur = inventory.getCurrentStock() != null ? inventory.getCurrentStock() : BigDecimal.ZERO;
                inventory.setCurrentStock(cur.add(restoreQty));
                storeInventoryRepository.save(inventory);
                inventoryLogRepository.save(InventoryLog.builder()
                        .store(order.getStore())
                        .ingredient(exp.getIngredient())
                        .quantityChange(restoreQty)
                        .transactionType(InventoryTransactionType.ADJUSTMENT)
                        .referenceOrderId(order.getId())
                        .note("Hoàn trả nguyên liệu do đơn hàng #" + order.getOrderCode() + " bị hủy")
                        .build());
            }
            log.info("Successfully restored inventory ingredients for cancelled order #{}", order.getOrderCode());
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

    @Override
    public com.utecoffe.dto.response.InventoryHealthDto getStoreInventoryHealth(Long storeId) {
        String storeName = "Toàn Hệ Thống UTECoffe";
        if (storeId != null && storeId > 0 && storeRepository != null) {
            var storeOpt = storeRepository.findById(storeId);
            if (storeOpt.isPresent()) storeName = storeOpt.get().getName();
        }

        List<StoreInventory> inventories = (storeId != null && storeId > 0)
                ? storeInventoryRepository.findByStoreId(storeId)
                : storeInventoryRepository.findAll();

        int total = inventories.size();
        int healthy = 0;
        int low = 0;
        int critical = 0;
        int outOfStock = 0;

        List<com.utecoffe.dto.response.InventoryHealthDto.UrgentRestockItemDto> urgentItems = new java.util.ArrayList<>();

        for (StoreInventory inv : inventories) {
            BigDecimal cur = (inv.getCurrentStock() != null) ? inv.getCurrentStock() : BigDecimal.ZERO;
            BigDecimal safe = (inv.getSafetyStock() != null) ? inv.getSafetyStock() : BigDecimal.valueOf(100);
            BigDecimal minThresh = (inv.getIngredient() != null && inv.getIngredient().getMinThreshold() != null)
                    ? inv.getIngredient().getMinThreshold()
                    : safe.multiply(BigDecimal.valueOf(1.5));

            Ingredient ing = inv.getIngredient();
            String ingName = (ing != null) ? ing.getName() : "Nguyên liệu #" + inv.getId();
            String sku = (ing != null) ? ing.getSku() : "SKU-" + inv.getId();
            String unit = (ing != null && ing.getUnit() != null) ? ing.getUnit() : "đơn vị";

            if (cur.compareTo(BigDecimal.ZERO) <= 0) {
                outOfStock++;
                BigDecimal suggested = safe.multiply(BigDecimal.valueOf(3));
                urgentItems.add(com.utecoffe.dto.response.InventoryHealthDto.UrgentRestockItemDto.builder()
                        .ingredientId(ing != null ? ing.getId() : null)
                        .ingredientName(ingName)
                        .sku(sku)
                        .unit(unit)
                        .currentStock(cur)
                        .safetyStock(safe)
                        .suggestedOrderQuantity(suggested)
                        .urgencyLevel("OUT_OF_STOCK")
                        .build());
            } else if (cur.compareTo(safe) <= 0) {
                critical++;
                BigDecimal suggested = safe.multiply(BigDecimal.valueOf(2.5)).subtract(cur);
                urgentItems.add(com.utecoffe.dto.response.InventoryHealthDto.UrgentRestockItemDto.builder()
                        .ingredientId(ing != null ? ing.getId() : null)
                        .ingredientName(ingName)
                        .sku(sku)
                        .unit(unit)
                        .currentStock(cur)
                        .safetyStock(safe)
                        .suggestedOrderQuantity(suggested)
                        .urgencyLevel("CRITICAL")
                        .build());
            } else if (cur.compareTo(minThresh) <= 0) {
                low++;
                BigDecimal suggested = minThresh.multiply(BigDecimal.valueOf(2)).subtract(cur);
                urgentItems.add(com.utecoffe.dto.response.InventoryHealthDto.UrgentRestockItemDto.builder()
                        .ingredientId(ing != null ? ing.getId() : null)
                        .ingredientName(ingName)
                        .sku(sku)
                        .unit(unit)
                        .currentStock(cur)
                        .safetyStock(safe)
                        .suggestedOrderQuantity(suggested)
                        .urgencyLevel("LOW")
                        .build());
            } else {
                healthy++;
            }
        }

        double healthScore = (total > 0)
                ? Math.round(((double) healthy / total) * 1000.0) / 10.0
                : 100.0;

        String verdict;
        if (healthScore >= 85.0) {
            verdict = "KHO HÀNG AN TOÀN: Chuỗi cung ứng vận hành tối ưu, nguồn nguyên liệu dồi dào sẵn sàng cho giờ cao điểm.";
        } else if (healthScore >= 60.0) {
            verdict = "CẢNH BÁO TỒN KHO: Một số nguyên liệu hạt hoặc sữa tươi chạm ngưỡng đặt hàng lại, cần tạo đơn mua PO sớm.";
        } else {
            verdict = "NGUY CƠ ĐỨT GÃY: Tồn kho chạm đáy an toàn, khuyến nghị cấp bách phát lệnh nhập nguyên liệu hỏa tốc.";
        }

        return com.utecoffe.dto.response.InventoryHealthDto.builder()
                .storeId(storeId)
                .storeName(storeName)
                .totalIngredientsTracked(total)
                .healthyStockCount(healthy)
                .lowStockCount(low)
                .criticalStockCount(critical)
                .outOfStockCount(outOfStock)
                .healthScorePercent(healthScore)
                .healthVerdict(verdict)
                .urgentRestockItems(urgentItems)
                .build();
    }
}
