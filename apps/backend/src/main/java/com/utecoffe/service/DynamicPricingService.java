package com.utecoffe.service;

import com.utecoffe.dto.response.DynamicPricingResultDto;

import java.util.List;

public interface DynamicPricingService {

    /**
     * Computes the dynamic price for a specific product based on current hour,
     * product category (pastry vs coffee), and yield management rules.
     */
    DynamicPricingResultDto calculateDynamicPrice(Long productId);

    /**
     * Evaluates dynamic pricing across all active products.
     */
    List<DynamicPricingResultDto> evaluateStorewidePricing();
}
