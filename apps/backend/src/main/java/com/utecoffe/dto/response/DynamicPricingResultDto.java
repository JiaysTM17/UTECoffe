package com.utecoffe.dto.response;

import java.math.BigDecimal;

/**
 * Result DTO for Dynamic Pricing & Yield Management Algorithm.
 */
public class DynamicPricingResultDto {
    private Long productId;
    private String productName;
    private BigDecimal basePrice;
    private BigDecimal dynamicPrice;
    private BigDecimal discountAmount;
    private double discountPercentage;
    private String pricingReason;
    private String timeWindow;
    private boolean isSurge;
    private boolean isHappyHour;
    private boolean isShelfLifeClearance;

    public DynamicPricingResultDto() {}

    public DynamicPricingResultDto(Long productId, String productName, BigDecimal basePrice, BigDecimal dynamicPrice,
                                 BigDecimal discountAmount, double discountPercentage, String pricingReason,
                                 String timeWindow, boolean isSurge, boolean isHappyHour, boolean isShelfLifeClearance) {
        this.productId = productId;
        this.productName = productName;
        this.basePrice = basePrice;
        this.dynamicPrice = dynamicPrice;
        this.discountAmount = discountAmount;
        this.discountPercentage = discountPercentage;
        this.pricingReason = pricingReason;
        this.timeWindow = timeWindow;
        this.isSurge = isSurge;
        this.isHappyHour = isHappyHour;
        this.isShelfLifeClearance = isShelfLifeClearance;
    }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }

    public BigDecimal getDynamicPrice() { return dynamicPrice; }
    public void setDynamicPrice(BigDecimal dynamicPrice) { this.dynamicPrice = dynamicPrice; }

    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }

    public double getDiscountPercentage() { return discountPercentage; }
    public void setDiscountPercentage(double discountPercentage) { this.discountPercentage = discountPercentage; }

    public String getPricingReason() { return pricingReason; }
    public void setPricingReason(String pricingReason) { this.pricingReason = pricingReason; }

    public String getTimeWindow() { return timeWindow; }
    public void setTimeWindow(String timeWindow) { this.timeWindow = timeWindow; }

    public boolean isSurge() { return isSurge; }
    public void setSurge(boolean surge) { isSurge = surge; }

    public boolean isHappyHour() { return isHappyHour; }
    public void setHappyHour(boolean happyHour) { isHappyHour = happyHour; }

    public boolean isShelfLifeClearance() { return isShelfLifeClearance; }
    public void setShelfLifeClearance(boolean shelfLifeClearance) { isShelfLifeClearance = shelfLifeClearance; }
}
