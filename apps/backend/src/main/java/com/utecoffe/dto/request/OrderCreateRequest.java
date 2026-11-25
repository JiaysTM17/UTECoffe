package com.utecoffe.dto.request;

import com.utecoffe.enums.OrderType;
import com.utecoffe.enums.PaymentMethod;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OrderCreateRequest {
    @NotNull(message = "Vui long chon chi nhanh phuc vu")
    private Long storeId;

    @NotNull(message = "Vui long chon hinh thuc don hang")
    private OrderType orderType;

    @NotNull(message = "Vui long chon phuong thuc thanh toan")
    private PaymentMethod paymentMethod;

    private String deliveryAddress;
    private String recipientName;
    private String recipientPhone;
    private String couponCode;
    private String note;

    @NotEmpty(message = "Don hang phai co it nhat mot mon")
    private List<OrderItemRequest> items;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OrderItemRequest {
        private Long productId;
        private Long productSizeId;
        private Integer quantity;
        private List<Long> toppingIds;
        private String note;
    }
}
