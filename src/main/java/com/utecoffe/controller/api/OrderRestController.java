package com.utecoffe.controller.api;

import com.utecoffe.dto.request.OrderCreateRequest;
import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.User;
import com.utecoffe.service.AuthService;
import com.utecoffe.service.OrderService;
import com.utecoffe.websocket.OrderNotificationService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderRestController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private AuthService authService;

    @Autowired
    private OrderNotificationService notificationService;

    @PostMapping
    public ResponseEntity<ApiResponse<Order>> createOrder(@Valid @RequestBody OrderCreateRequest request,
                                                         @AuthenticationPrincipal UserDetails userDetails) {
        Long userId = null;
        if (userDetails != null) {
            User user = authService.getByEmail(userDetails.getUsername());
            if (user != null) userId = user.getId();
        }

        Order order = orderService.createOrder(request, userId);
        notificationService.notifyNewOrderToKds(order);

        return ResponseEntity.ok(ApiResponse.success(order, "Dat hang thanh cong. Ma don: " + order.getOrderCode()));
    }

    @GetMapping("/{orderCode}")
    public ResponseEntity<ApiResponse<Order>> getOrderByCode(@PathVariable String orderCode) {
        return ResponseEntity.ok(ApiResponse.success(orderService.getOrderByCode(orderCode), "Thong tin don hang"));
    }

    @GetMapping("/my-orders")
    public ResponseEntity<ApiResponse<List<Order>>> getMyOrders(@AuthenticationPrincipal UserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Vui long dang nhap de xem lich su don"));
        }
        User user = authService.getByEmail(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.success(orderService.getUserOrders(user.getId()), "Lich su don hang"));
    }
}
