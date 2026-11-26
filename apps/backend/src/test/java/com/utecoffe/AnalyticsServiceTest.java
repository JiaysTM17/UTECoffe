package com.utecoffe;

import com.utecoffe.dto.response.ExecutiveAnalyticsDto;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.Store;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.enums.OrderType;
import com.utecoffe.repository.OrderRepository;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.service.impl.AnalyticsServiceImpl;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AnalyticsServiceTest {

    @Mock
    private OrderRepository orderRepository;

    @Mock
    private StoreRepository storeRepository;

    @Mock
    private com.utecoffe.repository.OrderItemRepository orderItemRepository;

    @Mock
    private com.utecoffe.repository.PaymentRepository paymentRepository;

    @InjectMocks
    private AnalyticsServiceImpl analyticsService;

    @Test
    void testGetExecutiveAnalytics_ComputesKpisAccurately() {
        Store store1 = Store.builder().id(1L).name("UTECoffe Thu Duc").address("01 Vo Van Ngan").build();
        Store store2 = Store.builder().id(2L).name("UTECoffe Quan 1").address("68 Le Loi").build();

        Order order1 = Order.builder()
                .id(1L)
                .store(store1)
                .status(OrderStatus.COMPLETED)
                .finalAmount(BigDecimal.valueOf(100000))
                .orderType(OrderType.DINE_IN)
                .createdAt(LocalDateTime.of(2026, 11, 26, 9, 30))
                .build();

        Order order2 = Order.builder()
                .id(2L)
                .store(store1)
                .status(OrderStatus.COMPLETED)
                .finalAmount(BigDecimal.valueOf(200000))
                .orderType(OrderType.TAKE_AWAY)
                .createdAt(LocalDateTime.of(2026, 11, 26, 9, 45))
                .build();

        Order order3 = Order.builder()
                .id(3L)
                .store(store2)
                .status(OrderStatus.CANCELLED)
                .finalAmount(BigDecimal.valueOf(50000))
                .orderType(OrderType.DELIVERY)
                .createdAt(LocalDateTime.of(2026, 11, 26, 14, 0))
                .build();

        when(storeRepository.findAll()).thenReturn(List.of(store1, store2));
        when(orderRepository.findAll()).thenReturn(List.of(order1, order2, order3));

        ExecutiveAnalyticsDto analytics = analyticsService.getExecutiveAnalytics();

        assertNotNull(analytics);
        assertEquals(BigDecimal.valueOf(300000), analytics.getTotalRevenue());
        assertEquals(3, analytics.getTotalOrders());
        assertEquals(2, analytics.getCompletedOrders());
        assertEquals(1, analytics.getCancelledOrders());
        assertEquals(BigDecimal.valueOf(150000), analytics.getAverageOrderValue()); // 300,000 / 2
        assertEquals(33.3, analytics.getCancellationRate()); // 1 / 3 * 100%
        assertEquals(9, analytics.getPeakHour()); // Hour 9 has 2 orders
        assertEquals(1, analytics.getDineInCount());
        assertEquals(1, analytics.getTakeAwayCount());
        assertEquals(1, analytics.getDeliveryCount());

        // Stores
        assertEquals(2, analytics.getStorePerformances().size());
        var s1 = analytics.getStorePerformances().stream().filter(s -> s.getStoreId().equals(1L)).findFirst().orElseThrow();
        assertEquals(2, s1.getOrderCount());
        assertEquals(BigDecimal.valueOf(300000), s1.getRevenue());
        assertEquals(100.0, s1.getRevenueSharePercentage());
    }

    @Test
    void testGetStoreProductSalesAnalytics_Success() {
        Store store1 = Store.builder().id(1L).name("UTECoffe Thu Duc").address("01 Vo Van Ngan").build();

        Order order1 = Order.builder()
                .id(1L)
                .store(store1)
                .status(OrderStatus.COMPLETED)
                .finalAmount(BigDecimal.valueOf(150000))
                .build();

        Order order2 = Order.builder()
                .id(2L)
                .store(store1)
                .status(OrderStatus.CANCELLED)
                .finalAmount(BigDecimal.valueOf(50000))
                .build();

        com.utecoffe.entity.Product coldBrew = com.utecoffe.entity.Product.builder().id(10L).name("Cold Brew Cam Vang").build();
        com.utecoffe.entity.OrderItem item1 = com.utecoffe.entity.OrderItem.builder()
                .id(101L)
                .product(coldBrew)
                .quantity(2)
                .subtotal(BigDecimal.valueOf(118000))
                .build();

        when(storeRepository.findById(1L)).thenReturn(java.util.Optional.of(store1));
        when(orderRepository.findAll()).thenReturn(List.of(order1, order2));
        when(orderItemRepository.findByOrderId(1L)).thenReturn(List.of(item1));

        com.utecoffe.dto.response.StoreSalesPerformanceDto dto = analyticsService.getStoreProductSalesAnalytics(1L);

        assertNotNull(dto);
        assertEquals(1L, dto.getStoreId());
        assertEquals("UTECoffe Thu Duc", dto.getStoreName());
        assertEquals(2, dto.getTotalOrders());
        assertEquals(1, dto.getCompletedOrders());
        assertEquals(1, dto.getCancelledOrders());
        assertEquals(BigDecimal.valueOf(150000), dto.getTotalRevenue());
        assertEquals(BigDecimal.valueOf(150000.00).setScale(2), dto.getAverageOrderValue());

        assertFalse(dto.getTopSellingProducts().isEmpty());
        var topProduct = dto.getTopSellingProducts().get(0);
        assertEquals(10L, topProduct.getProductId());
        assertEquals("Cold Brew Cam Vang", topProduct.getProductName());
        assertEquals(2, topProduct.getQuantitySold());
    }
}
