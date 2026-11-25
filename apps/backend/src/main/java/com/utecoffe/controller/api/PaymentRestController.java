package com.utecoffe.controller.api;

import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.Payment;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.enums.PaymentStatus;
import com.utecoffe.repository.PaymentRepository;
import com.utecoffe.service.OrderService;
import com.utecoffe.service.VietQrService;
import com.utecoffe.service.VnPayService;
import com.utecoffe.websocket.OrderNotificationService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/payments")
public class PaymentRestController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private VietQrService vietQrService;

    @Autowired
    private VnPayService vnPayService;

    @Autowired
    private com.utecoffe.service.MoMoPaymentService moMoPaymentService;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private OrderNotificationService notificationService;

    @GetMapping("/vietqr/{orderCode}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getVietQrDetails(@PathVariable String orderCode) {
        Order order = orderService.getOrderByCode(orderCode);
        String qrUrl = vietQrService.generateVietQrUrl(order);

        Map<String, Object> response = new HashMap<>();
        response.put("orderCode", order.getOrderCode());
        response.put("finalAmount", order.getFinalAmount());
        response.put("qrImageUrl", qrUrl);
        response.put("bankName", "VietinBank");
        response.put("accountNo", "108868686868");
        response.put("accountName", "UTECOFFE SPECIALTY");
        response.put("description", "THANH TOAN DON " + order.getOrderCode());

        return ResponseEntity.ok(ApiResponse.success(response, "Lay thong tin VietQR thanh cong"));
    }

    @PostMapping("/vietqr/verify/{orderCode}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> verifyVietQr(@PathVariable String orderCode) {
        Order order = orderService.getOrderByCode(orderCode);
        Payment payment = paymentRepository.findByOrderId(order.getId()).orElse(null);
        if (payment != null) {
            payment.setStatus(PaymentStatus.PAID);
            payment.setPaymentTime(LocalDateTime.now());
            payment.setTransactionId("VQR-" + System.currentTimeMillis());
            paymentRepository.save(payment);
        }
        orderService.updateOrderStatus(order.getId(), OrderStatus.PREPARING, "Xac nhan thanh toan VietQR thanh cong! Barista dang pha che.");
        notificationService.notifyOrderStatusChanged(order, "Thanh toan VietQR thanh cong! Don hang da duoc chuyen sang quay pha che.");
        notificationService.notifyNewOrderToKds(order);

        Map<String, Object> resp = new HashMap<>();
        resp.put("orderCode", order.getOrderCode());
        resp.put("status", "PREPARING");
        resp.put("message", "Thanh toan VietQR thanh cong! Barista dang bat dau chiet xuat.");
        return ResponseEntity.ok(ApiResponse.success(resp, "Xac nhan thanh toan VietQR thanh cong"));
    }

    @GetMapping("/vnpay/create-url/{orderCode}")
    public ResponseEntity<ApiResponse<String>> createVnPayUrl(@PathVariable String orderCode, HttpServletRequest request) {
        Order order = orderService.getOrderByCode(orderCode);
        String url = vnPayService.createPaymentUrl(order, request);
        return ResponseEntity.ok(ApiResponse.success(url, "Tao URL thanh toan VNPAY thanh cong"));
    }

    @GetMapping("/vnpay/callback")
    public void vnpayCallback(@RequestParam Map<String, String> queryParams, HttpServletResponse response) throws IOException {
        boolean valid = vnPayService.verifyCallback(queryParams);
        String orderCode = queryParams.get("vnp_TxnRef");
        String responseCode = queryParams.get("vnp_ResponseCode");

        if (valid && "00".equals(responseCode)) {
            // Payment success: Update Payment & Order status
            Order order = orderService.getOrderByCode(orderCode);
            Payment payment = paymentRepository.findByOrderId(order.getId()).orElse(null);
            if (payment != null) {
                payment.setStatus(PaymentStatus.PAID);
                payment.setTransactionId(queryParams.get("vnp_TransactionNo"));
                payment.setPaymentTime(LocalDateTime.now());
                paymentRepository.save(payment);
            }
            orderService.updateOrderStatus(order.getId(), OrderStatus.CONFIRMED, "Thanh toan VNPAY thanh cong");
            notificationService.notifyOrderStatusChanged(order, "Thanh toan VNPAY thanh cong, don hang da duoc xac nhan!");

            response.sendRedirect("/orders/tracking/" + orderCode + "?payment=success");
        } else {
            response.sendRedirect("/orders/tracking/" + orderCode + "?payment=failed");
        }
    }

    @GetMapping("/momo/create-url/{orderCode}")
    public ResponseEntity<ApiResponse<String>> createMoMoUrl(@PathVariable String orderCode) {
        Order order = orderService.getOrderByCode(orderCode);
        String url = moMoPaymentService.createPaymentRequest(order);
        return ResponseEntity.ok(ApiResponse.success(url, "Tao URL thanh toan MoMo thanh cong"));
    }

    @PostMapping("/momo/callback")
    public ResponseEntity<Map<String, Object>> momoCallback(@RequestBody Map<String, String> payload) {
        boolean valid = moMoPaymentService.verifySignature(payload);
        String orderCode = payload.get("orderId");
        String resultCode = payload.get("resultCode");

        Map<String, Object> resp = new HashMap<>();
        if (valid && "0".equals(resultCode)) {
            Order order = orderService.getOrderByCode(orderCode);
            Payment payment = paymentRepository.findByOrderId(order.getId()).orElse(null);
            if (payment != null) {
                payment.setStatus(PaymentStatus.PAID);
                payment.setTransactionId(payload.get("transId"));
                payment.setPaymentTime(LocalDateTime.now());
                paymentRepository.save(payment);
            }
            orderService.updateOrderStatus(order.getId(), OrderStatus.CONFIRMED, "Thanh toan MoMo thanh cong");
            notificationService.notifyOrderStatusChanged(order, "Thanh toan MoMo thanh cong!");
            resp.put("message", "Success");
            return ResponseEntity.ok(resp);
        }
        resp.put("message", "Invalid signature or failed transaction");
        return ResponseEntity.badRequest().body(resp);
    }
}
