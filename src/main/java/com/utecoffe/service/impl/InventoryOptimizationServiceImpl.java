package com.utecoffe.service.impl;

import com.utecoffe.dto.response.InventoryOptimizationDto;
import com.utecoffe.entity.Ingredient;
import com.utecoffe.entity.StoreInventory;
import com.utecoffe.repository.IngredientRepository;
import com.utecoffe.repository.StoreInventoryRepository;
import com.utecoffe.service.InventoryOptimizationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class InventoryOptimizationServiceImpl implements InventoryOptimizationService {

    private static final Logger log = LoggerFactory.getLogger(InventoryOptimizationServiceImpl.class);

    private final StoreInventoryRepository storeInventoryRepository;
    private final IngredientRepository ingredientRepository;

    private static final double ORDER_FIXED_COST_S = 250000.0;
    private static final double HOLDING_COST_RATIO = 0.18;
    private static final double Z_SERVICE_LEVEL_95 = 1.65;

    @Autowired
    public InventoryOptimizationServiceImpl(StoreInventoryRepository storeInventoryRepository,
                                           IngredientRepository ingredientRepository) {
        this.storeInventoryRepository = storeInventoryRepository;
        this.ingredientRepository = ingredientRepository;
    }

    @Override
    public List<InventoryOptimizationDto> analyzeStoreInventory(Long storeId) {
        log.info("Computing EOQ and ROP Supply Chain Optimization for Store: {}", storeId != null ? storeId : "ALL");

        List<StoreInventory> inventories;
        if (storeId != null && storeId > 0) {
            inventories = storeInventoryRepository.findByStoreId(storeId);
        } else {
            inventories = storeInventoryRepository.findAll();
        }

        if (inventories.isEmpty()) {
            List<Ingredient> ingredients = ingredientRepository.findAll();
            List<InventoryOptimizationDto> dtoList = new ArrayList<>();
            for (Ingredient ing : ingredients) {
                dtoList.add(calculateForIngredient(ing, ing.getMinThreshold(), ing.getMinThreshold().multiply(BigDecimal.valueOf(1.5))));
            }
            return dtoList;
        }

        List<InventoryOptimizationDto> results = new ArrayList<>();
        for (StoreInventory inv : inventories) {
            Ingredient ing = inv.getIngredient();
            results.add(calculateForIngredient(ing, inv.getSafetyStock(), inv.getCurrentStock()));
        }

        return results;
    }

    private InventoryOptimizationDto calculateForIngredient(Ingredient ing, BigDecimal configuredSafetyStock, BigDecimal currentStock) {
        double cost = ing.getCurrentCostPrice() != null ? ing.getCurrentCostPrice().doubleValue() : 50000.0;
        if (cost <= 0) cost = 50000.0;

        double threshold = ing.getMinThreshold() != null ? ing.getMinThreshold().doubleValue() : 1000.0;
        double annualDemand = Math.max(threshold * 24.0, 500.0);
        double dailyDemand = annualDemand / 365.0;

        int leadTimeDays = ing.getUnit().equalsIgnoreCase("gram") ? 5 : (ing.getUnit().equalsIgnoreCase("ml") ? 2 : 3);
        double holdingCostH = Math.max(cost * HOLDING_COST_RATIO, 1000.0);

        double eoq = Math.sqrt((2.0 * annualDemand * ORDER_FIXED_COST_S) / holdingCostH);
        eoq = Math.round(eoq * 10.0) / 10.0;

        double dailyStdDev = dailyDemand * 0.25;
        double calculatedSafetyStock = Z_SERVICE_LEVEL_95 * dailyStdDev * Math.sqrt(leadTimeDays);
        if (configuredSafetyStock != null && configuredSafetyStock.doubleValue() > calculatedSafetyStock) {
            calculatedSafetyStock = configuredSafetyStock.doubleValue();
        }
        calculatedSafetyStock = Math.round(calculatedSafetyStock * 10.0) / 10.0;

        double rop = (dailyDemand * leadTimeDays) + calculatedSafetyStock;
        rop = Math.round(rop * 10.0) / 10.0;

        double curStockVal = currentStock != null ? currentStock.doubleValue() : 0.0;
        double daysLeft = dailyDemand > 0 ? (curStockVal / dailyDemand) : 999.0;
        daysLeft = Math.round(daysLeft * 10.0) / 10.0;

        String status;
        String action;
        if (curStockVal <= calculatedSafetyStock) {
            status = "CRITICAL_REORDER";
            action = "CẢNH BÁO KHẨN: Tồn kho chạm đáy an toàn (" + curStockVal + " " + ing.getUnit() + "). Cần phát lệnh PO ngay lập tức số lượng EOQ = " + eoq + " " + ing.getUnit() + " để tránh gián đoạn phục vụ!";
        } else if (curStockVal <= rop) {
            status = "WARNING_LOW";
            action = "CHẠM ĐIỂM ĐẶT HÀNG (ROP = " + rop + "): Dự trữ còn đủ cho " + daysLeft + " ngày. Khuyến nghị lập đơn PO số lượng tối ưu kinh tế EOQ: " + eoq + " " + ing.getUnit() + ".";
        } else {
            status = "OPTIMAL_SURPLUS";
            action = "TỒN KHO ỔN ĐỊNH: Đủ vận hành trong " + daysLeft + " ngày tới. Chưa cần đặt thêm hàng.";
        }

        return InventoryOptimizationDto.builder()
                .ingredientId(ing.getId())
                .ingredientName(ing.getName())
                .sku(ing.getSku())
                .unit(ing.getUnit())
                .currentStock(BigDecimal.valueOf(curStockVal))
                .minThreshold(ing.getMinThreshold())
                .costPrice(BigDecimal.valueOf(cost))
                .annualDemand(Math.round(annualDemand * 10.0) / 10.0)
                .orderFixedCost(ORDER_FIXED_COST_S)
                .holdingCostPerUnit(Math.round(holdingCostH * 10.0) / 10.0)
                .eoqOptimalBatch(eoq)
                .dailyDemandRate(Math.round(dailyDemand * 100.0) / 100.0)
                .supplierLeadTimeDays(leadTimeDays)
                .safetyStock(calculatedSafetyStock)
                .reorderPoint(rop)
                .stockStatus(status)
                .actionRecommendation(action)
                .daysOfInventoryLeft(daysLeft)
                .build();
    }
}
