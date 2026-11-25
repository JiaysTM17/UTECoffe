package com.utecoffe.repository;

import com.utecoffe.entity.StoreTable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StoreTableRepository extends JpaRepository<StoreTable, Long> {
    List<StoreTable> findByStoreIdAndIsActiveTrue(Long storeId);
    Optional<StoreTable> findByStoreIdAndTableNumber(Long storeId, String tableNumber);
}
