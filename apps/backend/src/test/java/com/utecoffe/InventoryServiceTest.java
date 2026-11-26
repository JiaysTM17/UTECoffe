package com.utecoffe;

import com.utecoffe.entity.*;
import com.utecoffe.enums.InventoryTransactionType;
import com.utecoffe.repository.InventoryLogRepository;
import com.utecoffe.repository.OrderItemRepository;
import com.utecoffe.repository.RecipeRepository;
import com.utecoffe.repository.StoreInventoryRepository;
import com.utecoffe.service.impl.InventoryServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class InventoryServiceTest {

    @Mock
    private StoreInventoryRepository storeInventoryRepository;

    @Mock
    private InventoryLogRepository inventoryLogRepository;

    @Mock
    private RecipeRepository recipeRepository;

    @Mock
    private OrderItemRepository orderItemRepository;

    @InjectMocks
    private InventoryServiceImpl inventoryService;

    private Store store;
    private Order order;
    private Product product;
    private Ingredient coffeeBean;
    private StoreInventory inventory;
    private Recipe recipe;

    @BeforeEach
    void setUp() {
        store = Store.builder().id(1L).name("UTECoffe Thủ Đức").build();
        order = Order.builder().id(50L).orderCode("UTE-261126-0050").store(store).build();
        product = Product.builder().id(10L).name("Espresso Specialty").build();
        coffeeBean = Ingredient.builder().id(20L).name("Hạt Arabica Cầu Đất").build();

        inventory = StoreInventory.builder()
                .id(1L)
                .store(store)
                .ingredient(coffeeBean)
                .currentStock(BigDecimal.valueOf(1000.00)) // 1000g in stock
                .build();

        recipe = Recipe.builder()
                .id(1L)
                .product(product)
                .ingredient(coffeeBean)
                .quantityRequired(BigDecimal.valueOf(20.00)) // 20g per cup
                .build();
    }

    @Test
    void testVerifyStockForOrder_SufficientStock_ReturnsTrue() {
        OrderItem item = OrderItem.builder().product(product).quantity(2).build(); // Needs 40g
        when(orderItemRepository.findByOrderId(50L)).thenReturn(List.of(item));
        when(recipeRepository.findByProductId(10L)).thenReturn(List.of(recipe));
        when(storeInventoryRepository.findByStoreIdAndIngredientId(1L, 20L)).thenReturn(Optional.of(inventory));

        boolean result = inventoryService.verifyStockForOrder(order);

        assertTrue(result);
    }

    @Test
    void testVerifyStockForOrder_InsufficientStock_ReturnsFalse() {
        OrderItem item = OrderItem.builder().product(product).quantity(100).build(); // Needs 2000g, has 1000g
        when(orderItemRepository.findByOrderId(50L)).thenReturn(List.of(item));
        when(recipeRepository.findByProductId(10L)).thenReturn(List.of(recipe));
        when(storeInventoryRepository.findByStoreIdAndIngredientId(1L, 20L)).thenReturn(Optional.of(inventory));

        boolean result = inventoryService.verifyStockForOrder(order);

        assertFalse(result);
    }

    @Test
    void testDeductStockForOrder_Success_AndIdempotent() {
        OrderItem item = OrderItem.builder().product(product).quantity(2).build(); // 40g
        when(orderItemRepository.findByOrderId(50L)).thenReturn(List.of(item));
        when(recipeRepository.findByProductId(10L)).thenReturn(List.of(recipe));
        when(storeInventoryRepository.findByStoreIdAndIngredientId(1L, 20L)).thenReturn(Optional.of(inventory));
        when(inventoryLogRepository.existsByReferenceOrderIdAndTransactionType(50L, InventoryTransactionType.EXPORT_ORDER))
                .thenReturn(false);

        inventoryService.deductStockForOrder(order);

        // 1000g - 40g = 960g
        assertEquals(BigDecimal.valueOf(960.00), inventory.getCurrentStock());
        verify(storeInventoryRepository, times(1)).save(inventory);
        verify(inventoryLogRepository, times(1)).save(any(InventoryLog.class));

        // Test idempotency: second call should be ignored
        when(inventoryLogRepository.existsByReferenceOrderIdAndTransactionType(50L, InventoryTransactionType.EXPORT_ORDER))
                .thenReturn(true);
        inventoryService.deductStockForOrder(order);

        // Stock remains 960g
        assertEquals(BigDecimal.valueOf(960.00), inventory.getCurrentStock());
    }

    @Test
    void testRestoreStockForOrder_RestoresCorrectly() {
        OrderItem item = OrderItem.builder().product(product).quantity(2).build(); // 40g
        when(orderItemRepository.findByOrderId(50L)).thenReturn(List.of(item));
        when(recipeRepository.findByProductId(10L)).thenReturn(List.of(recipe));
        when(storeInventoryRepository.findByStoreIdAndIngredientId(1L, 20L)).thenReturn(Optional.of(inventory));
        when(inventoryLogRepository.existsByReferenceOrderIdAndTransactionType(50L, InventoryTransactionType.EXPORT_ORDER))
                .thenReturn(true);
        when(inventoryLogRepository.existsByReferenceOrderIdAndTransactionType(50L, InventoryTransactionType.ADJUSTMENT))
                .thenReturn(false);

        inventory.setCurrentStock(BigDecimal.valueOf(960.00));
        inventoryService.restoreStockForOrder(order);

        // 960g + 40g = 1000g restored
        assertEquals(BigDecimal.valueOf(1000.00), inventory.getCurrentStock());
        verify(inventoryLogRepository, times(1)).save(argThat(log ->
                log.getTransactionType() == InventoryTransactionType.ADJUSTMENT &&
                log.getQuantityChange().compareTo(BigDecimal.valueOf(40.00)) == 0));
    }
}
