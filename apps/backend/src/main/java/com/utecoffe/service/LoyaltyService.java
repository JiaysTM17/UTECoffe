package com.utecoffe.service;

import com.utecoffe.entity.LoyaltyCard;
import com.utecoffe.entity.Order;

public interface LoyaltyService {
    void accumulatePointsForOrder(Order order);
    LoyaltyCard getCardByUserId(Long userId);
    LoyaltyCard getOrCreateCardForUser(Long userId);
    int calculatePointsEarned(Order order);
    boolean redeemPoints(Long userId, int points, Order order);
}
