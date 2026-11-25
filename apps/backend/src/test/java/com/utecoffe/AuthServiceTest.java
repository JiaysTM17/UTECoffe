package com.utecoffe;

import com.utecoffe.dto.request.RegisterRequest;
import com.utecoffe.entity.Role;
import com.utecoffe.entity.User;
import com.utecoffe.enums.RoleName;
import com.utecoffe.repository.LoyaltyCardRepository;
import com.utecoffe.repository.RoleRepository;
import com.utecoffe.repository.UserRepository;
import com.utecoffe.service.impl.AuthServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private RoleRepository roleRepository;

    @Mock
    private LoyaltyCardRepository loyaltyCardRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private AuthServiceImpl authService;

    private RegisterRequest registerRequest;

    @BeforeEach
    void setUp() {
        registerRequest = new RegisterRequest();
        registerRequest.setFullName("Nguyen Van Test");
        registerRequest.setEmail("test@utecoffe.vn");
        registerRequest.setPhoneNumber("0987654321");
        registerRequest.setPassword("SecretPassword123");
    }

    @Test
    void testRegister_Success() {
        when(userRepository.existsByEmail("test@utecoffe.vn")).thenReturn(false);
        when(userRepository.existsByPhoneNumber("0987654321")).thenReturn(false);
        when(roleRepository.findByName(RoleName.ROLE_CUSTOMER)).thenReturn(Optional.of(Role.builder().name(RoleName.ROLE_CUSTOMER).build()));
        when(passwordEncoder.encode(anyString())).thenReturn("hashed_secret");

        User savedUser = User.builder()
                .id(1L)
                .fullName("Nguyen Van Test")
                .email("test@utecoffe.vn")
                .phoneNumber("0987654321")
                .passwordHash("hashed_secret")
                .build();

        when(userRepository.save(any(User.class))).thenReturn(savedUser);

        User result = authService.register(registerRequest);

        assertNotNull(result);
        assertEquals("test@utecoffe.vn", result.getEmail());
        verify(loyaltyCardRepository, times(1)).save(any());
    }

    @Test
    void testRegister_DuplicateEmail_ThrowsException() {
        when(userRepository.existsByEmail("test@utecoffe.vn")).thenReturn(true);

        assertThrows(IllegalArgumentException.class, () -> {
            authService.register(registerRequest);
        });

        verify(userRepository, never()).save(any(User.class));
    }
}
