package com.utecoffe.repository;

import com.utecoffe.entity.Order;
import com.utecoffe.enums.OrderStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    Optional<Order> findByOrderCode(String orderCode);
    List<Order> findByUserIdOrderByCreatedAtDesc(Long userId);

    // KDS Barista active queue for a store
    List<Order> findByStoreIdAndStatusInOrderByCreatedAtAsc(Long storeId, List<OrderStatus> statuses);

    @Query("SELECT o FROM Order o WHERE o.store.id = :storeId ORDER BY o.createdAt DESC")
    List<Order> findRecentOrdersByStore(@Param("storeId") Long storeId);
}
