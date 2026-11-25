package com.utecoffe.service;

import com.utecoffe.dto.response.KdsPriorityOrderDto;
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
}
