package com.utecoffe.websocket;

import com.utecoffe.entity.Order;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;

import java.util.Map;

@Controller
public class KdsWebSocketController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderNotificationService notificationService;

    @MessageMapping("/kds/update-status")
    public void handleKdsStatusUpdate(@Payload Map<String, Object> message) {
        Long orderId = Long.valueOf(message.get("orderId").toString());
        String statusStr = message.get("status").toString();
        OrderStatus newStatus = OrderStatus.valueOf(statusStr);

        Order updatedOrder = orderService.updateOrderStatus(orderId, newStatus, "Barista cap nhat trang thai qua man hinh KDS");
        notificationService.notifyOrderStatusChanged(updatedOrder, "Barista dang che bien don hang cua ban");
    }
}
