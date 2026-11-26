package com.utecoffe.service;

import com.utecoffe.dto.request.ReviewRequest;
import com.utecoffe.entity.Review;

import java.util.List;

public interface ReviewService {
    Review addReview(ReviewRequest request, Long userId);
    List<Review> getApprovedReviewsByProduct(Long productId);
    Double getProductAverageRating(Long productId);
    com.utecoffe.dto.response.ProductReviewSummaryDto getProductReviewSummary(Long productId);
}
