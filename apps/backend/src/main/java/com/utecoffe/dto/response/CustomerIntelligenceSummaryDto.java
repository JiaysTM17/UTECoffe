package com.utecoffe.dto.response;

import lombok.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CustomerIntelligenceSummaryDto {
    private Integer totalEvaluatedCustomers;
    private Integer championsCount;
    private Integer loyalCustomersCount;
    private Integer potentialLoyalistsCount;
    private Integer atRiskCount;
    private Integer hibernatingCount;
    private Integer lostCount;

    private Double averageChurnRisk;
    private List<RfmCustomerSegmentDto> segments;
}
