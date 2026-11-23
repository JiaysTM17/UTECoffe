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
}
