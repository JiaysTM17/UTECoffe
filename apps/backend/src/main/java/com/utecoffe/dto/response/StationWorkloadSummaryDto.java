package com.utecoffe.dto.response;

import lombok.*;

import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StationWorkloadSummaryDto {
    private Long storeId;
    private int totalActiveOrders;
    private int totalPendingSeconds;
    private Map<String, StationDetail> stationBreakdown;
    private String bottleneckStation;
    private String dispatchRecommendation;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class StationDetail {
        private String stationName;
        private int ticketCount;
        private int estimatedSeconds;
        private int activeBaristas;
        private String status; // OPTIMAL, BUSY, CONGESTED
    }
}
