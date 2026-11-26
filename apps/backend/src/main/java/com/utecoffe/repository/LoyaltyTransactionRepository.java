package com.utecoffe.repository;

import com.utecoffe.entity.LoyaltyTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LoyaltyTransactionRepository extends JpaRepository<LoyaltyTransaction, Long> {
    List<LoyaltyTransaction> findByLoyaltyCardIdOrderByCreatedAtDesc(Long loyaltyCardId);
    boolean existsByOrderIdAndTransactionType(Long orderId, String transactionType);
    Optional<LoyaltyTransaction> findByOrderIdAndTransactionType(Long orderId, String transactionType);
}

