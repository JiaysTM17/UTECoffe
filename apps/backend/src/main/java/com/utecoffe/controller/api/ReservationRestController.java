package com.utecoffe.controller.api;

import com.utecoffe.dto.request.ReservationRequest;
import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.entity.TableReservation;
import com.utecoffe.entity.User;
import com.utecoffe.service.AuthService;
import com.utecoffe.service.TableReservationService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/reservations")
public class ReservationRestController {

    @Autowired
    private TableReservationService reservationService;

    @Autowired
    private AuthService authService;

    @PostMapping
    public ResponseEntity<ApiResponse<TableReservation>> createReservation(
            @Valid @RequestBody ReservationRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        Long userId = null;
        if (userDetails != null) {
            User user = authService.getByEmail(userDetails.getUsername());
            if (user != null) userId = user.getId();
        }
        TableReservation res = reservationService.createReservation(request, userId);
        return ResponseEntity.ok(ApiResponse.success(res, "Dat ban thanh cong! Chung toi se lien he xac nhan som nhat"));
    }
}
