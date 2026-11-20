package com.utecoffe.controller.mvc;

import com.utecoffe.entity.Order;
import com.utecoffe.service.OrderService;
import com.utecoffe.service.StoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class CartController {

    @Autowired
    private StoreService storeService;

    @Autowired
    private OrderService orderService;

    @GetMapping("/cart")
    public String cart() {
        return "customer/cart";
    }

    @GetMapping("/checkout")
    public String checkout(Model model) {
        model.addAttribute("stores", storeService.getAllActiveStores());
        return "customer/checkout";
    }

    @GetMapping("/orders/tracking/{orderCode}")
    public String orderTracking(@PathVariable String orderCode, Model model) {
        Order order = orderService.getOrderByCode(orderCode);
        model.addAttribute("order", order);
        return "customer/order-tracking";
    }
}
