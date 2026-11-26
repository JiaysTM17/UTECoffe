package com.utecoffe.service;

import com.utecoffe.dto.response.ExecutiveAnalyticsDto;

public interface AnalyticsService {
    ExecutiveAnalyticsDto getExecutiveAnalytics();
    com.utecoffe.dto.response.StoreSalesPerformanceDto getStoreProductSalesAnalytics(Long storeId);
}
