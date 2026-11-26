package com.utecoffe.service;

import com.utecoffe.entity.Order;
import com.utecoffe.entity.StoreInventory;

import java.util.List;

public interface InventoryService {
    boolean verifyStockForOrder(Order order);
    void deductStockForOrder(Order order);
    void restoreStockForOrder(Order order);
    List<StoreInventory> getLowStockAlerts(Long storeId);
    com.utecoffe.dto.response.InventoryHealthDto getStoreInventoryHealth(Long storeId);
}

