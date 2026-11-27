package com.utecoffe.dto.response;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RfmCustomerSegmentDto {
    private Long userId;
    private String customerName;
    private String email;
    private String loyaltyTier;

    private Integer recencyDays;
    private Integer frequencyCount;
    private BigDecimal monetaryTotal;
    private BigDecimal averageOrderValue;
    private Double avgInterpurchaseDays;

    private Integer rScore; // 1-5
    private Integer fScore; // 1-5
    private Integer mScore; // 1-5

    private String rfmSegment; // CHAMPIONS, LOYAL, POTENTIAL, AT_RISK, HIBERNATING, LOST
    private Double churnProbability; // 0.00 - 1.00
    private String churnRiskLevel; // THẤP, TRUNG BÌNH, NGUY CƠ CAO, ĐÃ RỜI BỎ
    private String retentionActionRecommendation;
}
