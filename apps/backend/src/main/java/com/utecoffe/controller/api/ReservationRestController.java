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
        return ResponseEntity.ok(ApiResponse.success(res, "Đặt bàn thành công! UTECoffe hân hạnh được đón tiếp bạn thưởng thức không gian cà phê đặc sản."));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TableReservation>> getReservation(@PathVariable Long id) {
        TableReservation res = reservationService.getReservationById(id);
        return ResponseEntity.ok(ApiResponse.success(res, "Chi tiết thông tin đặt bàn"));
    }

    @PostMapping("/{id}/cancel")
    public ResponseEntity<ApiResponse<TableReservation>> cancelReservation(
            @PathVariable Long id,
            @RequestBody(required = false) java.util.Map<String, String> body,
            @AuthenticationPrincipal UserDetails userDetails) {
        Long userId = null;
        if (userDetails != null) {
            User user = authService.getByEmail(userDetails.getUsername());
            if (user != null) userId = user.getId();
        }
        String reason = (body != null) ? body.get("reason") : "Khách hàng yêu cầu hủy đặt bàn";
        TableReservation res = reservationService.cancelReservation(id, userId, reason);
        return ResponseEntity.ok(ApiResponse.success(res, "Hủy lịch đặt bàn thành công"));
    }

    @GetMapping("/store/{storeId}")
    public ResponseEntity<ApiResponse<java.util.List<TableReservation>>> getStoreReservations(@PathVariable Long storeId) {
        java.util.List<TableReservation> list = reservationService.getStoreReservations(storeId);
        return ResponseEntity.ok(ApiResponse.success(list, "Danh sách đặt bàn tại chi nhánh"));
    }
}
