package com.utecoffe.dto.response;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DeliveryStopDto {
    private Integer stopSequence;
    private Long orderId;
    private String orderCode;
    private String customerName;
    private String customerPhone;
    private String deliveryAddress;
    private Double latitude;
    private Double longitude;
    
    private Double legDistanceKm;
    private Integer legDurationMinutes;
    private Integer cumulativeMinutes;
    private String estimatedArrivalTime;
    
    private Integer totalCups;
    private Double beverageFreshnessScore; // 0.0 - 100.0%
    private String freshnessStatus;        // TUYỆT HẢO, TỐT, CẦN GIAO GẤP
}
