package com.utecoffe.dto.response;

import lombok.*;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InventoryHealthDto {
    private Long storeId;
    private String storeName;
    private int totalIngredientsTracked;
    private int healthyStockCount;
    private int lowStockCount;
    private int criticalStockCount;
    private int outOfStockCount;
    private double healthScorePercent;
    private String healthVerdict;
    private List<UrgentRestockItemDto> urgentRestockItems;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class UrgentRestockItemDto {
        private Long ingredientId;
        private String ingredientName;
        private String sku;
        private String unit;
        private BigDecimal currentStock;
        private BigDecimal safetyStock;
        private BigDecimal suggestedOrderQuantity;
        private String urgencyLevel;
    }
}
