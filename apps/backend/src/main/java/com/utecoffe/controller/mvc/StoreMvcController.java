package com.utecoffe.controller.mvc;

import com.utecoffe.dto.request.ReservationRequest;
import com.utecoffe.entity.TableReservation;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes) {

        Long userId = null;
        if (userDetails != null) {
            User user = authService.getByEmail(userDetails.getUsername());
            if (user != null) userId = user.getId();
        }

        LocalDateTime dateTime;
        try {
            if (reservationDate != null && reservationTime != null) {
                String timeStr = reservationTime.trim();
                if (timeStr.length() == 5) timeStr += ":00";
                dateTime = LocalDateTime.parse(reservationDate.trim() + "T" + timeStr);
            } else {
                dateTime = LocalDateTime.now().plusHours(2);
            }
        } catch (Exception ex) {
            dateTime = LocalDateTime.now().plusHours(2);
        }
        if (dateTime.isBefore(LocalDateTime.now().minusMinutes(10))) {
            dateTime = LocalDateTime.now().plusHours(2);
        }

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

        TableReservation saved = reservationService.createReservationWithZone(req, userId, zonePreference);
        redirectAttributes.addFlashAttribute("confirmedReservation", saved);
        redirectAttributes.addFlashAttribute("customerName", customerName != null && !customerName.isBlank() ? customerName : "Quý Khách");
        redirectAttributes.addFlashAttribute("phoneNumber", phoneNumber != null ? phoneNumber : "");
        redirectAttributes.addFlashAttribute("reservationCode", saved.getReservationCode());
        redirectAttributes.addFlashAttribute("tableNumber", saved.getStoreTable() != null ? saved.getStoreTable().getTableNumber() : "VIP 02");
        redirectAttributes.addFlashAttribute("assignedZoneName", saved.getAssignedZoneName());
        redirectAttributes.addFlashAttribute("storeName", saved.getStore() != null ? saved.getStore().getName() : "UTECoffe Flagship");
        redirectAttributes.addFlashAttribute("formattedTime", saved.getFormattedReservationTime());

        return "redirect:/reservation?success=true";
    }
}
