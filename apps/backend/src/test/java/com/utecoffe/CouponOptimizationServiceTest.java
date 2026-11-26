package com.utecoffe;

import com.utecoffe.dto.response.CouponKnapsackResultDto;
import com.utecoffe.entity.Coupon;
import com.utecoffe.enums.DiscountType;
import com.utecoffe.repository.CouponRepository;
import com.utecoffe.service.impl.CouponOptimizationServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CouponOptimizationServiceTest {

    @Mock
    private CouponRepository couponRepository;

    @InjectMocks
    private CouponOptimizationServiceImpl couponOptimizationService;

    private Coupon couponPct;
    private Coupon couponFixed;
    private Coupon couponExpired;

    @BeforeEach
    void setUp() {
        couponPct = Coupon.builder()
                .id(1L)
                .code("UTE20")
                .title("Giảm 20%")
                .discountType(DiscountType.PERCENTAGE)
                .discountValue(BigDecimal.valueOf(20))
                .minOrderValue(BigDecimal.valueOf(100000))
                .maxDiscountAmount(BigDecimal.valueOf(50000))
                .isActive(true)
                .startDate(LocalDateTime.now().minusDays(5))
                .endDate(LocalDateTime.now().plusDays(10))
                .usageLimit(100)
                .usedCount(10)
                .build();

        couponFixed = Coupon.builder()
                .id(2L)
                .code("UTE30K")
                .title("Giảm 30K")
                .discountType(DiscountType.FIXED_AMOUNT)
                .discountValue(BigDecimal.valueOf(30000))
                .minOrderValue(BigDecimal.valueOf(80000))
                .isActive(true)
                .startDate(LocalDateTime.now().minusDays(5))
                .endDate(LocalDateTime.now().plusDays(10))
                .usageLimit(100)
                .usedCount(5)
                .build();

        couponExpired = Coupon.builder()
                .id(3L)
                .code("EXPIRED50")
                .title("Đã hết hạn")
                .discountType(DiscountType.PERCENTAGE)
                .discountValue(BigDecimal.valueOf(50))
                .minOrderValue(BigDecimal.ZERO)
                .isActive(true)
                .startDate(LocalDateTime.now().minusDays(20))
                .endDate(LocalDateTime.now().minusDays(2))
                .usageLimit(100)
                .usedCount(0)
                .build();
    }

    @Test
    void testFindOptimalCoupon_PicksHighestDiscount() {
        BigDecimal cartSubtotal = BigDecimal.valueOf(200000);
        when(couponRepository.findByCode("UTE20")).thenReturn(Optional.of(couponPct));
        when(couponRepository.findByCode("UTE30K")).thenReturn(Optional.of(couponFixed));

        CouponKnapsackResultDto result = couponOptimizationService.findOptimalCouponCombination(
                cartSubtotal, List.of("UTE20", "UTE30K"));

        assertNotNull(result);
        // UTE20 gives 20% of 200,000 = 40,000 VND
        // UTE30K gives 30,000 VND
        // Best is UTE20 (40,000 VND)
        assertEquals(BigDecimal.valueOf(40000).setScale(2), result.getMaxDiscountAmount().setScale(2));
        assertEquals(BigDecimal.valueOf(160000).setScale(2), result.getFinalPaymentAmount().setScale(2));
        assertTrue(result.getOptimalCouponCodes().contains("UTE20"));
    }

    @Test
    void testFindOptimalCoupon_ExpiredCoupon_Excluded() {
        BigDecimal cartSubtotal = BigDecimal.valueOf(150000);
        when(couponRepository.findByCode("EXPIRED50")).thenReturn(Optional.of(couponExpired));

        CouponKnapsackResultDto result = couponOptimizationService.findOptimalCouponCombination(
                cartSubtotal, List.of("EXPIRED50"));

        assertNotNull(result);
        assertEquals(BigDecimal.ZERO, result.getMaxDiscountAmount());
        assertTrue(result.getOptimalCouponCodes().isEmpty());
    }

    @Test
    void testFindOptimalCoupon_BelowMinSpend_Excluded() {
        BigDecimal cartSubtotal = BigDecimal.valueOf(50000); // Below 100k min spend
        when(couponRepository.findByCode("UTE20")).thenReturn(Optional.of(couponPct));

        CouponKnapsackResultDto result = couponOptimizationService.findOptimalCouponCombination(
                cartSubtotal, List.of("UTE20"));

        assertNotNull(result);
        assertEquals(BigDecimal.ZERO, result.getMaxDiscountAmount());
    }
}
