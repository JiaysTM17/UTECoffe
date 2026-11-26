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

    @Override
    public com.utecoffe.dto.response.StationWorkloadSummaryDto getStationWorkloadSummary(Long storeId) {
        List<KdsPriorityOrderDto> queue = getOptimizedQueue(storeId);

        Map<String, com.utecoffe.dto.response.StationWorkloadSummaryDto.StationDetail> stationMap = new LinkedHashMap<>();
        stationMap.put("ESPRESSO_BAR", com.utecoffe.dto.response.StationWorkloadSummaryDto.StationDetail.builder()
                .stationName("Quầy Espresso & Cà Phê Pha Máy")
                .ticketCount(0)
                .estimatedSeconds(0)
                .activeBaristas(2)
                .status("OPTIMAL")
                .build());

        stationMap.put("POUR_OVER_BAR", com.utecoffe.dto.response.StationWorkloadSummaryDto.StationDetail.builder()
                .stationName("Quầy Pour-Over & Cà Phê Di Sản")
                .ticketCount(0)
                .estimatedSeconds(0)
                .activeBaristas(1)
                .status("OPTIMAL")
                .build());

        stationMap.put("PASTRIES", com.utecoffe.dto.response.StationWorkloadSummaryDto.StationDetail.builder()
                .stationName("Quầy Bánh Nướng & Tráng Miệng")
                .ticketCount(0)
                .estimatedSeconds(0)
                .activeBaristas(1)
                .status("OPTIMAL")
                .build());

        int totalSeconds = 0;
        for (KdsPriorityOrderDto item : queue) {
            String stationKey = item.getRecommendedStation();
            if (!stationMap.containsKey(stationKey)) {
                stationKey = "ESPRESSO_BAR";
            }
            var detail = stationMap.get(stationKey);
            detail.setTicketCount(detail.getTicketCount() + 1);
            detail.setEstimatedSeconds(detail.getEstimatedSeconds() + item.getEstimatedPrepSeconds());
            totalSeconds += item.getEstimatedPrepSeconds();
        }

        String bottleneck = "ESPRESSO_BAR";
        int maxSeconds = -1;

        for (Map.Entry<String, com.utecoffe.dto.response.StationWorkloadSummaryDto.StationDetail> entry : stationMap.entrySet()) {
            var detail = entry.getValue();
            int secs = detail.getEstimatedSeconds();
            if (secs > 900) {
                detail.setStatus("CONGESTED");
            } else if (secs > 480) {
                detail.setStatus("BUSY");
            } else {
                detail.setStatus("OPTIMAL");
            }

            if (secs > maxSeconds) {
                maxSeconds = secs;
                bottleneck = entry.getKey();
            }
        }

        String recommendation;
        if (queue.isEmpty()) {
            recommendation = "Toàn bộ quầy đang ở trạng thái sẵn sàng đón khách mới.";
        } else if (maxSeconds > 900) {
            var bottleDetail = stationMap.get(bottleneck);
            recommendation = "CẢNH BÁO TẢI CAO: " + bottleDetail.getStationName() + " đang có hàng đợi kéo dài (~" + (maxSeconds / 60) + " phút). Đề xuất điều phối thêm 1 Barista sang hỗ trợ.";
        } else if (maxSeconds > 480) {
            var bottleDetail = stationMap.get(bottleneck);
            recommendation = "LƯỢNG KHÁCH ĐÔNG: " + bottleDetail.getStationName() + " nhịp độ pha chế đang tăng nhanh. Barista giữ vững quy chuẩn SOP.";
        } else {
            recommendation = "Tốc độ phục vụ chuẩn mực, thời gian chờ bình quân dưới 5 phút.";
        }

        return com.utecoffe.dto.response.StationWorkloadSummaryDto.builder()
                .storeId(storeId)
                .totalActiveOrders(queue.size())
                .totalPendingSeconds(totalSeconds)
                .stationBreakdown(stationMap)
                .bottleneckStation(bottleneck)
                .dispatchRecommendation(recommendation)
                .build();
    }
}
