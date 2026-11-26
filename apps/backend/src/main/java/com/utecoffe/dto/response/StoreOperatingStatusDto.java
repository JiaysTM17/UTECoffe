package com.utecoffe.dto.response;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StoreOperatingStatusDto {
    private Long storeId;
    private String storeName;
    private String address;
    private String phoneNumber;
    private String openingTime;
    private String closingTime;
    private boolean isOpenNow;
    private String statusBadge;
    private String statusMessage;
    private String rushLevel;
    private String rushDescription;
    private int activeKdsQueueCount;
    private int occupiedTablesCount;
    private int totalTablesCount;
    private double tableOccupancyPercent;
}
