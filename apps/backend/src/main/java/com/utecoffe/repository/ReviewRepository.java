package com.utecoffe.repository;

import com.utecoffe.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByProductIdAndIsApprovedTrueOrderByCreatedAtDesc(Long productId);
    List<Review> findByUserId(Long userId);
}
