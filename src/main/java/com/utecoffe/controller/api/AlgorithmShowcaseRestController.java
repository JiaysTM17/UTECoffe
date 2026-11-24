package com.utecoffe.controller.api;

import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.dto.response.CouponKnapsackResultDto;
import com.utecoffe.dto.response.CrossSellRecommendationDto;
import com.utecoffe.dto.response.DynamicPricingResultDto;
import com.utecoffe.service.CouponOptimizationService;
import com.utecoffe.service.DynamicPricingService;
import com.utecoffe.service.IdempotencyService;
import com.utecoffe.service.MarketBasketAnalysisService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/algorithms")
@Tag(name = "Advanced Enterprise Algorithms", description = "Showcase of mathematical & computer science algorithms: Dynamic Pricing, Apriori, 0/1 Knapsack, Idempotency & Token Bucket")
public class AlgorithmShowcaseRestController {

    private final DynamicPricingService dynamicPricingService;
    private final MarketBasketAnalysisService marketBasketAnalysisService;
    private final CouponOptimizationService couponOptimizationService;
    private final IdempotencyService idempotencyService;

    public AlgorithmShowcaseRestController(DynamicPricingService dynamicPricingService,
                                           MarketBasketAnalysisService marketBasketAnalysisService,
                                           CouponOptimizationService couponOptimizationService,
                                           IdempotencyService idempotencyService) {
        this.dynamicPricingService = dynamicPricingService;
        this.marketBasketAnalysisService = marketBasketAnalysisService;
        this.couponOptimizationService = couponOptimizationService;
        this.idempotencyService = idempotencyService;
    }

    @Operation(summary = "Calculate Dynamic Price for all products (Yield Management)")
    @GetMapping("/dynamic-pricing")
    public ResponseEntity<ApiResponse<List<DynamicPricingResultDto>>> getDynamicPricing() {
        List<DynamicPricingResultDto> data = dynamicPricingService.evaluateStorewidePricing();
        return ResponseEntity.ok(ApiResponse.success(data, "Tính toán định giá động thành công theo chu kỳ nhu cầu"));
    }

    @Operation(summary = "Market Basket Analysis & Product Pairing (Apriori Algorithm)")
    @GetMapping("/cross-sell/{productId}")
    public ResponseEntity<ApiResponse<List<CrossSellRecommendationDto>>> getCrossSell(
            @PathVariable Long productId,
            @RequestParam(defaultValue = "4") int limit) {
        List<CrossSellRecommendationDto> data = marketBasketAnalysisService.getRecommendationsForProduct(productId, limit);
        return ResponseEntity.ok(ApiResponse.success(data, "Khai phá luật kết hợp sản phẩm thành công (Lift >= 1.0)"));
    }

    public static class CouponKnapsackRequest {
        private BigDecimal subtotal;
        private List<String> couponCodes;

        public BigDecimal getSubtotal() { return subtotal; }
        public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

        public List<String> getCouponCodes() { return couponCodes; }
        public void setCouponCodes(List<String> couponCodes) { this.couponCodes = couponCodes; }
    }

    @Operation(summary = "Optimal Voucher Stacking (0/1 Knapsack Dynamic Programming)")
    @PostMapping("/coupon-knapsack")
    public ResponseEntity<ApiResponse<CouponKnapsackResultDto>> optimizeCoupons(
            @RequestBody CouponKnapsackRequest request) {
        CouponKnapsackResultDto result = couponOptimizationService.findOptimalCouponCombination(
                request.getSubtotal(), request.getCouponCodes());
        return ResponseEntity.ok(ApiResponse.success(result, "Tối ưu hóa mã giảm giá thành công"));
    }

    @Operation(summary = "Verify Rate Limit Status (Token Bucket Algorithm)")
    @GetMapping("/rate-limit-check")
    public ResponseEntity<ApiResponse<Map<String, Object>>> checkRateLimit(
            @RequestParam(defaultValue = "demo-client") String clientId) {
        boolean allowed = idempotencyService.tryAcquireRateLimitToken(clientId);
        Map<String, Object> data = Map.of(
                "clientId", clientId,
                "tokenAcquired", allowed,
                "status", allowed ? "ALLOWED (HTTP 200)" : "RATE_LIMITED (HTTP 429)"
        );
        return ResponseEntity.ok(ApiResponse.success(data, "Kiểm tra Token Bucket hoàn tất"));
    }
}
