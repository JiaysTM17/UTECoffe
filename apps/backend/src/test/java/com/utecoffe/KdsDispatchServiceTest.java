package com.utecoffe;

import com.utecoffe.dto.response.KdsPriorityOrderDto;
import com.utecoffe.dto.response.StationWorkloadSummaryDto;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.OrderItem;
import com.utecoffe.entity.Product;
import com.utecoffe.entity.User;
import com.utecoffe.enums.OrderType;
import com.utecoffe.repository.LoyaltyCardRepository;
import com.utecoffe.repository.OrderItemRepository;
import com.utecoffe.service.OrderService;
import com.utecoffe.service.impl.KdsDispatchServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class KdsDispatchServiceTest {

    @Mock
    private OrderService orderService;

    @Mock
    private OrderItemRepository orderItemRepository;

    @Mock
    private LoyaltyCardRepository loyaltyCardRepository;

    @InjectMocks
    private KdsDispatchServiceImpl kdsDispatchService;

    private Order espressoOrder;
    private Order pourOverOrder;

    @BeforeEach
    void setUp() {
        Product espresso = Product.builder().id(1L).name("Espresso Signature UTECoffe").build();
        Product pourOver = Product.builder().id(2L).name("Pour Over V60 Arabica Typica").build();

        espressoOrder = Order.builder()
                .id(101L)
                .orderCode("UTE-261126-0101")
                .orderType(OrderType.DINE_IN)
                .createdAt(LocalDateTime.now().minusMinutes(5))
                .build();

        pourOverOrder = Order.builder()
                .id(102L)
                .orderCode("UTE-261126-0102")
                .orderType(OrderType.TAKE_AWAY)
                .createdAt(LocalDateTime.now().minusMinutes(12))
                .build();

        OrderItem item1 = OrderItem.builder().id(1L).order(espressoOrder).product(espresso).quantity(1).build();
        OrderItem item2 = OrderItem.builder().id(2L).order(pourOverOrder).product(pourOver).quantity(2).build();

        when(orderItemRepository.findByOrderId(101L)).thenReturn(List.of(item1));
        when(orderItemRepository.findByOrderId(102L)).thenReturn(List.of(item2));
    }

    @Test
    void testGetOptimizedQueue_PrioritizesLongWaitingOrders() {
        when(orderService.getKdsOrdersForStore(1L)).thenReturn(List.of(espressoOrder, pourOverOrder));

        List<KdsPriorityOrderDto> queue = kdsDispatchService.getOptimizedQueue(1L);

        assertNotNull(queue);
        assertEquals(2, queue.size());
        // pourOverOrder waited 12 mins -> higher priority score than espressoOrder (5 mins)
        assertEquals(102L, queue.get(0).getOrderId());
        assertEquals("POUR_OVER_BAR", queue.get(0).getRecommendedStation());
    }

    @Test
    void testGetStationWorkloadSummary_CalculatesWorkloadAndBottlenecks() {
        when(orderService.getKdsOrdersForStore(1L)).thenReturn(List.of(espressoOrder, pourOverOrder));

        StationWorkloadSummaryDto summary = kdsDispatchService.getStationWorkloadSummary(1L);

        assertNotNull(summary);
        assertEquals(1L, summary.getStoreId());
        assertEquals(2, summary.getTotalActiveOrders());
        assertTrue(summary.getTotalPendingSeconds() > 0);

        var breakdown = summary.getStationBreakdown();
        assertNotNull(breakdown);
        assertTrue(breakdown.containsKey("ESPRESSO_BAR"));
        assertTrue(breakdown.containsKey("POUR_OVER_BAR"));
        assertTrue(breakdown.containsKey("PASTRIES"));

        assertEquals(1, breakdown.get("ESPRESSO_BAR").getTicketCount());
        assertEquals(1, breakdown.get("POUR_OVER_BAR").getTicketCount());

        assertNotNull(summary.getBottleneckStation());
        assertNotNull(summary.getDispatchRecommendation());
    }
}
