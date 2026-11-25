package com.utecoffe.websocket;

import com.utecoffe.entity.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class OrderNotificationService {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    public void notifyNewOrderToKds(Order order) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("type", "NEW_ORDER");
        payload.put("orderId", order.getId());
        payload.put("orderCode", order.getOrderCode());
        payload.put("orderType", order.getOrderType().name());
        payload.put("status", order.getStatus().name());
        payload.put("finalAmount", order.getFinalAmount());
        payload.put("storeId", order.getStore().getId());
        payload.put("createdAt", order.getCreatedAt().toString());

        // Broadcast to KDS screen of this specific store
        messagingTemplate.convertAndSend("/topic/kds/" + order.getStore().getId(), payload);
    }

    public void notifyOrderStatusChanged(Order order, String message) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("type", "STATUS_CHANGED");
        payload.put("orderId", order.getId());
        payload.put("orderCode", order.getOrderCode());
        payload.put("status", order.getStatus().name());
        payload.put("message", message);

        // Broadcast to customer order tracking page
        messagingTemplate.convertAndSend("/topic/order/" + order.getOrderCode(), payload);

        // Also notify store KDS
        messagingTemplate.convertAndSend("/topic/kds/" + order.getStore().getId(), payload);
    }
}
