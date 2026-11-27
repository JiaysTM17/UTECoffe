package com.utecoffe.service.impl;

import com.utecoffe.dto.response.CustomerIntelligenceSummaryDto;
import com.utecoffe.dto.response.RfmCustomerSegmentDto;
import com.utecoffe.entity.LoyaltyCard;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.User;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.repository.LoyaltyCardRepository;
import com.utecoffe.repository.OrderRepository;
import com.utecoffe.repository.UserRepository;
import com.utecoffe.service.CustomerIntelligenceService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class CustomerIntelligenceServiceImpl implements CustomerIntelligenceService {

    private static final Logger log = LoggerFactory.getLogger(CustomerIntelligenceServiceImpl.class);

    private final UserRepository userRepository;
    private final OrderRepository orderRepository;
    private final LoyaltyCardRepository loyaltyCardRepository;

    @Autowired
    public CustomerIntelligenceServiceImpl(UserRepository userRepository,
                                          OrderRepository orderRepository,
                                          LoyaltyCardRepository loyaltyCardRepository) {
        this.userRepository = userRepository;
        this.orderRepository = orderRepository;
        this.loyaltyCardRepository = loyaltyCardRepository;
    }

    @Override
    public CustomerIntelligenceSummaryDto analyzeCustomerSegments() {
        log.info("Computing RFM Segmentation and Churn Risk Matrix across customer base...");

        List<User> users = userRepository.findAll();
        List<RfmCustomerSegmentDto> segments = new ArrayList<>();

        int champions = 0;
        int loyal = 0;
        int potential = 0;
        int atRisk = 0;
        int hibernating = 0;
        int lost = 0;
        double totalChurn = 0.0;

        for (User u : users) {
            RfmCustomerSegmentDto dto = analyzeCustomer(u.getId());
            if (dto != null) {
                segments.add(dto);
                totalChurn += dto.getChurnProbability();

                switch (dto.getRfmSegment()) {
                    case "CHAMPIONS" -> champions++;
                    case "LOYAL_CUSTOMERS" -> loyal++;
                    case "POTENTIAL_LOYALISTS" -> potential++;
                    case "AT_RISK" -> atRisk++;
                    case "HIBERNATING" -> hibernating++;
                    case "LOST" -> lost++;
                    default -> potential++;
                }
            }
        }

        // Sort by monetary total descending
        segments.sort(Comparator.comparing(RfmCustomerSegmentDto::getMonetaryTotal).reversed());

        double avgChurn = segments.isEmpty() ? 0.0 : Math.round((totalChurn / segments.size()) * 10.0) / 10.0;

        return CustomerIntelligenceSummaryDto.builder()
                .totalEvaluatedCustomers(segments.size())
                .championsCount(champions)
                .loyalCustomersCount(loyal)
                .potentialLoyalistsCount(potential)
                .atRiskCount(atRisk)
                .hibernatingCount(hibernating)
                .lostCount(lost)
                .averageChurnRisk(avgChurn)
                .segments(segments)
                .build();
    }

    @Override
    public RfmCustomerSegmentDto analyzeCustomer(Long userId) {
        Optional<User> optUser = userRepository.findById(userId);
        if (optUser.isEmpty()) return null;

        User user = optUser.get();
        List<Order> orders = orderRepository.findByUserIdOrderByCreatedAtDesc(userId);

        List<Order> completedOrders = orders != null ? orders.stream()
                .filter(o -> o.getStatus() == OrderStatus.COMPLETED)
                .sorted(Comparator.comparing(Order::getCreatedAt))
                .collect(Collectors.toList()) : Collections.emptyList();

        LocalDateTime now = LocalDateTime.now();
        int recencyDays = 90;
        if (!completedOrders.isEmpty()) {
            LocalDateTime lastOrderDate = completedOrders.get(completedOrders.size() - 1).getCreatedAt();
            if (lastOrderDate != null) {
                recencyDays = (int) Math.max(0, Duration.between(lastOrderDate, now).toDays());
            }
        }

        int frequency = completedOrders.size();

        BigDecimal monetary = completedOrders.stream()
                .map(Order::getFinalAmount)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal aov = frequency > 0
                ? monetary.divide(BigDecimal.valueOf(frequency), 0, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        // Calculate Average Inter-purchase Time (IPT)
        double iptDays = 14.0;
        if (completedOrders.size() >= 2) {
            long totalGaps = 0;
            for (int i = 1; i < completedOrders.size(); i++) {
                LocalDateTime prev = completedOrders.get(i - 1).getCreatedAt();
                LocalDateTime curr = completedOrders.get(i).getCreatedAt();
                if (prev != null && curr != null) {
                    totalGaps += Math.max(1, Duration.between(prev, curr).toDays());
                }
            }
            iptDays = (double) totalGaps / (completedOrders.size() - 1);
        }

        // RFM Scores (1 - 5)
        int rScore = scoreRecency(recencyDays);
        int fScore = scoreFrequency(frequency);
        int mScore = scoreMonetary(monetary);

        // Segment Classification
        String segment = classifySegment(rScore, fScore, mScore);

        // Churn Probability Model (Exponential Survival Decay)
        double churnProb = calculateChurnProbability(recencyDays, iptDays, frequency);
        String churnLevel = getChurnRiskLevel(churnProb);

        String loyaltyTier = "ĐỒNG";
        Optional<LoyaltyCard> cardOpt = loyaltyCardRepository.findByUserId(userId);
        if (cardOpt.isPresent() && cardOpt.get().getTier() != null) {
            loyaltyTier = cardOpt.get().getTier().name();
        }

        String actionRecommendation = recommendRetentionAction(segment, churnProb, loyaltyTier);

        return RfmCustomerSegmentDto.builder()
                .userId(userId)
                .customerName(user.getFullName() != null ? user.getFullName() : "Khách Hàng UTE")
                .email(user.getEmail())
                .loyaltyTier(loyaltyTier)
                .recencyDays(recencyDays)
                .frequencyCount(frequency)
                .monetaryTotal(monetary)
                .averageOrderValue(aov)
                .avgInterpurchaseDays(Math.round(iptDays * 10.0) / 10.0)
                .rScore(rScore)
                .fScore(fScore)
                .mScore(mScore)
                .rfmSegment(segment)
                .churnProbability(Math.round(churnProb * 1000.0) / 10.0)
                .churnRiskLevel(churnLevel)
                .retentionActionRecommendation(actionRecommendation)
                .build();
    }

    private int scoreRecency(int days) {
        if (days <= 7) return 5;
        if (days <= 14) return 4;
        if (days <= 30) return 3;
        if (days <= 60) return 2;
        return 1;
    }

    private int scoreFrequency(int count) {
        if (count >= 10) return 5;
        if (count >= 5) return 4;
        if (count >= 3) return 3;
        if (count >= 1) return 2;
        return 1;
    }

    private int scoreMonetary(BigDecimal monetary) {
        if (monetary.compareTo(BigDecimal.valueOf(1500000)) >= 0) return 5;
        if (monetary.compareTo(BigDecimal.valueOf(800000)) >= 0) return 4;
        if (monetary.compareTo(BigDecimal.valueOf(400000)) >= 0) return 3;
        if (monetary.compareTo(BigDecimal.valueOf(100000)) >= 0) return 2;
        return 1;
    }

    private String classifySegment(int r, int f, int m) {
        if (r >= 4 && f >= 4) return "CHAMPIONS";
        if (r >= 3 && f >= 3) return "LOYAL_CUSTOMERS";
        if (r >= 4 && f <= 2) return "POTENTIAL_LOYALISTS";
        if (r <= 2 && f >= 3) return "AT_RISK";
        if (r <= 2 && f <= 2 && r > 1) return "HIBERNATING";
        return "LOST";
    }

    private double calculateChurnProbability(int recencyDays, double iptDays, int frequency) {
        if (frequency == 0) return 0.85;

        // If customer ordered very recently well within normal cycle
        if (recencyDays <= iptDays) {
            return Math.max(0.04, 0.15 * (recencyDays / Math.max(1.0, iptDays)));
        }

        // Overdue beyond normal IPT: exponential decay towards churn
        double overdue = recencyDays - iptDays;
        double lambda = 1.0 / Math.max(7.0, iptDays * 1.5);
        double prob = 1.0 - Math.exp(-lambda * overdue);
        return Math.min(0.98, Math.max(0.10, prob));
    }

    private String getChurnRiskLevel(double prob) {
        if (prob >= 0.75) return "NGUY CƠ CAO (RỜI BỎ)";
        if (prob >= 0.45) return "TRUNG BÌNH (CẦN TÁC ĐỘNG)";
        return "THẤP (GẮN KẾT TỐT)";
    }

    private String recommendRetentionAction(String segment, double churnProb, String tier) {
        return switch (segment) {
            case "CHAMPIONS" -> "Tặng đặc quyền Private Cupping cùng Master Roaster & Mã VIP 20%. Duy trì dịch vụ ưu tiên cao nhất.";
            case "LOYAL_CUSTOMERS" -> "Gợi ý dòng sản phẩm hạt Bourbon cao cấp mới về & nhân đôi điểm thưởng UTEClub cuối tuần.";
            case "POTENTIAL_LOYALISTS" -> "Gửi thông báo chương trình thăng hạng UTEClub và voucher Free Ship đơn hàng tiếp theo.";
            case "AT_RISK" -> "Kích hoạt chiến dịch Re-engagement: Tặng 01 Cold Brew Signature miễn phí khi quay lại trong vòng 7 ngày.";
            case "HIBERNATING" -> "Gửi email cá nhân hóa món đồ uống quen thuộc với mã ưu đãi trở lại giảm 25%.";
            default -> "Khảo sát nguyên nhân rời bỏ & tặng voucher chào đón đặc biệt 30,000 VNĐ.";
        };
    }
}
