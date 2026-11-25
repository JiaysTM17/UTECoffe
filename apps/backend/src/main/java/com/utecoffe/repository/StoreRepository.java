package com.utecoffe.repository;

import com.utecoffe.entity.Store;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StoreRepository extends JpaRepository<Store, Long> {
    List<Store> findByIsActiveTrue();

    // Haversine formula to find nearest active store within radius (km)
    @Query(value = "SELECT *, " +
           "(6371 * acos(cos(radians(:lat)) * cos(radians(s.latitude)) * " +
           "cos(radians(s.longitude) - radians(:lng)) + " +
           "sin(radians(:lat)) * sin(radians(s.latitude)))) AS distance " +
           "FROM stores s WHERE s.is_active = true " +
           "ORDER BY distance ASC LIMIT 5", nativeQuery = true)
    List<Store> findNearestStores(@Param("lat") double lat, @Param("lng") double lng);
}
