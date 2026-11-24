package com.utecoffe.controller.mvc;

import com.utecoffe.entity.Order;
import com.utecoffe.entity.Store;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.repository.*;
import com.utecoffe.service.ExcelExportService;
import com.utecoffe.service.OrderService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

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
    private StoreInventoryRepository storeInventoryRepository;

    @Autowired
    private InventoryLogRepository inventoryLogRepository;

    @Autowired
    private CouponRepository couponRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AuditLogRepository auditLogRepository;

    @Autowired
    private ExcelExportService excelExportService;

    @Autowired
    private OrderService orderService;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        List<Order> allOrders = orderRepository.findAll();
        BigDecimal totalRevenue = allOrders.stream()
                .filter(o -> o.getStatus() == OrderStatus.COMPLETED)
                .map(Order::getFinalAmount)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        long pendingOrdersCount = allOrders.stream()
                .filter(o -> o.getStatus() == OrderStatus.PENDING || o.getStatus() == OrderStatus.PREPARING)
                .count();

        long completedOrdersCount = allOrders.stream()
                .filter(o -> o.getStatus() == OrderStatus.COMPLETED)
                .count();

        List<Store> stores = storeRepository.findAll();
        Map<Long, Long> storeOrderCounts = new HashMap<>();
        Map<Long, BigDecimal> storeRevenues = new HashMap<>();

        for (Store st : stores) {
            long count = allOrders.stream()
                    .filter(o -> o.getStore() != null && o.getStore().getId().equals(st.getId()))
                    .count();
            BigDecimal rev = allOrders.stream()
                    .filter(o -> o.getStore() != null && o.getStore().getId().equals(st.getId()) && o.getStatus() == OrderStatus.COMPLETED)
                    .map(Order::getFinalAmount)
                    .filter(Objects::nonNull)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            storeOrderCounts.put(st.getId(), count);
            storeRevenues.put(st.getId(), rev);
        }

        model.addAttribute("totalOrders", allOrders.size());
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("pendingOrdersCount", pendingOrdersCount);
        model.addAttribute("completedOrdersCount", completedOrdersCount);
        model.addAttribute("totalProducts", productRepository.count());
        model.addAttribute("totalStores", stores.size());
        model.addAttribute("stores", stores);
        model.addAttribute("storeOrderCounts", storeOrderCounts);
        model.addAttribute("storeRevenues", storeRevenues);
        model.addAttribute("totalUsers", userRepository.count());
        model.addAttribute("recentOrders", allOrders.stream()
                .sorted(Comparator.comparing(Order::getId).reversed())
                .limit(10)
                .toList());

        return "admin/dashboard";
    }

    @GetMapping("/orders/export")
    public void exportOrders(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        String headerValue = "attachment; filename=orders_export_" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".xlsx";
        response.setHeader("Content-Disposition", headerValue);
        List<Order> orders = orderRepository.findAll();
        excelExportService.exportOrdersToExcel(orders, response.getOutputStream());
    }

    @GetMapping("/orders")
    public String orders(Model model) {
        List<Order> orders = orderRepository.findAll().stream()
                .sorted(Comparator.comparing(Order::getId).reversed())
                .toList();
        model.addAttribute("orders", orders);
        model.addAttribute("stores", storeRepository.findAll());
        return "admin/orders";
    }

    @PostMapping("/orders/{orderId}/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateOrderStatus(@PathVariable Long orderId,
                                                                 @RequestParam OrderStatus status,
                                                                 @RequestParam(required = false) String note) {
        Order updated = orderService.updateOrderStatus(orderId, status, note);
        Map<String, Object> resp = new HashMap<>();
        resp.put("success", true);
        resp.put("orderId", orderId);
        resp.put("status", updated.getStatus().name());
        return ResponseEntity.ok(resp);
    }

    @GetMapping("/products")
    public String products(Model model) {
        model.addAttribute("products", productRepository.findAll());
        return "admin/products";
    }

    @GetMapping("/inventory")
    public String inventory(Model model) {
        model.addAttribute("inventories", storeInventoryRepository.findAll());
        model.addAttribute("logs", inventoryLogRepository.findAll().stream().limit(20).toList());
        return "admin/inventory";
    }

    @GetMapping("/stores")
    public String stores(Model model) {
        model.addAttribute("stores", storeRepository.findAll());
        return "admin/stores";
    }

    @GetMapping("/coupons")
    public String coupons(Model model) {
        model.addAttribute("coupons", couponRepository.findAll());
        return "admin/coupons";
    }

    @GetMapping("/users")
    public String users(Model model) {
        model.addAttribute("users", userRepository.findAll());
        return "admin/users";
    }

    @GetMapping("/audit-logs")
    public String auditLogs(Model model) {
        model.addAttribute("logs", auditLogRepository.findTop50ByOrderByTimestampDesc());
        return "admin/audit-logs";
    }
}