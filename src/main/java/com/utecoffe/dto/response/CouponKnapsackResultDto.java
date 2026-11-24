package com.utecoffe.dto.response;

import java.math.BigDecimal;
import java.util.List;

/**
 * Result DTO for Optimal Coupon Stacking via 0-1 Knapsack / Dynamic Programming.
 */
public class CouponKnapsackResultDto {
    private BigDecimal cartSubtotal;
    private BigDecimal maxDiscountAmount;
    private BigDecimal finalPaymentAmount;
    private List<String> optimalCouponCodes;
    private List<String> appliedCouponTitles;
    private String optimizationStrategy;
    private double savingsPercentage;

    public CouponKnapsackResultDto() {}

    public CouponKnapsackResultDto(BigDecimal cartSubtotal, BigDecimal maxDiscountAmount, BigDecimal finalPaymentAmount,
                                  List<String> optimalCouponCodes, List<String> appliedCouponTitles,
                                  String optimizationStrategy, double savingsPercentage) {
        this.cartSubtotal = cartSubtotal;
        this.maxDiscountAmount = maxDiscountAmount;
        this.finalPaymentAmount = finalPaymentAmount;
        this.optimalCouponCodes = optimalCouponCodes;
        this.appliedCouponTitles = appliedCouponTitles;
        this.optimizationStrategy = optimizationStrategy;
        this.savingsPercentage = savingsPercentage;
    }

    public BigDecimal getCartSubtotal() { return cartSubtotal; }
    public void setCartSubtotal(BigDecimal cartSubtotal) { this.cartSubtotal = cartSubtotal; }

    public BigDecimal getMaxDiscountAmount() { return maxDiscountAmount; }
    public void setMaxDiscountAmount(BigDecimal maxDiscountAmount) { this.maxDiscountAmount = maxDiscountAmount; }

    public BigDecimal getFinalPaymentAmount() { return finalPaymentAmount; }
    public void setFinalPaymentAmount(BigDecimal finalPaymentAmount) { this.finalPaymentAmount = finalPaymentAmount; }

    public List<String> getOptimalCouponCodes() { return optimalCouponCodes; }
    public void setOptimalCouponCodes(List<String> optimalCouponCodes) { this.optimalCouponCodes = optimalCouponCodes; }

    public List<String> getAppliedCouponTitles() { return appliedCouponTitles; }
    public void setAppliedCouponTitles(List<String> appliedCouponTitles) { this.appliedCouponTitles = appliedCouponTitles; }

    public String getOptimizationStrategy() { return optimizationStrategy; }
    public void setOptimizationStrategy(String optimizationStrategy) { this.optimizationStrategy = optimizationStrategy; }

    public double getSavingsPercentage() { return savingsPercentage; }
    public void setSavingsPercentage(double savingsPercentage) { this.savingsPercentage = savingsPercentage; }
}
