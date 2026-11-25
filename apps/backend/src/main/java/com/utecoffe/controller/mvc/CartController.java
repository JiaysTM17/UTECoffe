package com.utecoffe.controller.mvc;

import com.utecoffe.dto.cart.CartItemViewDto;
import com.utecoffe.dto.cart.CartViewDto;
import com.utecoffe.dto.request.OrderCreateRequest;
import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.dto.response.CouponKnapsackResultDto;
import com.utecoffe.dto.response.CrossSellRecommendationDto;
import com.utecoffe.entity.*;
import com.utecoffe.enums.OrderType;
import com.utecoffe.enums.PaymentMethod;
import com.utecoffe.repository.ProductRepository;
import com.utecoffe.repository.ProductSizeRepository;
import com.utecoffe.repository.ToppingRepository;
import com.utecoffe.service.*;
import com.utecoffe.websocket.OrderNotificationService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

@Controller
public class CartController {

    private static final String CART_SESSION_KEY = "SESSION_CART";
    private final AtomicLong itemIdGenerator = new AtomicLong(1000);

    @Autowired
    private StoreService storeService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductSizeRepository productSizeRepository;

    @Autowired
    private ToppingRepository toppingRepository;

    @Autowired
    private CouponOptimizationService couponOptimizationService;

    @Autowired
    private MarketBasketAnalysisService marketBasketAnalysisService;

    @Autowired
    private VietQrService vietQrService;

    @Autowired
    private VnPayService vnPayService;

    @Autowired
    private MoMoPaymentService moMoPaymentService;

    @Autowired
    private AuthService authService;

    @Autowired
    private OrderNotificationService notificationService;

    private CartViewDto getOrCreateCart(HttpSession session) {
        CartViewDto cart = (CartViewDto) session.getAttribute(CART_SESSION_KEY);
        if (cart == null) {
            cart = new CartViewDto();
            session.setAttribute(CART_SESSION_KEY, cart);
        }
        return cart;
    }

    private void recalculateCart(CartViewDto cart) {
        if (cart == null) return;

        BigDecimal subtotal = BigDecimal.ZERO;
        if (cart.getItems() != null) {
            for (CartItemViewDto item : cart.getItems()) {
                if (item.getUnitPrice() != null && item.getQuantity() != null) {
                    BigDecimal itemSubtotal = item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
                    item.setSubtotal(itemSubtotal);
                    subtotal = subtotal.add(itemSubtotal);
                }
            }
        }
        cart.setTotalAmount(subtotal);

        // Free shipping rule: orders >= 150,000 VND get free shipping (otherwise 15,000 VND)
        if (subtotal.compareTo(BigDecimal.valueOf(150000)) >= 0 || subtotal.compareTo(BigDecimal.ZERO) == 0) {
            cart.setShippingFee(BigDecimal.ZERO);
        } else {
            cart.setShippingFee(BigDecimal.valueOf(15000));
        }

        // 0/1 Knapsack Coupon Optimization
        List<String> userVouchers = List.of("UTE2026", "FREESHIP", "VIP_COFFEE_30", "WELCOME10");
        try {
            CouponKnapsackResultDto optimal = couponOptimizationService.findOptimalCouponCombination(subtotal, userVouchers);
            cart.setOptimalCoupon(optimal);
        } catch (Exception ignored) {}

        // Apply selected voucher if any
        BigDecimal discount = BigDecimal.ZERO;
        if (cart.getCouponCode() != null && !cart.getCouponCode().isBlank()) {
            String code = cart.getCouponCode().trim().toUpperCase();
            if ("UTE2026".equals(code)) {
                // 20% discount up to 50,000 VND
                discount = subtotal.multiply(BigDecimal.valueOf(0.20));
                if (discount.compareTo(BigDecimal.valueOf(50000)) > 0) {
                    discount = BigDecimal.valueOf(50000);
                }
            } else if ("FREESHIP".equals(code)) {
                cart.setShippingFee(BigDecimal.ZERO);
                discount = BigDecimal.valueOf(15000);
            }
        }
        cart.setDiscountAmount(discount);

        // Apriori Market Basket Analysis Recommendations
        if (cart.getItems() != null && !cart.getItems().isEmpty()) {
            try {
                Long firstProductId = cart.getItems().get(0).getProduct().getId();
                List<CrossSellRecommendationDto> recommendations =
                        marketBasketAnalysisService.getRecommendationsForProduct(firstProductId, 3);
                cart.setPairingRecommendations(recommendations);
            } catch (Exception ignored) {}
        }

        BigDecimal finalAmount = subtotal.subtract(discount).add(cart.getShippingFee());
        if (finalAmount.compareTo(BigDecimal.ZERO) < 0) {
            finalAmount = BigDecimal.ZERO;
        }
        cart.setFinalAmount(finalAmount);
    }

    private void seedDefaultItemIfEmpty(CartViewDto cart) {
        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            List<Product> products = productRepository.findAll();
            if (!products.isEmpty()) {
                Product defaultProduct = products.get(0);
                ProductSize defaultSize = ProductSize.builder()
                        .product(defaultProduct)
                        .sizeName("M (Grande)")
                        .extraPrice(BigDecimal.valueOf(10000))
                        .build();

                BigDecimal unitPrice = defaultProduct.getBasePrice().add(defaultSize.getExtraPrice());
                CartItemViewDto defaultItem = CartItemViewDto.builder()
                        .id(itemIdGenerator.incrementAndGet())
                        .product(defaultProduct)
                        .productSize(defaultSize)
                        .quantity(1)
                        .sugarLevel(100)
                        .iceLevel(100)
                        .unitPrice(unitPrice)
                        .subtotal(unitPrice)
                        .build();

                if (cart.getItems() == null) {
                    cart.setItems(new ArrayList<>());
                }
                cart.getItems().add(defaultItem);
            }
        }
    }

    @GetMapping("/cart")
    public String cart(HttpSession session, Model model) {
        CartViewDto cart = getOrCreateCart(session);
        recalculateCart(cart);
        model.addAttribute("cart", cart);
        return "customer/cart";
    }

    @PostMapping("/cart/add")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addToCart(
            @RequestParam("productId") Long productId,
            @RequestParam(name = "size", defaultValue = "M") String size,
            @RequestParam(name = "sugar", defaultValue = "100") Object sugarParam,
            @RequestParam(name = "ice", defaultValue = "100") Object iceParam,
            @RequestParam(name = "quantity", defaultValue = "1") Integer quantity,
            @RequestParam(name = "toppingIds", required = false) List<Long> toppingIds,
            @RequestParam(name = "note", required = false) String note,
            HttpSession session) {

        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Sản phẩm không tồn tại: " + productId));

        CartViewDto cart = getOrCreateCart(session);
        if (cart.getItems() == null) {
            cart.setItems(new ArrayList<>());
        }

        Integer sugar = 100;
        if (sugarParam != null) {
            String s = sugarParam.toString().replaceAll("[^0-9]", "");
            if (!s.isEmpty()) {
                try { sugar = Integer.parseInt(s); } catch (Exception ignored) {}
            }
        }

        Integer ice = 100;
        if (iceParam != null) {
            String s = iceParam.toString();
            if ("HOT".equalsIgnoreCase(s.trim())) {
                ice = 0;
            } else {
                String digits = s.replaceAll("[^0-9]", "");
                if (!digits.isEmpty()) {
                    try { ice = Integer.parseInt(digits); } catch (Exception ignored) {}
                }
            }
        }

        int finalQty = (quantity != null && quantity > 0) ? quantity : 1;

        BigDecimal extraSize = "L".equalsIgnoreCase(size) ? BigDecimal.valueOf(18000)
                : "M".equalsIgnoreCase(size) ? BigDecimal.valueOf(10000) : BigDecimal.ZERO;

        ProductSize productSize = ProductSize.builder()
                .product(product)
                .sizeName("Size " + size)
                .extraPrice(extraSize)
                .build();

        BigDecimal unitPrice = product.getBasePrice().add(extraSize);
        List<String> toppingNames = new ArrayList<>();
        if (toppingIds != null) {
            for (Long tid : toppingIds) {
                toppingRepository.findById(tid).ifPresent(t -> {
                    toppingNames.add(t.getName());
                });
            }
        }

        CartItemViewDto newItem = CartItemViewDto.builder()
                .id(itemIdGenerator.incrementAndGet())
                .product(product)
                .productSize(productSize)
                .quantity(finalQty)
                .sugarLevel(sugar)
                .iceLevel(ice)
                .toppingIds(toppingIds)
                .toppingNames(toppingNames)
                .unitPrice(unitPrice)
                .subtotal(unitPrice.multiply(BigDecimal.valueOf(finalQty)))
                .note(note)
                .build();

        cart.getItems().add(newItem);
        recalculateCart(cart);

        Map<String, Object> resp = new HashMap<>();
        resp.put("success", true);
        resp.put("cartCount", cart.getItems().size());
        resp.put("totalAmount", cart.getTotalAmount());
        resp.put("finalAmount", cart.getFinalAmount());
        resp.put("message", "Đã thêm " + product.getName() + " vào giỏ hàng");
        return ResponseEntity.ok(resp);
    }

    @PostMapping("/cart/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateCartQuantity(
            @RequestParam("itemId") Long itemId,
            @RequestParam("quantity") Integer quantity,
            HttpSession session) {

        CartViewDto cart = getOrCreateCart(session);
        if (cart.getItems() != null) {
            if (quantity <= 0) {
                cart.getItems().removeIf(it -> Objects.equals(it.getId(), itemId));
            } else {
                for (CartItemViewDto item : cart.getItems()) {
                    if (Objects.equals(item.getId(), itemId)) {
                        item.setQuantity(quantity);
                        break;
                    }
                }
            }
        }
        recalculateCart(cart);

        Map<String, Object> resp = new HashMap<>();
        resp.put("success", true);
        resp.put("totalAmount", cart.getTotalAmount());
        resp.put("finalAmount", cart.getFinalAmount());
        return ResponseEntity.ok(resp);
    }

    @PostMapping("/cart/remove/{itemId}")
    public String removeCartItem(@PathVariable("itemId") Long itemId, HttpSession session) {
        CartViewDto cart = getOrCreateCart(session);
        if (cart.getItems() != null) {
            cart.getItems().removeIf(it -> Objects.equals(it.getId(), itemId));
        }
        recalculateCart(cart);
        return "redirect:/cart";
    }

    @PostMapping("/cart/apply-voucher")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> applyVoucher(@RequestParam("code") String code, HttpSession session) {
        CartViewDto cart = getOrCreateCart(session);
        cart.setCouponCode(code);
        recalculateCart(cart);

        Map<String, Object> resp = new HashMap<>();
        resp.put("success", true);
        resp.put("discountAmount", cart.getDiscountAmount());
        resp.put("finalAmount", cart.getFinalAmount());
        resp.put("shippingFee", cart.getShippingFee());
        resp.put("message", "Đã áp dụng mã " + code);
        return ResponseEntity.ok(resp);
    }

    @GetMapping({"/checkout", "/cart/checkout"})
    public String checkout(HttpSession session, Model model) {
        CartViewDto cart = getOrCreateCart(session);
        seedDefaultItemIfEmpty(cart);
        recalculateCart(cart);

        model.addAttribute("cart", cart);
        model.addAttribute("stores", storeService.getAllActiveStores());
        return "customer/checkout";
    }

    @PostMapping("/checkout/place-order")
    public String placeOrder(
            @RequestParam(name = "storeId", defaultValue = "1") Long storeId,
            @RequestParam(name = "orderType", defaultValue = "DELIVERY") OrderType orderType,
            @RequestParam(name = "paymentMethod", defaultValue = "COD") PaymentMethod paymentMethod,
            @RequestParam(name = "recipientName", required = false) String recipientName,
            @RequestParam(name = "customerName", required = false) String customerName,
            @RequestParam(name = "recipientPhone", required = false) String recipientPhone,
            @RequestParam(name = "customerPhone", required = false) String customerPhone,
            @RequestParam(name = "deliveryAddress", required = false) String deliveryAddress,
            @RequestParam(name = "note", required = false) String note,
            @RequestParam(name = "couponCode", required = false) String couponCode,
            @AuthenticationPrincipal UserDetails userDetails,
            HttpServletRequest request,
            HttpSession session) {

        CartViewDto cart = getOrCreateCart(session);
        seedDefaultItemIfEmpty(cart);
        recalculateCart(cart);

        String finalName = recipientName != null && !recipientName.isBlank() ? recipientName
                : (customerName != null && !customerName.isBlank() ? customerName : "Khách Hàng UTE");
        String finalPhone = recipientPhone != null && !recipientPhone.isBlank() ? recipientPhone
                : (customerPhone != null && !customerPhone.isBlank() ? customerPhone : "0900000000");

        Long userId = null;
        if (userDetails != null) {
            User user = authService.getByEmail(userDetails.getUsername());
            if (user != null) userId = user.getId();
        }

        // Build OrderCreateRequest
        List<OrderCreateRequest.OrderItemRequest> orderItems = new ArrayList<>();
        if (cart.getItems() != null) {
            for (CartItemViewDto it : cart.getItems()) {
                OrderCreateRequest.OrderItemRequest reqItem = new OrderCreateRequest.OrderItemRequest();
                reqItem.setProductId(it.getProduct().getId());
                reqItem.setQuantity(it.getQuantity());
                reqItem.setToppingIds(it.getToppingIds());
                reqItem.setNote(it.getNote());
                orderItems.add(reqItem);
            }
        }

        OrderCreateRequest createRequest = new OrderCreateRequest();
        createRequest.setStoreId(storeId != null ? storeId : 1L);
        createRequest.setOrderType(orderType != null ? orderType : OrderType.DELIVERY);
        createRequest.setPaymentMethod(paymentMethod != null ? paymentMethod : PaymentMethod.COD);
        createRequest.setRecipientName(finalName);
        createRequest.setRecipientPhone(finalPhone);
        createRequest.setDeliveryAddress(deliveryAddress != null ? deliveryAddress : "Nhận tại cửa hàng UTECoffe");
        createRequest.setNote(note);
        createRequest.setCouponCode(couponCode != null ? couponCode : cart.getCouponCode());
        createRequest.setItems(orderItems);

        Order order = orderService.createOrder(createRequest, userId);
        notificationService.notifyNewOrderToKds(order);

        // Reset cart in session
        session.removeAttribute(CART_SESSION_KEY);

        // In-App Simulated QR Payment - Keep customer 100% on UTECoffe website!
        String methodCode = paymentMethod != null ? paymentMethod.name().toLowerCase() : "vietqr";
        if (paymentMethod == PaymentMethod.COD) {
            return "redirect:/orders/tracking/" + order.getOrderCode() + "?payment=cod";
        } else {
            return "redirect:/orders/tracking/" + order.getOrderCode() + "?payment=" + methodCode + "&showQr=true";
        }
    }

    @GetMapping("/orders/tracking/{orderCode}")
    public String orderTracking(
            @PathVariable("orderCode") String orderCode,
            @RequestParam(name = "payment", required = false) String paymentParam,
            @RequestParam(name = "showQr", required = false) Boolean showQr,
            Model model) {
        Order order = orderService.getOrderByCode(orderCode);
        model.addAttribute("order", order);

        String vietQrUrl = vietQrService.generateVietQrUrl(order);
        model.addAttribute("vietQrUrl", vietQrUrl);

        boolean isElectronicPayment = order.getPaymentMethod() != null && !"COD".equalsIgnoreCase(order.getPaymentMethod());
        boolean displayQr = Boolean.TRUE.equals(showQr) || (isElectronicPayment && "PENDING".equalsIgnoreCase(String.valueOf(order.getStatus())));
        model.addAttribute("showQr", displayQr);
        model.addAttribute("paymentParam", paymentParam != null ? paymentParam : (order.getPaymentMethod() != null ? order.getPaymentMethod().toLowerCase() : "vietqr"));

        return "customer/order-tracking";
    }
}
