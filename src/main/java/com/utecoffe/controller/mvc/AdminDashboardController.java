package com.utecoffe.controller.mvc;

import com.utecoffe.repository.OrderRepository;
import com.utecoffe.repository.ProductRepository;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("totalOrders", orderRepository.count());
        model.addAttribute("totalProducts", productRepository.count());
        model.addAttribute("totalStores", storeRepository.count());
        model.addAttribute("totalUsers", userRepository.count());
        return "admin/dashboard";
    }

    @GetMapping("/orders")
    public String orders(Model model) {
        model.addAttribute("orders", orderRepository.findAll());
        return "admin/orders";
    }

    @GetMapping("/products")
    public String products(Model model) {
        model.addAttribute("products", productRepository.findAll());
        return "admin/products";
    }
}
