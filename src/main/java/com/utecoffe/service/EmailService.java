package com.utecoffe.service;

import com.utecoffe.entity.Order;
import com.utecoffe.entity.TableReservation;

public interface EmailService {
    void sendOrderReceipt(Order order);
    void sendReservationConfirmation(TableReservation reservation);
}
