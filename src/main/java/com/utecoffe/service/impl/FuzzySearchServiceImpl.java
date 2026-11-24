package com.utecoffe.service.impl;

import com.utecoffe.dto.response.FuzzySearchResultDto;
import com.utecoffe.entity.Product;
import com.utecoffe.repository.ProductRepository;
import com.utecoffe.service.FuzzySearchService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.Normalizer;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class FuzzySearchServiceImpl implements FuzzySearchService {

    private static final Logger log = LoggerFactory.getLogger(FuzzySearchServiceImpl.class);

    private final ProductRepository productRepository;
    private static final Pattern DIACRITICS_PATTERN = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");

    @Autowired
    public FuzzySearchServiceImpl(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    public List<FuzzySearchResultDto> fuzzySearch(String query, double threshold, int limit) {
        if (query == null || query.trim().isEmpty()) {
            return Collections.emptyList();
        }

        String rawQuery = query.trim();
        String normalizedQuery = normalizeString(rawQuery);
        Set<String> queryNGrams = generateNGrams(normalizedQuery, 2);

        List<Product> allProducts = productRepository.findAll();
        List<FuzzySearchResultDto> matches = new ArrayList<>();

        for (Product product : allProducts) {
            String rawName = product.getName();
            String normalizedName = normalizeString(rawName);
            String rawCategory = product.getCategory() != null ? product.getCategory().getName() : "";
            String normalizedCategory = normalizeString(rawCategory);

            double exactScore = 0.0;
            if (normalizedName.equals(normalizedQuery)) {
                exactScore = 1.0;
            } else if (normalizedName.startsWith(normalizedQuery)) {
                exactScore = 0.92;
            } else if (normalizedName.contains(normalizedQuery)) {
                exactScore = 0.85;
            } else if (normalizedCategory.contains(normalizedQuery)) {
                exactScore = 0.75;
            }

            int distance = calculateDamerauLevenshtein(normalizedQuery, normalizedName);
            int maxLen = Math.max(normalizedQuery.length(), normalizedName.length());
            double levenshteinSim = maxLen > 0 ? (1.0 - (double) distance / maxLen) : 0.0;
            levenshteinSim = Math.max(0.0, levenshteinSim);

            String[] tokens = normalizedName.split("\\s+");
            for (String token : tokens) {
                int tokenDist = calculateDamerauLevenshtein(normalizedQuery, token);
                int tokenMax = Math.max(normalizedQuery.length(), token.length());
                double tokenSim = tokenMax > 0 ? (1.0 - (double) tokenDist / tokenMax) : 0.0;
                if (tokenSim > levenshteinSim) {
                    levenshteinSim = tokenSim;
                    distance = tokenDist;
                }
            }

            Set<String> nameNGrams = generateNGrams(normalizedName, 2);
            double jaccard = calculateJaccard(queryNGrams, nameNGrams);

            double finalScore;
            if (exactScore > 0) {
                finalScore = Math.max(exactScore, (0.65 * levenshteinSim) + (0.35 * jaccard));
            } else {
                finalScore = (0.65 * levenshteinSim) + (0.35 * jaccard);
            }

            finalScore = Math.round(finalScore * 1000.0) / 1000.0;

            if (finalScore >= threshold) {
                String highlight = (exactScore >= 0.85) ? "Khớp chính xác / Chuỗi con"
                        : (distance <= 2 ? "Khớp gần đúng (Lỗi chính tả " + distance + " ký tự)"
                        : "Khớp tương đồng âm vị N-Gram (" + Math.round(finalScore * 100) + "%)");

                matches.add(FuzzySearchResultDto.builder()
                        .productId(product.getId())
                        .productName(product.getName())
                        .productSlug(product.getSlug())
                        .productImageUrl(product.getImageUrl())
                        .price(product.getBasePrice())
                        .categoryName(rawCategory)
                        .description(product.getDescription())
                        .matchScore(finalScore)
                        .editDistance(distance)
                        .jaccardSimilarity(Math.round(jaccard * 1000.0) / 1000.0)
                        .matchHighlight(highlight)
                        .product(product)
                        .build());
            }
        }

        return matches.stream()
                .sorted(Comparator.comparingDouble(FuzzySearchResultDto::getMatchScore).reversed())
                .limit(Math.max(1, limit))
                .collect(Collectors.toList());
    }

    public static int calculateDamerauLevenshtein(String s1, String s2) {
        int len1 = s1.length();
        int len2 = s2.length();
        int[][] d = new int[len1 + 1][len2 + 1];

        for (int i = 0; i <= len1; i++) {
            d[i][0] = i;
        }
        for (int j = 0; j <= len2; j++) {
            d[0][j] = j;
        }

        for (int i = 1; i <= len1; i++) {
            for (int j = 1; j <= len2; j++) {
                int cost = (s1.charAt(i - 1) == s2.charAt(j - 1)) ? 0 : 1;

                d[i][j] = Math.min(
                        d[i - 1][j] + 1,
                        Math.min(
                                d[i][j - 1] + 1,
                                d[i - 1][j - 1] + cost
                        )
                );

                if (i > 1 && j > 1
                        && s1.charAt(i - 1) == s2.charAt(j - 2)
                        && s1.charAt(i - 2) == s2.charAt(j - 1)) {
                    d[i][j] = Math.min(d[i][j], d[i - 2][j - 2] + cost);
                }
            }
        }
        return d[len1][len2];
    }

    private static String normalizeString(String input) {
        if (input == null) return "";
        String nfd = Normalizer.normalize(input.toLowerCase(), Normalizer.Form.NFD);
        String stripped = DIACRITICS_PATTERN.matcher(nfd).replaceAll("");
        return stripped.replace('đ', 'd').replace('Đ', 'd').replaceAll("[^a-z0-9\\s]", " ").replaceAll("\\s+", " ").trim();
    }

    private static Set<String> generateNGrams(String str, int n) {
        Set<String> nGrams = new HashSet<>();
        if (str == null || str.length() < n) {
            if (str != null && !str.isEmpty()) nGrams.add(str);
            return nGrams;
        }
        for (int i = 0; i <= str.length() - n; i++) {
            nGrams.add(str.substring(i, i + n));
        }
        return nGrams;
    }

    private static double calculateJaccard(Set<String> set1, Set<String> set2) {
        if (set1.isEmpty() && set2.isEmpty()) return 1.0;
        if (set1.isEmpty() || set2.isEmpty()) return 0.0;

        Set<String> intersection = new HashSet<>(set1);
        intersection.retainAll(set2);

        Set<String> union = new HashSet<>(set1);
        union.addAll(set2);

        return (double) intersection.size() / union.size();
    }
}
