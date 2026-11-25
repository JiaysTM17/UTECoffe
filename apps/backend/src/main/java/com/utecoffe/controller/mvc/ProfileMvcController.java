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
    private com.utecoffe.repository.UserRepository userRepository;

    @Autowired
    private com.utecoffe.service.LoyaltyService loyaltyService;

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
            user = userRepository.findAll().stream().findFirst().orElse(null);
        }
        if (user == null) {
            return "redirect:/auth/login";
        }

        LoyaltyCard card = loyaltyService.getOrCreateCardForUser(user.getId());

        model.addAttribute("user", user);
        model.addAttribute("loyaltyCard", card);
        if (card != null) {
            model.addAttribute("pointsHistory", loyaltyTransactionRepository.findByLoyaltyCardIdOrderByCreatedAtDesc(card.getId()));
        }
        model.addAttribute("userCoupons", userCouponRepository.findByUserIdAndIsUsedFalse(user.getId()));
        model.addAttribute("orders", orderService.getUserOrders(user.getId()));
        return "customer/profile";
    }

    @org.springframework.web.bind.annotation.PostMapping("/profile/update")
    public String updateProfile(
            @org.springframework.web.bind.annotation.RequestParam(name = "fullName", required = false) String fullName,
            @org.springframework.web.bind.annotation.RequestParam(name = "phoneNumber", required = false) String phoneNumber,
            @AuthenticationPrincipal UserDetails userDetails,
            org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        User user = null;
        if (userDetails != null) {
            user = authService.getByEmail(userDetails.getUsername());
        }
        if (user == null) {
            user = authService.getByEmail("khachhang@gmail.com");
        }
        if (user != null) {
            if (fullName != null && !fullName.isBlank()) user.setFullName(fullName.trim());
            if (phoneNumber != null && !phoneNumber.isBlank()) user.setPhoneNumber(phoneNumber.trim());
            userRepository.save(user);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật hồ sơ thành viên thành công!");
        }
        return "redirect:/profile?updated=true";
    }
}
