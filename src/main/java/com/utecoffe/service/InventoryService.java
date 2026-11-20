package com.utecoffe.service;

import com.utecoffe.entity.Order;
import com.utecoffe.entity.StoreInventory;

import java.util.List;

public interface InventoryService {
    boolean verifyStockForOrder(Order order);
    void deductStockForOrder(Order order);
    List<StoreInventory> getLowStockAlerts(Long storeId);
}
