package com.utecoffe.service;

import com.utecoffe.dto.request.OrderCreateRequest;
import com.utecoffe.entity.Order;
import com.utecoffe.enums.OrderStatus;

import java.util.List;

public interface OrderService {
    Order createOrder(OrderCreateRequest request, Long userId);
    Order getOrderByCode(String orderCode);
    Order getOrderById(Long id);
    List<Order> getUserOrders(Long userId);
    List<Order> getKdsOrdersForStore(Long storeId);
    Order updateOrderStatus(Long orderId, OrderStatus newStatus, String note);
}
