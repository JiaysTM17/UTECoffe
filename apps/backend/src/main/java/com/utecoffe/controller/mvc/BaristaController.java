package com.utecoffe.controller.mvc;

import com.utecoffe.entity.Order;
import com.utecoffe.entity.Store;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.enums.OrderType;
import com.utecoffe.service.OrderService;
import com.utecoffe.service.StoreService;
import com.utecoffe.websocket.OrderNotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class BaristaController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private StoreService storeService;

    @Autowired(required = false)
    private OrderNotificationService notificationService;

    @GetMapping({"/barista/kds", "/barista/orders"})
    public String kdsScreen(@RequestParam(defaultValue = "1") Long storeId, Model model) {
        Store store = storeService.getStoreById(storeId);
        List<Store> allStores = storeService.getAllActiveStores();
        List<Order> activeOrders = orderService.getKdsOrdersForStore(storeId);

        long pendingCount = activeOrders.stream().filter(o -> o.getStatus() == OrderStatus.PENDING).count();
        long preparingCount = activeOrders.stream().filter(o -> o.getStatus() == OrderStatus.PREPARING).count();
        long dineInCount = activeOrders.stream().filter(o -> o.getOrderType() == OrderType.DINE_IN).count();
        long takeAwayCount = activeOrders.stream().filter(o -> o.getOrderType() == OrderType.TAKE_AWAY).count();
        long deliveryCount = activeOrders.stream().filter(o -> o.getOrderType() == OrderType.DELIVERY).count();

        model.addAttribute("store", store);
        model.addAttribute("allStores", allStores);
        model.addAttribute("activeOrders", activeOrders);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("preparingCount", preparingCount);
        model.addAttribute("dineInCount", dineInCount);
        model.addAttribute("takeAwayCount", takeAwayCount);
        model.addAttribute("deliveryCount", deliveryCount);
        return "barista/kds";
    }

    @PostMapping("/barista/orders/{orderId}/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateStatus(@PathVariable Long orderId,
                                                            @RequestParam OrderStatus status,
                                                            @RequestParam(required = false) String note) {
        Order updated = orderService.updateOrderStatus(orderId, status, note);
        if (notificationService != null) {
            notificationService.notifyOrderStatusChanged(updated, note);
        }
        Map<String, Object> resp = new HashMap<>();
        resp.put("success", true);
        resp.put("orderId", orderId);
        resp.put("status", updated.getStatus().name());
        resp.put("message", "Cập nhật trạng thái thành công");
        return ResponseEntity.ok(resp);
    }
}