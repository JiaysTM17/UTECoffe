package com.utecoffe.dto.response;

import com.utecoffe.enums.OrderType;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KdsSlaEscalationDto {
    private Long storeId;
    private int totalActiveTickets;
    private int normalTicketsCount;
    private int warningTicketsCount;
    private int breachedTicketsCount;
    private double slaAdherenceRatePercent;
    private List<KdsTicketSlaDetail> tickets;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class KdsTicketSlaDetail {
        private Long orderId;
        private String orderCode;
        private String customerName;
        private String customerTier;
        private OrderType orderType;
        private int totalItems;
        private long waitingMinutes;
        private int slaThresholdMinutes;
        private boolean isSlaBreached;
        private String urgencyStatus;
        private String expediteAction;
    }
}
