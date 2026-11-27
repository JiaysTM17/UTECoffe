package com.utecoffe.service;

import com.utecoffe.dto.response.DeliveryOptimizationDto;

public interface DeliveryOptimizationService {
    DeliveryOptimizationDto calculateDeliveryEstimate(Long storeId, Double destLat, Double destLon, String destAddress);
    DeliveryOptimizationDto calculateDeliveryEstimateForOrder(Long orderId);
}
