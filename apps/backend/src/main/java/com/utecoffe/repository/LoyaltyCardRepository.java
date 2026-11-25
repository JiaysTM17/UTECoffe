package com.utecoffe.repository;

import com.utecoffe.entity.LoyaltyCard;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface LoyaltyCardRepository extends JpaRepository<LoyaltyCard, Long> {
    Optional<LoyaltyCard> findByUserId(Long userId);
    Optional<LoyaltyCard> findByCardNumber(String cardNumber);
}
