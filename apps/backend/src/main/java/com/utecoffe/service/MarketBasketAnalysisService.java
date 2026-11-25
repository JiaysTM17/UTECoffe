package com.utecoffe.service;

import com.utecoffe.dto.response.CrossSellRecommendationDto;

import java.util.List;

public interface MarketBasketAnalysisService {

    /**
     * Finds the best pairing items for a given source product using the Apriori Algorithm.
     * Computes Support, Confidence, and Lift metrics.
     *
     * @param productId The product currently viewed or added to cart.
     * @param limit Maximum number of recommendations to return.
     * @return List of recommended cross-sell items sorted by Lift metric.
     */
    List<CrossSellRecommendationDto> getRecommendationsForProduct(Long productId, int limit);
}
