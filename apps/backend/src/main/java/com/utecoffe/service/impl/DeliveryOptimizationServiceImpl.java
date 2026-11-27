package com.utecoffe.service.impl;

import com.utecoffe.dto.response.DeliveryOptimizationDto;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.Store;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.repository.OrderRepository;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.service.DeliveryOptimizationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;

@Service
public class DeliveryOptimizationServiceImpl implements DeliveryOptimizationService {

    private static final Logger log = LoggerFactory.getLogger(DeliveryOptimizationServiceImpl.class);

    private final StoreRepository storeRepository;
    private final OrderRepository orderRepository;

    private static final double EARTH_RADIUS_KM = 6371.0;
    private static final double BASE_MOTORBIKE_SPEED_KM_PER_HOUR = 28.0;
    private static final int CONCURRENT_BARISTAS = 2;
    private static final double MEAN_SERVICE_TIME_MINS = 3.5; // 1/mu

    @Autowired
    public DeliveryOptimizationServiceImpl(StoreRepository storeRepository,
                                          OrderRepository orderRepository) {
        this.storeRepository = storeRepository;
        this.orderRepository = orderRepository;
    }

    @Override
    public DeliveryOptimizationDto calculateDeliveryEstimate(Long storeId, Double destLat, Double destLon, String destAddress) {
        Store store = storeRepository.findById(storeId != null ? storeId : 1L)
                .orElseGet(() -> storeRepository.findAll().stream().findFirst()
                        .orElse(Store.builder()
                                .id(1L)
                                .name("UTECoffe Flagship Thủ Đức")
                                .address("01 Võ Văn Ngân, TP. Thủ Đức, TP.HCM")
                                .latitude(10.8504)
                                .longitude(106.7719)
                                .build()));

        double sLat = store.getLatitude() != null ? store.getLatitude() : 10.8504;
        double sLon = store.getLongitude() != null ? store.getLongitude() : 106.7719;

        double dLat = destLat != null ? destLat : (sLat + 0.025);
        double dLon = destLon != null ? destLon : (sLon + 0.020);

        // 1. Haversine Distance Calculation
        double distanceKm = calculateHaversineDistance(sLat, sLon, dLat, dLon);
        if (distanceKm < 0.5) distanceKm = 0.8; // Minimum urban road route

        // 2. Queueing Theory M/M/c Model for Barista Prep Time
        List<Order> activeOrders = orderRepository.findByStoreIdAndStatusInOrderByCreatedAtAsc(
                store.getId(),
                Arrays.asList(OrderStatus.CONFIRMED, OrderStatus.PREPARING)
        );
        int queueSize = activeOrders != null ? activeOrders.size() : 0;
        int prepMins = calculateMmcQueueTime(queueSize);

        // 3. Traffic Congestion Velocity Model
        LocalDateTime now = LocalDateTime.now();
        double trafficFactor = calculateTrafficFactor(now);
        String trafficLabel = getTrafficStatusLabel(trafficFactor);

        // Transit time = (distance / speed) * trafficFactor * 60 + 3 mins buffer (handover)
        double rawTransitHours = distanceKm / BASE_MOTORBIKE_SPEED_KM_PER_HOUR;
        int transitMins = (int) Math.round(rawTransitHours * trafficFactor * 60.0) + 3;
        if (transitMins < 5) transitMins = 5;

        int totalMins = prepMins + transitMins;
        LocalDateTime arrivalTime = now.plusMinutes(totalMins);
        String arrivalStr = arrivalTime.format(DateTimeFormatter.ofPattern("HH:mm"));

        String tierBadge = totalMins <= 30 ? "⚡ Siêu Tốc 20-30 Phút" : "🛡️ Đảm Bảo Nhiệt Độ & Hương Vị";

        return DeliveryOptimizationDto.builder()
                .storeId(store.getId())
                .originBranchName(store.getName())
                .originAddress(store.getAddress())
                .originLat(sLat)
                .originLon(sLon)
                .destinationAddress(destAddress != null && !destAddress.isBlank() ? destAddress : "Địa chỉ giao hàng mặc định")
                .destinationLat(dLat)
                .destinationLon(dLon)
                .distanceKm(Math.round(distanceKm * 10.0) / 10.0)
                .activeBaristaQueueSize(queueSize)
                .prepMinutes(prepMins)
                .transitMinutes(transitMins)
                .totalEstimatedMinutes(totalMins)
                .estimatedArrivalFormatted(arrivalStr)
                .trafficCongestionFactor(Math.round(trafficFactor * 100.0) / 100.0)
                .trafficStatusLabel(trafficLabel)
                .deliveryTierBadge(tierBadge)
                .build();
    }

    @Override
    public DeliveryOptimizationDto calculateDeliveryEstimateForOrder(Long orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Đơn hàng không tồn tại: " + orderId));

        Long storeId = order.getStore() != null ? order.getStore().getId() : 1L;
        String address = order.getDeliveryAddress();
        return calculateDeliveryEstimate(storeId, null, null, address);
    }

    private double calculateHaversineDistance(double lat1, double lon1, double lat2, double lon2) {
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);

        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                        Math.sin(dLon / 2) * Math.sin(dLon / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return EARTH_RADIUS_KM * c;
    }

    private int calculateMmcQueueTime(int queueSize) {
        int c = CONCURRENT_BARISTAS;
        double mu = 1.0 / MEAN_SERVICE_TIME_MINS; // ~0.2857 orders/min

        // Arrival rate approximation based on queue size
        double lambda = Math.min(0.50, Math.max(0.05, queueSize / 12.0));
        double rho = lambda / (c * mu);
        if (rho >= 0.95) rho = 0.95;

        // Erlang-C delay formula P_0
        double sum = 1.0; // k=0 term
        double term = 1.0;
        for (int k = 1; k < c; k++) {
            term *= (c * rho) / k;
            sum += term;
        }
        term *= (c * rho) / c;
        double p0 = 1.0 / (sum + (term / (1.0 - rho)));

        // Erlang C probability of queuing P_Q
        double pQ = (term / (1.0 - rho)) * p0;

        // Waiting time in queue: W_q = P_Q / (c*mu - lambda)
        double wQueue = pQ / Math.max(0.02, (c * mu - lambda));

        // Total preparation time = Queue wait + Barista handcrafted brew time (3.5m)
        double totalPrep = wQueue + MEAN_SERVICE_TIME_MINS + (queueSize * 0.4);
        return (int) Math.max(4, Math.round(totalPrep));
    }

    private double calculateTrafficFactor(LocalDateTime time) {
        int hour = time.getHour();
        int min = time.getMinute();
        double timeDecimal = hour + (min / 60.0);

        // Morning Rush: 07:00 - 09:00 (Factor 1.45)
        if (timeDecimal >= 7.0 && timeDecimal <= 9.0) {
            return 1.45;
        }
        // Lunch Rush: 11:30 - 13:00 (Factor 1.25)
        if (timeDecimal >= 11.5 && timeDecimal <= 13.0) {
            return 1.25;
        }
        // Evening Rush: 17:00 - 19:30 (Factor 1.50)
        if (timeDecimal >= 17.0 && timeDecimal <= 19.5) {
            return 1.50;
        }
        // Off-peak daylight: 1.08
        if (timeDecimal >= 6.0 && timeDecimal <= 22.0) {
            return 1.08;
        }
        // Late night / early morning: 0.95
        return 0.95;
    }

    private String getTrafficStatusLabel(double factor) {
        if (factor >= 1.40) return "GIỜ CAO ĐIỂM (MẬT ĐỘ CAO)";
        if (factor >= 1.20) return "ĐÔNG ĐÚC VỪA PHẢI";
        return "GIAO THÔNG THÔNG THOÁNG";
    }
}
