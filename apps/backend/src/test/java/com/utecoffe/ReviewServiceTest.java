package com.utecoffe;

import com.utecoffe.dto.request.ReviewRequest;
import com.utecoffe.dto.response.ProductReviewSummaryDto;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.Product;
import com.utecoffe.entity.Review;
import com.utecoffe.entity.User;
import com.utecoffe.repository.OrderRepository;
import com.utecoffe.repository.ProductRepository;
import com.utecoffe.repository.ReviewRepository;
import com.utecoffe.repository.UserRepository;
import com.utecoffe.service.impl.ReviewServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ReviewServiceTest {

    @Mock
    private ReviewRepository reviewRepository;

    @Mock
    private ProductRepository productRepository;

    @Mock
    private OrderRepository orderRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private ReviewServiceImpl reviewService;

    private Product product;
    private User user;
    private Order order;

    @BeforeEach
    void setUp() {
        product = Product.builder().id(10L).name("Cold Brew Cam Vang Specialty").build();
        user = User.builder().id(1L).fullName("Nguyen Van A").build();
        order = Order.builder().id(99L).orderCode("UTE-261126-0099").build();
    }

    @Test
    void testAddReview_Success() {
        ReviewRequest request = new ReviewRequest();
        request.setProductId(10L);
        request.setOrderId(99L);
        request.setRating(5);
        request.setComment("Huong cam rat thom, hau vi ngot sau");

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(productRepository.findById(10L)).thenReturn(Optional.of(product));
        when(orderRepository.findById(99L)).thenReturn(Optional.of(order));
        when(reviewRepository.save(any(Review.class))).thenAnswer(i -> i.getArgument(0));

        Review result = reviewService.addReview(request, 1L);

        assertNotNull(result);
        assertEquals(5, result.getRating());
        assertEquals("Huong cam rat thom, hau vi ngot sau", result.getComment());
        assertTrue(result.getIsApproved());
        assertEquals(user, result.getUser());
        assertEquals(product, result.getProduct());
        assertEquals(order, result.getOrder());
    }

    @Test
    void testGetProductAverageRating_DefaultWhenNoReviews() {
        when(reviewRepository.findByProductIdAndIsApprovedTrueOrderByCreatedAtDesc(10L))
                .thenReturn(Collections.emptyList());

        Double avg = reviewService.getProductAverageRating(10L);
        assertEquals(5.0, avg);
    }

    @Test
    void testGetProductReviewSummary_WithVerifiedReviews() {
        Review r1 = Review.builder().id(1L).rating(5).comment("Cà phê thơm nồng nàn, chua thanh tự nhiên").order(order).build();
        Review r2 = Review.builder().id(2L).rating(4).comment("Vị ngọt hậu sâu lắng, rất ưng ý").order(null).build();

        when(productRepository.findById(10L)).thenReturn(Optional.of(product));
        when(reviewRepository.findByProductIdAndIsApprovedTrueOrderByCreatedAtDesc(10L))
                .thenReturn(List.of(r1, r2));

        ProductReviewSummaryDto summary = reviewService.getProductReviewSummary(10L);

        assertNotNull(summary);
        assertEquals(10L, summary.getProductId());
        assertEquals(2, summary.getTotalReviews());
        assertEquals(4.5, summary.getAverageRating());
        assertEquals(1, summary.getVerifiedPurchaseCount());
        assertEquals(100.0, summary.getRecommendationRatePercent()); // both are >= 4
        assertEquals(50.0, summary.getFiveStarPercent()); // 1 of 2
        assertNotNull(summary.getSentimentVerdict());
        assertFalse(summary.getHighlightedFlavorNotes().isEmpty());
    }
}
