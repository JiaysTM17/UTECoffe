package com.utecoffe.controller.mvc;

import com.utecoffe.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/menu")
public class MenuController {

    @Autowired
    private ProductService productService;

    @GetMapping
    public String menu(@RequestParam(required = false) Long categoryId, Model model) {
        model.addAttribute("categories", productService.getAllCategories());
        if (categoryId != null) {
            model.addAttribute("products", productService.getProductsByCategory(categoryId));
            model.addAttribute("selectedCategoryId", categoryId);
        } else {
            model.addAttribute("products", productService.getAllAvailable());
        }
        return "customer/menu";
    }

    @GetMapping("/{slug}")
    public String productDetail(@PathVariable String slug, Model model) {
        model.addAttribute("product", productService.getProductBySlug(slug));
        return "customer/product-detail";
    }
}
