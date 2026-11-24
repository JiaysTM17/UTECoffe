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
}

