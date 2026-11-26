package com.utecoffe.repository;

import com.utecoffe.entity.UserCoupon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserCouponRepository extends JpaRepository<UserCoupon, Long> {
    List<UserCoupon> findByUserIdAndIsUsedFalse(Long userId);
    List<UserCoupon> findByUserId(Long userId);
    Optional<UserCoupon> findByUserIdAndCouponId(Long userId, Long couponId);
    boolean existsByUserIdAndCouponIdAndIsUsedTrue(Long userId, Long couponId);
    long countByUserIdAndCouponIdAndIsUsedTrue(Long userId, Long couponId);
}
