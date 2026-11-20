package com.utecoffe.repository;

import com.utecoffe.entity.Coupon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface CouponRepository extends JpaRepository<Coupon, Long> {
    Optional<Coupon> findByCodeAndIsActiveTrue(String code);

    @Query("SELECT c FROM Coupon c WHERE c.isActive = true AND :now BETWEEN c.startDate AND c.endDate AND (c.usageLimit IS NULL OR c.usedCount < c.usageLimit)")
    List<Coupon> findActiveCoupons(LocalDateTime now);
}
