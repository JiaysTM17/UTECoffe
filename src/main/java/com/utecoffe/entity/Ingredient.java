package com.utecoffe.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "ingredients")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ingredient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false, unique = true, length = 50)
    private String sku;

    @Column(nullable = false, length = 30)
    private String unit; // gram, ml, shot, piece

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal minThreshold;

    @Column(precision = 12, scale = 2)
    private BigDecimal currentCostPrice;
}
