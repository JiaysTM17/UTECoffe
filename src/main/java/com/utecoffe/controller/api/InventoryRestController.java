package com.utecoffe.controller.api;

import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.dto.response.InventoryOptimizationDto;
import com.utecoffe.service.InventoryOptimizationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/inventory")
public class InventoryRestController {

    @Autowired
    private InventoryOptimizationService inventoryOptimizationService;

    @GetMapping("/optimization")
    public ResponseEntity<ApiResponse<List<InventoryOptimizationDto>>> getInventoryOptimization(
            @RequestParam(value = "storeId", required = false) Long storeId) {
        return ResponseEntity.ok(ApiResponse.success(
                inventoryOptimizationService.analyzeStoreInventory(storeId),
                "Phan tich ton kho toi uu hoa theo mo hinh kinh te EOQ va ROP"));
    }
}
