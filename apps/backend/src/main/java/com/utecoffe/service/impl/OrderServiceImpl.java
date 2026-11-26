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
    private UserCouponRepository userCouponRepository;

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
            if (isCouponEligible(coupon, subtotal, LocalDateTime.now(), user != null ? user.getId() : null)) {
                if (coupon.getDiscountType() == com.utecoffe.enums.DiscountType.PERCENTAGE) {
                    discount = subtotal.multiply(coupon.getDiscountValue()).divide(BigDecimal.valueOf(100));
                    if (coupon.getMaxDiscountAmount() != null && discount.compareTo(coupon.getMaxDiscountAmount()) > 0) {
                        discount = coupon.getMaxDiscountAmount();
                    }
                } else {
                    discount = coupon.getDiscountValue();
                }
                coupon.setUsedCount((coupon.getUsedCount() != null ? coupon.getUsedCount() : 0) + 1);
                couponRepository.save(coupon);

                if (user != null) {
                    UserCoupon userCoupon = UserCoupon.builder()
                            .user(user)
                            .coupon(coupon)
                            .order(savedOrder)
                            .isUsed(true)
                            .usedAt(LocalDateTime.now())
                            .build();
                    userCouponRepository.save(userCoupon);
                }
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

        // Initial Tracking record with stock availability check
        boolean stockAvailable = true;
        try {
            stockAvailable = inventoryService.verifyStockForOrder(savedOrder);
        } catch (Exception ignored) {}

        OrderTracking tracking = OrderTracking.builder()
                .order(savedOrder)
                .status(OrderStatus.PENDING)
                .message(stockAvailable ? "Đơn hàng đã được tạo thành công và chuyển đến quầy Barista" : "Đơn hàng đã ghi nhận, đang kiểm tra tồn kho nguyên liệu")
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

    private boolean isCouponEligible(Coupon coupon, BigDecimal subtotal, LocalDateTime now, Long userId) {
        if (coupon == null || !Boolean.TRUE.equals(coupon.getIsActive())) {
            return false;
        }
        if (coupon.getStartDate() != null && now.isBefore(coupon.getStartDate())) {
            return false;
        }
        if (coupon.getEndDate() != null && now.isAfter(coupon.getEndDate())) {
            return false;
        }
        if (coupon.getUsageLimit() != null && coupon.getUsedCount() != null
                && coupon.getUsedCount() >= coupon.getUsageLimit()) {
            return false;
        }
        if (coupon.getMinOrderValue() != null && subtotal.compareTo(coupon.getMinOrderValue()) < 0) {
            return false;
        }
        // Per-user limit enforcement (default: 1 use per customer account)
        if (userId != null && coupon.getId() != null) {
            long usedByUser = userCouponRepository.countByUserIdAndCouponIdAndIsUsedTrue(userId, coupon.getId());
            if (usedByUser >= 1) {
                return false;
            }
        }
        return true;
    }

    @Override
    @Transactional
    @Auditable(action = "UPDATE_ORDER_STATUS", entityName = "Order")
    public Order updateOrderStatus(Long orderId, OrderStatus newStatus, String note) {
        Order order = getOrderById(orderId);
        OrderStatus currentStatus = order.getStatus();

        if (currentStatus == newStatus) {
            return order; // No-op if status is unchanged
        }

        // Validate state transitions
        if (!isValidStatusTransition(currentStatus, newStatus)) {
            throw new IllegalStateException("Không thể chuyển trạng thái đơn hàng từ " + currentStatus + " sang " + newStatus);
        }

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

        // If order is CANCELLED, restore ingredients, reverse loyalty points, and restore coupon
        if (newStatus == OrderStatus.CANCELLED) {
            inventoryService.restoreStockForOrder(order);
            loyaltyService.reversePointsForOrder(order);

            if (order.getUser() != null) {
                List<UserCoupon> userCoupons = userCouponRepository.findByUserId(order.getUser().getId());
                for (UserCoupon uc : userCoupons) {
                    if (uc.getOrder() != null && uc.getOrder().getId().equals(order.getId()) && Boolean.TRUE.equals(uc.getIsUsed())) {
                        uc.setIsUsed(false);
                        uc.setUsedAt(null);
                        userCouponRepository.save(uc);

                        Coupon c = uc.getCoupon();
                        if (c != null && c.getUsedCount() != null && c.getUsedCount() > 0) {
                            c.setUsedCount(c.getUsedCount() - 1);
                            couponRepository.save(c);
                        }
                    }
                }
            }
        }

        String defaultMsg = switch (newStatus) {
            case CONFIRMED -> "Barista đã xác nhận đơn hàng và chuẩn bị nguyên liệu";
            case PREPARING -> "Thức uống đang được nghệ nhân Barista tỉ mỉ pha chế";
            case READY -> "Thức uống đã sẵn sàng tại quầy đón khách";
            case DELIVERING -> "Shipper đang giao thức uống đến tận tay bạn";
            case COMPLETED -> "Đơn hàng đã hoàn thành. Chúc bạn thưởng thức trọn vẹn hương vị UTECoffe!";
            case CANCELLED -> "Đơn hàng đã được hủy thành công";
            default -> "Đơn hàng đang được hệ thống xử lý";
        };

        OrderTracking tracking = OrderTracking.builder()
                .order(order)
                .status(newStatus)
                .message(note != null && !note.isBlank() ? note : defaultMsg)
                .build();
        orderTrackingRepository.save(tracking);

        return updated;
    }

    @Override
    @Transactional
    @Auditable(action = "CANCEL_ORDER", entityName = "Order")
    public Order cancelOrder(Long orderId, Long userId, String reason) {
        Order order = getOrderById(orderId);

        // Verify ownership if requested by user
        if (userId != null && (order.getUser() == null || !order.getUser().getId().equals(userId))) {
            throw new IllegalArgumentException("Bạn không có quyền hủy đơn hàng này");
        }

        // Customer can only cancel when order is still in PENDING status
        if (order.getStatus() != OrderStatus.PENDING) {
            throw new IllegalStateException("Đơn hàng đã được xác nhận hoặc đang pha chế, không thể tự hủy. Vui lòng liên hệ hotline 1900 2026.");
        }

        String cancelReason = (reason != null && !reason.isBlank()) ? reason : "Khách hàng yêu cầu hủy đơn hàng";
        return updateOrderStatus(orderId, OrderStatus.CANCELLED, cancelReason);
    }

    private boolean isValidStatusTransition(OrderStatus from, OrderStatus to) {
        if (from == null || to == null) return false;

        return switch (from) {
            case PENDING -> (to == OrderStatus.CONFIRMED || to == OrderStatus.PREPARING || to == OrderStatus.CANCELLED);
            case CONFIRMED -> (to == OrderStatus.PREPARING || to == OrderStatus.CANCELLED);
            case PREPARING -> (to == OrderStatus.READY || to == OrderStatus.DELIVERING || to == OrderStatus.COMPLETED || to == OrderStatus.CANCELLED);
            case READY -> (to == OrderStatus.DELIVERING || to == OrderStatus.COMPLETED || to == OrderStatus.CANCELLED);
            case DELIVERING -> (to == OrderStatus.COMPLETED || to == OrderStatus.CANCELLED);
            case COMPLETED, CANCELLED -> false; // Terminal states
        };
    }
}
