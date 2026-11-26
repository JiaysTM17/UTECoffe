package com.utecoffe.service;

import com.utecoffe.dto.response.KdsPriorityOrderDto;
import com.utecoffe.dto.response.StationWorkloadSummaryDto;
import java.util.List;

public interface KdsDispatchService {
    /**
     * Compute Dynamic Weighted Priority Queue (WFQ) and Station ETA for active KDS orders.
     * Prevents queue starvation, expedites VIP guests and dine-in delicate orders,
     * and optimizes barista station throughput.
     * @param storeId Store identifier
     * @return Ranked list of active orders sorted by priority score descending
     */
    List<KdsPriorityOrderDto> getOptimizedQueue(Long storeId);

    /**
     * Analyze station load, calculate bottleneck stations, and recommend dynamic barista re-allocation.
     * @param storeId Store identifier
     * @return Workload summary and dispatch recommendation
     */
    StationWorkloadSummaryDto getStationWorkloadSummary(Long storeId);

    /**
     * Monitor active ticket preparation times against strict SLA thresholds
     * (e.g. 8 mins for Takeaway, 12 mins for Dine-In).
     * Automatically escalates tickets at risk of breaching SLA.
     * @param storeId Store identifier
     * @return SLA monitoring and ticket escalation status
     */
    com.utecoffe.dto.response.KdsSlaEscalationDto getKdsSlaStatus(Long storeId);
}
