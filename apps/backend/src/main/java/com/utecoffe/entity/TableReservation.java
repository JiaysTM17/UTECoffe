package com.utecoffe.entity;

import com.utecoffe.enums.ReservationStatus;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "table_reservations")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TableReservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id", nullable = false)
    private Store store;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "table_id")
    private StoreTable storeTable;

    @Column(nullable = false)
    private LocalDateTime reservationTime;

    @Column(nullable = false)
    private Integer guestCount;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private ReservationStatus status;

    @Column(length = 500)
    private String note;

    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    public String getReservationCode() {
        if (this.id != null) {
            String datePart = (this.createdAt != null) 
                    ? String.format("%ty%tm%td", this.createdAt, this.createdAt, this.createdAt) 
                    : "261125";
            return "UTE-RES-" + datePart + "-" + String.format("%04d", this.id);
        }
        return "UTE-RES-261125-9999";
    }

    public String getFormattedReservationTime() {
        if (this.reservationTime != null) {
            return this.reservationTime.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm - dd/MM/yyyy"));
        }
        return "";
    }

    public String getAssignedZoneName() {
        if (this.storeTable != null) {
            String num = this.storeTable.getTableNumber().toUpperCase();
            if (num.contains("BAR") || num.startsWith("B") || num.equals("T-01") || num.equals("Q1-01") || num.equals("BT-01")) return "Quầy Barista Nghệ Nhân";
            if (num.contains("VIP") || num.contains("LOUNGE") || num.startsWith("L")) return "Sofa VIP Lounge Sang Trọng";
            if (num.contains("GARDEN") || num.startsWith("G") || num.startsWith("V")) return "Sân Vườn Xanh Thoáng Mát";
            if (num.contains("WORK") || num.startsWith("W") || num.startsWith("CW")) return "Bàn Co-Working Hiện Đại";
        }
        return "Không Gian Tiêu Chuẩn";
    }
}
