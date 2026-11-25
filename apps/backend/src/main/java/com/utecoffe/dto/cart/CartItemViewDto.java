package com.utecoffe.dto.cart;

import com.utecoffe.entity.Product;
import com.utecoffe.entity.ProductSize;
import lombok.*;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CartItemViewDto {
    private Long id;
    private Product product;
    private ProductSize productSize;
    private Integer quantity;
    private Integer sugarLevel;
    private Integer iceLevel;
    private List<Long> toppingIds;
    private List<String> toppingNames;
    private BigDecimal unitPrice;
    private BigDecimal subtotal;
    private String note;
}
