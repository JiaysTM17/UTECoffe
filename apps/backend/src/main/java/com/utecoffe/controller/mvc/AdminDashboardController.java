package com.utecoffe.controller.mvc;

import com.utecoffe.entity.*;
import com.utecoffe.enums.DiscountType;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.enums.OrderType;
import com.utecoffe.enums.ReservationStatus;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private StoreTableRepository storeTableRepository;

    @Autowired
    private TableReservationRepository tableReservationRepository;

    @Autowired
    private StoreInventoryRepository storeInventoryRepository;

    @Autowired
    private InventoryLogRepository inventoryLogRepository;

    @Autowired
    private IngredientRepository ingredientRepository;

    @Autowired
    private CategoryRepository categoryRepository;

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

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private SupplierRepository supplierRepository;

    @Autowired
    private PurchaseOrderRepository purchaseOrderRepository;

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private RefundRepository refundRepository;

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

        // Channel breakdown
        long dineInCount = allOrders.stream().filter(o -> o.getOrderType() == OrderType.DINE_IN).count();
        long takeAwayCount = allOrders.stream().filter(o -> o.getOrderType() == OrderType.TAKE_AWAY).count();
        long deliveryCount = allOrders.stream().filter(o -> o.getOrderType() == OrderType.DELIVERY).count();

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

        // Top 5 Best-selling Products
        List<OrderItem> allOrderItems = orderItemRepository.findAll();
        Map<String, Long> productSalesMap = new HashMap<>();
        for (OrderItem item : allOrderItems) {
            if (item.getProduct() != null) {
                productSalesMap.put(item.getProduct().getName(),
                        productSalesMap.getOrDefault(item.getProduct().getName(), 0L) + item.getQuantity());
            }
        }
        List<Map.Entry<String, Long>> topProducts = productSalesMap.entrySet().stream()
                .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                .limit(5)
                .toList();

        model.addAttribute("totalOrders", allOrders.size());
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("pendingOrdersCount", pendingOrdersCount);
        model.addAttribute("completedOrdersCount", completedOrdersCount);
        model.addAttribute("dineInCount", dineInCount);
        model.addAttribute("takeAwayCount", takeAwayCount);
        model.addAttribute("deliveryCount", deliveryCount);
        model.addAttribute("totalProducts", productRepository.count());
        model.addAttribute("totalStores", stores.size());
        model.addAttribute("stores", stores);
        model.addAttribute("storeOrderCounts", storeOrderCounts);
        model.addAttribute("storeRevenues", storeRevenues);
        model.addAttribute("topProducts", topProducts);
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

    @GetMapping("/stores")
    public String stores(Model model) {
        List<Store> stores = storeRepository.findAll();
        List<StoreTable> tables = storeTableRepository.findAll();
        List<TableReservation> reservations = tableReservationRepository.findAll().stream()
                .sorted(Comparator.comparing(TableReservation::getId).reversed())
                .toList();

        long occupiedTablesCount = tables.stream().filter(t -> Boolean.TRUE.equals(t.getIsOccupied())).count();

        model.addAttribute("stores", stores);
        model.addAttribute("tables", tables);
        model.addAttribute("reservations", reservations);
        model.addAttribute("totalTables", tables.size());
        model.addAttribute("occupiedTablesCount", occupiedTablesCount);
        return "admin/stores";
    }

    @PostMapping("/reservations/{id}/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateReservationStatus(@PathVariable Long id,
                                                                       @RequestParam ReservationStatus status) {
        Optional<TableReservation> opt = tableReservationRepository.findById(id);
        if (opt.isPresent()) {
            TableReservation res = opt.get();
            res.setStatus(status);
            if (res.getStoreTable() != null) {
                if (status == ReservationStatus.SEATED) {
                    res.getStoreTable().setIsOccupied(true);
                    storeTableRepository.save(res.getStoreTable());
                } else if (status == ReservationStatus.COMPLETED || status == ReservationStatus.CANCELLED) {
                    res.getStoreTable().setIsOccupied(false);
                    storeTableRepository.save(res.getStoreTable());
                }
            }
            tableReservationRepository.save(res);
            return ResponseEntity.ok(Map.of("success", true, "id", id, "status", status.name()));
        }
        return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Không tìm thấy lượt đặt bàn"));
    }

    @GetMapping("/coupons")
    public String coupons(Model model) {
        model.addAttribute("coupons", couponRepository.findAll().stream()
                .sorted(Comparator.comparing(Coupon::getId).reversed())
                .toList());
        return "admin/coupons";
    }

    @PostMapping("/coupons/create")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createCoupon(@RequestParam String code,
                                                            @RequestParam String title,
                                                            @RequestParam DiscountType discountType,
                                                            @RequestParam BigDecimal discountValue,
                                                            @RequestParam(required = false, defaultValue = "0") BigDecimal minOrderValue,
                                                            @RequestParam(required = false, defaultValue = "1000") Integer usageLimit) {
        Coupon c = Coupon.builder()
                .code(code.toUpperCase().trim())
                .title(title)
                .discountType(discountType)
                .discountValue(discountValue)
                .minOrderValue(minOrderValue)
                .maxDiscountAmount(discountValue.multiply(BigDecimal.valueOf(2)))
                .usageLimit(usageLimit)
                .usedCount(0)
                .isActive(true)
                .startDate(LocalDateTime.now())
                .endDate(LocalDateTime.now().plusMonths(6))
                .build();
        couponRepository.save(c);
        return ResponseEntity.ok(Map.of("success", true, "code", c.getCode()));
    }

    @PostMapping("/coupons/{id}/toggle")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleCoupon(@PathVariable Long id) {
        Optional<Coupon> opt = couponRepository.findById(id);
        if (opt.isPresent()) {
            Coupon c = opt.get();
            c.setIsActive(!Boolean.TRUE.equals(c.getIsActive()));
            couponRepository.save(c);
            return ResponseEntity.ok(Map.of("success", true, "isActive", c.getIsActive()));
        }
        return ResponseEntity.badRequest().body(Map.of("success", false));
    }

    @GetMapping("/products")
    public String products(Model model) {
        model.addAttribute("products", productRepository.findAll());
        model.addAttribute("categories", categoryRepository.findAll());
        return "admin/products";
    }

    @PostMapping("/products/{id}/toggle")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleProduct(@PathVariable Long id) {
        Optional<Product> opt = productRepository.findById(id);
        if (opt.isPresent()) {
            Product p = opt.get();
            p.setIsAvailable(!Boolean.TRUE.equals(p.getIsAvailable()));
            productRepository.save(p);
            return ResponseEntity.ok(Map.of("success", true, "isAvailable", p.getIsAvailable()));
        }
        return ResponseEntity.badRequest().body(Map.of("success", false));
    }

    @GetMapping("/inventory")
    public String inventory(Model model) {
        List<StoreInventory> inventories = storeInventoryRepository.findAll();
        long lowStockCount = inventories.stream()
                .filter(i -> i.getCurrentStock().compareTo(i.getSafetyStock()) <= 0)
                .count();

        model.addAttribute("inventories", inventories);
        model.addAttribute("stores", storeRepository.findAll());
        model.addAttribute("ingredients", ingredientRepository.findAll());
        model.addAttribute("lowStockCount", lowStockCount);
        model.addAttribute("logs", inventoryLogRepository.findAll().stream()
                .sorted(Comparator.comparing(InventoryLog::getId).reversed())
                .limit(20)
                .toList());
        return "admin/inventory";
    }

    @PostMapping("/inventory/{id}/restock")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> restockInventory(@PathVariable Long id,
                                                                @RequestParam BigDecimal amount) {
        Optional<StoreInventory> opt = storeInventoryRepository.findById(id);
        if (opt.isPresent()) {
            StoreInventory inv = opt.get();
            inv.setCurrentStock(inv.getCurrentStock().add(amount));
            inv.setLastRestockedAt(LocalDateTime.now());
            storeInventoryRepository.save(inv);
            return ResponseEntity.ok(Map.of("success", true, "newStock", inv.getCurrentStock()));
        }
        return ResponseEntity.badRequest().body(Map.of("success", false));
    }

    @GetMapping("/users")
    public String users(Model model) {
        model.addAttribute("users", userRepository.findAll());
        return "admin/users";
    }

    @GetMapping("/reviews")
    public String reviews(Model model) {
        model.addAttribute("reviews", reviewRepository.findAll().stream()
                .sorted(Comparator.comparing(Review::getId).reversed())
                .toList());
        return "admin/reviews";
    }

    @PostMapping("/reviews/{id}/reply")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> replyReview(@PathVariable Long id, @RequestParam String reply) {
        return ResponseEntity.ok(Map.of("success", true, "message", "Đã gửi phản hồi CSKH tới khách hàng"));
    }

    @GetMapping("/suppliers")
    public String suppliers(Model model) {
        model.addAttribute("suppliers", supplierRepository.findAll());
        model.addAttribute("purchaseOrders", purchaseOrderRepository.findAll().stream()
                .sorted(Comparator.comparing(PurchaseOrder::getId).reversed())
                .toList());
        model.addAttribute("stores", storeRepository.findAll());
        return "admin/suppliers";
    }

    @PostMapping("/suppliers/po/create")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createPurchaseOrder(@RequestParam Long storeId,
                                                                   @RequestParam Long supplierId,
                                                                   @RequestParam BigDecimal totalAmount) {
        Store store = storeRepository.findById(storeId).orElse(null);
        Supplier supplier = supplierRepository.findById(supplierId).orElse(null);
        if (store != null && supplier != null) {
            String poCode = "PO-" + System.currentTimeMillis() % 100000;
            PurchaseOrder po = PurchaseOrder.builder()
                    .store(store)
                    .supplier(supplier)
                    .orderCode(poCode)
                    .totalAmount(totalAmount)
                    .status("SENT")
                    .build();
            purchaseOrderRepository.save(po);
            return ResponseEntity.ok(Map.of("success", true, "code", poCode));
        }
        return ResponseEntity.badRequest().body(Map.of("success", false));
    }

    @PostMapping("/suppliers/po/{id}/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updatePoStatus(@PathVariable Long id, @RequestParam String status) {
        Optional<PurchaseOrder> opt = purchaseOrderRepository.findById(id);
        if (opt.isPresent()) {
            PurchaseOrder po = opt.get();
            po.setStatus(status);
            purchaseOrderRepository.save(po);
            return ResponseEntity.ok(Map.of("success", true, "status", status));
        }
        return ResponseEntity.badRequest().body(Map.of("success", false));
    }

    @GetMapping("/recipes")
    public String recipes(Model model) {
        model.addAttribute("recipes", recipeRepository.findAll());
        model.addAttribute("products", productRepository.findAll());
        model.addAttribute("ingredients", ingredientRepository.findAll());
        return "admin/recipes";
    }

    @GetMapping("/refunds")
    public String refunds(Model model) {
        model.addAttribute("refunds", refundRepository.findAll().stream()
                .sorted(Comparator.comparing(Refund::getId).reversed())
                .toList());
        return "admin/refunds";
    }

    @PostMapping("/refunds/{id}/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateRefundStatus(@PathVariable Long id, @RequestParam String status) {
        Optional<Refund> opt = refundRepository.findById(id);
        if (opt.isPresent()) {
            Refund ref = opt.get();
            ref.setStatus(status);
            refundRepository.save(ref);
            return ResponseEntity.ok(Map.of("success", true, "status", status));
        }
        return ResponseEntity.badRequest().body(Map.of("success", false));
    }

    @GetMapping("/audit-logs")
    public String auditLogs(Model model) {
        model.addAttribute("logs", auditLogRepository.findTop50ByOrderByTimestampDesc());
        return "admin/audit-logs";
    }
}