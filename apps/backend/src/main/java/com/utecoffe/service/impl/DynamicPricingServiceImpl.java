package com.utecoffe.service.impl;

import com.utecoffe.dto.response.DynamicPricingResultDto;
import com.utecoffe.entity.Product;
import com.utecoffe.repository.ProductRepository;
import com.utecoffe.service.DynamicPricingService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Advanced Dynamic Pricing & Yield Management Implementation.
 * Leverages demand elasticity and perishable inventory life cycles.
 */
@Service
public class DynamicPricingServiceImpl implements DynamicPricingService {

    private static final Logger log = LoggerFactory.getLogger(DynamicPricingServiceImpl.class);
    private final ProductRepository productRepository;

    public DynamicPricingServiceImpl(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    public DynamicPricingResultDto calculateDynamicPrice(Long productId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Product not found with ID: " + productId));

        LocalTime now = LocalTime.now();
        BigDecimal base = product.getBasePrice();
        String catSlug = product.getCategory() != null ? product.getCategory().getSlug() : "";
        boolean isPastry = "banh-ngot-thu-cong".equals(catSlug) || "banh-nghe-nhan".equals(catSlug);

        double discountRate = 0.0;
        String reason = "Giá niêm yết tiêu chuẩn";
        String window = "Standard Hours (09:30 - 14:00)";
        boolean isHappyHour = false;
        boolean isClearance = false;

        // Condition 1: Evening Pastry Clearance (20:30 - 23:00) -> 25% discount to prevent waste
        if (isPastry && (now.isAfter(LocalTime.of(20, 30)) || now.isBefore(LocalTime.of(6, 0)))) {
            discountRate = 0.25;
            reason = "Chương trình Giờ Vàng Xanh (Anti-Food Waste): Giảm 25% bánh nướng tươi trong ngày";
            window = "Evening Clearance (20:30 - 23:00)";
            isClearance = true;
        }
        // Condition 2: Afternoon Coffee Happy Hour (14:00 - 16:30) -> 12% discount to boost off-peak traffic
        else if (!isPastry && now.isAfter(LocalTime.of(14, 0)) && now.isBefore(LocalTime.of(16, 30))) {
            discountRate = 0.12;
            reason = "Artisan Happy Hour: Ưu đãi 12% giờ thưởng trà & cà phê chiều thư giãn";
            window = "Afternoon Happy Hour (14:00 - 16:30)";
            isHappyHour = true;
        }
        // Condition 3: Morning Peak Rush (07:30 - 09:30) -> High demand baseline
        else if (now.isAfter(LocalTime.of(7, 30)) && now.isBefore(LocalTime.of(9, 30))) {
            reason = "Giờ cao điểm phục vụ điểm tâm & cà phê sáng";
            window = "Morning Rush (07:30 - 09:30)";
        }

        BigDecimal discountAmount = base.multiply(BigDecimal.valueOf(discountRate))
                .setScale(0, RoundingMode.HALF_UP);
        BigDecimal dynamicPrice = base.subtract(discountAmount);

        return new DynamicPricingResultDto(
                product.getId(),
                product.getName(),
                base,
                dynamicPrice,
                discountAmount,
                discountRate * 100.0,
                reason,
                window,
                false,
                isHappyHour,
                isClearance
        );
    }

    @Override
    public List<DynamicPricingResultDto> evaluateStorewidePricing() {
        return productRepository.findByIsAvailableTrue().stream()
                .map(p -> calculateDynamicPrice(p.getId()))
                .collect(Collectors.toList());
    }
}
