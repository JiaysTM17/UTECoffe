package com.utecoffe.service.impl;

import com.utecoffe.dto.response.ExecutiveAnalyticsDto;
import com.utecoffe.entity.Order;
import com.utecoffe.entity.Store;
import com.utecoffe.enums.OrderStatus;
import com.utecoffe.enums.OrderType;
import com.utecoffe.repository.OrderRepository;
import com.utecoffe.repository.StoreRepository;
import com.utecoffe.service.AnalyticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class AnalyticsServiceImpl implements AnalyticsService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private StoreRepository storeRepository;

    @Autowired(required = false)
    private com.utecoffe.repository.OrderItemRepository orderItemRepository;

    @Autowired(required = false)
    private com.utecoffe.repository.PaymentRepository paymentRepository;

    @Override
    public ExecutiveAnalyticsDto getExecutiveAnalytics() {
        List<Order> allOrders = orderRepository.findAll();
        List<Store> allStores = storeRepository.findAll();

        long totalOrders = allOrders.size();
        long completedOrders = 0;
        long pendingOrders = 0;
        long cancelledOrders = 0;
        long dineInCount = 0;
        long takeAwayCount = 0;
        long deliveryCount = 0;

        BigDecimal totalRevenue = BigDecimal.ZERO;
        BigDecimal todayRevenue = BigDecimal.ZERO;
        BigDecimal yesterdayRevenue = BigDecimal.ZERO;
        BigDecimal thisWeekRevenue = BigDecimal.ZERO;
        BigDecimal lastWeekRevenue = BigDecimal.ZERO;

        LocalDate today = LocalDate.now();
        LocalDate yesterday = today.minusDays(1);
        LocalDateTime sevenDaysAgo = LocalDateTime.now().minusDays(7);
        LocalDateTime fourteenDaysAgo = LocalDateTime.now().minusDays(14);

        Map<Integer, Long> hourlyDist = new TreeMap<>();
        for (int i = 0; i < 24; i++) {
            hourlyDist.put(i, 0L);
        }

        for (Order o : allOrders) {
            OrderStatus status = o.getStatus();
            if (status == OrderStatus.COMPLETED) {
                completedOrders++;
                BigDecimal amount = o.getFinalAmount() != null ? o.getFinalAmount() : BigDecimal.ZERO;
                totalRevenue = totalRevenue.add(amount);

                if (o.getCreatedAt() != null) {
                    LocalDate orderDate = o.getCreatedAt().toLocalDate();
                    if (orderDate.equals(today)) {
                        todayRevenue = todayRevenue.add(amount);
                    } else if (orderDate.equals(yesterday)) {
                        yesterdayRevenue = yesterdayRevenue.add(amount);
                    }

                    if (o.getCreatedAt().isAfter(sevenDaysAgo)) {
                        thisWeekRevenue = thisWeekRevenue.add(amount);
                    } else if (o.getCreatedAt().isAfter(fourteenDaysAgo)) {
                        lastWeekRevenue = lastWeekRevenue.add(amount);
                    }
                }
            } else if (status == OrderStatus.PENDING || status == OrderStatus.CONFIRMED || status == OrderStatus.PREPARING) {
                pendingOrders++;
            } else if (status == OrderStatus.CANCELLED) {
                cancelledOrders++;
            }

            if (o.getOrderType() == OrderType.DINE_IN) dineInCount++;
            else if (o.getOrderType() == OrderType.TAKE_AWAY) takeAwayCount++;
            else if (o.getOrderType() == OrderType.DELIVERY) deliveryCount++;

            if (o.getCreatedAt() != null) {
                int hour = o.getCreatedAt().getHour();
                hourlyDist.put(hour, hourlyDist.getOrDefault(hour, 0L) + 1);
            }
        }

        BigDecimal aov = (completedOrders > 0)
                ? totalRevenue.divide(BigDecimal.valueOf(completedOrders), 0, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        double cancelRate = (totalOrders > 0)
                ? Math.round((cancelledOrders * 1000.0 / totalOrders)) / 10.0
                : 0.0;

        double dodGrowth = (yesterdayRevenue.compareTo(BigDecimal.ZERO) > 0)
                ? Math.round((todayRevenue.subtract(yesterdayRevenue).doubleValue() * 1000.0 / yesterdayRevenue.doubleValue())) / 10.0
                : 0.0;

        double wowGrowth = (lastWeekRevenue.compareTo(BigDecimal.ZERO) > 0)
                ? Math.round((thisWeekRevenue.subtract(lastWeekRevenue).doubleValue() * 1000.0 / lastWeekRevenue.doubleValue())) / 10.0
                : 0.0;

        int peakHour = hourlyDist.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse(9);

        // Branch breakdown
        List<ExecutiveAnalyticsDto.StorePerformanceDto> storePerformances = new ArrayList<>();
        for (Store store : allStores) {
            long storeOrders = 0;
            BigDecimal storeRev = BigDecimal.ZERO;

            for (Order o : allOrders) {
                if (o.getStore() != null && o.getStore().getId().equals(store.getId())) {
                    storeOrders++;
                    if (o.getStatus() == OrderStatus.COMPLETED && o.getFinalAmount() != null) {
                        storeRev = storeRev.add(o.getFinalAmount());
                    }
                }
            }

            BigDecimal storeAov = (storeOrders > 0 && storeRev.compareTo(BigDecimal.ZERO) > 0)
                    ? storeRev.divide(BigDecimal.valueOf(storeOrders), 0, RoundingMode.HALF_UP)
                    : BigDecimal.ZERO;

            double revShare = (totalRevenue.compareTo(BigDecimal.ZERO) > 0)
                    ? Math.round((storeRev.doubleValue() * 1000.0 / totalRevenue.doubleValue())) / 10.0
                    : 0.0;

            storePerformances.add(ExecutiveAnalyticsDto.StorePerformanceDto.builder()
                    .storeId(store.getId())
                    .storeName(store.getName())
                    .address(store.getAddress())
                    .orderCount(storeOrders)
                    .revenue(storeRev)
                    .averageTicketSize(storeAov)
                    .revenueSharePercentage(revShare)
                    .build());
        }

        return ExecutiveAnalyticsDto.builder()
                .totalRevenue(totalRevenue)
                .totalOrders(totalOrders)
                .completedOrders(completedOrders)
                .pendingOrders(pendingOrders)
                .cancelledOrders(cancelledOrders)
                .averageOrderValue(aov)
                .cancellationRate(cancelRate)
                .todayRevenue(todayRevenue)
                .yesterdayRevenue(yesterdayRevenue)
                .dayOverDayGrowth(dodGrowth)
                .thisWeekRevenue(thisWeekRevenue)
                .lastWeekRevenue(lastWeekRevenue)
                .weekOverWeekGrowth(wowGrowth)
                .hourlyOrderDistribution(hourlyDist)
                .peakHour(peakHour)
                .dineInCount(dineInCount)
                .takeAwayCount(takeAwayCount)
                .deliveryCount(deliveryCount)
                .storePerformances(storePerformances)
                .build();
    }

    @Override
    public com.utecoffe.dto.response.StoreSalesPerformanceDto getStoreProductSalesAnalytics(Long storeId) {
        Store store = (storeRepository != null) ? storeRepository.findById(storeId).orElse(null) : null;
        String storeName = (store != null) ? store.getName() : "Chi nhánh #" + storeId;
        String address = (store != null) ? store.getAddress() : "TP. Hồ Chí Minh";

        List<Order> allOrders = orderRepository.findAll();
        List<Order> storeOrders = allOrders.stream()
                .filter(o -> o.getStore() != null && o.getStore().getId().equals(storeId))
                .toList();

        long totalOrders = storeOrders.size();
        long completed = 0;
        long cancelled = 0;
        BigDecimal revenue = BigDecimal.ZERO;

        Map<String, Long> paymentMap = new LinkedHashMap<>();
        paymentMap.put("VIETQR", 0L);
        paymentMap.put("VNPAY", 0L);
        paymentMap.put("MOMO", 0L);
        paymentMap.put("TIỀN MẶT", 0L);

        Map<Long, com.utecoffe.dto.response.StoreSalesPerformanceDto.ProductSalesMetricDto> productMetrics = new HashMap<>();

        for (Order o : storeOrders) {
            if (o.getStatus() == OrderStatus.COMPLETED) {
                completed++;
                BigDecimal amt = o.getFinalAmount() != null ? o.getFinalAmount() : BigDecimal.ZERO;
                revenue = revenue.add(amt);

                // Payment method detection
                String method = "VIETQR";
                if (paymentRepository != null) {
                    var payOpt = paymentRepository.findByOrderId(o.getId());
                    if (payOpt.isPresent() && payOpt.get().getPaymentMethod() != null) {
                        method = payOpt.get().getPaymentMethod().name();
                    }
                }
                paymentMap.put(method, paymentMap.getOrDefault(method, 0L) + 1);

                // Aggregate item sales
                if (orderItemRepository != null) {
                    var items = orderItemRepository.findByOrderId(o.getId());
                    for (var item : items) {
                        if (item.getProduct() != null) {
                            Long pId = item.getProduct().getId();
                            String pName = item.getProduct().getName();
                            int qty = item.getQuantity() != null ? item.getQuantity() : 1;
                            BigDecimal lineSubtotal = item.getSubtotal() != null ? item.getSubtotal() : BigDecimal.ZERO;

                            productMetrics.compute(pId, (k, v) -> {
                                if (v == null) {
                                    return com.utecoffe.dto.response.StoreSalesPerformanceDto.ProductSalesMetricDto.builder()
                                            .productId(pId)
                                            .productName(pName)
                                            .quantitySold(qty)
                                            .totalRevenue(lineSubtotal)
                                            .build();
                                } else {
                                    v.setQuantitySold(v.getQuantitySold() + qty);
                                    v.setTotalRevenue(v.getTotalRevenue().add(lineSubtotal));
                                    return v;
                                }
                            });
                        }
                    }
                }
            } else if (o.getStatus() == OrderStatus.CANCELLED) {
                cancelled++;
            }
        }

        BigDecimal aov = (completed > 0)
                ? revenue.divide(BigDecimal.valueOf(completed), 2, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        List<com.utecoffe.dto.response.StoreSalesPerformanceDto.ProductSalesMetricDto> topProducts = productMetrics.values().stream()
                .sorted(Comparator.comparingLong(com.utecoffe.dto.response.StoreSalesPerformanceDto.ProductSalesMetricDto::getQuantitySold).reversed())
                .limit(5)
                .toList();

        return com.utecoffe.dto.response.StoreSalesPerformanceDto.builder()
                .storeId(storeId)
                .storeName(storeName)
                .address(address)
                .totalRevenue(revenue)
                .totalOrders(totalOrders)
                .completedOrders(completed)
                .cancelledOrders(cancelled)
                .averageOrderValue(aov)
                .paymentMethodBreakdown(paymentMap)
                .topSellingProducts(topProducts)
                .build();
    }
}
