package com.utecoffe.service;

import com.utecoffe.dto.request.ReservationRequest;
import com.utecoffe.entity.TableReservation;

import java.util.List;

public interface TableReservationService {
    TableReservation createReservation(ReservationRequest request, Long userId);
    List<TableReservation> getUserReservations(Long userId);
    List<TableReservation> getStoreReservations(Long storeId);
}
