package com.utecoffe.service.impl;

import com.utecoffe.entity.LoyaltyCard;
import com.utecoffe.entity.LoyaltyTransaction;
import com.utecoffe.entity.Order;
import com.utecoffe.enums.LoyaltyTier;
import com.utecoffe.repository.LoyaltyCardRepository;
import com.utecoffe.repository.LoyaltyTransactionRepository;
import com.utecoffe.service.LoyaltyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

@Service
public class LoyaltyServiceImpl implements LoyaltyService {

    @Autowired
    private LoyaltyCardRepository loyaltyCardRepository;

    @Autowired
    private LoyaltyTransactionRepository transactionRepository;

    @Autowired
    private com.utecoffe.repository.UserRepository userRepository;

    @Override
    @Transactional
    public void accumulatePointsForOrder(Order order) {
        if (order.getUser() == null || order.getFinalAmount() == null) {
            return;
        }

        LoyaltyCard card = getOrCreateCardForUser(order.getUser().getId());
        if (card == null) {
            return;
        }

        int pointsEarned = calculatePointsEarned(order);
        if (pointsEarned <= 0) {
            return;
        }

        card.setPointsBalance(card.getPointsBalance() + pointsEarned);
        card.setLifetimePoints(card.getLifetimePoints() + pointsEarned);

        // Auto Tier Upgrade Check matching UTEClub Tier Specification:
        // BRONZE (< 500), SILVER (500 - 1499), GOLD (1500 - 2999), DIAMOND (>= 3000)
        int lifetime = card.getLifetimePoints();
        if (lifetime >= 3000) {
            card.setTier(LoyaltyTier.DIAMOND);
        } else if (lifetime >= 1500) {
            card.setTier(LoyaltyTier.GOLD);
        } else if (lifetime >= 500) {
            card.setTier(LoyaltyTier.SILVER);
        } else {
            card.setTier(LoyaltyTier.BRONZE);
        }

        loyaltyCardRepository.save(card);

        // Transaction Audit Record
        LoyaltyTransaction tx = LoyaltyTransaction.builder()
                .loyaltyCard(card)
                .order(order)
                .pointsChange(pointsEarned)
                .transactionType("EARN")
                .description("Tích lũy hạt vàng từ đơn hàng #" + order.getOrderCode() + " (+" + pointsEarned + " hạt vàng)")
                .build();
        transactionRepository.save(tx);
    }

    @Override
    public int calculatePointsEarned(Order order) {
        if (order == null || order.getFinalAmount() == null) {
            return 0;
        }
        int basePoints = order.getFinalAmount().divide(BigDecimal.valueOf(10000)).intValue();
        if (basePoints <= 0) {
            return 0;
        }

        if (order.getUser() != null) {
            LoyaltyCard card = getCardByUserId(order.getUser().getId());
            if (card != null && card.getTier() != null) {
                return switch (card.getTier()) {
                    case DIAMOND -> basePoints * 2; // 2.0x Double Points for VIP Diamond
                    case GOLD -> (int) Math.round(basePoints * 1.5); // 1.5x for Gold VIP
                    case SILVER -> (int) Math.round(basePoints * 1.25); // 1.25x for Silver
                    default -> basePoints;
                };
            }
        }
        return basePoints;
    }

    @Override
    public LoyaltyCard getCardByUserId(Long userId) {
        if (userId == null) return null;
        return loyaltyCardRepository.findByUserId(userId).orElse(null);
    }

    @Override
    @Transactional
    public LoyaltyCard getOrCreateCardForUser(Long userId) {
        if (userId == null) return null;
        return loyaltyCardRepository.findByUserId(userId).orElseGet(() -> {
            com.utecoffe.entity.User user = userRepository.findById(userId).orElse(null);
            LoyaltyCard newCard = LoyaltyCard.builder()
                    .user(user)
                    .cardNumber("#UTE-2026-" + String.format("%04d", userId))
                    .pointsBalance(100) // Welcome bonus 100 points
                    .lifetimePoints(100)
                    .tier(LoyaltyTier.BRONZE)
                    .build();
            return loyaltyCardRepository.save(newCard);
        });
    }

    @Override
    @Transactional
    public boolean redeemPoints(Long userId, int points, Order order) {
        LoyaltyCard card = getCardByUserId(userId);
        if (card == null || card.getPointsBalance() < points) {
            return false;
        }

        card.setPointsBalance(card.getPointsBalance() - points);
        loyaltyCardRepository.save(card);

        LoyaltyTransaction tx = LoyaltyTransaction.builder()
                .loyaltyCard(card)
                .order(order)
                .pointsChange(-points)
                .transactionType("REDEEM")
                .description("Đổi hạt vàng ưu đãi cho đơn hàng #" + (order != null ? order.getOrderCode() : "trực tuyến"))
                .build();
        transactionRepository.save(tx);

        return true;
    }
}
