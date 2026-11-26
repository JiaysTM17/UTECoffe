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

    @Override
    public com.utecoffe.dto.response.ProductReviewSummaryDto getProductReviewSummary(Long productId) {
        Product product = productRepository.findById(productId).orElse(null);
        String productName = (product != null) ? product.getName() : "Sản Phẩm UTECoffe #" + productId;

        List<Review> reviews = getApprovedReviewsByProduct(productId);
        java.util.Map<Integer, Integer> starMap = new java.util.LinkedHashMap<>();
        for (int i = 5; i >= 1; i--) {
            starMap.put(i, 0);
        }

        if (reviews.isEmpty()) {
            return com.utecoffe.dto.response.ProductReviewSummaryDto.builder()
                    .productId(productId)
                    .productName(productName)
                    .averageRating(5.0)
                    .totalReviews(0)
                    .starBreakdown(starMap)
                    .fiveStarPercent(100.0)
                    .recommendationRatePercent(100.0)
                    .verifiedPurchaseCount(0)
                    .sentimentVerdict("Món mới tinh hoa đang sẵn sàng đón nhận những cảm nhận cupping đầu tiên từ quý khách.")
                    .highlightedFlavorNotes(java.util.List.of("Hương Hoa Trắng", "Hậu Vị Ngọt Sâu", "Hạt Rang Mộc Cầu Đất"))
                    .build();
        }

        double sum = 0.0;
        int verifiedCount = 0;
        int recCount = 0;

        java.util.Set<String> detectedNotes = new java.util.LinkedHashSet<>();

        for (Review r : reviews) {
            int rating = Math.max(1, Math.min(5, (r.getRating() != null ? r.getRating() : 5)));
            sum += rating;
            starMap.put(rating, starMap.getOrDefault(rating, 0) + 1);

            if (rating >= 4) recCount++;
            if (r.getOrder() != null) verifiedCount++;

            if (r.getComment() != null) {
                String c = r.getComment().toLowerCase();
                if (c.contains("thơm") || c.contains("aroma")) detectedNotes.add("Hương Thơm Nồng Nàn");
                if (c.contains("chua") || c.contains("thanh")) detectedNotes.add("Độ Chua Thanh Tự Nhiên");
                if (c.contains("ngọt") || c.contains("hậu")) detectedNotes.add("Ngọt Hậu Sâu Lắng");
                if (c.contains("đậm") || c.contains("body")) detectedNotes.add("Thể Chất Dày Dặn");
                if (c.contains("cam") || c.contains("hoa") || c.contains("quả")) detectedNotes.add("Nốt Hương Trái Cây Tươi Mới");
                if (c.contains("béo") || c.contains("ngậy") || c.contains("sữa")) detectedNotes.add("Vị Sữa Mịn Mượt");
            }
        }

        if (detectedNotes.isEmpty()) {
            detectedNotes.add("Rang Mộc Thủ Công");
            detectedNotes.add("Cà Phê Đặc Sản 85+ SCA");
        }

        int total = reviews.size();
        double avg = Math.round((sum / total) * 10.0) / 10.0;
        double fiveStarPct = Math.round(((double) starMap.get(5) / total) * 1000.0) / 10.0;
        double recPct = Math.round(((double) recCount / total) * 1000.0) / 10.0;

        String verdict;
        if (avg >= 4.7) {
            verdict = "Được khách hàng đặc biệt khen ngợi về hương vị nguyên bản và chất lượng mẻ rang thủ công.";
        } else if (avg >= 4.0) {
            verdict = "Được đánh giá tích cực với độ cân bằng hương vị hài hòa và hậu vị dễ chịu.";
        } else {
            verdict = "Hương vị cá tính, đang tiếp tục được nghệ nhân roaster tinh chỉnh hồ sơ rang.";
        }

        return com.utecoffe.dto.response.ProductReviewSummaryDto.builder()
                .productId(productId)
                .productName(productName)
                .averageRating(avg)
                .totalReviews(total)
                .starBreakdown(starMap)
                .fiveStarPercent(fiveStarPct)
                .recommendationRatePercent(recPct)
                .verifiedPurchaseCount(verifiedCount)
                .sentimentVerdict(verdict)
                .highlightedFlavorNotes(new java.util.ArrayList<>(detectedNotes))
                .build();
    }
}
