package com.utecoffe.dto.response;

import java.math.BigDecimal;

/**
 * Result DTO for Market Basket Analysis (Apriori Algorithm / Association Rules).
 */
public class CrossSellRecommendationDto {
    private Long targetProductId;
    private String targetProductName;
    private String targetProductSlug;
    private String targetImageUrl;
    private BigDecimal targetPrice;
    private double support;
    private double confidence;
    private double lift;
    private String pairingRationale;

    public CrossSellRecommendationDto() {}

    public CrossSellRecommendationDto(Long targetProductId, String targetProductName, String targetProductSlug,
                                      String targetImageUrl, BigDecimal targetPrice, double support,
                                      double confidence, double lift, String pairingRationale) {
        this.targetProductId = targetProductId;
        this.targetProductName = targetProductName;
        this.targetProductSlug = targetProductSlug;
        this.targetImageUrl = targetImageUrl;
        this.targetPrice = targetPrice;
        this.support = support;
        this.confidence = confidence;
        this.lift = lift;
        this.pairingRationale = pairingRationale;
    }

    public Long getTargetProductId() { return targetProductId; }
    public void setTargetProductId(Long targetProductId) { this.targetProductId = targetProductId; }

    public String getTargetProductName() { return targetProductName; }
    public void setTargetProductName(String targetProductName) { this.targetProductName = targetProductName; }

    public String getTargetProductSlug() { return targetProductSlug; }
    public void setTargetProductSlug(String targetProductSlug) { this.targetProductSlug = targetProductSlug; }

    public String getTargetImageUrl() { return targetImageUrl; }
    public void setTargetImageUrl(String targetImageUrl) { this.targetImageUrl = targetImageUrl; }

    public BigDecimal getTargetPrice() { return targetPrice; }
    public void setTargetPrice(BigDecimal targetPrice) { this.targetPrice = targetPrice; }

    public double getSupport() { return support; }
    public void setSupport(double support) { this.support = support; }

    public double getConfidence() { return confidence; }
    public void setConfidence(double confidence) { this.confidence = confidence; }

    public double getLift() { return lift; }
    public void setLift(double lift) { this.lift = lift; }

    public String getPairingRationale() { return pairingRationale; }
    public void setPairingRationale(String pairingRationale) { this.pairingRationale = pairingRationale; }
}
