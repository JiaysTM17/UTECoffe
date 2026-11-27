package com.utecoffe;

import com.utecoffe.dto.response.CustomerIntelligenceSummaryDto;
import com.utecoffe.dto.response.RfmCustomerSegmentDto;
import com.utecoffe.entity.LoyaltyCard;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.User;
import com.utecoffe.enums.LoyaltyTier;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.repository.LoyaltyCardRepository;
import com.utecoffe.repository.OrderRepository;
import com.utecoffe.repository.UserRepository;
import com.utecoffe.service.CustomerIntelligenceService;
import com.utecoffe.service.impl.CustomerIntelligenceServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CustomerIntelligenceServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private OrderRepository orderRepository;

    @Mock
    private LoyaltyCardRepository loyaltyCardRepository;

    private CustomerIntelligenceService customerIntelligenceService;
    private User diamondUser;

    @BeforeEach
    void setUp() {
        customerIntelligenceService = new CustomerIntelligenceServiceImpl(
                userRepository, orderRepository, loyaltyCardRepository
        );

        diamondUser = User.builder()
                .id(10L)
                .fullName("Lê Hoàng Yến Vy")
                .email("vy.le@utecoffe.vn")
                .build();
    }

    @Test
    @DisplayName("Should classify customer as CHAMPIONS when ordering frequently with high spend")
    void testAnalyzeCustomerChampions() {
        LocalDateTime now = LocalDateTime.now();
        List<Order> orders = Arrays.asList(
                Order.builder().id(1L).user(diamondUser).status(OrderStatus.COMPLETED)
                        .finalAmount(BigDecimal.valueOf(500000)).createdAt(now.minusDays(20)).build(),
                Order.builder().id(2L).user(diamondUser).status(OrderStatus.COMPLETED)
                        .finalAmount(BigDecimal.valueOf(600000)).createdAt(now.minusDays(10)).build(),
                Order.builder().id(3L).user(diamondUser).status(OrderStatus.COMPLETED)
                        .finalAmount(BigDecimal.valueOf(700000)).createdAt(now.minusDays(2)).build()
        );

        when(userRepository.findById(10L)).thenReturn(Optional.of(diamondUser));
        when(orderRepository.findByUserIdOrderByCreatedAtDesc(10L)).thenReturn(orders);
        when(loyaltyCardRepository.findByUserId(10L)).thenReturn(Optional.of(
                LoyaltyCard.builder().user(diamondUser).tier(LoyaltyTier.DIAMOND).build()
        ));

        RfmCustomerSegmentDto dto = customerIntelligenceService.analyzeCustomer(10L);

        assertNotNull(dto);
        assertEquals(10L, dto.getUserId());
        assertEquals("DIAMOND", dto.getLoyaltyTier());
        assertEquals(3, dto.getFrequencyCount());
        assertEquals(BigDecimal.valueOf(1800000), dto.getMonetaryTotal());
        assertTrue(dto.getRecencyDays() <= 3);
        assertTrue(dto.getChurnProbability() < 25.0, "Active recent customer should have low churn probability");
        assertNotNull(dto.getRetentionActionRecommendation());
    }

    @Test
    @DisplayName("Should evaluate whole customer base into aggregated segments")
    void testAnalyzeCustomerSegments() {
        when(userRepository.findAll()).thenReturn(List.of(diamondUser));
        when(userRepository.findById(10L)).thenReturn(Optional.of(diamondUser));
        when(orderRepository.findByUserIdOrderByCreatedAtDesc(10L)).thenReturn(Collections.emptyList());
        when(loyaltyCardRepository.findByUserId(10L)).thenReturn(Optional.empty());

        CustomerIntelligenceSummaryDto summary = customerIntelligenceService.analyzeCustomerSegments();

        assertNotNull(summary);
        assertEquals(1, summary.getTotalEvaluatedCustomers());
        assertFalse(summary.getSegments().isEmpty());
    }
}
