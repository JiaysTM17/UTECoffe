package com.utecoffe.dto.response;

import lombok.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SupplyChainForecastSummaryDto {
    private Long storeId;
    private String storeName;
    private Integer totalMonitoredIngredients;
    private Integer criticalReplenishCount;
    private List<DemandForecastDto> forecasts;
}
