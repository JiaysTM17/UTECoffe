package com.utecoffe.controller.mvc;

import com.utecoffe.entity.LoyaltyCard;
import com.utecoffe.entity.User;
import com.utecoffe.repository.LoyaltyCardRepository;
import com.utecoffe.repository.LoyaltyTransactionRepository;
import com.utecoffe.repository.UserCouponRepository;
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
    private UserCouponRepository userCouponRepository;

    @Autowired
    private OrderService orderService;

    @GetMapping("/profile")
    public String profile(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        User user = null;
        if (userDetails != null) {
            user = authService.getByEmail(userDetails.getUsername());
        }
        if (user == null) {
            user = authService.getByEmail("khachhang@gmail.com");
        }
        if (user == null) {
            return "redirect:/auth/login";
        }

        LoyaltyCard card = loyaltyCardRepository.findByUserId(user.getId()).orElse(null);
        if (card == null) {
            card = LoyaltyCard.builder()
                    .user(user)
                    .cardNumber("#UTE-2026-" + String.format("%04d", user.getId()))
                    .pointsBalance(120)
                    .lifetimePoints(120)
                    .tier(com.utecoffe.enums.LoyaltyTier.BRONZE)
                    .build();
            card = loyaltyCardRepository.save(card);
        }

        model.addAttribute("user", user);
        model.addAttribute("loyaltyCard", card);
        if (card != null) {
            model.addAttribute("pointsHistory", loyaltyTransactionRepository.findByLoyaltyCardIdOrderByCreatedAtDesc(card.getId()));
        }
        model.addAttribute("userCoupons", userCouponRepository.findByUserIdAndIsUsedFalse(user.getId()));
        model.addAttribute("orders", orderService.getUserOrders(user.getId()));
        return "customer/profile";
    }
}
