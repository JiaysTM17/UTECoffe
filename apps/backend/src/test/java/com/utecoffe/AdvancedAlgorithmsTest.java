package com.utecoffe;

import com.utecoffe.dto.response.DeliveryRoutePlanDto;
import com.utecoffe.dto.response.OrderRiskAssessmentDto;
import com.utecoffe.entity.Coupon;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.User;
import com.utecoffe.enums.DiscountType;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.enums.OrderType;
import com.utecoffe.repository.OrderItemRepository;
import com.utecoffe.repository.OrderRepository;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.service.RouteOptimizationService.RouteStopInput;
import com.utecoffe.service.impl.FraudDetectionServiceImpl;
import com.utecoffe.service.impl.OrderServiceImpl;
import com.utecoffe.service.impl.RouteOptimizationServiceImpl;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.mock;

class AdvancedAlgorithmsTest {

    private final RouteOptimizationServiceImpl router = new RouteOptimizationServiceImpl(
            mock(StoreRepository.class), mock(OrderRepository.class), mock(OrderItemRepository.class));
    private final FraudDetectionServiceImpl fraud = new FraudDetectionServiceImpl(mock(OrderRepository.class));

    private static final double O_LAT = 10.8504, O_LON = 106.7719;

    @Test
    @DisplayName("2-opt route is a permutation of all stops and never longer than FIFO")
    void routeIsValidAndNotWorseThanFifo() {
        // Deliberately zig-zag FIFO order along a line east of the store
        double[] offsets = {0.05, 0.01, 0.04, 0.02, 0.03};
        List<RouteStopInput> stops = new ArrayList<>();
        for (int i = 0; i < offsets.length; i++) {
            stops.add(new RouteStopInput((long) i + 1, "UTE-" + i, "KH" + i, "09", "addr" + i,
                    O_LAT, O_LON + offsets[i], 2, 0));
        }
        DeliveryRoutePlanDto plan = router.optimizeRoute(1L, "Flagship", O_LAT, O_LON, stops);

        assertEquals(5, plan.getStops().size());
        Set<Long> ids = new HashSet<>();
        plan.getStops().forEach(s -> ids.add(s.getOrderId()));
        assertEquals(5, ids.size(), "every stop visited exactly once");
        assertTrue(plan.getOptimizedDistanceKm() <= plan.getNaiveDistanceKm());
        assertTrue(plan.getDistanceSavedPercent() > 20, "zig-zag should be heavily improved");
        // Optimal open path on a line is monotone: 0.01,0.02,...,0.05
        assertEquals(2L, plan.getStops().get(0).getOrderId());
        assertEquals(1L, plan.getStops().get(4).getOrderId());
        // Freshness strictly non-increasing along the route
        for (int i = 1; i < plan.getStops().size(); i++) {
            assertTrue(plan.getStops().get(i).getBeverageFreshnessScore()
                    <= plan.getStops().get(i - 1).getBeverageFreshnessScore());
        }
    }

    @Test
    @DisplayName("Empty stop list yields an empty, well-formed plan")
    void emptyRoute() {
        DeliveryRoutePlanDto plan = router.optimizeRoute(1L, "Flagship", O_LAT, O_LON, List.of());
        assertEquals(0, plan.getTotalStops());
        assertEquals(0.0, plan.getOptimizedDistanceKm());
        assertTrue(plan.getStops().isEmpty());
    }

    @Test
    @DisplayName("Missing coordinates are geocoded deterministically near the store")
    void pseudoGeocodeDeterministic() {
        List<RouteStopInput> s = List.of(new RouteStopInput(1L, "A", "x", "y", "KTX Khu A", null, null, 1, 0));
        DeliveryRoutePlanDto p1 = router.optimizeRoute(1L, "S", O_LAT, O_LON, s);
        DeliveryRoutePlanDto p2 = router.optimizeRoute(1L, "S", O_LAT, O_LON, s);
        assertEquals(p1.getStops().get(0).getLatitude(), p2.getStops().get(0).getLatitude());
        assertTrue(p1.getOptimizedDistanceKm() < 10);
    }

    @Test
    @DisplayName("Normal repeat customer is LOW risk; burst + cancels + huge amount is HIGH risk")
    void fraudScoring() {
        LocalDateTime now = LocalDateTime.of(2026, 11, 27, 14, 0);
        User loyal = User.builder().id(1L).createdAt(now.minusDays(200)).build();
        List<Order> history = new ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            history.add(Order.builder().id((long) i).user(loyal).status(OrderStatus.COMPLETED)
                    .finalAmount(BigDecimal.valueOf(80_000)).createdAt(now.minusDays(i)).build());
        }
        Order normal = Order.builder().id(100L).user(loyal).orderType(OrderType.TAKE_AWAY)
                .finalAmount(BigDecimal.valueOf(90_000)).createdAt(now).build();
        OrderRiskAssessmentDto low = fraud.score(normal, history);
        assertEquals("LOW", low.getRiskLevel());
        assertEquals("AUTO_APPROVE", low.getRecommendedAction());

        User fresh = User.builder().id(2L).createdAt(now.minusHours(2)).build();
        LocalDateTime night = now.withHour(2);
        List<Order> abuse = new ArrayList<>();
        for (int i = 1; i <= 4; i++) {
            abuse.add(Order.builder().id(200L + i).user(fresh).status(OrderStatus.CANCELLED)
                    .finalAmount(BigDecimal.valueOf(60_000)).createdAt(night.minusMinutes(i * 3)).build());
        }
        Order suspicious = Order.builder().id(300L).user(fresh).orderType(OrderType.DELIVERY)
                .finalAmount(BigDecimal.valueOf(1_500_000)).createdAt(night).build();
        OrderRiskAssessmentDto high = fraud.score(suspicious, abuse);
        assertEquals("HIGH", high.getRiskLevel());
        assertTrue(high.getRiskScore() > low.getRiskScore());
        assertFalse(high.getReasons().isEmpty());
    }

    @Test
    @DisplayName("Coupon discount is rounded, capped by max amount and never exceeds subtotal")
    void couponDiscountBounds() {
        Coupon pct = Coupon.builder().discountType(DiscountType.PERCENTAGE)
                .discountValue(BigDecimal.valueOf(15)).maxDiscountAmount(BigDecimal.valueOf(30_000)).build();
        assertEquals(0, OrderServiceImpl.computeCouponDiscount(pct, BigDecimal.valueOf(100_001))
                .compareTo(BigDecimal.valueOf(15_000)));
        assertEquals(0, OrderServiceImpl.computeCouponDiscount(pct, BigDecimal.valueOf(500_000))
                .compareTo(BigDecimal.valueOf(30_000)));

        Coupon fixed = Coupon.builder().discountType(DiscountType.FIXED_AMOUNT)
                .discountValue(BigDecimal.valueOf(50_000)).build();
        assertEquals(0, OrderServiceImpl.computeCouponDiscount(fixed, BigDecimal.valueOf(35_000))
                .compareTo(BigDecimal.valueOf(35_000)), "fixed discount capped at subtotal");
        assertEquals(0, OrderServiceImpl.computeCouponDiscount(fixed, BigDecimal.ZERO).signum());
    }
}
