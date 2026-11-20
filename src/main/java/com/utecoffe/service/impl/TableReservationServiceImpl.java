package com.utecoffe.service.impl;

import com.utecoffe.dto.request.ReservationRequest;
import com.utecoffe.entity.Store;
import com.utecoffe.entity.StoreTable;
import com.utecoffe.entity.TableReservation;
import com.utecoffe.entity.User;
import com.utecoffe.enums.ReservationStatus;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.repository.StoreTableRepository;
import com.utecoffe.repository.TableReservationRepository;
import com.utecoffe.repository.UserRepository;
import com.utecoffe.service.TableReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TableReservationServiceImpl implements TableReservationService {

    @Autowired
    private TableReservationRepository reservationRepository;

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private StoreTableRepository tableRepository;

    @Autowired
    private UserRepository userRepository;

    @Override
    public TableReservation createReservation(ReservationRequest request, Long userId) {
        Store store = storeRepository.findById(request.getStoreId())
                .orElseThrow(() -> new RuntimeException("Chi nhanh khong ton tai"));

        User user = (userId != null) ? userRepository.findById(userId).orElse(null) : null;

        StoreTable table = (request.getTableId() != null)
                ? tableRepository.findById(request.getTableId()).orElse(null)
                : null;

        TableReservation reservation = TableReservation.builder()
                .user(user)
                .store(store)
                .storeTable(table)
                .reservationTime(request.getReservationTime())
                .guestCount(request.getGuestCount())
                .status(ReservationStatus.PENDING)
                .note(request.getNote())
                .build();

        return reservationRepository.save(reservation);
    }

    @Override
    public List<TableReservation> getUserReservations(Long userId) {
        return reservationRepository.findByUserIdOrderByReservationTimeDesc(userId);
    }

    @Override
    public List<TableReservation> getStoreReservations(Long storeId) {
        return reservationRepository.findByStoreIdAndStatus(storeId, ReservationStatus.CONFIRMED);
    }
}
