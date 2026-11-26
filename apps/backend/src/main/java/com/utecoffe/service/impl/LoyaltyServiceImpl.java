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

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(LoyaltyServiceImpl.class);

    @Override
    @Transactional
    public void accumulatePointsForOrder(Order order) {
        if (order == null || order.getId() == null || order.getUser() == null || order.getFinalAmount() == null) {
            return;
        }

        // Idempotency check: Do not earn points multiple times for the same order
        if (transactionRepository.existsByOrderIdAndTransactionType(order.getId(), "EARN")) {
            log.info("Loyalty points already accumulated for order #{}, skipping duplicate accumulation.", order.getOrderCode());
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
        updateCardTier(card);
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
        log.info("Accumulated {} loyalty points for user {} on order #{}", pointsEarned, order.getUser().getId(), order.getOrderCode());
    }

    @Override
    @Transactional
    public void reversePointsForOrder(Order order) {
        if (order == null || order.getId() == null || order.getUser() == null) {
            return;
        }

        var earnTxOpt = transactionRepository.findByOrderIdAndTransactionType(order.getId(), "EARN");
        if (earnTxOpt.isEmpty()) {
            return; // Order never earned points, nothing to reverse
        }

        if (transactionRepository.existsByOrderIdAndTransactionType(order.getId(), "REVERSE")) {
            log.info("Loyalty points already reversed for order #{}, skipping.", order.getOrderCode());
            return;
        }

        LoyaltyCard card = getCardByUserId(order.getUser().getId());
        if (card == null) {
            return;
        }

        int pointsToReverse = earnTxOpt.get().getPointsChange();
        card.setPointsBalance(Math.max(0, card.getPointsBalance() - pointsToReverse));
        card.setLifetimePoints(Math.max(0, card.getLifetimePoints() - pointsToReverse));
        updateCardTier(card);
        loyaltyCardRepository.save(card);

        LoyaltyTransaction reverseTx = LoyaltyTransaction.builder()
                .loyaltyCard(card)
                .order(order)
                .pointsChange(-pointsToReverse)
                .transactionType("REVERSE")
                .description("Thu hồi hạt vàng do đơn hàng #" + order.getOrderCode() + " bị hủy (-" + pointsToReverse + " hạt vàng)")
                .build();
        transactionRepository.save(reverseTx);
        log.info("Reversed {} loyalty points for user {} on cancelled order #{}", pointsToReverse, order.getUser().getId(), order.getOrderCode());
    }

    private void updateCardTier(LoyaltyCard card) {
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
