package com.utecoffe;

import com.utecoffe.dto.request.OrderCreateRequest;
import com.utecoffe.entity.*;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.enums.OrderType;
import com.utecoffe.enums.PaymentMethod;
import com.utecoffe.repository.*;
import com.utecoffe.service.InventoryService;
import com.utecoffe.service.impl.OrderServiceImpl;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

    @Mock
    private OrderRepository orderRepository;
    @Mock
    private OrderItemRepository orderItemRepository;
    @Mock
    private OrderItemToppingRepository orderItemToppingRepository;
    @Mock
    private OrderTrackingRepository orderTrackingRepository;
    @Mock
    private PaymentRepository paymentRepository;
    @Mock
    private StoreRepository storeRepository;
    @Mock
    private ProductRepository productRepository;
    @Mock
    private ProductSizeRepository productSizeRepository;
    @Mock
    private ToppingRepository toppingRepository;
    @Mock
    private UserRepository userRepository;
    @Mock
    private CouponRepository couponRepository;
    @Mock
    private InventoryService inventoryService;
    @Mock
    private com.utecoffe.service.LoyaltyService loyaltyService;
    @Mock
    private com.utecoffe.service.EmailService emailService;

    @InjectMocks
    private OrderServiceImpl orderService;

    @Test
    void testCreateOrder_Success() {
        OrderCreateRequest request = new OrderCreateRequest();
        request.setStoreId(1L);
        request.setOrderType(OrderType.TAKE_AWAY);
        request.setPaymentMethod(PaymentMethod.VIETQR);
        request.setRecipientName("Tran Thi B");
        request.setRecipientPhone("0912345678");

        OrderCreateRequest.OrderItemRequest itemReq = new OrderCreateRequest.OrderItemRequest();
        itemReq.setProductId(1L);
        itemReq.setQuantity(2);
        request.setItems(Collections.singletonList(itemReq));

        Store store = Store.builder().id(1L).name("UTECoffe Thu Duc").build();
        Product product = Product.builder().id(1L).name("Cold Brew").basePrice(BigDecimal.valueOf(50000)).build();

        when(storeRepository.findById(1L)).thenReturn(Optional.of(store));
        when(productRepository.findById(1L)).thenReturn(Optional.of(product));
        when(orderRepository.save(any(Order.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Order order = orderService.createOrder(request, null);

        assertNotNull(order);
        assertEquals(OrderStatus.PENDING, order.getStatus());
        assertEquals(BigDecimal.valueOf(100000), order.getSubtotal());
        assertEquals(BigDecimal.valueOf(100000), order.getFinalAmount());
        verify(paymentRepository, times(1)).save(any(Payment.class));
    }
}
