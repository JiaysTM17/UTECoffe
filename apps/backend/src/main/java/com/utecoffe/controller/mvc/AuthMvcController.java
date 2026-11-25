package com.utecoffe.controller.mvc;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/auth")
public class AuthMvcController {

    @GetMapping("/login")
    public String login() {
        return "customer/login";
    }

    @GetMapping("/register")
    public String register() {
        return "customer/register";
    }
}
