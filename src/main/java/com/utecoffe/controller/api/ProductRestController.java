package com.utecoffe.controller.api;

import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.dto.response.FlavorPairingDto;
import com.utecoffe.dto.response.FuzzySearchResultDto;
import com.utecoffe.dto.response.TasteMatchResultDto;
import com.utecoffe.entity.Category;
import com.utecoffe.entity.Product;
import com.utecoffe.service.FuzzySearchService;
import com.utecoffe.service.ProductService;
import com.utecoffe.service.RecommendationService;
import com.utecoffe.service.TasteProfileService;
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

    @Autowired
    private TasteProfileService tasteProfileService;

    @Autowired
    private FuzzySearchService fuzzySearchService;

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
    public ResponseEntity<ApiResponse<Product>> getBySlug(@PathVariable("slug") String slug) {
        return ResponseEntity.ok(ApiResponse.success(productService.getProductBySlug(slug), "Chi tiet mon"));
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<Product>>> search(@RequestParam("q") String q) {
        return ResponseEntity.ok(ApiResponse.success(productService.search(q), "Ket qua tim kiem"));
    }

    @GetMapping("/fuzzy-search")
    public ResponseEntity<ApiResponse<List<FuzzySearchResultDto>>> fuzzySearch(
            @RequestParam("q") String q,
            @RequestParam(value = "threshold", defaultValue = "0.35") double threshold,
            @RequestParam(value = "limit", defaultValue = "8") int limit) {
        return ResponseEntity.ok(ApiResponse.success(
                fuzzySearchService.fuzzySearch(q, threshold, limit),
                "Ket qua tim kiem thong minh Damerau-Levenshtein"));
    }

    @GetMapping("/taste-match")
    public ResponseEntity<ApiResponse<List<TasteMatchResultDto>>> matchTaste(
            @RequestParam(value = "acidity", defaultValue = "3.5") double acidity,
            @RequestParam(value = "body", defaultValue = "3.5") double body,
            @RequestParam(value = "sweetness", defaultValue = "3.5") double sweetness,
            @RequestParam(value = "bitterness", defaultValue = "3.5") double bitterness,
            @RequestParam(value = "aroma", defaultValue = "3.5") double aroma,
            @RequestParam(value = "limit", defaultValue = "4") int limit) {
        return ResponseEntity.ok(ApiResponse.success(
                tasteProfileService.matchPalate(acidity, body, sweetness, bitterness, aroma, limit),
                "Ket qua goi y ca phe theo do tuong dong Cosine"));
    }

    @GetMapping("/{id}/pairings")
    public ResponseEntity<ApiResponse<List<FlavorPairingDto>>> getPairings(@PathVariable("id") Long id) {
        return ResponseEntity.ok(ApiResponse.success(recommendationService.getPairingsForProduct(id), "Goi y ghep vi thuong hang"));
    }

    @GetMapping("/trending")
    public ResponseEntity<ApiResponse<List<Product>>> getTrending(@RequestParam(value = "limit", defaultValue = "4") int limit) {
        return ResponseEntity.ok(ApiResponse.success(recommendationService.getTrendingOrPersonalized(null, limit), "Thuc don thinh hanh"));
    }
}
