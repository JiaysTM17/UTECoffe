package com.utecoffe.repository;

import com.utecoffe.entity.StoreInventory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StoreInventoryRepository extends JpaRepository<StoreInventory, Long> {
    List<StoreInventory> findByStoreId(Long storeId);
    Optional<StoreInventory> findByStoreIdAndIngredientId(Long storeId, Long ingredientId);

    @Query("SELECT si FROM StoreInventory si WHERE si.store.id = :storeId AND si.currentStock <= si.safetyStock")
    List<StoreInventory> findLowStockAlerts(@Param("storeId") Long storeId);
}
