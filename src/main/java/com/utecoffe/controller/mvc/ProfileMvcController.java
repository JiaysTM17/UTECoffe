package com.utecoffe.controller.mvc;

import com.utecoffe.entity.LoyaltyCard;
import com.utecoffe.entity.User;
import com.utecoffe.repository.LoyaltyCardRepository;
import com.utecoffe.repository.LoyaltyTransactionRepository;
import com.utecoffe.service.AuthService;
import com.utecoffe.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ProfileMvcController {

    @Autowired
    private AuthService authService;

    @Autowired
    private LoyaltyCardRepository loyaltyCardRepository;

    @Autowired
    private LoyaltyTransactionRepository loyaltyTransactionRepository;

    @Autowired
    private OrderService orderService;

    @GetMapping("/profile")
    public String profile(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        if (userDetails == null) {
            return "redirect:/auth/login";
        }
        User user = authService.getByEmail(userDetails.getUsername());
        LoyaltyCard card = loyaltyCardRepository.findByUserId(user.getId()).orElse(null);

        model.addAttribute("user", user);
        model.addAttribute("loyaltyCard", card);
        if (card != null) {
            model.addAttribute("pointsHistory", loyaltyTransactionRepository.findByLoyaltyCardIdOrderByCreatedAtDesc(card.getId()));
        }
        model.addAttribute("orders", orderService.getUserOrders(user.getId()));
        return "customer/profile";
    }
}
