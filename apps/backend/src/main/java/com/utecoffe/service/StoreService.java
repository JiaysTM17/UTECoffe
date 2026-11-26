package com.utecoffe.service;

import com.utecoffe.dto.response.StoreDistanceDto;
import com.utecoffe.entity.Store;
import java.util.List;

public interface StoreService {
    List<Store> getAllActiveStores();
    Store getStoreById(Long id);
    List<Store> findNearestStores(double lat, double lng);
    List<StoreDistanceDto> findNearestStoresWithDistance(double lat, double lng);
    com.utecoffe.dto.response.StoreOperatingStatusDto getStoreOperatingStatus(Long storeId);
}
