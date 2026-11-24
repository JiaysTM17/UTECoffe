package com.utecoffe.controller.mvc;

import com.utecoffe.service.ProductService;
import com.utecoffe.service.StoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @Autowired
    private ProductService productService;

    @Autowired
    private StoreService storeService;

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("featuredProducts", productService.getFeaturedProducts());
        model.addAttribute("categories", productService.getAllCategories());
        model.addAttribute("stores", storeService.getAllActiveStores());
        return "customer/index";
    }

    @GetMapping("/story")
    public String story() {
        return "customer/story";
    }

    @GetMapping("/uteclub")
    public String uteclub() {
        return "customer/uteclub";
    }

    @GetMapping("/coming-soon")
    public String comingSoon(Model model) {
        model.addAttribute("title", "Tính Năng Đang Hoàn Thiện");
        model.addAttribute("message", "Kênh truyền thông & tính năng này của UTECoffe Artisanal Roasters đang trong quá trình hoàn thiện nội dung và chuẩn bị ra mắt độc quyền. Xin chân thành cảm ơn sự đồng hành của quý khách!");
        return "customer/coming-soon";
    }

    @GetMapping("/policy/refund")
    public String policyRefund(Model model) {
        model.addAttribute("title", "Chính Sách Đổi Trả & Bồi Hoàn Điểm Thưởng");
        return "customer/policy-refund";
    }

    @GetMapping("/policy/terms")
    public String policyTerms(Model model) {
        model.addAttribute("title", "Điều Khoản Dịch Vụ & Bảo Mật Khách Hàng");
        return "customer/policy-terms";
    }
}
