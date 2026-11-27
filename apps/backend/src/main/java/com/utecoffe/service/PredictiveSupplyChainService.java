package com.utecoffe.service;

import com.utecoffe.dto.response.DemandForecastDto;
import com.utecoffe.dto.response.SupplyChainForecastSummaryDto;

public interface PredictiveSupplyChainService {
    SupplyChainForecastSummaryDto forecastStoreDemand(Long storeId);
    DemandForecastDto forecastIngredientDemand(Long ingredientId, Long storeId);
}
