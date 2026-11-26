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

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

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
        return createReservationWithZone(request, userId, request.getZonePreference());
    }

    @Override
    public TableReservation createReservationWithZone(ReservationRequest request, Long userId, String zonePreference) {
        Store store = storeRepository.findById(request.getStoreId())
                .orElseThrow(() -> new RuntimeException("Chi nhánh không tồn tại"));

        User user = null;
        if (userId != null) {
            user = userRepository.findById(userId).orElse(null);
        }
        if (user == null) {
            user = userRepository.findAll().stream().findFirst().orElse(null);
        }
        LocalDateTime reqTime = request.getReservationTime();
        if (reqTime == null || reqTime.isBefore(LocalDateTime.now().minusMinutes(15))) {
            reqTime = LocalDateTime.now().plusHours(2);
        }
        int guests = (request.getGuestCount() != null && request.getGuestCount() > 0) ? request.getGuestCount() : 2;

        LocalDateTime windowStart = (reqTime != null) ? reqTime.minusMinutes(89) : LocalDateTime.now().minusMinutes(89);
        LocalDateTime windowEnd = (reqTime != null) ? reqTime.plusMinutes(89) : LocalDateTime.now().plusMinutes(89);

        List<TableReservation> overlapping = reservationRepository.findByStoreId(store.getId()).stream()
                .filter(r -> r.getStatus() != ReservationStatus.CANCELLED && r.getStatus() != ReservationStatus.COMPLETED)
                .filter(r -> r.getReservationTime() != null)
                .filter(r -> !r.getReservationTime().isBefore(windowStart) && !r.getReservationTime().isAfter(windowEnd))
                .collect(Collectors.toList());

        Set<Long> busyTableIds = overlapping.stream()
                .map(TableReservation::getStoreTable)
                .filter(Objects::nonNull)
                .map(StoreTable::getId)
                .collect(Collectors.toSet());

        StoreTable table = null;
        if (request.getTableId() != null) {
            StoreTable requestedTable = tableRepository.findById(request.getTableId()).orElse(null);
            if (requestedTable != null) {
                if (busyTableIds.contains(requestedTable.getId())) {
                    throw new IllegalStateException("Bàn " + requestedTable.getTableNumber() + " đã có khách đặt trong khung giờ này. Vui lòng chọn bàn khác hoặc để hệ thống tự động sắp xếp.");
                }
                if (requestedTable.getCapacity() < guests) {
                    throw new IllegalArgumentException("Bàn " + requestedTable.getTableNumber() + " chỉ có sức chứa " + requestedTable.getCapacity() + " người, không đủ cho " + guests + " khách.");
                }
                table = requestedTable;
            }
        }

        // Interval Scheduling & Multi-Criteria Best-Fit Table Allocation Algorithm
        if (table == null && reqTime != null) {
            List<StoreTable> candidateTables = tableRepository.findByStoreIdAndIsActiveTrue(store.getId()).stream()
                    .filter(t -> !busyTableIds.contains(t.getId()))
                    .filter(t -> t.getCapacity() >= guests)
                    .collect(Collectors.toList());

            if (!candidateTables.isEmpty()) {
                String pref = (zonePreference != null) ? zonePreference.toUpperCase() : "LOUNGE";
                StoreTable bestCandidate = null;
                int highestScore = Integer.MIN_VALUE;

                for (StoreTable candidate : candidateTables) {
                    String num = candidate.getTableNumber().toUpperCase();
                    int score = 0;

                    // Criterion 1: Zone Match (+100)
                    boolean matchesZone = false;
                    if (pref.contains("BAR") && (num.contains("BAR") || num.startsWith("B") || num.equals("T-01") || num.equals("Q1-01") || num.equals("BT-01"))) {
                        matchesZone = true;
                    } else if (pref.contains("LOUNGE") && (num.contains("VIP") || num.contains("LOUNGE") || num.startsWith("L"))) {
                        matchesZone = true;
                    } else if (pref.contains("GARDEN") && (num.contains("GARDEN") || num.startsWith("G") || num.startsWith("V"))) {
                        matchesZone = true;
                    } else if (pref.contains("WORK") && (num.contains("WORK") || num.startsWith("W") || num.startsWith("CW"))) {
                        matchesZone = true;
                    }

                    if (matchesZone) {
                        score += 100;
                    }

                    // Criterion 2: Minimum Capacity Waste (-10 per extra unused seat)
                    int waste = candidate.getCapacity() - guests;
                    score -= (waste * 10);

                    if (score > highestScore) {
                        highestScore = score;
                        bestCandidate = candidate;
                    }
                }
                table = bestCandidate;
            } else {
                throw new IllegalStateException("Rất tiếc, tất cả các bàn phù hợp tại chi nhánh trong khung giờ này đã kín chỗ. Quý khách vui lòng chọn khung giờ khác hoặc chi nhánh lân cận.");
            }
        }

        TableReservation reservation = TableReservation.builder()
                .user(user)
                .store(store)
                .storeTable(table)
                .reservationTime(reqTime)
                .guestCount(guests)
                .status(ReservationStatus.CONFIRMED)
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
        return reservationRepository.findByStoreId(storeId);
    }

    @Override
    public TableReservation getReservationById(Long id) {
        return reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thông tin đặt bàn: " + id));
    }

    @Override
    @org.springframework.transaction.annotation.Transactional
    public TableReservation updateStatus(Long id, ReservationStatus status) {
        TableReservation res = getReservationById(id);
        res.setStatus(status);
        if (res.getStoreTable() != null) {
            if (status == ReservationStatus.SEATED) {
                res.getStoreTable().setIsOccupied(true);
                tableRepository.save(res.getStoreTable());
            } else if (status == ReservationStatus.COMPLETED || status == ReservationStatus.CANCELLED) {
                res.getStoreTable().setIsOccupied(false);
                tableRepository.save(res.getStoreTable());
            }
        }
        return reservationRepository.save(res);
    }

    @Override
    @org.springframework.transaction.annotation.Transactional
    public TableReservation cancelReservation(Long id, Long userId, String reason) {
        TableReservation res = getReservationById(id);

        if (userId != null && (res.getUser() == null || !res.getUser().getId().equals(userId))) {
            throw new IllegalArgumentException("Bạn không có quyền hủy lịch đặt bàn này");
        }

        if (res.getStatus() == ReservationStatus.CANCELLED) {
            return res; // Already cancelled
        }

        if (res.getStatus() == ReservationStatus.COMPLETED || res.getStatus() == ReservationStatus.SEATED) {
            throw new IllegalStateException("Lịch đặt bàn đã được sử dụng hoặc hoàn thành, không thể hủy.");
        }

        res.setStatus(ReservationStatus.CANCELLED);
        if (reason != null && !reason.isBlank()) {
            String existingNote = res.getNote() != null ? res.getNote() + " | " : "";
            res.setNote(existingNote + "Lý do hủy: " + reason);
        }

        if (res.getStoreTable() != null) {
            res.getStoreTable().setIsOccupied(false);
            tableRepository.save(res.getStoreTable());
        }

        return reservationRepository.save(res);
    }
}
