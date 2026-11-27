package com.utecoffe.controller.api;

import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.dto.response.CouponKnapsackResultDto;
import com.utecoffe.dto.response.CrossSellRecommendationDto;
import com.utecoffe.dto.response.DynamicPricingResultDto;
import com.utecoffe.dto.response.TasteMatchResultDto;
import com.utecoffe.service.CouponOptimizationService;
import com.utecoffe.service.DynamicPricingService;
import com.utecoffe.service.IdempotencyService;
import com.utecoffe.service.MarketBasketAnalysisService;
import com.utecoffe.service.TasteProfileService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/algorithms")
@Tag(name = "Advanced Enterprise Algorithms", description = "Showcase of mathematical & computer science algorithms: Dynamic Pricing, Apriori, 0/1 Knapsack, Idempotency, Token Bucket & Cosine Taste Matching")
public class AlgorithmShowcaseRestController {

    private final DynamicPricingService dynamicPricingService;
    private final MarketBasketAnalysisService marketBasketAnalysisService;
    private final CouponOptimizationService couponOptimizationService;
    private final IdempotencyService idempotencyService;
    private final TasteProfileService tasteProfileService;
    private final com.utecoffe.service.DeliveryOptimizationService deliveryOptimizationService;
    private final com.utecoffe.service.CustomerIntelligenceService customerIntelligenceService;
    private final com.utecoffe.service.PredictiveSupplyChainService predictiveSupplyChainService;

    public AlgorithmShowcaseRestController(DynamicPricingService dynamicPricingService,
                                           MarketBasketAnalysisService marketBasketAnalysisService,
                                           CouponOptimizationService couponOptimizationService,
                                           IdempotencyService idempotencyService,
                                           TasteProfileService tasteProfileService,
                                           com.utecoffe.service.DeliveryOptimizationService deliveryOptimizationService,
                                           com.utecoffe.service.CustomerIntelligenceService customerIntelligenceService,
                                           com.utecoffe.service.PredictiveSupplyChainService predictiveSupplyChainService) {
        this.dynamicPricingService = dynamicPricingService;
        this.marketBasketAnalysisService = marketBasketAnalysisService;
        this.couponOptimizationService = couponOptimizationService;
        this.idempotencyService = idempotencyService;
        this.tasteProfileService = tasteProfileService;
        this.deliveryOptimizationService = deliveryOptimizationService;
        this.customerIntelligenceService = customerIntelligenceService;
        this.predictiveSupplyChainService = predictiveSupplyChainService;
    }

    @Operation(summary = "Calculate Dynamic Price for all products (Yield Management)")
    @GetMapping("/dynamic-pricing")
    public ResponseEntity<ApiResponse<List<DynamicPricingResultDto>>> getDynamicPricing() {
        List<DynamicPricingResultDto> data = dynamicPricingService.evaluateStorewidePricing();
        return ResponseEntity.ok(ApiResponse.success(data, "Cập nhật bảng giá ưu đãi theo thời điểm thành công"));
    }

    @Operation(summary = "Market Basket Analysis & Product Pairing (Apriori Algorithm)")
    @GetMapping("/cross-sell/{productId}")
    public ResponseEntity<ApiResponse<List<CrossSellRecommendationDto>>> getCrossSell(
            @PathVariable Long productId,
            @RequestParam(defaultValue = "4") int limit) {
        List<CrossSellRecommendationDto> data = marketBasketAnalysisService.getRecommendationsForProduct(productId, limit);
        return ResponseEntity.ok(ApiResponse.success(data, "Gợi ý kết hợp món thưởng thức hoàn hảo"));
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

    @Operation(summary = "Specialty Coffee Palate Matching (5D Vector Cosine Similarity)")
    @GetMapping("/palate-match")
    public ResponseEntity<ApiResponse<List<TasteMatchResultDto>>> matchPalate(
            @RequestParam(defaultValue = "3.5") double acidity,
            @RequestParam(defaultValue = "3.5") double body,
            @RequestParam(defaultValue = "4.0") double sweetness,
            @RequestParam(defaultValue = "2.5") double bitterness,
            @RequestParam(defaultValue = "4.5") double aroma,
            @RequestParam(defaultValue = "5") int limit) {
        List<TasteMatchResultDto> matches = tasteProfileService.matchPalate(acidity, body, sweetness, bitterness, aroma, limit);
        return ResponseEntity.ok(ApiResponse.success(matches, "Khớp vị giác cà phê đặc sản thành công"));
    }

    @Operation(summary = "Filter Specialty Coffees by Roast Degree & Tasting Notes")
    @GetMapping("/flavor-filter")
    public ResponseEntity<ApiResponse<List<TasteMatchResultDto>>> filterFlavors(
            @RequestParam(required = false) String roastLevel,
            @RequestParam(required = false) String flavor,
            @RequestParam(defaultValue = "6") int limit) {
        List<TasteMatchResultDto> results = tasteProfileService.filterByRoastAndNotes(roastLevel, flavor, limit);
        return ResponseEntity.ok(ApiResponse.success(results, "Lọc hương vị & độ rang thành công"));
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
        return ResponseEntity.ok(ApiResponse.success(data, "Kiểm tra an toàn kết nối hoàn tất"));
    }

    @Operation(summary = "Delivery ETA & Barista Queue Optimization (Haversine & M/M/c Erlang-C Queueing Model)")
    @GetMapping("/delivery-eta")
    public ResponseEntity<ApiResponse<com.utecoffe.dto.response.DeliveryOptimizationDto>> calculateDeliveryEta(
            @RequestParam(defaultValue = "1") Long storeId,
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lon,
            @RequestParam(defaultValue = "01 Võ Văn Ngân, Thủ Đức") String address) {
        com.utecoffe.dto.response.DeliveryOptimizationDto dto = deliveryOptimizationService.calculateDeliveryEstimate(storeId, lat, lon, address);
        return ResponseEntity.ok(ApiResponse.success(dto, "Tính toán lộ trình & hàng đợi Barista hoàn tất"));
    }

    @Operation(summary = "Customer RFM Segmentation & Churn Risk Prediction (Exponential Decay Model)")
    @GetMapping("/rfm-churn")
    public ResponseEntity<ApiResponse<com.utecoffe.dto.response.CustomerIntelligenceSummaryDto>> analyzeRfmChurn() {
        com.utecoffe.dto.response.CustomerIntelligenceSummaryDto summary = customerIntelligenceService.analyzeCustomerSegments();
        return ResponseEntity.ok(ApiResponse.success(summary, "Phân khúc khách hàng RFM & dự báo nguy cơ rời bỏ hoàn tất"));
    }

    @Operation(summary = "Ingredient Demand Forecasting (Holt-Winters Triple Exponential Smoothing & Safety Stock)")
    @GetMapping("/demand-forecast")
    public ResponseEntity<ApiResponse<com.utecoffe.dto.response.SupplyChainForecastSummaryDto>> forecastDemand(
            @RequestParam(defaultValue = "1") Long storeId) {
        com.utecoffe.dto.response.SupplyChainForecastSummaryDto forecast = predictiveSupplyChainService.forecastStoreDemand(storeId);
        return ResponseEntity.ok(ApiResponse.success(forecast, "Dự báo nhu cầu nguyên vật liệu Holt-Winters hoàn tất"));
    }
}
