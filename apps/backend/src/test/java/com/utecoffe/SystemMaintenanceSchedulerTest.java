package com.utecoffe;

import com.utecoffe.scheduler.SystemMaintenanceScheduler;
import com.utecoffe.security.RateLimiterService;
import com.utecoffe.service.TableReservationService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class SystemMaintenanceSchedulerTest {

    @Mock
    private TableReservationService tableReservationService;

    @Mock
    private RateLimiterService rateLimiterService;

    @InjectMocks
    private SystemMaintenanceScheduler scheduler;

    @Test
    void testSweepOverdueReservations_InvokesService() {
        when(tableReservationService.autoExpireOverdueReservations()).thenReturn(3);

        scheduler.sweepOverdueReservations();

        verify(tableReservationService, times(1)).autoExpireOverdueReservations();
    }

    @Test
    void testCleanupRateLimiterBuckets_InvokesRateLimiter() {
        scheduler.cleanupRateLimiterBuckets();

        verify(rateLimiterService, times(1)).cleanup();
    }
}
