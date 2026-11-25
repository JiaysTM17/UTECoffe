package com.utecoffe.service.impl;

import com.utecoffe.entity.Order;
import com.utecoffe.service.MoMoPaymentService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.UUID;

@Service
public class MoMoPaymentServiceImpl implements MoMoPaymentService {

    @Value("${momo.partner-code:MOMO_PARTNER_CODE}")
    private String partnerCode;

    @Value("${momo.access-key:MOMO_ACCESS_KEY}")
    private String accessKey;

    @Value("${momo.secret-key:MOMO_SECRET_KEY}")
    private String secretKey;

    @Value("${momo.endpoint:https://test-payment.momo.vn/v2/gateway/api/create}")
    private String endpoint;

    @Value("${momo.return-url:http://localhost:8080/api/payments/momo/return}")
    private String returnUrl;

    @Value("${momo.notify-url:http://localhost:8080/api/payments/momo/callback}")
    private String notifyUrl;

    @Override
    public String createPaymentRequest(Order order) {
        String requestId = UUID.randomUUID().toString();
        String orderId = order.getOrderCode();
        String orderInfo = "Thanh toan don hang UTECoffe: " + order.getOrderCode();
        String amount = order.getFinalAmount().toBigInteger().toString();
        String extraData = "";

        // Raw signature string format defined by MoMo API v2
        String rawHash = "accessKey=" + accessKey +
                "&amount=" + amount +
                "&extraData=" + extraData +
                "&ipnUrl=" + notifyUrl +
                "&orderId=" + orderId +
                "&orderInfo=" + orderInfo +
                "&partnerCode=" + partnerCode +
                "&redirectUrl=" + returnUrl +
                "&requestId=" + requestId +
                "&requestType=captureWallet";

        String signature = hmacSHA256(secretKey, rawHash);

        // Simulated payUrl for sandbox or actual MoMo gateway link
        return "https://test-payment.momo.vn/v2/gateway/pay?orderId=" + orderId + "&requestId=" + requestId + "&signature=" + signature;
    }

    @Override
    public boolean verifySignature(Map<String, String> params) {
        String signature = params.get("signature");
        if (signature == null) return false;

        String rawHash = "accessKey=" + accessKey +
                "&amount=" + params.get("amount") +
                "&extraData=" + params.getOrDefault("extraData", "") +
                "&message=" + params.getOrDefault("message", "") +
                "&orderId=" + params.get("orderId") +
                "&orderInfo=" + params.get("orderInfo") +
                "&orderType=" + params.getOrDefault("orderType", "") +
                "&partnerCode=" + partnerCode +
                "&payType=" + params.getOrDefault("payType", "") +
                "&requestId=" + params.get("requestId") +
                "&responseTime=" + params.get("responseTime") +
                "&resultCode=" + params.get("resultCode") +
                "&transId=" + params.get("transId");

        String calculated = hmacSHA256(secretKey, rawHash);
        return calculated.equalsIgnoreCase(signature);
    }

    private String hmacSHA256(String key, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            hmac.init(secretKeySpec);
            byte[] hash = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception ex) {
            return "";
        }
    }
}
