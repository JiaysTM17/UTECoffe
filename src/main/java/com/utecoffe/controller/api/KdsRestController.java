package com.utecoffe.controller.api;

import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.entity.Order;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.service.OrderService;
import com.utecoffe.websocket.OrderNotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/kds")
public class KdsRestController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderNotificationService notificationService;

    @GetMapping("/orders/{storeId}")
    public ResponseEntity<ApiResponse<List<Order>>> getStoreKdsOrders(@PathVariable Long storeId) {
        return ResponseEntity.ok(ApiResponse.success(orderService.getKdsOrdersForStore(storeId), "Danh sach don KDS"));
    }

    @PostMapping("/orders/{orderId}/status")
    public ResponseEntity<ApiResponse<Order>> updateStatus(@PathVariable Long orderId,
                                                          @RequestParam OrderStatus status,
                                                          @RequestParam(required = false) String note) {
        Order updated = orderService.updateOrderStatus(orderId, status, note);
        notificationService.notifyOrderStatusChanged(updated, note);
        return ResponseEntity.ok(ApiResponse.success(updated, "Cap nhat trang thai thanh cong"));
    }
}
