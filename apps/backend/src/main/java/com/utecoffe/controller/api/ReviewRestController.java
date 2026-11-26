package com.utecoffe.controller.api;

import com.utecoffe.dto.request.ReviewRequest;
import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.entity.Review;
import com.utecoffe.entity.User;
import com.utecoffe.service.AuthService;
import com.utecoffe.service.ReviewService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/reviews")
public class ReviewRestController {

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private AuthService authService;

    @GetMapping("/product/{productId}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getProductReviews(@PathVariable Long productId) {
        List<Review> reviews = reviewService.getApprovedReviewsByProduct(productId);
        Double avgRating = reviewService.getProductAverageRating(productId);

        Map<String, Object> data = new HashMap<>();
        data.put("reviews", reviews);
        data.put("averageRating", avgRating);
        data.put("totalReviews", reviews.size());

        return ResponseEntity.ok(ApiResponse.success(data, "Lay danh gia mon thanh cong"));
    }

    @GetMapping("/summary/{productId}")
    public ResponseEntity<ApiResponse<com.utecoffe.dto.response.ProductReviewSummaryDto>> getProductReviewSummary(@PathVariable Long productId) {
        com.utecoffe.dto.response.ProductReviewSummaryDto summary = reviewService.getProductReviewSummary(productId);
        return ResponseEntity.ok(ApiResponse.success(summary, "Tổng hợp phân tích đánh giá hương vị món"));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Review>> addReview(
            @Valid @RequestBody ReviewRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Vui long dang nhap de danh gia"));
        }
        User user = authService.getByEmail(userDetails.getUsername());
        Review review = reviewService.addReview(request, user.getId());
        return ResponseEntity.ok(ApiResponse.success(review, "Cam on ban da chia se danh gia huong vi!"));
    }
}
