package com.utecoffe;

import com.utecoffe.dto.request.ReservationRequest;
import com.utecoffe.entity.Store;
import com.utecoffe.entity.StoreTable;
import com.utecoffe.entity.TableReservation;
import com.utecoffe.entity.User;
import com.utecoffe.enums.ReservationStatus;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.repository.StoreTableRepository;
import com.utecoffe.repository.TableReservationRepository;
import com.utecoffe.repository.UserRepository;
import com.utecoffe.service.impl.TableReservationServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TableReservationServiceTest {

    @Mock
    private TableReservationRepository reservationRepository;

    @Mock
    private StoreRepository storeRepository;

    @Mock
    private StoreTableRepository tableRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private TableReservationServiceImpl reservationService;

    private Store store;
    private User user;
    private StoreTable tableLounge;
    private StoreTable tableBar;

    @BeforeEach
    void setUp() {
        store = Store.builder().id(1L).name("UTECoffe Flagship").build();
        user = User.builder().id(10L).fullName("Le Van A").build();

        tableLounge = StoreTable.builder()
                .id(101L)
                .store(store)
                .tableNumber("VIP-LOUNGE-01")
                .capacity(4)
                .isActive(true)
                .isOccupied(false)
                .build();

        tableBar = StoreTable.builder()
                .id(102L)
                .store(store)
                .tableNumber("BAR-01")
                .capacity(2)
                .isActive(true)
                .isOccupied(false)
                .build();
    }

    @Test
    void testCreateReservation_BestFitAllocation_Success() {
        ReservationRequest request = new ReservationRequest();
        request.setStoreId(1L);
        request.setGuestCount(2);
        request.setReservationTime(LocalDateTime.now().plusHours(3));
        request.setZonePreference("BAR");

        when(storeRepository.findById(1L)).thenReturn(Optional.of(store));
        when(userRepository.findById(10L)).thenReturn(Optional.of(user));
        when(reservationRepository.findByStoreId(1L)).thenReturn(Collections.emptyList());
        when(tableRepository.findByStoreIdAndIsActiveTrue(1L)).thenReturn(List.of(tableLounge, tableBar));
        when(reservationRepository.save(any(TableReservation.class))).thenAnswer(i -> i.getArgument(0));

        TableReservation res = reservationService.createReservationWithZone(request, 10L, "BAR");

        assertNotNull(res);
        assertEquals(ReservationStatus.CONFIRMED, res.getStatus());
        assertEquals("BAR-01", res.getStoreTable().getTableNumber());
    }

    @Test
    void testCreateReservation_SpecificTableRequested_WhenBusy_ThrowsException() {
        LocalDateTime resTime = LocalDateTime.now().plusHours(2);
        ReservationRequest request = new ReservationRequest();
        request.setStoreId(1L);
        request.setTableId(101L);
        request.setGuestCount(2);
        request.setReservationTime(resTime);

        TableReservation existing = TableReservation.builder()
                .id(999L)
                .store(store)
                .storeTable(tableLounge)
                .reservationTime(resTime.plusMinutes(10))
                .status(ReservationStatus.CONFIRMED)
                .build();

        when(storeRepository.findById(1L)).thenReturn(Optional.of(store));
        when(userRepository.findById(10L)).thenReturn(Optional.of(user));
        when(reservationRepository.findByStoreId(1L)).thenReturn(List.of(existing));
        when(tableRepository.findById(101L)).thenReturn(Optional.of(tableLounge));

        assertThrows(IllegalStateException.class, () -> {
            reservationService.createReservation(request, 10L);
        });
    }

    @Test
    void testCancelReservation_Success() {
        TableReservation res = TableReservation.builder()
                .id(1L)
                .user(user)
                .store(store)
                .storeTable(tableBar)
                .status(ReservationStatus.CONFIRMED)
                .build();

        when(reservationRepository.findById(1L)).thenReturn(Optional.of(res));
        when(reservationRepository.save(any(TableReservation.class))).thenAnswer(i -> i.getArgument(0));

        TableReservation cancelled = reservationService.cancelReservation(1L, 10L, "Thay doi ke hoach");

        assertEquals(ReservationStatus.CANCELLED, cancelled.getStatus());
        assertFalse(tableBar.getIsOccupied());
        verify(tableRepository, times(1)).save(tableBar);
    }

    @Test
    void testCancelReservation_Unauthorized_ThrowsException() {
        TableReservation res = TableReservation.builder()
                .id(1L)
                .user(user)
                .store(store)
                .status(ReservationStatus.CONFIRMED)
                .build();

        when(reservationRepository.findById(1L)).thenReturn(Optional.of(res));

        assertThrows(IllegalArgumentException.class, () -> {
            reservationService.cancelReservation(1L, 999L, "Reason");
        });
    }

    @Test
    void testAutoExpireOverdueReservations_CancelsOverdueAndFreesTable() {
        StoreTable table = StoreTable.builder().id(200L).tableNumber("T-01").isOccupied(true).build();
        TableReservation overdue = TableReservation.builder()
                .id(99L)
                .status(ReservationStatus.CONFIRMED)
                .reservationTime(LocalDateTime.now().minusMinutes(45)) // 45 mins ago -> overdue
                .storeTable(table)
                .build();

        TableReservation future = TableReservation.builder()
                .id(100L)
                .status(ReservationStatus.CONFIRMED)
                .reservationTime(LocalDateTime.now().plusHours(1))
                .build();

        when(reservationRepository.findAll()).thenReturn(List.of(overdue, future));
        when(reservationRepository.save(any(TableReservation.class))).thenAnswer(i -> i.getArgument(0));

        int expiredCount = reservationService.autoExpireOverdueReservations();

        assertEquals(1, expiredCount);
        assertEquals(ReservationStatus.CANCELLED, overdue.getStatus());
        assertTrue(overdue.getNote().contains("No-show"));
        assertFalse(table.getIsOccupied());
        verify(tableRepository, times(1)).save(table);
    }

    @Test
    void testGetTableUtilization_Success() {
        tableLounge.setIsOccupied(true);
        tableBar.setIsOccupied(false);

        TableReservation todayRes = TableReservation.builder()
                .id(201L)
                .store(store)
                .storeTable(tableLounge)
                .reservationTime(LocalDateTime.now().withHour(18).withMinute(0))
                .guestCount(4)
                .status(ReservationStatus.SEATED)
                .build();

        when(storeRepository.findById(1L)).thenReturn(Optional.of(store));
        when(tableRepository.findByStoreIdAndIsActiveTrue(1L)).thenReturn(List.of(tableLounge, tableBar));
        when(reservationRepository.findByStoreId(1L)).thenReturn(List.of(todayRes));

        com.utecoffe.dto.response.TableUtilizationDto dto = reservationService.getTableUtilization(1L);

        assertNotNull(dto);
        assertEquals(1L, dto.getStoreId());
        assertEquals(2, dto.getTotalTables());
        assertEquals(1, dto.getOccupiedTables());
        assertEquals(1, dto.getAvailableTables());
        assertEquals(50.0, dto.getOccupancyRatePercent());
        assertEquals(1, dto.getTodayReservationsCount());
        assertEquals(1, dto.getSeatedTodayCount());
        assertEquals(4.0, dto.getAveragePartySize());
        assertNotNull(dto.getZoneBreakdown());
        assertNotNull(dto.getFloorManagerAdvice());
    }
}
