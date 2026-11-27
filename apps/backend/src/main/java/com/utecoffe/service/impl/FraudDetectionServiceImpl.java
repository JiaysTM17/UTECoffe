package com.utecoffe.service.impl;

import com.utecoffe.dto.response.OrderRiskAssessmentDto;
import com.utecoffe.entity.Order;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.enums.OrderType;
import com.utecoffe.repository.OrderRepository;
import com.utecoffe.service.FraudDetectionService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Explainable order-risk scoring.
 *
 * Features
 *  - amountZ      : robust z-score of order amount vs. the customer's history, using Bayesian shrinkage
 *                   of mean/variance towards a store-wide prior when history is short (James-Stein style).
 *  - velocity     : number of orders by the same customer in the previous 15 minutes (burst detection).
 *  - cancelRate   : posterior mean of cancellation probability with Beta(1, 4) prior.
 *  - newAccount   : account younger than 24h (1/0).
 *  - nightOrder   : placed between 00:00 and 05:00 (1/0).
 *  - guestCod     : guest checkout of a delivery order (1/0).
 * Score  p = sigmoid(b + sum w_i * x_i), with per-feature contributions returned for transparency.
 */
@Service
public class FraudDetectionServiceImpl implements FraudDetectionService {

    private static final double PRIOR_MEAN = 85_000;     // typical UTECoffe ticket (VND)
    private static final double PRIOR_STD = 45_000;
    private static final double PRIOR_STRENGTH = 3.0;    // pseudo-observations of the prior
    private static final double BIAS = -4.0;

    private static final Map<String, Double> WEIGHTS = new LinkedHashMap<>();
    static {
        WEIGHTS.put("amountZ", 0.9);
        WEIGHTS.put("velocity", 1.1);
        WEIGHTS.put("cancelRate", 3.5);
        WEIGHTS.put("newAccount", 0.8);
        WEIGHTS.put("nightOrder", 0.6);
        WEIGHTS.put("guestCod", 0.7);
    }

    private final OrderRepository orderRepository;

    public FraudDetectionServiceImpl(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    @Override
    public OrderRiskAssessmentDto assessOrder(Long orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đơn hàng: " + orderId));
        Long userId = order.getUser() != null ? order.getUser().getId() : null;
        List<Order> history = userId != null ? orderRepository.findByUserIdOrderByCreatedAtDesc(userId) : List.of();
        return score(order, history);
    }

    /** Pure scoring function (history may include the order itself; it is excluded). */
    public OrderRiskAssessmentDto score(Order order, List<Order> history) {
        LocalDateTime placedAt = order.getCreatedAt() != null ? order.getCreatedAt() : LocalDateTime.now();
        double amount = toDouble(order.getFinalAmount());

        List<Order> past = new ArrayList<>();
        if (history != null) {
            for (Order h : history) {
                if (h == null || (order.getId() != null && order.getId().equals(h.getId()))) continue;
                if (h.getCreatedAt() != null && h.getCreatedAt().isAfter(placedAt)) continue; // no look-ahead
                past.add(h);
            }
        }

        // --- amount z-score with Bayesian shrinkage
        int n = 0;
        double sum = 0, sumSq = 0;
        int cancelled = 0;
        int recent = 0;
        for (Order h : past) {
            if (h.getStatus() == OrderStatus.CANCELLED) {
                cancelled++;
            } else {
                double a = toDouble(h.getFinalAmount());
                n++;
                sum += a;
                sumSq += a * a;
            }
            if (h.getCreatedAt() != null && Duration.between(h.getCreatedAt(), placedAt).toMinutes() <= 15) {
                recent++;
            }
        }
        double postMean = (PRIOR_STRENGTH * PRIOR_MEAN + sum) / (PRIOR_STRENGTH + n);
        double sampleVar = n > 1 ? Math.max(0, (sumSq - sum * sum / n) / (n - 1)) : 0;
        double postVar = (PRIOR_STRENGTH * PRIOR_STD * PRIOR_STD + (n > 1 ? (n - 1) * sampleVar : 0))
                / (PRIOR_STRENGTH + Math.max(0, n - 1));
        double std = Math.max(10_000, Math.sqrt(postVar));
        double amountZ = Math.max(0, (amount - postMean) / std); // only unusually LARGE orders are suspicious
        amountZ = Math.min(amountZ, 6);

        double velocity = Math.min(recent, 5);
        double cancelRate = (cancelled + 1.0) / (past.size() + 5.0); // Beta(1,4) posterior mean
        double newAccount = (order.getUser() != null && order.getUser().getCreatedAt() != null
                && Duration.between(order.getUser().getCreatedAt(), placedAt).toHours() < 24) ? 1 : 0;
        int hour = placedAt.getHour();
        double night = (hour < 5) ? 1 : 0;
        double guestCod = (order.getUser() == null && order.getOrderType() == OrderType.DELIVERY) ? 1 : 0;

        Map<String, Double> features = new LinkedHashMap<>();
        features.put("amountZ", round(amountZ));
        features.put("velocity", velocity);
        features.put("cancelRate", round(cancelRate));
        features.put("newAccount", newAccount);
        features.put("nightOrder", night);
        features.put("guestCod", guestCod);

        double logit = BIAS;
        Map<String, Double> contributions = new LinkedHashMap<>();
        for (Map.Entry<String, Double> e : features.entrySet()) {
            double c = WEIGHTS.get(e.getKey()) * e.getValue();
            contributions.put(e.getKey(), round(c));
            logit += c;
        }
        double p = 1.0 / (1.0 + Math.exp(-logit));

        List<String> reasons = new ArrayList<>();
        if (amountZ >= 2) reasons.add(String.format("Giá trị đơn cao bất thường (%.1fσ so với lịch sử khách)", amountZ));
        if (velocity >= 2) reasons.add("Đặt " + (int) velocity + " đơn liên tiếp trong 15 phút");
        if (cancelRate >= 0.4) reasons.add(String.format("Tỷ lệ hủy đơn cao (%.0f%%)", cancelRate * 100));
        if (newAccount > 0) reasons.add("Tài khoản mới tạo dưới 24 giờ");
        if (night > 0) reasons.add("Đặt hàng khung giờ 00:00–05:00");
        if (guestCod > 0) reasons.add("Khách vãng lai đặt giao hàng tận nơi");
        if (reasons.isEmpty()) reasons.add("Hành vi mua hàng bình thường");

        String level = p >= 0.6 ? "HIGH" : p >= 0.25 ? "MEDIUM" : "LOW";
        String action = switch (level) {
            case "HIGH" -> "MANUAL_REVIEW";
            case "MEDIUM" -> "VERIFY_PHONE";
            default -> "AUTO_APPROVE";
        };

        return OrderRiskAssessmentDto.builder()
                .orderId(order.getId())
                .orderCode(order.getOrderCode())
                .userId(order.getUser() != null ? order.getUser().getId() : null)
                .riskProbability(Math.round(p * 10000.0) / 10000.0)
                .riskScore((int) Math.round(p * 100))
                .riskLevel(level)
                .recommendedAction(action)
                .features(features)
                .contributions(contributions)
                .reasons(reasons)
                .algorithm("Bayesian-shrunk z-score + Beta posterior + Logistic risk model")
                .build();
    }

    private static double toDouble(BigDecimal v) {
        return v != null ? v.doubleValue() : 0.0;
    }

    private static double round(double v) {
        return Math.round(v * 1000.0) / 1000.0;
    }
}
