package com.utecoffe.service;

import com.utecoffe.dto.response.InventoryOptimizationDto;
import java.util.List;

public interface InventoryOptimizationService {
    /**
     * Compute Economic Order Quantity (EOQ), Safety Stock (SS), and Reorder Point (ROP)
     * for all ingredients across stores or a specific store to prevent supply chain bottlenecks.
     * @param storeId Optional store filter (null for system-wide aggregation)
     * @return List of analytical inventory optimization recommendations
     */
    List<InventoryOptimizationDto> analyzeStoreInventory(Long storeId);
}
