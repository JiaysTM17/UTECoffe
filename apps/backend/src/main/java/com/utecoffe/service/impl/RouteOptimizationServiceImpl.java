package com.utecoffe.service.impl;

import com.utecoffe.dto.response.DeliveryRoutePlanDto;
import com.utecoffe.dto.response.DeliveryStopDto;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.OrderItem;
import com.utecoffe.entity.Store;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.enums.OrderType;
import com.utecoffe.repository.OrderItemRepository;
import com.utecoffe.repository.OrderRepository;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.service.RouteOptimizationService;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Multi-stop delivery batching for shippers.
 *
 * 1. Distance matrix with the Haversine great-circle formula (scaled by a 1.3 urban detour factor).
 * 2. Construction heuristic: Nearest Neighbor from the store (O(n^2)).
 * 3. Improvement: 2-opt local search on the open path (reverses segments while total length decreases).
 * 4. Beverage freshness: exponential decay F(t) = 100 * 2^(-t / T_half) where t = waiting + in-transit minutes.
 */
@Service
public class RouteOptimizationServiceImpl implements RouteOptimizationService {

    private static final double EARTH_RADIUS_KM = 6371.0088;
    private static final double URBAN_DETOUR_FACTOR = 1.3;
    private static final double AVG_SPEED_KMH = 22.0;          // motorbike in HCMC traffic
    private static final int HANDOVER_MINUTES = 2;             // parking + hand-over per stop
    private static final double FRESHNESS_HALF_LIFE_MIN = 45.0; // iced drinks lose half their quality in ~45'
    private static final int MAX_STOPS_PER_BATCH = 12;

    private final StoreRepository storeRepository;
    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;

    public RouteOptimizationServiceImpl(StoreRepository storeRepository,
                                        OrderRepository orderRepository,
                                        OrderItemRepository orderItemRepository) {
        this.storeRepository = storeRepository;
        this.orderRepository = orderRepository;
        this.orderItemRepository = orderItemRepository;
    }

    @Override
    public DeliveryRoutePlanDto planStoreDeliveryRoute(Long storeId) {
        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new IllegalArgumentException("Chi nhánh không tồn tại: " + storeId));

        List<Order> ready = orderRepository.findByStoreIdAndStatusInOrderByCreatedAtAsc(
                storeId, List.of(OrderStatus.READY));
        LocalDateTime now = LocalDateTime.now();
        List<RouteStopInput> inputs = new ArrayList<>();
        for (Order o : ready) {
            if (o.getOrderType() != OrderType.DELIVERY) continue;
            if (inputs.size() >= MAX_STOPS_PER_BATCH) break;
            int cups = 0;
            List<OrderItem> items = orderItemRepository.findByOrderId(o.getId());
            if (items != null) {
                for (OrderItem it : items) cups += it.getQuantity() != null ? it.getQuantity() : 0;
            }
            LocalDateTime readyAt = o.getUpdatedAt() != null ? o.getUpdatedAt() : o.getCreatedAt();
            int waited = readyAt != null ? (int) Math.max(0, Duration.between(readyAt, now).toMinutes()) : 0;
            inputs.add(new RouteStopInput(o.getId(), o.getOrderCode(), o.getRecipientName(), o.getRecipientPhone(),
                    o.getDeliveryAddress(), null, null, Math.max(cups, 1), waited));
        }
        return optimizeRoute(store.getId(), store.getName(), store.getLatitude(), store.getLongitude(), inputs);
    }

    @Override
    public DeliveryRoutePlanDto optimizeRoute(Long storeId, String storeName, double originLat, double originLon,
                                              List<RouteStopInput> stops) {
        List<RouteStopInput> input = stops != null ? stops : Collections.emptyList();
        int n = input.size();

        // Node 0 = store, nodes 1..n = stops
        double[] lat = new double[n + 1];
        double[] lon = new double[n + 1];
        lat[0] = originLat;
        lon[0] = originLon;
        for (int i = 0; i < n; i++) {
            RouteStopInput s = input.get(i);
            if (s.lat() != null && s.lon() != null && isValidCoordinate(s.lat(), s.lon())) {
                lat[i + 1] = s.lat();
                lon[i + 1] = s.lon();
            } else {
                double[] g = pseudoGeocode(s.address(), originLat, originLon);
                lat[i + 1] = g[0];
                lon[i + 1] = g[1];
            }
        }

        double[][] dist = new double[n + 1][n + 1];
        for (int i = 0; i <= n; i++) {
            for (int j = i + 1; j <= n; j++) {
                double d = haversineKm(lat[i], lon[i], lat[j], lon[j]) * URBAN_DETOUR_FACTOR;
                dist[i][j] = d;
                dist[j][i] = d;
            }
        }

        // FIFO baseline
        List<Integer> fifo = new ArrayList<>();
        for (int i = 1; i <= n; i++) fifo.add(i);
        double naive = pathLength(fifo, dist);

        List<Integer> route = nearestNeighbor(n, dist);
        int improvements = twoOpt(route, dist);
        double optimized = pathLength(route, dist);

        // Safety net: 2-opt result must never be worse than FIFO
        if (optimized > naive) {
            route = fifo;
            optimized = naive;
        }

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter hhmm = DateTimeFormatter.ofPattern("HH:mm");
        List<DeliveryStopDto> out = new ArrayList<>();
        int prev = 0;
        double cumulativeMin = 0;
        double freshnessSum = 0;
        for (int seq = 0; seq < route.size(); seq++) {
            int node = route.get(seq);
            RouteStopInput s = input.get(node - 1);
            double leg = dist[prev][node];
            int legMin = (int) Math.ceil(leg / AVG_SPEED_KMH * 60.0);
            cumulativeMin += legMin;
            double freshness = freshnessScore(s.minutesSinceReady() + cumulativeMin);
            freshnessSum += freshness;
            out.add(DeliveryStopDto.builder()
                    .stopSequence(seq + 1)
                    .orderId(s.orderId())
                    .orderCode(s.orderCode())
                    .customerName(s.customerName())
                    .customerPhone(s.phone())
                    .deliveryAddress(s.address())
                    .latitude(round(lat[node], 6))
                    .longitude(round(lon[node], 6))
                    .legDistanceKm(round(leg, 2))
                    .legDurationMinutes(legMin)
                    .cumulativeMinutes((int) cumulativeMin)
                    .estimatedArrivalTime(now.plusMinutes((long) cumulativeMin).format(hhmm))
                    .totalCups(s.cups())
                    .beverageFreshnessScore(round(freshness, 1))
                    .freshnessStatus(freshness >= 80 ? "TUYỆT HẢO" : freshness >= 60 ? "TỐT" : "CẦN GIAO GẤP")
                    .build());
            cumulativeMin += HANDOVER_MINUTES;
            prev = node;
        }

        double saved = naive > 0 ? (naive - optimized) / naive * 100.0 : 0.0;
        return DeliveryRoutePlanDto.builder()
                .storeId(storeId)
                .storeName(storeName)
                .originLat(originLat)
                .originLon(originLon)
                .totalStops(n)
                .naiveDistanceKm(round(naive, 2))
                .optimizedDistanceKm(round(optimized, 2))
                .distanceSavedPercent(round(Math.max(0, saved), 1))
                .twoOptImprovements(improvements)
                .totalRouteMinutes((int) cumulativeMin)
                .averageFreshnessScore(n > 0 ? round(freshnessSum / n, 1) : 100.0)
                .algorithm("Haversine + Nearest-Neighbor + 2-opt (open TSP) + Exponential Freshness Decay")
                .stops(out)
                .build();
    }

    // ---------------------------------------------------------------- algorithms

    static List<Integer> nearestNeighbor(int n, double[][] dist) {
        List<Integer> route = new ArrayList<>(n);
        boolean[] visited = new boolean[n + 1];
        int current = 0;
        for (int step = 0; step < n; step++) {
            int best = -1;
            double bestD = Double.MAX_VALUE;
            for (int j = 1; j <= n; j++) {
                if (!visited[j] && dist[current][j] < bestD) {
                    bestD = dist[current][j];
                    best = j;
                }
            }
            visited[best] = true;
            route.add(best);
            current = best;
        }
        return route;
    }

    /** 2-opt for an open path starting at depot 0 (path does not return). Returns number of improving moves. */
    static int twoOpt(List<Integer> route, double[][] dist) {
        int size = route.size();
        if (size < 3) return 0;
        int moves = 0;
        boolean improved = true;
        int guard = 0;
        while (improved && guard++ < 1000) {
            improved = false;
            for (int i = 0; i < size - 1; i++) {
                int a = (i == 0) ? 0 : route.get(i - 1);
                int b = route.get(i);
                for (int k = i + 1; k < size; k++) {
                    int c = route.get(k);
                    int d = (k + 1 < size) ? route.get(k + 1) : -1; // -1 = open end
                    double before = dist[a][b] + (d >= 0 ? dist[c][d] : 0);
                    double after = dist[a][c] + (d >= 0 ? dist[b][d] : 0);
                    if (after + 1e-9 < before) {
                        Collections.reverse(route.subList(i, k + 1));
                        moves++;
                        improved = true;
                        b = route.get(i);
                    }
                }
            }
        }
        return moves;
    }

    static double pathLength(List<Integer> route, double[][] dist) {
        double total = 0;
        int prev = 0;
        for (int node : route) {
            total += dist[prev][node];
            prev = node;
        }
        return total;
    }

    static double haversineKm(double lat1, double lon1, double lat2, double lon2) {
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        return 2 * EARTH_RADIUS_KM * Math.asin(Math.min(1.0, Math.sqrt(a)));
    }

    static double freshnessScore(double minutes) {
        return 100.0 * Math.pow(2.0, -Math.max(0, minutes) / FRESHNESS_HALF_LIFE_MIN);
    }

    /** Deterministic offline geocode: stable point within ~6 km of the store derived from the address hash. */
    static double[] pseudoGeocode(String address, double originLat, double originLon) {
        String key = address != null ? address.trim().toLowerCase() : "";
        long h = key.hashCode() & 0xffffffffL;
        double angle = (h % 3600) / 3600.0 * 2 * Math.PI;
        double radiusKm = 0.8 + ((h / 3600) % 520) / 100.0; // 0.8 – 6.0 km
        double dLat = (radiusKm / EARTH_RADIUS_KM) * Math.cos(angle);
        double dLon = (radiusKm / (EARTH_RADIUS_KM * Math.cos(Math.toRadians(originLat)))) * Math.sin(angle);
        return new double[]{originLat + Math.toDegrees(dLat), originLon + Math.toDegrees(dLon)};
    }

    private static boolean isValidCoordinate(double lat, double lon) {
        return lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180 && !(lat == 0 && lon == 0);
    }

    private static double round(double v, int places) {
        double f = Math.pow(10, places);
        return Math.round(v * f) / f;
    }
}
