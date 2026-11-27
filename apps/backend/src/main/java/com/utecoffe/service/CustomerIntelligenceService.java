package com.utecoffe.service;

import com.utecoffe.dto.response.CustomerIntelligenceSummaryDto;
import com.utecoffe.dto.response.RfmCustomerSegmentDto;

public interface CustomerIntelligenceService {
    CustomerIntelligenceSummaryDto analyzeCustomerSegments();
    RfmCustomerSegmentDto analyzeCustomer(Long userId);
}
