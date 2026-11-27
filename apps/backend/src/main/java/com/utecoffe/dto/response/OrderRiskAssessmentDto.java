package com.utecoffe.dto.response;

import lombok.*;

import java.util.List;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderRiskAssessmentDto {
    private Long orderId;
    private String orderCode;
    private Long userId;

    private Double riskProbability;   // 0..1 (logistic output)
    private Integer riskScore;        // 0..100
    private String riskLevel;         // LOW / MEDIUM / HIGH
    private String recommendedAction; // AUTO_APPROVE / VERIFY_PHONE / MANUAL_REVIEW

    private Map<String, Double> features;      // standardized feature values
    private Map<String, Double> contributions; // weight * feature (explainability)
    private List<String> reasons;
    private String algorithm;
}
