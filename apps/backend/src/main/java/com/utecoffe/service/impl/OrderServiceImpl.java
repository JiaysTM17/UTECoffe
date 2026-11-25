package com.utecoffe.service.impl;

import com.utecoffe.dto.request.OrderCreateRequest;
import com.utecoffe.entity.*;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.enums.PaymentStatus;
import com.utecoffe.repository.*;
import com.utecoffe.service.InventoryService;
import com.utecoffe.aspect.Auditable;
import com.utecoffe.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private OrderItemToppingRepository orderItemToppingRepository;

    @Autowired
    private OrderTrackingRepository orderTrackingRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductSizeRepository productSizeRepository;

    @Autowired
    private ToppingRepository toppingRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CouponRepository couponRepository;

    @Autowired
    private InventoryService inventoryService;

    @Autowired
    private com.utecoffe.service.LoyaltyService loyaltyService;

    @Autowired(required = false)
    private com.utecoffe.service.EmailService emailService;

    @Override
    @Transactional
    @Auditable(action = "CREATE_ORDER", entityName = "Order")
    public Order createOrder(OrderCreateRequest request, Long userId) {
        Store store = storeRepository.findById(request.getStoreId())
                .orElseThrow(() -> new RuntimeException("Chi nhanh khong ton tai"));

        User user = (userId != null) ? userRepository.findById(userId).orElse(null) : null;

        // Generate Order Code: UTE-YYMMDD-XXXX
        String dateStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyMMdd"));
        String randStr = String.format("%04d", new Random().nextInt(10000));
        String orderCode = "UTE-" + dateStr + "-" + randStr;

        BigDecimal subtotal = BigDecimal.ZERO;

        Order order = Order.builder()
                .orderCode(orderCode)
                .user(user)
                .store(store)
                .orderType(request.getOrderType())
                .status(OrderStatus.PENDING)
                .deliveryAddress(request.getDeliveryAddress())
                .recipientName(request.getRecipientName())
                .recipientPhone(request.getRecipientPhone())
                .note(request.getNote())
                .subtotal(BigDecimal.ZERO)
                .discountAmount(BigDecimal.ZERO)
                .shippingFee(request.getOrderType() == com.utecoffe.enums.OrderType.DELIVERY ? BigDecimal.valueOf(20000) : BigDecimal.ZERO)
                .finalAmount(BigDecimal.ZERO)
                .build();

        Order savedOrder = orderRepository.save(order);

        // Process items
        for (OrderCreateRequest.OrderItemRequest itemReq : request.getItems()) {
            Product product = productRepository.findById(itemReq.getProductId())
                    .orElseThrow(() -> new RuntimeException("San pham khong ton tai: " + itemReq.getProductId()));

            ProductSize size = (itemReq.getProductSizeId() != null)
                    ? productSizeRepository.findById(itemReq.getProductSizeId()).orElse(null)
                    : null;

            BigDecimal unitPrice = product.getBasePrice();
            if (size != null) {
                unitPrice = unitPrice.add(size.getExtraPrice());
            }

            BigDecimal itemSubtotal = unitPrice.multiply(BigDecimal.valueOf(itemReq.getQuantity()));

            OrderItem orderItem = OrderItem.builder()
                    .order(savedOrder)
                    .product(product)
                    .productSize(size)
                    .unitPrice(unitPrice)
                    .quantity(itemReq.getQuantity())
                    .subtotal(itemSubtotal)
                    .note(itemReq.getNote())
                    .build();

            OrderItem savedItem = orderItemRepository.save(orderItem);

            // Toppings
            if (itemReq.getToppingIds() != null) {
                for (Long toppingId : itemReq.getToppingIds()) {
                    Topping topping = toppingRepository.findById(toppingId).orElse(null);
                    if (topping != null) {
                        BigDecimal toppingSubtotal = topping.getPrice().multiply(BigDecimal.valueOf(itemReq.getQuantity()));
                        OrderItemTopping itemTopping = OrderItemTopping.builder()
                                .orderItem(savedItem)
                                .topping(topping)
                                .unitPrice(topping.getPrice())
                                .quantity(itemReq.getQuantity())
                                .subtotal(toppingSubtotal)
                                .build();
                        orderItemToppingRepository.save(itemTopping);
                        itemSubtotal = itemSubtotal.add(toppingSubtotal);
                    }
                }
            }

            subtotal = subtotal.add(itemSubtotal);
        }

        // Coupon calculation
        BigDecimal discount = BigDecimal.ZERO;
        if (request.getCouponCode() != null && !request.getCouponCode().isBlank()) {
            Coupon coupon = couponRepository.findByCodeAndIsActiveTrue(request.getCouponCode().trim()).orElse(null);
            if (coupon != null && (coupon.getMinOrderValue() == null || subtotal.compareTo(coupon.getMinOrderValue()) >= 0)) {
                if (coupon.getDiscountType() == com.utecoffe.enums.DiscountType.PERCENTAGE) {
                    discount = subtotal.multiply(coupon.getDiscountValue()).divide(BigDecimal.valueOf(100));
                    if (coupon.getMaxDiscountAmount() != null && discount.compareTo(coupon.getMaxDiscountAmount()) > 0) {
                        discount = coupon.getMaxDiscountAmount();
                    }
                } else {
                    discount = coupon.getDiscountValue();
                }
                coupon.setUsedCount(coupon.getUsedCount() + 1);
                couponRepository.save(coupon);
            }
        }

        BigDecimal finalAmount = subtotal.subtract(discount).add(savedOrder.getShippingFee());
        if (finalAmount.compareTo(BigDecimal.ZERO) < 0) {
            finalAmount = BigDecimal.ZERO;
        }

        savedOrder.setSubtotal(subtotal);
        savedOrder.setDiscountAmount(discount);
        savedOrder.setFinalAmount(finalAmount);
        orderRepository.save(savedOrder);

        // Initial Payment record
        Payment payment = Payment.builder()
                .order(savedOrder)
                .paymentMethod(request.getPaymentMethod())
                .status(PaymentStatus.UNPAID)
                .amount(finalAmount)
                .build();
        paymentRepository.save(payment);

        // Initial Tracking record
        OrderTracking tracking = OrderTracking.builder()
                .order(savedOrder)
                .status(OrderStatus.PENDING)
                .message("Don hang da duoc tao thanh cong va cho xac nhan")
                .build();
        orderTrackingRepository.save(tracking);

        // Async email confirmation dispatch
        if (emailService != null) {
            emailService.sendOrderReceipt(savedOrder);
        }

        return savedOrder;
    }

    @Override
    public Order getOrderByCode(String orderCode) {
        Order order = orderRepository.findByOrderCode(orderCode)
                .orElseThrow(() -> new RuntimeException("Khong tim thay don hang: " + orderCode));
        List<OrderItem> items = orderItemRepository.findByOrderId(order.getId());
        order.setItems(items);
        paymentRepository.findByOrderId(order.getId()).ifPresent(p -> {
            if (p.getPaymentMethod() != null) {
                order.setPaymentMethod(p.getPaymentMethod().name());
            }
        });
        return order;
    }

    @Override
    public Order getOrderById(Long id) {
        return orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay don hang: " + id));
    }

    @Override
    public List<Order> getUserOrders(Long userId) {
        return orderRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    @Override
    public List<Order> getKdsOrdersForStore(Long storeId) {
        List<OrderStatus> kdsStatuses = Arrays.asList(OrderStatus.CONFIRMED, OrderStatus.PREPARING);
        return orderRepository.findByStoreIdAndStatusInOrderByCreatedAtAsc(storeId, kdsStatuses);
    }

    @Override
    @Transactional
    @Auditable(action = "UPDATE_ORDER_STATUS", entityName = "Order")
    public Order updateOrderStatus(Long orderId, OrderStatus newStatus, String note) {
        Order order = getOrderById(orderId);
        order.setStatus(newStatus);
        Order updated = orderRepository.save(order);

        // If order moves to PREPARING, deduct ingredients BOM
        if (newStatus == OrderStatus.PREPARING) {
            inventoryService.deductStockForOrder(order);
        }

        // If order is COMPLETED, automatically accumulate UTEClub loyalty points
        if (newStatus == OrderStatus.COMPLETED) {
            loyaltyService.accumulatePointsForOrder(order);
        }

        OrderTracking tracking = OrderTracking.builder()
                .order(order)
                .status(newStatus)
                .message(note != null ? note : "Trang thai don hang chuyen sang: " + newStatus.name())
                .build();
        orderTrackingRepository.save(tracking);

        return updated;
    }
}
