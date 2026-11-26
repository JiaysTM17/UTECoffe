package com.utecoffe.scheduler;

import com.utecoffe.security.RateLimiterService;
import com.utecoffe.service.TableReservationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Enterprise Background Worker & Automated Task Maintenance.
 * Handles auto-cancellation of no-show table reservations,
 * evicts stale rate-limiting token buckets, and ensures system cleanliness.
 */
@Component
public class SystemMaintenanceScheduler {

    private static final Logger log = LoggerFactory.getLogger(SystemMaintenanceScheduler.class);

    private final TableReservationService tableReservationService;
    private final RateLimiterService rateLimiterService;

    @Autowired
    public SystemMaintenanceScheduler(TableReservationService tableReservationService,
                                      RateLimiterService rateLimiterService) {
        this.tableReservationService = tableReservationService;
        this.rateLimiterService = rateLimiterService;
    }

    /**
     * Runs every 10 minutes (600,000 ms).
     * Automatically scans and cancels overdue table reservations (> 30 mins after reservation time)
     * and releases the table for walk-in guests.
     */
    @Scheduled(fixedRate = 600000, initialDelay = 60000)
    public void sweepOverdueReservations() {
        try {
            int expiredCount = tableReservationService.autoExpireOverdueReservations();
            if (expiredCount > 0) {
                log.info("SystemMaintenance: Auto-expired {} overdue table reservations (No-show)", expiredCount);
            }
        } catch (Exception e) {
            log.error("SystemMaintenance: Error sweeping overdue reservations: {}", e.getMessage());
        }
    }

    /**
     * Runs every 1 hour (3,600,000 ms).
     * Cleans up stale token buckets from the in-memory sliding window rate limiter.
     */
    @Scheduled(fixedRate = 3600000, initialDelay = 120000)
    public void cleanupRateLimiterBuckets() {
        try {
            rateLimiterService.cleanup();
            log.info("SystemMaintenance: Cleaned up expired rate-limiter token buckets");
        } catch (Exception e) {
            log.error("SystemMaintenance: Error cleaning rate limiter buckets: {}", e.getMessage());
        }
    }
}
