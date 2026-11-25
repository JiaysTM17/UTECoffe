package com.utecoffe.service.impl;

import com.utecoffe.entity.Category;
import com.utecoffe.entity.Product;
import com.utecoffe.repository.CategoryRepository;
import com.utecoffe.repository.ProductRepository;
import com.utecoffe.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.Normalizer;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Override
    public List<Product> getAllAvailable() {
        return productRepository.findByIsAvailableTrue();
    }

    @Override
    public List<Product> getFeaturedProducts() {
        return productRepository.findByIsFeaturedTrueAndIsAvailableTrue();
    }

    @Override
    public List<Product> getProductsByCategory(Long categoryId) {
        return productRepository.findByCategoryIdAndIsAvailableTrue(categoryId);
    }

    @Override
    public Product getProductBySlug(String slug) {
        return productRepository.findBySlug(slug)
                .orElseThrow(() -> new RuntimeException("San pham khong ton tai: " + slug));
    }

    @Override
    public Product getProductById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("San pham khong ton tai voi id: " + id));
    }

    @Override
    public List<Category> getAllCategories() {
        return categoryRepository.findByIsActiveTrueOrderByDisplayOrderAsc();
    }

    /**
     * Advanced Multi-Tier Search:
     * 1. Exact SQL Substring Search (ProductRepository.searchProducts).
     * 2. Levenshtein Distance & Token Fuzzy Matching across title, description & normalized unaccented text.
     * 3. Sort by computed relevance / similarity score.
     */
    @Override
    public List<Product> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllAvailable();
        }

        String query = keyword.trim().toLowerCase();
        String queryUnaccented = removeAccents(query);

        // 1. Initial SQL Search
        List<Product> exactMatches = productRepository.searchProducts(query);
        Set<Long> seenIds = exactMatches.stream().map(Product::getId).collect(Collectors.toSet());

        // 2. Levenshtein Fuzzy Search across all available products
        List<Product> allProducts = getAllAvailable();
        List<ScoredProduct> scored = new ArrayList<>();

        for (Product p : allProducts) {
            if (seenIds.contains(p.getId())) {
                scored.add(new ScoredProduct(p, 1.0)); // Perfect match
                continue;
            }

            String name = p.getName() != null ? p.getName().toLowerCase() : "";
            String nameUnaccented = removeAccents(name);

            double maxScore = 0.0;

            // Direct similarity
            double simExact = computeSimilarity(query, name);
            double simUnacc = computeSimilarity(queryUnaccented, nameUnaccented);
            maxScore = Math.max(maxScore, Math.max(simExact, simUnacc));

            // Word token similarity
            String[] tokens = nameUnaccented.split("\\s+");
            for (String token : tokens) {
                double tokenSim = computeSimilarity(queryUnaccented, token);
                if (tokenSim > maxScore) maxScore = tokenSim;
            }

            // Substring check in unaccented text
            if (nameUnaccented.contains(queryUnaccented)) {
                maxScore = Math.max(maxScore, 0.85);
            }

            if (maxScore >= 0.45) {
                scored.add(new ScoredProduct(p, maxScore));
            }
        }

        // 3. Sort by score descending
        scored.sort((a, b) -> Double.compare(b.score, a.score));

        return scored.stream().map(sp -> sp.product).collect(Collectors.toList());
    }

    private static class ScoredProduct {
        final Product product;
        final double score;
        ScoredProduct(Product product, double score) {
            this.product = product;
            this.score = score;
        }
    }

    public static double computeSimilarity(String s1, String s2) {
        if (s1.equalsIgnoreCase(s2)) return 1.0;
        int maxLen = Math.max(s1.length(), s2.length());
        if (maxLen == 0) return 1.0;
        int dist = levenshteinDistance(s1, s2);
        return 1.0 - ((double) dist / maxLen);
    }

    public static int levenshteinDistance(String a, String b) {
        int[] costs = new int[b.length() + 1];
        for (int j = 0; j < costs.length; j++) costs[j] = j;
        for (int i = 1; i <= a.length(); i++) {
            costs[0] = i;
            int nw = i - 1;
            for (int j = 1; j <= b.length(); j++) {
                int cj = Math.min(1 + Math.min(costs[j], costs[j - 1]),
                        a.charAt(i - 1) == b.charAt(j - 1) ? nw : nw + 1);
                nw = costs[j];
                costs[j] = cj;
            }
        }
        return costs[b.length()];
    }

    private static String removeAccents(String text) {
        if (text == null) return "";
        String normalized = Normalizer.normalize(text, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(normalized).replaceAll("").replace('đ', 'd').replace('Đ', 'D');
    }
}
