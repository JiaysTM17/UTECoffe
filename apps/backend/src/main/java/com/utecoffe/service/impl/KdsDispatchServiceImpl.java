package com.utecoffe.service.impl;

import com.utecoffe.dto.response.KdsPriorityOrderDto;
import com.utecoffe.entity.LoyaltyCard;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.OrderItem;
import com.utecoffe.entity.User;
import com.utecoffe.enums.OrderType;
import com.utecoffe.repository.LoyaltyCardRepository;
import com.utecoffe.repository.OrderItemRepository;
import com.utecoffe.service.KdsDispatchService;
import com.utecoffe.service.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class KdsDispatchServiceImpl implements KdsDispatchService {

    private static final Logger log = LoggerFactory.getLogger(KdsDispatchServiceImpl.class);

    private final OrderService orderService;
    private final OrderItemRepository orderItemRepository;
    private final LoyaltyCardRepository loyaltyCardRepository;
    private static final int ACTIVE_BARISTAS_PER_STATION = 2;

    @Autowired
    public KdsDispatchServiceImpl(OrderService orderService,
                                 OrderItemRepository orderItemRepository,
                                 LoyaltyCardRepository loyaltyCardRepository) {
        this.orderService = orderService;
        this.orderItemRepository = orderItemRepository;
        this.loyaltyCardRepository = loyaltyCardRepository;
    }

    @Override
    public List<KdsPriorityOrderDto> getOptimizedQueue(Long storeId) {
        List<Order> activeOrders = orderService.getKdsOrdersForStore(storeId);
        if (activeOrders.isEmpty()) {
            return Collections.emptyList();
        }

        List<KdsPriorityOrderDto> priorityList = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now();

        for (Order order : activeOrders) {
            long waitingMins = 0;
            if (order.getCreatedAt() != null) {
                waitingMins = Math.max(0, Duration.between(order.getCreatedAt(), now).toMinutes());
            }

            String tier = "GUEST";
            double tierPoints = 0.0;
            User user = order.getUser();
            if (user != null) {
                Optional<LoyaltyCard> cardOpt = loyaltyCardRepository.findByUserId(user.getId());
                if (cardOpt.isPresent() && cardOpt.get().getTier() != null) {
                    tier = cardOpt.get().getTier().name();
                    switch (tier) {
                        case "DIAMOND" -> tierPoints = 35.0;
                        case "GOLD" -> tierPoints = 20.0;
                        case "SILVER" -> tierPoints = 10.0;
                        default -> tierPoints = 3.0;
                    }
                }
            }

            double typePoints = 5.0;
            if (order.getOrderType() == OrderType.DINE_IN) {
                typePoints = 15.0;
            } else if (order.getOrderType() == OrderType.TAKE_AWAY) {
                typePoints = 10.0;
            }

            double waitPoints = waitingMins * 3.5;

            int totalPrepSeconds = 0;
            String dominantStation = "ESPRESSO_BAR";
            List<OrderItem> items = orderItemRepository.findByOrderId(order.getId());
            int itemCount = items.size();

            if (!items.isEmpty()) {
                for (OrderItem item : items) {
                    String pName = (item.getProduct() != null && item.getProduct().getName() != null)
                            ? item.getProduct().getName().toLowerCase()
                            : "";
                    int qty = item.getQuantity() != null ? item.getQuantity() : 1;

                    if (pName.contains("pour over") || pName.contains("v60") || pName.contains("chemex")) {
                        totalPrepSeconds += 240 * qty;
                        dominantStation = "POUR_OVER_BAR";
                    } else if (pName.contains("cold brew")) {
                        totalPrepSeconds += 35 * qty;
                    } else if (pName.contains("latte") || pName.contains("cappuccino") || pName.contains("espresso")) {
                        totalPrepSeconds += 90 * qty;
                        if (!dominantStation.equals("POUR_OVER_BAR")) dominantStation = "ESPRESSO_BAR";
                    } else if (pName.contains("bánh") || pName.contains("croissant") || pName.contains("tiramisu")) {
                        totalPrepSeconds += 60 * qty;
                        if (!dominantStation.equals("POUR_OVER_BAR") && !dominantStation.equals("ESPRESSO_BAR")) {
                            dominantStation = "PASTRIES";
                        }
                    } else {
                        totalPrepSeconds += 75 * qty;
                    }
                }
            } else {
                totalPrepSeconds = 120;
            }

            double priorityScore = waitPoints + tierPoints + typePoints;
            priorityScore = Math.round(priorityScore * 10.0) / 10.0;

            String priorityLevel;
            String reason;
            if (tierPoints >= 20.0 || waitingMins >= 10) {
                priorityLevel = "URGENT_VIP";
                reason = "Khách hàng " + tier + " / Chờ " + waitingMins + "p -> Cần ưu tiên làm ngay";
            } else if (order.getOrderType() == OrderType.DINE_IN || waitingMins >= 5) {
                priorityLevel = "HIGH_DINE_IN";
                reason = "Đơn tại bàn / Chờ " + waitingMins + "p -> Chuẩn bị phục vụ nóng";
            } else {
                priorityLevel = "STANDARD";
                reason = "Hàng đợi điều phối chuẩn theo thời gian tiếp nhận";
            }

            priorityList.add(KdsPriorityOrderDto.builder()
                    .orderId(order.getId())
                    .orderCode(order.getOrderCode())
                    .customerName(order.getRecipientName() != null ? order.getRecipientName() : "Khách UTECoffe")
                    .customerPhone(order.getRecipientPhone())
                    .customerTier(tier)
                    .orderType(order.getOrderType())
                    .createdAt(order.getCreatedAt())
                    .waitingMinutes(waitingMins)
                    .itemCount(itemCount)
                    .priorityScore(priorityScore)
                    .estimatedPrepSeconds(totalPrepSeconds)
                    .priorityLevel(priorityLevel)
                    .priorityReason(reason)
                    .recommendedStation(dominantStation)
                    .build());
        }

        priorityList.sort(Comparator.comparingDouble(KdsPriorityOrderDto::getPriorityScore).reversed());

        int accumulatedPrepSeconds = 0;
        for (KdsPriorityOrderDto item : priorityList) {
            accumulatedPrepSeconds += item.getEstimatedPrepSeconds();
            int etaMinutes = (int) Math.ceil((double) accumulatedPrepSeconds / (ACTIVE_BARISTAS_PER_STATION * 60.0));
            item.setEstimatedWaitEtaMinutes(Math.max(1, etaMinutes));
        }

        return priorityList;
    }
}
