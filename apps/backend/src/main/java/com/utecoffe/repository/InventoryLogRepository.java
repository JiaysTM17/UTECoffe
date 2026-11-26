package com.utecoffe.repository;

import com.utecoffe.entity.InventoryLog;
import com.utecoffe.enums.InventoryTransactionType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InventoryLogRepository extends JpaRepository<InventoryLog, Long> {
    List<InventoryLog> findByStoreIdOrderByCreatedAtDesc(Long storeId);
    boolean existsByReferenceOrderIdAndTransactionType(Long referenceOrderId, InventoryTransactionType transactionType);
    List<InventoryLog> findByReferenceOrderIdAndTransactionType(Long referenceOrderId, InventoryTransactionType transactionType);
}

