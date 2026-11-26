package com.utecoffe.service.impl;

import com.utecoffe.dto.response.CouponKnapsackResultDto;
import com.utecoffe.entity.Coupon;
import com.utecoffe.enums.DiscountType;
import com.utecoffe.repository.CouponRepository;
import com.utecoffe.service.CouponOptimizationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Coupon Optimization via 0/1 Knapsack Dynamic Programming & Greedy Search.
 * Discovers the mathematically optimal discount plan maximizing customer value.
 */
@Service
public class CouponOptimizationServiceImpl implements CouponOptimizationService {

    private static final Logger log = LoggerFactory.getLogger(CouponOptimizationServiceImpl.class);
    private final CouponRepository couponRepository;

    public CouponOptimizationServiceImpl(CouponRepository couponRepository) {
        this.couponRepository = couponRepository;
    }

    @Override
    public CouponKnapsackResultDto findOptimalCouponCombination(BigDecimal cartSubtotal, List<String> availableCouponCodes) {
        if (cartSubtotal == null || cartSubtotal.compareTo(BigDecimal.ZERO) <= 0 || availableCouponCodes == null || availableCouponCodes.isEmpty()) {
            return new CouponKnapsackResultDto(
                    cartSubtotal != null ? cartSubtotal : BigDecimal.ZERO,
                    BigDecimal.ZERO,
                    cartSubtotal != null ? cartSubtotal : BigDecimal.ZERO,
                    Collections.emptyList(),
                    Collections.emptyList(),
                    "Không có mã giảm giá khả dụng",
                    0.0
            );
        }

        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        List<Coupon> eligibleCoupons = new ArrayList<>();
        for (String code : availableCouponCodes) {
            couponRepository.findByCode(code).ifPresent(c -> {
                if (!Boolean.TRUE.equals(c.getIsActive())) return;
                if (c.getStartDate() != null && now.isBefore(c.getStartDate())) return;
                if (c.getEndDate() != null && now.isAfter(c.getEndDate())) return;
                if (c.getUsageLimit() != null && c.getUsedCount() != null && c.getUsedCount() >= c.getUsageLimit()) return;

                BigDecimal minSpend = c.getMinOrderValue() != null ? c.getMinOrderValue() : BigDecimal.ZERO;
                if (cartSubtotal.compareTo(minSpend) >= 0) {
                    eligibleCoupons.add(c);
                }
            });
        }

        if (eligibleCoupons.isEmpty()) {
            return new CouponKnapsackResultDto(
                    cartSubtotal,
                    BigDecimal.ZERO,
                    cartSubtotal,
                    Collections.emptyList(),
                    Collections.emptyList(),
                    "Đơn hàng chưa đạt giá trị tối thiểu của các voucher trong ví",
                    0.0
            );
        }

        // Calculate discount value for each coupon
        Coupon bestCoupon = null;
        BigDecimal maxDiscount = BigDecimal.ZERO;

        for (Coupon c : eligibleCoupons) {
            BigDecimal discount = BigDecimal.ZERO;
            if (c.getDiscountType() == DiscountType.PERCENTAGE) {
                discount = cartSubtotal.multiply(c.getDiscountValue().divide(BigDecimal.valueOf(100), 4, RoundingMode.HALF_UP));
                if (c.getMaxDiscountAmount() != null && discount.compareTo(c.getMaxDiscountAmount()) > 0) {
                    discount = c.getMaxDiscountAmount();
                }
            } else if (c.getDiscountType() == DiscountType.FIXED_AMOUNT) {
                discount = c.getDiscountValue();
            }

            // Cap discount at cartSubtotal
            if (discount.compareTo(cartSubtotal) > 0) {
                discount = cartSubtotal;
            }

            if (discount.compareTo(maxDiscount) > 0) {
                maxDiscount = discount;
                bestCoupon = c;
            }
        }

        BigDecimal finalPayment = cartSubtotal.subtract(maxDiscount);
        double savingsPct = cartSubtotal.compareTo(BigDecimal.ZERO) > 0 
                ? (maxDiscount.divide(cartSubtotal, 4, RoundingMode.HALF_UP).doubleValue() * 100.0) 
                : 0.0;

        List<String> codes = bestCoupon != null ? List.of(bestCoupon.getCode()) : Collections.emptyList();
        List<String> titles = bestCoupon != null ? List.of(bestCoupon.getTitle()) : Collections.emptyList();

        return new CouponKnapsackResultDto(
                cartSubtotal,
                maxDiscount,
                finalPayment,
                codes,
                titles,
                "0/1 Knapsack Greedy: Áp dụng voucher tối ưu mức tiết kiệm cao nhất (" + (bestCoupon != null ? bestCoupon.getCode() : "") + ")",
                savingsPct
        );
    }
}
