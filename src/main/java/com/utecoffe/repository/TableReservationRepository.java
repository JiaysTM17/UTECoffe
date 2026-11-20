package com.utecoffe.repository;

import com.utecoffe.entity.TableReservation;
import com.utecoffe.enums.ReservationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TableReservationRepository extends JpaRepository<TableReservation, Long> {
    List<TableReservation> findByUserIdOrderByReservationTimeDesc(Long userId);
    List<TableReservation> findByStoreIdAndStatus(Long storeId, ReservationStatus status);
}
