package com.utecoffe.dto.response;

import com.utecoffe.entity.Product;
import java.math.BigDecimal;

public class FuzzySearchResultDto {
    private Long productId;
    private String productName;
    private String productSlug;
    private String productImageUrl;
    private BigDecimal price;
    private String categoryName;
    private String description;

    private double matchScore;
    private int editDistance;
    private double jaccardSimilarity;
    private String matchHighlight;
    private Product product;

    public FuzzySearchResultDto() {}

    public static FuzzySearchResultDtoBuilder builder() {
        return new FuzzySearchResultDtoBuilder();
    }

    public static class FuzzySearchResultDtoBuilder {
        private final FuzzySearchResultDto dto = new FuzzySearchResultDto();

        public FuzzySearchResultDtoBuilder productId(Long productId) { dto.productId = productId; return this; }
        public FuzzySearchResultDtoBuilder productName(String productName) { dto.productName = productName; return this; }
        public FuzzySearchResultDtoBuilder productSlug(String productSlug) { dto.productSlug = productSlug; return this; }
        public FuzzySearchResultDtoBuilder productImageUrl(String productImageUrl) { dto.productImageUrl = productImageUrl; return this; }
        public FuzzySearchResultDtoBuilder price(BigDecimal price) { dto.price = price; return this; }
        public FuzzySearchResultDtoBuilder categoryName(String categoryName) { dto.categoryName = categoryName; return this; }
        public FuzzySearchResultDtoBuilder description(String description) { dto.description = description; return this; }
        public FuzzySearchResultDtoBuilder matchScore(double matchScore) { dto.matchScore = matchScore; return this; }
        public FuzzySearchResultDtoBuilder editDistance(int editDistance) { dto.editDistance = editDistance; return this; }
        public FuzzySearchResultDtoBuilder jaccardSimilarity(double jaccardSimilarity) { dto.jaccardSimilarity = jaccardSimilarity; return this; }
        public FuzzySearchResultDtoBuilder matchHighlight(String matchHighlight) { dto.matchHighlight = matchHighlight; return this; }
        public FuzzySearchResultDtoBuilder product(Product product) { dto.product = product; return this; }

        public FuzzySearchResultDto build() { return dto; }
    }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getProductSlug() { return productSlug; }
    public void setProductSlug(String productSlug) { this.productSlug = productSlug; }
    public String getProductImageUrl() { return productImageUrl; }
    public void setProductImageUrl(String productImageUrl) { this.productImageUrl = productImageUrl; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getMatchScore() { return matchScore; }
    public void setMatchScore(double matchScore) { this.matchScore = matchScore; }
    public int getEditDistance() { return editDistance; }
    public void setEditDistance(int editDistance) { this.editDistance = editDistance; }
    public double getJaccardSimilarity() { return jaccardSimilarity; }
    public void setJaccardSimilarity(double jaccardSimilarity) { this.jaccardSimilarity = jaccardSimilarity; }
    public String getMatchHighlight() { return matchHighlight; }
    public void setMatchHighlight(String matchHighlight) { this.matchHighlight = matchHighlight; }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
}
