package com.utecoffe;

import com.utecoffe.dto.response.StoreDistanceDto;
import com.utecoffe.dto.response.StoreOperatingStatusDto;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.Store;
import com.utecoffe.entity.StoreTable;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.repository.OrderRepository;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.repository.StoreTableRepository;
import com.utecoffe.service.impl.StoreServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class StoreServiceTest {

    @Mock
    private StoreRepository storeRepository;

    @Mock
    private StoreTableRepository storeTableRepository;

    @Mock
    private OrderRepository orderRepository;

    @InjectMocks
    private StoreServiceImpl storeService;

    private Store flagshipStore;
    private Store roasteryStore;

    @BeforeEach
    void setUp() {
        flagshipStore = Store.builder()
                .id(1L)
                .name("UTECoffe Flagship Thu Duc")
                .address("01 Vo Van Ngan, TP. Thu Duc")
                .phoneNumber("1900 2026")
                .latitude(10.8505)
                .longitude(106.7719)
                .openingTime("07:00")
                .closingTime("22:30")
                .isActive(true)
                .build();

        roasteryStore = Store.builder()
                .id(2L)
                .name("UTECoffe Roastery Quan 1")
                .address("68 Le Loi, Quan 1")
                .phoneNumber("1900 2027")
                .latitude(10.7769)
                .longitude(106.7009)
                .openingTime("07:30")
                .closingTime("23:00")
                .isActive(true)
                .build();
    }

    @Test
    void testFindNearestStoresWithDistance_HaversineSorted() {
        when(storeRepository.findByIsActiveTrue()).thenReturn(List.of(flagshipStore, roasteryStore));

        // Coordinate near Thu Duc
        double userLat = 10.8520;
        double userLng = 106.7725;

        List<StoreDistanceDto> results = storeService.findNearestStoresWithDistance(userLat, userLng);

        assertNotNull(results);
        assertEquals(2, results.size());
        // Flagship Thu Duc should be much closer (~0.2km) than Quan 1 (~10km)
        assertEquals(1L, results.get(0).getStore().getId());
        assertTrue(results.get(0).getDistanceKm() < 1.0);
        assertTrue(results.get(1).getDistanceKm() > 5.0);
    }

    @Test
    void testGetStoreOperatingStatus_ComputesStatusAndOccupancy() {
        when(storeRepository.findById(1L)).thenReturn(Optional.of(flagshipStore));

        StoreTable t1 = StoreTable.builder().id(1L).isOccupied(true).isActive(true).build();
        StoreTable t2 = StoreTable.builder().id(2L).isOccupied(false).isActive(true).build();
        when(storeTableRepository.findByStoreIdAndIsActiveTrue(1L)).thenReturn(List.of(t1, t2));

        Order o1 = Order.builder().id(101L).status(OrderStatus.PREPARING).build();
        when(orderRepository.findByStoreIdAndStatusInOrderByCreatedAtAsc(eq(1L), any()))
                .thenReturn(List.of(o1));

        StoreOperatingStatusDto statusDto = storeService.getStoreOperatingStatus(1L);

        assertNotNull(statusDto);
        assertEquals(1L, statusDto.getStoreId());
        assertEquals("UTECoffe Flagship Thu Duc", statusDto.getStoreName());
        assertEquals("07:00", statusDto.getOpeningTime());
        assertEquals("22:30", statusDto.getClosingTime());
        assertNotNull(statusDto.getStatusBadge());
        assertNotNull(statusDto.getStatusMessage());

        assertEquals(1, statusDto.getActiveKdsQueueCount());
        assertEquals("LOW", statusDto.getRushLevel());
        assertEquals(2, statusDto.getTotalTablesCount());
        assertEquals(1, statusDto.getOccupiedTablesCount());
        assertEquals(50.0, statusDto.getTableOccupancyPercent());
    }
}
