package com.utecoffe.repository;

import com.utecoffe.entity.InventoryLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InventoryLogRepository extends JpaRepository<InventoryLog, Long> {
    List<InventoryLog> findByStoreIdOrderByCreatedAtDesc(Long storeId);
}
