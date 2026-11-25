package com.utecoffe.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LoginRequest {
    @NotBlank(message = "Email hoac so dien thoai khong duoc de trong")
    private String emailOrPhone;

    @NotBlank(message = "Mat khau khong duoc de trong")
    private String password;
}
