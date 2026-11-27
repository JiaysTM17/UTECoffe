package com.utecoffe.service;

import com.utecoffe.dto.response.DeliveryRoutePlanDto;

import java.util.List;

public interface RouteOptimizationService {

    /** A stop to visit; lat/lon may be null (deterministically geocoded around the store). */
    record RouteStopInput(Long orderId, String orderCode, String customerName, String phone,
                          String address, Double lat, Double lon, int cups, int minutesSinceReady) {}

    /** Plans a route for all READY delivery orders of a store. */
    DeliveryRoutePlanDto planStoreDeliveryRoute(Long storeId);

    /** Pure algorithm: Nearest-Neighbor construction + 2-opt local search (open TSP path from origin). */
    DeliveryRoutePlanDto optimizeRoute(Long storeId, String storeName, double originLat, double originLon,
                                       List<RouteStopInput> stops);
}
