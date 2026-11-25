package com.utecoffe.controller.mvc;

import com.utecoffe.dto.request.ReservationRequest;
import com.utecoffe.entity.User;
import com.utecoffe.service.AuthService;
import com.utecoffe.service.StoreService;
import com.utecoffe.service.TableReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@Controller
public class StoreMvcController {

    @Autowired
    private StoreService storeService;

    @Autowired
    private TableReservationService reservationService;

    @Autowired
    private AuthService authService;

    @GetMapping("/stores")
    public String stores(Model model) {
        model.addAttribute("stores", storeService.getAllActiveStores());
        return "customer/stores";
    }

    @GetMapping("/reservation")
    public String reservation(Model model) {
        model.addAttribute("stores", storeService.getAllActiveStores());
        return "customer/reservation";
    }

    @PostMapping({"/reservation", "/reservation/book"})
    public String handleReservation(
            @RequestParam Long storeId,
            @RequestParam String reservationDate,
            @RequestParam String reservationTime,
            @RequestParam(required = false) Integer guestCount,
            @RequestParam(required = false) Integer numberOfGuests,
            @RequestParam(required = false) String note,
            @RequestParam(required = false) String specialRequest,
            @RequestParam(required = false) String customerName,
            @RequestParam(required = false) String phoneNumber,
            @RequestParam(required = false) String zonePreference,
            @AuthenticationPrincipal UserDetails userDetails) {

        Long userId = null;
        if (userDetails != null) {
            User user = authService.getByEmail(userDetails.getUsername());
            if (user != null) userId = user.getId();
        }

        LocalDateTime dateTime = LocalDateTime.parse(reservationDate + "T" + reservationTime + ":00");

        ReservationRequest req = new ReservationRequest();
        req.setStoreId(storeId);
        req.setReservationTime(dateTime);
        req.setGuestCount(guestCount != null ? guestCount : (numberOfGuests != null ? numberOfGuests : 2));

        StringBuilder noteBuilder = new StringBuilder();
        if (customerName != null && !customerName.isBlank()) {
            noteBuilder.append("Khách: ").append(customerName).append(" | SĐT: ").append(phoneNumber != null ? phoneNumber : "").append(" | ");
        }
        if (zonePreference != null && !zonePreference.isBlank()) {
            noteBuilder.append("Khu vực: ").append(zonePreference).append(" | ");
        }
        if (note != null && !note.isBlank()) {
            noteBuilder.append(note);
        } else if (specialRequest != null && !specialRequest.isBlank()) {
            noteBuilder.append(specialRequest);
        }
        req.setNote(noteBuilder.toString());

        reservationService.createReservation(req, userId);

        return "redirect:/reservation?success=true";
    }
}
