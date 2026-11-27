package com.utecoffe.dto.response;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DeliveryRoutePlanDto {
    private Long storeId;
    private String storeName;
    private Double originLat;
    private Double originLon;

    private Integer totalStops;
    private Double naiveDistanceKm;       // distance visiting stops in FIFO order
    private Double optimizedDistanceKm;   // distance after Nearest-Neighbor + 2-opt
    private Double distanceSavedPercent;
    private Integer twoOptImprovements;
    private Integer totalRouteMinutes;
    private Double averageFreshnessScore;
    private String algorithm;

    private List<DeliveryStopDto> stops;
}
