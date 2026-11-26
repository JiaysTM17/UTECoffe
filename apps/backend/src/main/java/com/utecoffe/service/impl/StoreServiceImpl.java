package com.utecoffe.service.impl;

import com.utecoffe.dto.response.StoreDistanceDto;
import com.utecoffe.entity.Store;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.service.StoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class StoreServiceImpl implements StoreService {

    private static final double EARTH_RADIUS_KM = 6371.0;

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private com.utecoffe.repository.StoreTableRepository storeTableRepository;

    @Autowired
    private com.utecoffe.repository.OrderRepository orderRepository;

    @Override
    public List<Store> getAllActiveStores() {
        return storeRepository.findByIsActiveTrue();
    }

    @Override
    public Store getStoreById(Long id) {
        return storeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Chi nhanh khong ton tai: " + id));
    }

    @Override
    public List<Store> findNearestStores(double lat, double lng) {
        return findNearestStoresWithDistance(lat, lng).stream()
                .map(StoreDistanceDto::getStore)
                .collect(Collectors.toList());
    }

    /**
     * Enterprise Haversine Formula: Calculates spherical distance across Earth's curved surface.
     * Guaranteed to work reliably on both in-memory H2 (local) and PostgreSQL (production).
     */
    @Override
    public List<StoreDistanceDto> findNearestStoresWithDistance(double lat, double lng) {
        List<Store> activeStores = storeRepository.findByIsActiveTrue();
        List<StoreDistanceDto> results = new ArrayList<>();

        for (Store s : activeStores) {
            double storeLat = s.getLatitude() != null ? s.getLatitude().doubleValue() : 10.7769;
            double storeLng = s.getLongitude() != null ? s.getLongitude().doubleValue() : 106.7009;

            double distanceKm = calculateHaversineDistance(lat, lng, storeLat, storeLng);
            
            // Estimated delivery: 10 mins preparation + ~3 mins per km
            int estMinutes = (int) Math.round(10 + (distanceKm * 3.0));
            if (estMinutes < 15) estMinutes = 15;

            boolean deliverable = distanceKm <= 20.0; // Within 20km delivery radius

            results.add(StoreDistanceDto.builder()
                    .store(s)
                    .distanceKm(Math.round(distanceKm * 10.0) / 10.0)
                    .estimatedDeliveryMinutes(estMinutes)
                    .isDeliverable(deliverable)
                    .formattedDistance(String.format("%.1f km", distanceKm))
                    .build());
        }

        results.sort(Comparator.comparingDouble(StoreDistanceDto::getDistanceKm));
        return results;
    }

    private double calculateHaversineDistance(double lat1, double lng1, double lat2, double lng2) {
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);

        double a = Math.sin(dLat / 2.0) * Math.sin(dLat / 2.0)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLng / 2.0) * Math.sin(dLng / 2.0);

        double c = 2.0 * Math.atan2(Math.sqrt(a), Math.sqrt(1.0 - a));
        return EARTH_RADIUS_KM * c;
    }

    @Override
    public com.utecoffe.dto.response.StoreOperatingStatusDto getStoreOperatingStatus(Long storeId) {
        Store store = getStoreById(storeId);

        String openStr = (store.getOpeningTime() != null && !store.getOpeningTime().isBlank()) ? store.getOpeningTime() : "07:00";
        String closeStr = (store.getClosingTime() != null && !store.getClosingTime().isBlank()) ? store.getClosingTime() : "22:30";

        java.time.LocalTime now = java.time.LocalTime.now();
        java.time.LocalTime openTime;
        java.time.LocalTime closeTime;
        try {
            openTime = java.time.LocalTime.parse(openStr);
            closeTime = java.time.LocalTime.parse(closeStr);
        } catch (Exception e) {
            openTime = java.time.LocalTime.of(7, 0);
            closeTime = java.time.LocalTime.of(22, 30);
        }

        boolean isOpen;
        if (closeTime.isAfter(openTime)) {
            isOpen = !now.isBefore(openTime) && !now.isAfter(closeTime);
        } else {
            isOpen = !now.isBefore(openTime) || !now.isAfter(closeTime);
        }

        String statusBadge;
        String statusMessage;
        if (isOpen) {
            long minutesUntilClosing = java.time.Duration.between(now, closeTime).toMinutes();
            if (minutesUntilClosing > 0 && minutesUntilClosing <= 45) {
                statusBadge = "CLOSING_SOON";
                statusMessage = "Sắp đóng cửa (còn " + minutesUntilClosing + " phút) - Nhận đơn mang đi";
            } else {
                statusBadge = "OPEN";
                statusMessage = "Đang mở cửa phục vụ tại chỗ & giao hàng";
            }
        } else {
            statusBadge = "CLOSED";
            statusMessage = "Tạm đóng cửa - Giờ mở cửa: " + openStr + " đến " + closeStr;
        }

        List<com.utecoffe.enums.OrderStatus> activeStatuses = List.of(
                com.utecoffe.enums.OrderStatus.PENDING,
                com.utecoffe.enums.OrderStatus.CONFIRMED,
                com.utecoffe.enums.OrderStatus.PREPARING
        );
        var activeOrders = orderRepository.findByStoreIdAndStatusInOrderByCreatedAtAsc(store.getId(), activeStatuses);
        int activeQueueCount = (activeOrders != null) ? activeOrders.size() : 0;

        String rushLevel;
        String rushDesc;
        if (activeQueueCount >= 8) {
            rushLevel = "HIGH";
            rushDesc = "Đông khách (Hàng đợi " + activeQueueCount + " đơn) - Dự kiến phục vụ 12-15 phút";
        } else if (activeQueueCount >= 3) {
            rushLevel = "MODERATE";
            rushDesc = "Nhộn nhịp (Hàng đợi " + activeQueueCount + " đơn) - Dự kiến phục vụ 5-8 phút";
        } else {
            rushLevel = "LOW";
            rushDesc = "Không gian thoáng đãng - Chiết xuất & phục vụ ngay trong 3-5 phút";
        }

        var tables = storeTableRepository.findByStoreIdAndIsActiveTrue(store.getId());
        int totalTables = (tables != null) ? tables.size() : 0;
        int occupiedTables = (tables != null)
                ? (int) tables.stream().filter(t -> Boolean.TRUE.equals(t.getIsOccupied())).count()
                : 0;
        double occPercent = (totalTables > 0)
                ? Math.round(((double) occupiedTables / totalTables) * 1000.0) / 10.0
                : 0.0;

        return com.utecoffe.dto.response.StoreOperatingStatusDto.builder()
                .storeId(store.getId())
                .storeName(store.getName())
                .address(store.getAddress())
                .phoneNumber(store.getPhoneNumber())
                .openingTime(openStr)
                .closingTime(closeStr)
                .isOpenNow(isOpen)
                .statusBadge(statusBadge)
                .statusMessage(statusMessage)
                .rushLevel(rushLevel)
                .rushDescription(rushDesc)
                .activeKdsQueueCount(activeQueueCount)
                .occupiedTablesCount(occupiedTables)
                .totalTablesCount(totalTables)
                .tableOccupancyPercent(occPercent)
                .build();
    }
}

