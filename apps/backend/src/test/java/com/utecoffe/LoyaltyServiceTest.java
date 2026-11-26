package com.utecoffe;

import com.utecoffe.entity.LoyaltyCard;
import com.utecoffe.entity.LoyaltyTransaction;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.User;
import com.utecoffe.enums.LoyaltyTier;
import com.utecoffe.repository.LoyaltyCardRepository;
import com.utecoffe.repository.LoyaltyTransactionRepository;
import com.utecoffe.repository.UserRepository;
import com.utecoffe.service.impl.LoyaltyServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class LoyaltyServiceTest {

    @Mock
    private LoyaltyCardRepository loyaltyCardRepository;

    @Mock
    private LoyaltyTransactionRepository transactionRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private LoyaltyServiceImpl loyaltyService;

    private User user;
    private LoyaltyCard card;

    @BeforeEach
    void setUp() {
        user = User.builder().id(1L).fullName("Test User").build();
        card = LoyaltyCard.builder()
                .id(1L)
                .user(user)
                .cardNumber("#UTE-2026-0001")
                .pointsBalance(100)
                .lifetimePoints(100)
                .tier(LoyaltyTier.BRONZE)
                .build();
    }

    @Test
    void testAccumulatePoints_BronzeTier_Success() {
        Order order = Order.builder()
                .id(100L)
                .orderCode("UTE-261126-0001")
                .user(user)
                .finalAmount(BigDecimal.valueOf(100000))
                .build();

        when(transactionRepository.existsByOrderIdAndTransactionType(100L, "EARN")).thenReturn(false);
        when(loyaltyCardRepository.findByUserId(1L)).thenReturn(Optional.of(card));

        loyaltyService.accumulatePointsForOrder(order);

        // 100,000 VND / 10,000 = 10 base points
        // Total points: 100 + 10 = 110
        assertEquals(110, card.getPointsBalance());
        assertEquals(110, card.getLifetimePoints());
        verify(transactionRepository, times(1)).save(any(LoyaltyTransaction.class));
    }

    @Test
    void testAccumulatePoints_DiamondTier_DoublePoints() {
        card.setTier(LoyaltyTier.DIAMOND);
        card.setLifetimePoints(3500);

        Order order = Order.builder()
                .id(101L)
                .orderCode("UTE-261126-0002")
                .user(user)
                .finalAmount(BigDecimal.valueOf(200000))
                .build();

        when(transactionRepository.existsByOrderIdAndTransactionType(101L, "EARN")).thenReturn(false);
        when(loyaltyCardRepository.findByUserId(1L)).thenReturn(Optional.of(card));

        loyaltyService.accumulatePointsForOrder(order);

        // 200,000 / 10,000 = 20 base * 2x for Diamond = 40 points
        assertEquals(140, card.getPointsBalance());
        assertEquals(3540, card.getLifetimePoints());
        assertEquals(LoyaltyTier.DIAMOND, card.getTier());
    }

    @Test
    void testAccumulatePoints_Idempotent_DoesNotDuplicate() {
        Order order = Order.builder()
                .id(102L)
                .orderCode("UTE-261126-0003")
                .user(user)
                .finalAmount(BigDecimal.valueOf(100000))
                .build();

        when(transactionRepository.existsByOrderIdAndTransactionType(102L, "EARN")).thenReturn(true);

        loyaltyService.accumulatePointsForOrder(order);

        // Balance should not change
        assertEquals(100, card.getPointsBalance());
        verify(transactionRepository, never()).save(any(LoyaltyTransaction.class));
    }

    @Test
    void testReversePoints_WhenOrderCancelled_Success() {
        Order order = Order.builder()
                .id(103L)
                .orderCode("UTE-261126-0004")
                .user(user)
                .build();

        LoyaltyTransaction earnTx = LoyaltyTransaction.builder()
                .id(50L)
                .order(order)
                .pointsChange(25)
                .transactionType("EARN")
                .build();

        card.setPointsBalance(125);
        card.setLifetimePoints(125);

        when(transactionRepository.findByOrderIdAndTransactionType(103L, "EARN")).thenReturn(Optional.of(earnTx));
        when(transactionRepository.existsByOrderIdAndTransactionType(103L, "REVERSE")).thenReturn(false);
        when(loyaltyCardRepository.findByUserId(1L)).thenReturn(Optional.of(card));

        loyaltyService.reversePointsForOrder(order);

        assertEquals(100, card.getPointsBalance());
        assertEquals(100, card.getLifetimePoints());
        verify(transactionRepository, times(1)).save(argThat(tx -> 
                "REVERSE".equals(tx.getTransactionType()) && tx.getPointsChange() == -25));
    }

    @Test
    void testRedeemPoints_SufficientBalance_Success() {
        when(loyaltyCardRepository.findByUserId(1L)).thenReturn(Optional.of(card));

        boolean result = loyaltyService.redeemPoints(1L, 40, null);

        assertTrue(result);
        assertEquals(60, card.getPointsBalance());
        verify(transactionRepository, times(1)).save(any(LoyaltyTransaction.class));
    }

    @Test
    void testRedeemPoints_InsufficientBalance_ReturnsFalse() {
        when(loyaltyCardRepository.findByUserId(1L)).thenReturn(Optional.of(card));

        boolean result = loyaltyService.redeemPoints(1L, 250, null);

        assertFalse(result);
        assertEquals(100, card.getPointsBalance());
        verify(transactionRepository, never()).save(any(LoyaltyTransaction.class));
    }
}
