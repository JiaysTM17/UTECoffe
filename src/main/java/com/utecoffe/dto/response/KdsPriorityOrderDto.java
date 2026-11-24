package com.utecoffe.dto.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.utecoffe.enums.OrderType;
import java.time.LocalDateTime;

@JsonIgnoreProperties(ignoreUnknown = true)
public class KdsPriorityOrderDto {
    private Long orderId;
    private String orderCode;
    private String customerName;
    private String customerPhone;
    private String customerTier;
    private OrderType orderType;
    private LocalDateTime createdAt;
    private long waitingMinutes;
    private int itemCount;

    private double priorityScore;
    private int estimatedPrepSeconds;
    private int estimatedWaitEtaMinutes;
    private String priorityLevel;
    private String priorityReason;
    private String recommendedStation;

    public KdsPriorityOrderDto() {}

    public static KdsPriorityOrderDtoBuilder builder() {
        return new KdsPriorityOrderDtoBuilder();
    }

    public static class KdsPriorityOrderDtoBuilder {
        private final KdsPriorityOrderDto dto = new KdsPriorityOrderDto();

        public KdsPriorityOrderDtoBuilder orderId(Long orderId) { dto.orderId = orderId; return this; }
        public KdsPriorityOrderDtoBuilder orderCode(String orderCode) { dto.orderCode = orderCode; return this; }
        public KdsPriorityOrderDtoBuilder customerName(String customerName) { dto.customerName = customerName; return this; }
        public KdsPriorityOrderDtoBuilder customerPhone(String customerPhone) { dto.customerPhone = customerPhone; return this; }
        public KdsPriorityOrderDtoBuilder customerTier(String customerTier) { dto.customerTier = customerTier; return this; }
        public KdsPriorityOrderDtoBuilder orderType(OrderType orderType) { dto.orderType = orderType; return this; }
        public KdsPriorityOrderDtoBuilder createdAt(LocalDateTime createdAt) { dto.createdAt = createdAt; return this; }
        public KdsPriorityOrderDtoBuilder waitingMinutes(long waitingMinutes) { dto.waitingMinutes = waitingMinutes; return this; }
        public KdsPriorityOrderDtoBuilder itemCount(int itemCount) { dto.itemCount = itemCount; return this; }
        public KdsPriorityOrderDtoBuilder priorityScore(double priorityScore) { dto.priorityScore = priorityScore; return this; }
        public KdsPriorityOrderDtoBuilder estimatedPrepSeconds(int estimatedPrepSeconds) { dto.estimatedPrepSeconds = estimatedPrepSeconds; return this; }
        public KdsPriorityOrderDtoBuilder estimatedWaitEtaMinutes(int estimatedWaitEtaMinutes) { dto.estimatedWaitEtaMinutes = estimatedWaitEtaMinutes; return this; }
        public KdsPriorityOrderDtoBuilder priorityLevel(String priorityLevel) { dto.priorityLevel = priorityLevel; return this; }
        public KdsPriorityOrderDtoBuilder priorityReason(String priorityReason) { dto.priorityReason = priorityReason; return this; }
        public KdsPriorityOrderDtoBuilder recommendedStation(String recommendedStation) { dto.recommendedStation = recommendedStation; return this; }

        public KdsPriorityOrderDto build() { return dto; }
    }

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
    public String getCustomerTier() { return customerTier; }
    public void setCustomerTier(String customerTier) { this.customerTier = customerTier; }
    public OrderType getOrderType() { return orderType; }
    public void setOrderType(OrderType orderType) { this.orderType = orderType; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public long getWaitingMinutes() { return waitingMinutes; }
    public void setWaitingMinutes(long waitingMinutes) { this.waitingMinutes = waitingMinutes; }
    public int getItemCount() { return itemCount; }
    public void setItemCount(int itemCount) { this.itemCount = itemCount; }
    public double getPriorityScore() { return priorityScore; }
    public void setPriorityScore(double priorityScore) { this.priorityScore = priorityScore; }
    public int getEstimatedPrepSeconds() { return estimatedPrepSeconds; }
    public void setEstimatedPrepSeconds(int estimatedPrepSeconds) { this.estimatedPrepSeconds = estimatedPrepSeconds; }
    public int getEstimatedWaitEtaMinutes() { return estimatedWaitEtaMinutes; }
    public void setEstimatedWaitEtaMinutes(int estimatedWaitEtaMinutes) { this.estimatedWaitEtaMinutes = estimatedWaitEtaMinutes; }
    public String getPriorityLevel() { return priorityLevel; }
    public void setPriorityLevel(String priorityLevel) { this.priorityLevel = priorityLevel; }
    public String getPriorityReason() { return priorityReason; }
    public void setPriorityReason(String priorityReason) { this.priorityReason = priorityReason; }
    public String getRecommendedStation() { return recommendedStation; }
    public void setRecommendedStation(String recommendedStation) { this.recommendedStation = recommendedStation; }
}
