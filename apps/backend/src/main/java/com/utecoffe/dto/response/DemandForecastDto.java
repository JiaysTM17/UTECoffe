package com.utecoffe.dto.response;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DemandForecastDto {
    private Long ingredientId;
    private String ingredientName;
    private String unit;
    private BigDecimal currentStock;
    private BigDecimal safetyStock;
    private BigDecimal reorderPoint;

    private Double historicalAvgDailyDemand;
    private Double forecastDay1;
    private Double forecastDay2;
    private Double forecastDay3;
    private Double forecastDay7Total;

    private Double alphaLevel;
    private Double betaTrend;
    private Double gammaSeasonality;
    private Double mapePercentage; // Mean Absolute Percentage Error

    private String replenishmentAction; // CẦN ĐẶT HÀNG GẤP, MỨC DỰ TRỮ TỐI ƯU, TỒN KHO DƯ DÀNG
    private String shelfLifeAdvisory;
}
