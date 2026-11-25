package com.utecoffe.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "store_tables")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StoreTable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id", nullable = false)
    private Store store;

    @Column(nullable = false, length = 50)
    private String tableNumber;

    @Column(nullable = false)
    private Integer capacity;

    @Column(length = 500)
    private String qrCodeUrl;

    @Builder.Default
    @Column(nullable = false)
    private Boolean isOccupied = false;

    @Builder.Default
    @Column(nullable = false)
    private Boolean isActive = true;
}
