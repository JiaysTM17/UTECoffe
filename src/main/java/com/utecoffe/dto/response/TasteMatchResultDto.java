package com.utecoffe.dto.response;

import com.utecoffe.entity.Product;
import java.math.BigDecimal;
import java.util.List;

public class TasteMatchResultDto {
    private Long productId;
    private String productName;
    private String productSlug;
    private String productImageUrl;
    private BigDecimal price;
    private String categoryName;
    
    private double matchScorePercent;
    private double cosineSimilarity;
    private String scaCuppingScore;
    private String roastLevel;
    private String terroir;
    private List<String> tastingNotes;
    private String sensoryVerdict;

    private double acidity;
    private double body;
    private double sweetness;
    private double bitterness;
    private double aroma;

    private Product product;

    public TasteMatchResultDto() {}

    public static TasteMatchResultDtoBuilder builder() {
        return new TasteMatchResultDtoBuilder();
    }

    public static class TasteMatchResultDtoBuilder {
        private final TasteMatchResultDto dto = new TasteMatchResultDto();

        public TasteMatchResultDtoBuilder productId(Long productId) { dto.productId = productId; return this; }
        public TasteMatchResultDtoBuilder productName(String productName) { dto.productName = productName; return this; }
        public TasteMatchResultDtoBuilder productSlug(String productSlug) { dto.productSlug = productSlug; return this; }
        public TasteMatchResultDtoBuilder productImageUrl(String productImageUrl) { dto.productImageUrl = productImageUrl; return this; }
        public TasteMatchResultDtoBuilder price(BigDecimal price) { dto.price = price; return this; }
        public TasteMatchResultDtoBuilder categoryName(String categoryName) { dto.categoryName = categoryName; return this; }
        public TasteMatchResultDtoBuilder matchScorePercent(double matchScorePercent) { dto.matchScorePercent = matchScorePercent; return this; }
        public TasteMatchResultDtoBuilder cosineSimilarity(double cosineSimilarity) { dto.cosineSimilarity = cosineSimilarity; return this; }
        public TasteMatchResultDtoBuilder scaCuppingScore(String scaCuppingScore) { dto.scaCuppingScore = scaCuppingScore; return this; }
        public TasteMatchResultDtoBuilder roastLevel(String roastLevel) { dto.roastLevel = roastLevel; return this; }
        public TasteMatchResultDtoBuilder terroir(String terroir) { dto.terroir = terroir; return this; }
        public TasteMatchResultDtoBuilder tastingNotes(List<String> tastingNotes) { dto.tastingNotes = tastingNotes; return this; }
        public TasteMatchResultDtoBuilder sensoryVerdict(String sensoryVerdict) { dto.sensoryVerdict = sensoryVerdict; return this; }
        public TasteMatchResultDtoBuilder acidity(double acidity) { dto.acidity = acidity; return this; }
        public TasteMatchResultDtoBuilder body(double body) { dto.body = body; return this; }
        public TasteMatchResultDtoBuilder sweetness(double sweetness) { dto.sweetness = sweetness; return this; }
        public TasteMatchResultDtoBuilder bitterness(double bitterness) { dto.bitterness = bitterness; return this; }
        public TasteMatchResultDtoBuilder aroma(double aroma) { dto.aroma = aroma; return this; }
        public TasteMatchResultDtoBuilder product(Product product) { dto.product = product; return this; }

        public TasteMatchResultDto build() { return dto; }
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
    public double getMatchScorePercent() { return matchScorePercent; }
    public void setMatchScorePercent(double matchScorePercent) { this.matchScorePercent = matchScorePercent; }
    public double getCosineSimilarity() { return cosineSimilarity; }
    public void setCosineSimilarity(double cosineSimilarity) { this.cosineSimilarity = cosineSimilarity; }
    public String getScaCuppingScore() { return scaCuppingScore; }
    public void setScaCuppingScore(String scaCuppingScore) { this.scaCuppingScore = scaCuppingScore; }
    public String getRoastLevel() { return roastLevel; }
    public void setRoastLevel(String roastLevel) { this.roastLevel = roastLevel; }
    public String getTerroir() { return terroir; }
    public void setTerroir(String terroir) { this.terroir = terroir; }
    public List<String> getTastingNotes() { return tastingNotes; }
    public void setTastingNotes(List<String> tastingNotes) { this.tastingNotes = tastingNotes; }
    public String getSensoryVerdict() { return sensoryVerdict; }
    public void setSensoryVerdict(String sensoryVerdict) { this.sensoryVerdict = sensoryVerdict; }
    public double getAcidity() { return acidity; }
    public void setAcidity(double acidity) { this.acidity = acidity; }
    public double getBody() { return body; }
    public void setBody(double body) { this.body = body; }
    public double getSweetness() { return sweetness; }
    public void setSweetness(double sweetness) { this.sweetness = sweetness; }
    public double getBitterness() { return bitterness; }
    public void setBitterness(double bitterness) { this.bitterness = bitterness; }
    public double getAroma() { return aroma; }
    public void setAroma(double aroma) { this.aroma = aroma; }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
}
