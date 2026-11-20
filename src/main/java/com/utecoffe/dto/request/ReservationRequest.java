package com.utecoffe.dto.request;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReservationRequest {
    @NotNull(message = "Vui long chon chi nhanh dat ban")
    private Long storeId;

    private Long tableId;

    @NotNull(message = "Vui long chon thoi gian dat ban")
    @Future(message = "Thoi gian dat ban phai o tuong lai")
    private LocalDateTime reservationTime;

    @NotNull(message = "Vui long nhap so luong khach")
    @Min(value = 1, message = "So luong khach toi thieu la 1 nguoi")
    private Integer guestCount;

    private String note;
}
