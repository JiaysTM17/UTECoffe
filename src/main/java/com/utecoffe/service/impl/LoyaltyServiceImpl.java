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

    @Override
    @Transactional
    public void accumulatePointsForOrder(Order order) {
        if (order.getUser() == null || order.getFinalAmount() == null) {
            return;
        }

        LoyaltyCard card = loyaltyCardRepository.findByUserId(order.getUser().getId()).orElse(null);
        if (card == null) {
            return;
        }

        // Rule: 1 point per 10,000 VND
        int pointsEarned = order.getFinalAmount().divide(BigDecimal.valueOf(10000)).intValue();
        if (pointsEarned <= 0) {
            return;
        }

        card.setPointsBalance(card.getPointsBalance() + pointsEarned);
        card.setLifetimePoints(card.getLifetimePoints() + pointsEarned);

        // Auto Tier Upgrade Check
        int lifetime = card.getLifetimePoints();
        if (lifetime >= 1000) {
            card.setTier(LoyaltyTier.DIAMOND);
        } else if (lifetime >= 500) {
            card.setTier(LoyaltyTier.GOLD);
        } else if (lifetime >= 100) {
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
                .description("Tich diem don hang #" + order.getOrderCode() + " (+" + pointsEarned + " hat vang)")
                .build();
        transactionRepository.save(tx);
    }

    @Override
    public LoyaltyCard getCardByUserId(Long userId) {
        return loyaltyCardRepository.findByUserId(userId).orElse(null);
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
                .description("Doi diem uu dai don hang #" + (order != null ? order.getOrderCode() : ""))
                .build();
        transactionRepository.save(tx);

        return true;
    }
}
