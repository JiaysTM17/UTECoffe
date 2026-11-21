package com.utecoffe.service.impl;

import com.utecoffe.dto.request.ReviewRequest;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.Product;
import com.utecoffe.entity.Review;
import com.utecoffe.entity.User;
import com.utecoffe.repository.OrderRepository;
import com.utecoffe.repository.ProductRepository;
import com.utecoffe.repository.ReviewRepository;
import com.utecoffe.repository.UserRepository;
import com.utecoffe.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private UserRepository userRepository;

    @Override
    public Review addReview(ReviewRequest request, Long userId) {
        User user = (userId != null) ? userRepository.findById(userId).orElse(null) : null;
        if (user == null) {
            throw new IllegalArgumentException("Vui long dang nhap de gui danh gia mon");
        }

        Product product = productRepository.findById(request.getProductId())
                .orElseThrow(() -> new RuntimeException("San pham khong ton tai: " + request.getProductId()));

        Order order = (request.getOrderId() != null)
                ? orderRepository.findById(request.getOrderId()).orElse(null)
                : null;

        Review review = Review.builder()
                .user(user)
                .product(product)
                .order(order)
                .rating(request.getRating())
                .comment(request.getComment())
                .isApproved(true) // Auto-approve or admin moderation
                .build();

        return reviewRepository.save(review);
    }

    @Override
    public List<Review> getApprovedReviewsByProduct(Long productId) {
        return reviewRepository.findByProductIdAndIsApprovedTrueOrderByCreatedAtDesc(productId);
    }

    @Override
    public Double getProductAverageRating(Long productId) {
        List<Review> reviews = getApprovedReviewsByProduct(productId);
        if (reviews.isEmpty()) {
            return 5.0; // Default 5.0 for fresh products
        }
        double sum = 0;
        for (Review r : reviews) {
            sum += r.getRating();
        }
        return Math.round((sum / reviews.size()) * 10.0) / 10.0;
    }
}
