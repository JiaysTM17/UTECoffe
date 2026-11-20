package com.utecoffe.controller.api;

import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.entity.Store;
import com.utecoffe.service.StoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stores")
public class StoreRestController {

    @Autowired
    private StoreService storeService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Store>>> getAll() {
        return ResponseEntity.ok(ApiResponse.success(storeService.getAllActiveStores(), "Danh sach chi nhanh UTECoffe"));
    }

    @GetMapping("/nearest")
    public ResponseEntity<ApiResponse<List<Store>>> getNearest(@RequestParam double lat, @RequestParam double lng) {
        return ResponseEntity.ok(ApiResponse.success(storeService.findNearestStores(lat, lng), "Chi nhanh gan nhat"));
    }
}
