package com.utecoffe.dto.response;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DeliveryOptimizationDto {
    private Long storeId;
    private String originBranchName;
    private String originAddress;
    private Double originLat;
    private Double originLon;

    private String destinationAddress;
    private Double destinationLat;
    private Double destinationLon;

    private Double distanceKm;
    private Integer activeBaristaQueueSize;
    private Integer prepMinutes;
    private Integer transitMinutes;
    private Integer totalEstimatedMinutes;
    private String estimatedArrivalFormatted;

    private Double trafficCongestionFactor;
    private String trafficStatusLabel; // THÔNG THOÁNG, GIỜ CAO ĐIỂM, ĐÔNG ĐÚC
    private String deliveryTierBadge;
}
