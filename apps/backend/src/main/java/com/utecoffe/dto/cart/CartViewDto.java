package com.utecoffe.dto.cart;

import com.utecoffe.dto.response.CouponKnapsackResultDto;
import com.utecoffe.dto.response.CrossSellRecommendationDto;
import lombok.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CartViewDto {
    @Builder.Default
    private List<CartItemViewDto> items = new ArrayList<>();

    @Builder.Default
    private BigDecimal totalAmount = BigDecimal.ZERO;

    @Builder.Default
    private BigDecimal shippingFee = BigDecimal.valueOf(15000);

    private String couponCode;

    @Builder.Default
    private BigDecimal discountAmount = BigDecimal.ZERO;

    @Builder.Default
    private BigDecimal finalAmount = BigDecimal.ZERO;

    private CouponKnapsackResultDto optimalCoupon;
    private List<CrossSellRecommendationDto> pairingRecommendations;
}
