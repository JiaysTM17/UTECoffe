package com.utecoffe.service.impl;

import com.utecoffe.entity.Store;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.service.StoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StoreServiceImpl implements StoreService {

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
        return storeRepository.findNearestStores(lat, lng);
    }
}
