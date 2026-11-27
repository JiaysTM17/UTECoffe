package com.utecoffe;

import com.utecoffe.dto.response.DemandForecastDto;
import com.utecoffe.dto.response.SupplyChainForecastSummaryDto;
import com.utecoffe.entity.Ingredient;
import com.utecoffe.entity.Store;
import com.utecoffe.entity.StoreInventory;
import com.utecoffe.repository.IngredientRepository;
import com.utecoffe.repository.StoreInventoryRepository;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.service.PredictiveSupplyChainService;
import com.utecoffe.service.impl.PredictiveSupplyChainServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PredictiveSupplyChainServiceTest {

    @Mock
    private IngredientRepository ingredientRepository;

    @Mock
    private StoreInventoryRepository storeInventoryRepository;

    @Mock
    private StoreRepository storeRepository;

    private PredictiveSupplyChainService predictiveSupplyChainService;
    private Ingredient coffeeBeans;
    private Store store;

    @BeforeEach
    void setUp() {
        predictiveSupplyChainService = new PredictiveSupplyChainServiceImpl(
                ingredientRepository, storeInventoryRepository, storeRepository
        );

        coffeeBeans = Ingredient.builder()
                .id(1L)
                .name("Hạt Bourbon Cầu Đất Rang Mộc")
                .unit("KG")
                .minThreshold(BigDecimal.valueOf(15.0))
                .build();

        store = Store.builder()
                .id(1L)
                .name("UTECoffe Flagship Thủ Đức")
                .build();
    }

    @Test
    @DisplayName("Should generate 7-day Holt-Winters demand forecast and dynamic ROP")
    void testForecastIngredientDemand() {
        StoreInventory inventory = StoreInventory.builder()
                .id(100L)
                .store(store)
                .ingredient(coffeeBeans)
                .currentStock(BigDecimal.valueOf(12.0)) // Below safety threshold -> should trigger urgent replenishment
                .safetyStock(BigDecimal.valueOf(15.0))
                .build();

        when(ingredientRepository.findById(1L)).thenReturn(Optional.of(coffeeBeans));
        when(storeInventoryRepository.findByStoreIdAndIngredientId(1L, 1L)).thenReturn(Optional.of(inventory));

        DemandForecastDto dto = predictiveSupplyChainService.forecastIngredientDemand(1L, 1L);

        assertNotNull(dto);
        assertEquals(1L, dto.getIngredientId());
        assertEquals("Hạt Bourbon Cầu Đất Rang Mộc", dto.getIngredientName());
        assertTrue(dto.getForecastDay1() > 0.0);
        assertTrue(dto.getForecastDay7Total() > 0.0);
        assertTrue(dto.getReorderPoint().compareTo(BigDecimal.ZERO) > 0);
        assertNotNull(dto.getReplenishmentAction());
        assertTrue(dto.getReplenishmentAction().contains("GẤP"), "Should flag urgent replenishment when current stock is low");
        assertNotNull(dto.getShelfLifeAdvisory());
    }

    @Test
    @DisplayName("Should forecast entire store inventory demand")
    void testForecastStoreDemand() {
        when(storeRepository.findById(1L)).thenReturn(Optional.of(store));
        when(ingredientRepository.findAll()).thenReturn(List.of(coffeeBeans));
        when(ingredientRepository.findById(1L)).thenReturn(Optional.of(coffeeBeans));
        when(storeInventoryRepository.findByStoreIdAndIngredientId(1L, 1L)).thenReturn(Optional.empty());

        SupplyChainForecastSummaryDto summary = predictiveSupplyChainService.forecastStoreDemand(1L);

        assertNotNull(summary);
        assertEquals(1L, summary.getStoreId());
        assertEquals(1, summary.getTotalMonitoredIngredients());
        assertFalse(summary.getForecasts().isEmpty());
    }
}
