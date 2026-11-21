package com.utecoffe.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReviewRequest {
    @NotNull(message = "Vui long chon san pham can danh gia")
    private Long productId;

    private Long orderId;

    @NotNull(message = "Vui long chon so sao danh gia")
    @Min(value = 1, message = "So sao toi thieu la 1")
    @Max(value = 5, message = "So sao toi da la 5")
    private Integer rating;

    @NotBlank(message = "Vui long nhap cam nhan ve huong vi mon")
    private String comment;
}
