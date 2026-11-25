package com.utecoffe.service;

import com.utecoffe.dto.response.FlavorPairingDto;
import com.utecoffe.entity.Product;

import java.util.List;

public interface RecommendationService {

    /**
     * Recommends optimal food-beverage pairings based on Terroir & Flavor Harmony Matrix.
     */
    List<FlavorPairingDto> getPairingsForProduct(Long productId);

    /**
     * Personalized recommendations based on order history and trending products.
     */
    List<Product> getTrendingOrPersonalized(Long userId, int limit);
}
