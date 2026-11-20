package com.utecoffe.service.impl;

import com.utecoffe.dto.request.LoginRequest;
import com.utecoffe.dto.request.RegisterRequest;
import com.utecoffe.dto.response.JwtAuthResponse;
import com.utecoffe.entity.LoyaltyCard;
import com.utecoffe.entity.Role;
import com.utecoffe.entity.User;
import com.utecoffe.enums.LoyaltyTier;
import com.utecoffe.enums.RoleName;
import com.utecoffe.repository.LoyaltyCardRepository;
import com.utecoffe.repository.RoleRepository;
import com.utecoffe.repository.UserRepository;
import com.utecoffe.security.JwtTokenProvider;
import com.utecoffe.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class AuthServiceImpl implements AuthService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private LoyaltyCardRepository loyaltyCardRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Override
    public JwtAuthResponse authenticateApi(LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmailOrPhone(), request.getPassword())
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = tokenProvider.generateToken(authentication);

        User user = userRepository.findByEmailOrPhoneNumber(request.getEmailOrPhone(), request.getEmailOrPhone())
                .orElseThrow(() -> new RuntimeException("User not found"));

        return JwtAuthResponse.builder()
                .accessToken(token)
                .tokenType("Bearer")
                .userId(user.getId())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .role(user.getRole().getName().name())
                .build();
    }

    @Override
    @Transactional
    public User register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email da ton tai trong he thong: " + request.getEmail());
        }
        if (userRepository.existsByPhoneNumber(request.getPhoneNumber())) {
            throw new IllegalArgumentException("So dien thoai da ton tai: " + request.getPhoneNumber());
        }

        Role customerRole = roleRepository.findByName(RoleName.ROLE_CUSTOMER)
                .orElseGet(() -> roleRepository.save(Role.builder()
                        .name(RoleName.ROLE_CUSTOMER)
                        .description("Khach hang tieu chuan")
                        .build()));

        User user = User.builder()
                .fullName(request.getFullName())
                .email(request.getEmail())
                .phoneNumber(request.getPhoneNumber())
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .role(customerRole)
                .status(true)
                .build();

        User savedUser = userRepository.save(user);

        // Auto-create UTEClub Loyalty Card
        LoyaltyCard loyaltyCard = LoyaltyCard.builder()
                .user(savedUser)
                .cardNumber("UTE-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase())
                .pointsBalance(0)
                .lifetimePoints(0)
                .tier(LoyaltyTier.BRONZE)
                .build();
        loyaltyCardRepository.save(loyaltyCard);

        return savedUser;
    }

    @Override
    public User getByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }
}
