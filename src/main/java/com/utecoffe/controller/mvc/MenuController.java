package com.utecoffe.controller.mvc;

import com.utecoffe.entity.Product;
import com.utecoffe.service.ProductService;
import com.utecoffe.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/menu")
public class MenuController {

    @Autowired
    private ProductService productService;

    @Autowired
    private ReviewService reviewService;

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
        try {
            Product product = productService.getProductBySlug(slug);
            if (product == null) {
                return "redirect:/menu";
            }
            model.addAttribute("product", product);
            model.addAttribute("reviews", reviewService.getApprovedReviewsByProduct(product.getId()));
            model.addAttribute("avgRating", reviewService.getProductAverageRating(product.getId()));
            return "customer/product-detail";
        } catch (Exception e) {
            return "redirect:/menu";
        }
    }

    @GetMapping("/detail/{id}")
    public String productDetailById(@PathVariable Long id) {
        try {
            Product product = productService.getProductById(id);
            if (product == null) {
                return "redirect:/menu";
            }
            return "redirect:/menu/" + product.getSlug();
        } catch (Exception e) {
            return "redirect:/menu";
        }
    }
}
