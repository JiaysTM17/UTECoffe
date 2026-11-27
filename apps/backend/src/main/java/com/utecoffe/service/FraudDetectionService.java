package com.utecoffe.service;

import com.utecoffe.dto.response.OrderRiskAssessmentDto;

public interface FraudDetectionService {
    /** Scores an existing order for fraud / abuse risk using the customer's behavioural history. */
    OrderRiskAssessmentDto assessOrder(Long orderId);
}
