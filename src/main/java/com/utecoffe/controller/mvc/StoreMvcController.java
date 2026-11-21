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

    @PostMapping("/reservation")
    public String handleReservation(
            @RequestParam Long storeId,
            @RequestParam String reservationDate,
            @RequestParam String reservationTime,
            @RequestParam Integer guestCount,
            @RequestParam(required = false) String note,
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
        req.setGuestCount(guestCount);
        req.setNote(note);

        reservationService.createReservation(req, userId);

        return "redirect:/reservation?success=true";
    }
}
