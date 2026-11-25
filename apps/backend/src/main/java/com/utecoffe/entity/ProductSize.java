package com.utecoffe.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "product_sizes")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductSize {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(nullable = false, length = 20)
    private String sizeName; // S, M, L

    @Builder.Default
    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal extraPrice = BigDecimal.ZERO;

    public String getName() {
        return sizeName != null ? sizeName : "Standard";
    }
}
