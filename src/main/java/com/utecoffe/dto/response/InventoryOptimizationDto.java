package com.utecoffe.dto.response;

import java.math.BigDecimal;

public class InventoryOptimizationDto {
    private Long ingredientId;
    private String ingredientName;
    private String sku;
    private String unit;
    private BigDecimal currentStock;
    private BigDecimal minThreshold;
    private BigDecimal costPrice;

    private double annualDemand;
    private double orderFixedCost;
    private double holdingCostPerUnit;
    private double eoqOptimalBatch;
    private double dailyDemandRate;
    private int supplierLeadTimeDays;
    private double safetyStock;
    private double reorderPoint;
    
    private String stockStatus;
    private String actionRecommendation;
    private double daysOfInventoryLeft;

    public InventoryOptimizationDto() {}

    public static InventoryOptimizationDtoBuilder builder() {
        return new InventoryOptimizationDtoBuilder();
    }

    public static class InventoryOptimizationDtoBuilder {
        private final InventoryOptimizationDto dto = new InventoryOptimizationDto();

        public InventoryOptimizationDtoBuilder ingredientId(Long ingredientId) { dto.ingredientId = ingredientId; return this; }
        public InventoryOptimizationDtoBuilder ingredientName(String ingredientName) { dto.ingredientName = ingredientName; return this; }
        public InventoryOptimizationDtoBuilder sku(String sku) { dto.sku = sku; return this; }
        public InventoryOptimizationDtoBuilder unit(String unit) { dto.unit = unit; return this; }
        public InventoryOptimizationDtoBuilder currentStock(BigDecimal currentStock) { dto.currentStock = currentStock; return this; }
        public InventoryOptimizationDtoBuilder minThreshold(BigDecimal minThreshold) { dto.minThreshold = minThreshold; return this; }
        public InventoryOptimizationDtoBuilder costPrice(BigDecimal costPrice) { dto.costPrice = costPrice; return this; }
        public InventoryOptimizationDtoBuilder annualDemand(double annualDemand) { dto.annualDemand = annualDemand; return this; }
        public InventoryOptimizationDtoBuilder orderFixedCost(double orderFixedCost) { dto.orderFixedCost = orderFixedCost; return this; }
        public InventoryOptimizationDtoBuilder holdingCostPerUnit(double holdingCostPerUnit) { dto.holdingCostPerUnit = holdingCostPerUnit; return this; }
        public InventoryOptimizationDtoBuilder eoqOptimalBatch(double eoqOptimalBatch) { dto.eoqOptimalBatch = eoqOptimalBatch; return this; }
        public InventoryOptimizationDtoBuilder dailyDemandRate(double dailyDemandRate) { dto.dailyDemandRate = dailyDemandRate; return this; }
        public InventoryOptimizationDtoBuilder supplierLeadTimeDays(int supplierLeadTimeDays) { dto.supplierLeadTimeDays = supplierLeadTimeDays; return this; }
        public InventoryOptimizationDtoBuilder safetyStock(double safetyStock) { dto.safetyStock = safetyStock; return this; }
        public InventoryOptimizationDtoBuilder reorderPoint(double reorderPoint) { dto.reorderPoint = reorderPoint; return this; }
        public InventoryOptimizationDtoBuilder stockStatus(String stockStatus) { dto.stockStatus = stockStatus; return this; }
        public InventoryOptimizationDtoBuilder actionRecommendation(String actionRecommendation) { dto.actionRecommendation = actionRecommendation; return this; }
        public InventoryOptimizationDtoBuilder daysOfInventoryLeft(double daysOfInventoryLeft) { dto.daysOfInventoryLeft = daysOfInventoryLeft; return this; }

        public InventoryOptimizationDto build() { return dto; }
    }

    public Long getIngredientId() { return ingredientId; }
    public void setIngredientId(Long ingredientId) { this.ingredientId = ingredientId; }
    public String getIngredientName() { return ingredientName; }
    public void setIngredientName(String ingredientName) { this.ingredientName = ingredientName; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public BigDecimal getCurrentStock() { return currentStock; }
    public void setCurrentStock(BigDecimal currentStock) { this.currentStock = currentStock; }
    public BigDecimal getMinThreshold() { return minThreshold; }
    public void setMinThreshold(BigDecimal minThreshold) { this.minThreshold = minThreshold; }
    public BigDecimal getCostPrice() { return costPrice; }
    public void setCostPrice(BigDecimal costPrice) { this.costPrice = costPrice; }
    public double getAnnualDemand() { return annualDemand; }
    public void setAnnualDemand(double annualDemand) { this.annualDemand = annualDemand; }
    public double getOrderFixedCost() { return orderFixedCost; }
    public void setOrderFixedCost(double orderFixedCost) { this.orderFixedCost = orderFixedCost; }
    public double getHoldingCostPerUnit() { return holdingCostPerUnit; }
    public void setHoldingCostPerUnit(double holdingCostPerUnit) { this.holdingCostPerUnit = holdingCostPerUnit; }
    public double getEoqOptimalBatch() { return eoqOptimalBatch; }
    public void setEoqOptimalBatch(double eoqOptimalBatch) { this.eoqOptimalBatch = eoqOptimalBatch; }
    public double getDailyDemandRate() { return dailyDemandRate; }
    public void setDailyDemandRate(double dailyDemandRate) { this.dailyDemandRate = dailyDemandRate; }
    public int getSupplierLeadTimeDays() { return supplierLeadTimeDays; }
    public void setSupplierLeadTimeDays(int supplierLeadTimeDays) { this.supplierLeadTimeDays = supplierLeadTimeDays; }
    public double getSafetyStock() { return safetyStock; }
    public void setSafetyStock(double safetyStock) { this.safetyStock = safetyStock; }
    public double getReorderPoint() { return reorderPoint; }
    public void setReorderPoint(double reorderPoint) { this.reorderPoint = reorderPoint; }
    public String getStockStatus() { return stockStatus; }
    public void setStockStatus(String stockStatus) { this.stockStatus = stockStatus; }
    public String getActionRecommendation() { return actionRecommendation; }
    public void setActionRecommendation(String actionRecommendation) { this.actionRecommendation = actionRecommendation; }
    public double getDaysOfInventoryLeft() { return daysOfInventoryLeft; }
    public void setDaysOfInventoryLeft(double daysOfInventoryLeft) { this.daysOfInventoryLeft = daysOfInventoryLeft; }
}
