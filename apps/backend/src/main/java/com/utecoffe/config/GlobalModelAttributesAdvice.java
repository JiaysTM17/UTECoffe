package com.utecoffe.config;

import com.utecoffe.entity.LoyaltyCard;
import com.utecoffe.entity.User;
import com.utecoffe.repository.LoyaltyCardRepository;
import com.utecoffe.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice(basePackages = "com.utecoffe.controller.mvc")
public class GlobalModelAttributesAdvice {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private LoyaltyCardRepository loyaltyCardRepository;

    @ModelAttribute("currentUser")
    public User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            return userRepository.findByEmail(auth.getName()).orElse(null);
        }
        return null;
    }

    @ModelAttribute("currentLoyaltyCard")
    public LoyaltyCard getCurrentLoyaltyCard() {
        User user = getCurrentUser();
        if (user != null) {
            return loyaltyCardRepository.findByUserId(user.getId()).orElse(null);
        }
        return null;
    }
}
