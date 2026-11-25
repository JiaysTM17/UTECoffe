package com.utecoffe.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RegisterRequest {
    @NotBlank(message = "Ho va ten khong duoc de trong")
    private String fullName;

    @NotBlank(message = "Email khong duoc de trong")
    @Email(message = "Email khong dung dinh dang")
    private String email;

    @NotBlank(message = "So dien thoai khong duoc de trong")
    @Pattern(regexp = "^(0[3|5|7|8|9])+([0-9]{8})$", message = "So dien thoai khong hop le")
    private String phoneNumber;

    @NotBlank(message = "Mat khau khong duoc de trong")
    @Size(min = 6, message = "Mat khau phai co toi thieu 6 ky tu")
    private String password;
}
