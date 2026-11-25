package com.utecoffe.service;

import com.utecoffe.dto.request.LoginRequest;
import com.utecoffe.dto.request.RegisterRequest;
import com.utecoffe.dto.response.JwtAuthResponse;
import com.utecoffe.entity.User;

public interface AuthService {
    JwtAuthResponse authenticateApi(LoginRequest request);
    User register(RegisterRequest request);
    User getByEmail(String email);
}
