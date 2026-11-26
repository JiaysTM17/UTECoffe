package com.utecoffe.controller.api;

import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.dto.response.KdsPriorityOrderDto;
import com.utecoffe.entity.Order;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.service.KdsDispatchService;
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
    private KdsDispatchService kdsDispatchService;

    @Autowired
    private OrderNotificationService notificationService;

    @GetMapping("/orders/{storeId}")
    public ResponseEntity<ApiResponse<List<Order>>> getStoreKdsOrders(@PathVariable("storeId") Long storeId) {
        return ResponseEntity.ok(ApiResponse.success(orderService.getKdsOrdersForStore(storeId), "Danh sach don KDS"));
    }

    @GetMapping("/queue-optimization/{storeId}")
    public ResponseEntity<ApiResponse<List<KdsPriorityOrderDto>>> getOptimizedQueue(@PathVariable("storeId") Long storeId) {
        return ResponseEntity.ok(ApiResponse.success(
                kdsDispatchService.getOptimizedQueue(storeId),
                "Hang doi phuc vu toi uu hoa theo thuat toan Weighted Fair Queuing"));
    }

    @GetMapping("/workload/{storeId}")
    public ResponseEntity<ApiResponse<com.utecoffe.dto.response.StationWorkloadSummaryDto>> getStationWorkload(@PathVariable("storeId") Long storeId) {
        return ResponseEntity.ok(ApiResponse.success(
                kdsDispatchService.getStationWorkloadSummary(storeId),
                "Thong ke tai lam viec va dieu phoi cac quay Barista"));
    }

    @GetMapping("/sla/{storeId}")
    public ResponseEntity<ApiResponse<com.utecoffe.dto.response.KdsSlaEscalationDto>> getKdsSlaStatus(@PathVariable("storeId") Long storeId) {
        return ResponseEntity.ok(ApiResponse.success(
                kdsDispatchService.getKdsSlaStatus(storeId),
                "Giam sat thoi gian cho chuan SLA va dieu phoi hoa toc Barista"));
    }

    @PostMapping("/orders/{orderId}/status")
    public ResponseEntity<ApiResponse<Void>> updateStatus(@PathVariable("orderId") Long orderId,
                                                          @RequestParam("status") OrderStatus status,
                                                          @RequestParam(value = "note", required = false) String note) {
        Order updated = orderService.updateOrderStatus(orderId, status, note);
        notificationService.notifyOrderStatusChanged(updated, note);
        return ResponseEntity.ok(ApiResponse.success(null, "Cap nhat trang thai thanh cong"));
    }
}
