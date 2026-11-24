package com.utecoffe.dto.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.utecoffe.entity.Product;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class FlavorPairingDto {
    private Long targetProductId;
    private String targetProductName;
    private Long recommendedProductId;
    private String recommendedProductName;
    private String recommendedProductSlug;
    private String recommendedProductImage;
    private BigDecimal recommendedProductPrice;
    private String recommendedCategoryName;
    private double pairingScore;
    private String harmonyReason;
    private String pairingTag;

    // For JSP JSTL binding: pair.recommendedProduct.name, etc.
    private Product recommendedProduct;
}
