package com.utecoffe.service;

import com.utecoffe.entity.Order;

public interface VietQrService {
    String generateVietQrUrl(Order order);
    String generateEmvCoPayload(Order order);
}
