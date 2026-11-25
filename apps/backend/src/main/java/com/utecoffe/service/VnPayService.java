package com.utecoffe.service;

import com.utecoffe.entity.Order;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Map;

public interface VnPayService {
    String createPaymentUrl(Order order, HttpServletRequest request);
    boolean verifyCallback(Map<String, String> queryParams);
}
