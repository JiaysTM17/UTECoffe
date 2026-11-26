package com.utecoffe.dto.response;

import lombok.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExecutiveAnalyticsDto {
    private BigDecimal totalRevenue;
    private long totalOrders;
    private long completedOrders;
    private long pendingOrders;
    private long cancelledOrders;
    private BigDecimal averageOrderValue;
    private double cancellationRate;

    // Time-based comparisons
    private BigDecimal todayRevenue;
    private BigDecimal yesterdayRevenue;
    private double dayOverDayGrowth;

    private BigDecimal thisWeekRevenue;
    private BigDecimal lastWeekRevenue;
    private double weekOverWeekGrowth;

    // Peak hours analysis (Hour 0-23 -> order count)
    private Map<Integer, Long> hourlyOrderDistribution;
    private int peakHour;

    // Breakdown by channel
    private long dineInCount;
    private long takeAwayCount;
    private long deliveryCount;

    // Branch performance list
    private List<StorePerformanceDto> storePerformances;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class StorePerformanceDto {
        private Long storeId;
        private String storeName;
        private String address;
        private long orderCount;
        private BigDecimal revenue;
        private BigDecimal averageTicketSize;
        private double revenueSharePercentage;
    }
}
