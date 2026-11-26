package com.utecoffe.dto.response;

import lombok.*;

import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TableUtilizationDto {
    private Long storeId;
    private String storeName;
    private int totalTables;
    private int occupiedTables;
    private int availableTables;
    private double occupancyRatePercent;

    private int todayReservationsCount;
    private int seatedTodayCount;
    private int completedTodayCount;
    private int cancelledTodayCount;
    private double averagePartySize;
    private String peakHourSlot;

    private Map<String, ZoneUtilizationDetail> zoneBreakdown;
    private String utilizationStatus;
    private String floorManagerAdvice;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class ZoneUtilizationDetail {
        private String zoneName;
        private int totalTables;
        private int occupiedTables;
        private int availableTables;
        private double occupancyPercent;
    }
}
