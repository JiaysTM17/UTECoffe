package com.utecoffe.service;

import com.utecoffe.entity.Order;
import java.util.Map;

public interface MoMoPaymentService {
    String createPaymentRequest(Order order);
    boolean verifySignature(Map<String, String> params);
}
