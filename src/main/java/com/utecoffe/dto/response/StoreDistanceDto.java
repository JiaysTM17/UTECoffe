package com.utecoffe.dto.response;

import com.utecoffe.entity.Store;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StoreDistanceDto {
    private Store store;
    private double distanceKm;
    private int estimatedDeliveryMinutes;
    private boolean isDeliverable;
    private String formattedDistance;
}
