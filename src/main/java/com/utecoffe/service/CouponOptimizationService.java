package com.utecoffe.service;

import com.utecoffe.dto.response.CouponKnapsackResultDto;

import java.math.BigDecimal;
import java.util.List;

public interface CouponOptimizationService {

    /**
     * Calculates the optimal combination of coupons using 0/1 Knapsack Dynamic Programming.
     *
     * @param cartSubtotal Total cart amount before discount.
     * @param availableCouponCodes List of candidate coupon codes held by user.
     * @return Optimization result showing max savings, applied coupons, and net total.
     */
    CouponKnapsackResultDto findOptimalCouponCombination(BigDecimal cartSubtotal, List<String> availableCouponCodes);
}
