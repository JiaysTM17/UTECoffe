package com.utecoffe.dto.response;

import lombok.*;

import java.util.List;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductReviewSummaryDto {
    private Long productId;
    private String productName;
    private double averageRating;
    private int totalReviews;
    private Map<Integer, Integer> starBreakdown;
    private double fiveStarPercent;
    private double recommendationRatePercent;
    private int verifiedPurchaseCount;
    private String sentimentVerdict;
    private List<String> highlightedFlavorNotes;
}
