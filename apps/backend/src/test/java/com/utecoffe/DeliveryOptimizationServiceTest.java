package com.utecoffe;

import com.utecoffe.dto.response.DeliveryOptimizationDto;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.Store;
import com.utecoffe.repository.OrderRepository;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.service.DeliveryOptimizationService;
import com.utecoffe.service.impl.DeliveryOptimizationServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collections;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class DeliveryOptimizationServiceTest {

    @Mock
    private StoreRepository storeRepository;

    @Mock
    private OrderRepository orderRepository;

    private DeliveryOptimizationService deliveryOptimizationService;
    private Store flagshipStore;

    @BeforeEach
    void setUp() {
        deliveryOptimizationService = new DeliveryOptimizationServiceImpl(storeRepository, orderRepository);

        flagshipStore = Store.builder()
                .id(1L)
                .name("UTECoffe Flagship Thủ Đức")
                .address("01 Võ Văn Ngân, TP. Thủ Đức")
                .latitude(10.8504)
                .longitude(106.7719)
                .build();
    }

    @Test
    @DisplayName("Should compute accurate Haversine distance, queue prep time, and delivery ETA")
    void testCalculateDeliveryEstimate() {
        when(storeRepository.findById(1L)).thenReturn(Optional.of(flagshipStore));
        when(orderRepository.findByStoreIdAndStatusInOrderByCreatedAtAsc(any(), any()))
                .thenReturn(Collections.emptyList());

        // Destination: 10.8700, 106.7900 (~3.0 km away)
        DeliveryOptimizationDto dto = deliveryOptimizationService.calculateDeliveryEstimate(
                1L, 10.8700, 106.7900, "KTX Khu A ĐHQG, Linh Trung, Thủ Đức"
        );

        assertNotNull(dto);
        assertEquals(1L, dto.getStoreId());
        assertEquals("UTECoffe Flagship Thủ Đức", dto.getOriginBranchName());
        assertTrue(dto.getDistanceKm() > 1.0, "Distance should be greater than 1 km");
        assertTrue(dto.getPrepMinutes() >= 3, "Prep minutes should be at least 3 minutes");
        assertTrue(dto.getTransitMinutes() >= 5, "Transit minutes should be at least 5 minutes");
        assertEquals(dto.getPrepMinutes() + dto.getTransitMinutes(), dto.getTotalEstimatedMinutes());
        assertNotNull(dto.getEstimatedArrivalFormatted());
        assertNotNull(dto.getTrafficStatusLabel());
    }

    @Test
    @DisplayName("Should calculate delivery estimate for existing order")
    void testCalculateDeliveryEstimateForOrder() {
        Order order = Order.builder()
                .id(55L)
                .store(flagshipStore)
                .deliveryAddress("Landmark 81, Bình Thạnh, TP.HCM")
                .build();

        when(orderRepository.findById(55L)).thenReturn(Optional.of(order));
        when(storeRepository.findById(1L)).thenReturn(Optional.of(flagshipStore));
        when(orderRepository.findByStoreIdAndStatusInOrderByCreatedAtAsc(any(), any()))
                .thenReturn(Collections.emptyList());

        DeliveryOptimizationDto dto = deliveryOptimizationService.calculateDeliveryEstimateForOrder(55L);

        assertNotNull(dto);
        assertEquals("Landmark 81, Bình Thạnh, TP.HCM", dto.getDestinationAddress());
        assertTrue(dto.getTotalEstimatedMinutes() > 0);
    }
}
