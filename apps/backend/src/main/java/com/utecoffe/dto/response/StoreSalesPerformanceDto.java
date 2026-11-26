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
public class StoreSalesPerformanceDto {
    private Long storeId;
    private String storeName;
    private String address;
    private BigDecimal totalRevenue;
    private long totalOrders;
    private long completedOrders;
    private long cancelledOrders;
    private BigDecimal averageOrderValue;
    private Map<String, Long> paymentMethodBreakdown;
    private List<ProductSalesMetricDto> topSellingProducts;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class ProductSalesMetricDto {
        private Long productId;
        private String productName;
        private long quantitySold;
        private BigDecimal totalRevenue;
    }
}
