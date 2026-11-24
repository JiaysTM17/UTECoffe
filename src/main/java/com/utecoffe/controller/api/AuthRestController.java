package com.utecoffe.controller.api;

import com.utecoffe.aspect.RateLimited;
import com.utecoffe.dto.request.LoginRequest;
import com.utecoffe.dto.request.RegisterRequest;
import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.dto.response.JwtAuthResponse;
import com.utecoffe.entity.User;
import com.utecoffe.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthRestController {

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    @RateLimited(keyPrefix = "rl_login", capacity = 10.0, refillTokensPerSecond = 0.5, message = "Bạn đã thử đăng nhập quá nhiều lần. Vui lòng thử lại sau 1 phút.")
    public ResponseEntity<ApiResponse<JwtAuthResponse>> login(@Valid @RequestBody LoginRequest request) {
        JwtAuthResponse response = authService.authenticateApi(request);
        return ResponseEntity.ok(ApiResponse.success(response, "Dang nhap thanh cong"));
    }

    @PostMapping("/register")
    @RateLimited(keyPrefix = "rl_reg", capacity = 5.0, refillTokensPerSecond = 0.2, message = "Bạn đã đăng ký quá nhanh. Vui lòng chờ giây lát.")
    public ResponseEntity<ApiResponse<User>> register(@Valid @RequestBody RegisterRequest request) {
        User user = authService.register(request);
        return ResponseEntity.ok(ApiResponse.success(user, "Dang ky tai khoan thanh cong"));
    }

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<User>> getCurrentUser(@AuthenticationPrincipal UserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chua dang nhap"));
        }
        User user = authService.getByEmail(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.success(user, "Thong tin tai khoan"));
    }
}
