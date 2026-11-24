package com.utecoffe.controller.api;

import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.dto.response.FlavorPairingDto;
import com.utecoffe.entity.Category;
import com.utecoffe.entity.Product;
import com.utecoffe.service.ProductService;
import com.utecoffe.service.RecommendationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductRestController {

    @Autowired
    private ProductService productService;

    @Autowired
    private RecommendationService recommendationService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Product>>> getAll() {
        return ResponseEntity.ok(ApiResponse.success(productService.getAllAvailable(), "Danh sach thuc don"));
    }

    @GetMapping("/featured")
    public ResponseEntity<ApiResponse<List<Product>>> getFeatured() {
        return ResponseEntity.ok(ApiResponse.success(productService.getFeaturedProducts(), "San pham dac sac"));
    }

    @GetMapping("/categories")
    public ResponseEntity<ApiResponse<List<Category>>> getCategories() {
        return ResponseEntity.ok(ApiResponse.success(productService.getAllCategories(), "Danh muc mon"));
    }

    @GetMapping("/{slug}")
    public ResponseEntity<ApiResponse<Product>> getBySlug(@PathVariable String slug) {
        return ResponseEntity.ok(ApiResponse.success(productService.getProductBySlug(slug), "Chi tiet mon"));
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<Product>>> search(@RequestParam String q) {
        return ResponseEntity.ok(ApiResponse.success(productService.search(q), "Ket qua tim kiem"));
    }

    @GetMapping("/{id}/pairings")
    public ResponseEntity<ApiResponse<List<FlavorPairingDto>>> getPairings(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(recommendationService.getPairingsForProduct(id), "Gợi ý ghép vị thượng hạng"));
    }

    @GetMapping("/trending")
    public ResponseEntity<ApiResponse<List<Product>>> getTrending(@RequestParam(defaultValue = "4") int limit) {
        return ResponseEntity.ok(ApiResponse.success(recommendationService.getTrendingOrPersonalized(null, limit), "Thực đơn thịnh hành"));
    }
}
