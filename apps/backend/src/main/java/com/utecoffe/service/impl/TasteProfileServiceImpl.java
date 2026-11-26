package com.utecoffe.service.impl;

import com.utecoffe.dto.response.TasteMatchResultDto;
import com.utecoffe.entity.Product;
import com.utecoffe.repository.ProductRepository;
import com.utecoffe.service.TasteProfileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class TasteProfileServiceImpl implements TasteProfileService {

    private static final Logger log = LoggerFactory.getLogger(TasteProfileServiceImpl.class);

    private final ProductRepository productRepository;

    @Autowired
    public TasteProfileServiceImpl(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    // Internal record for Sensory Vector in 5D Space
    private record SensoryVector(
            double acidity,
            double body,
            double sweetness,
            double bitterness,
            double aroma,
            String scaScore,
            String roastLevel,
            String terroir,
            List<String> notes,
            String verdict
    ) {}

    private static final Map<String, SensoryVector> SENSORY_KNOWLEDGE_BASE = new HashMap<>();

    static {
        SENSORY_KNOWLEDGE_BASE.put("cold-brew-cam-vang-specialty", new SensoryVector(
                4.6, 2.5, 4.2, 1.4, 4.8,
                "87.5 SCA", "Light-Medium Roast", "Cầu Đất, Đà Lạt (1.600m)",
                List.of("Cam Sunkist", "Quả Mọng Dại", "Hương Hoa Trắng"),
                "Hương cam vàng mọng nước hòa quyện cùng vị ngọt hậu sâu sắc của Arabica ủ lạnh 18 giờ."
        ));

        SENSORY_KNOWLEDGE_BASE.put("cold-brew-nguyen-ban-cau-dat", new SensoryVector(
                3.8, 3.2, 4.0, 2.2, 4.5,
                "86.5 SCA", "Medium Roast", "Cầu Đất, Lâm Đồng (1.600m)",
                List.of("Mận Chín", "Socola Đen Nhẹ", "Mật Mía"),
                "Mộc mạc, thanh khiết với hương mận chín và hậu vị ngọt sâu lưu luyến."
        ));

        SENSORY_KNOWLEDGE_BASE.put("pour-over-v60-arabica-typica", new SensoryVector(
                4.5, 2.8, 4.3, 1.8, 4.9,
                "88.5 SCA", "Light Roast", "Cầu Đất Di Sản (1.650m)",
                List.of("Hoa Nhài", "Chanh Vàng Meyer", "Trà Đào"),
                "Dòng cà phê di sản Typica quý hiếm được chiết xuất thủ công V60, ngát hương hoa nhài và trà đào thanh tao."
        ));

        SENSORY_KNOWLEDGE_BASE.put("pour-over-chemex-geisha-cau-dat", new SensoryVector(
                4.8, 2.4, 4.7, 1.2, 5.0,
                "91.0 SCA Grand Cru", "Ultra Light Roast", "Đỉnh Cầu Đất 1.700m",
                List.of("Hương Hoa Cam", "Quả Mơ Vàng", "Mật Ong Rừng"),
                "Đỉnh cao cà phê đặc sản thế giới với độ phức hợp hương thơm bùng nổ, hậu vị hoa cam và mật ong kéo dài."
        ));

        SENSORY_KNOWLEDGE_BASE.put("espresso-signature-utecoffe", new SensoryVector(
                2.0, 4.8, 3.2, 4.6, 4.2,
                "85.5 SCA", "Medium-Dark Roast", "Blend Cầu Đất & Buôn Ma Thuột",
                List.of("Socola 85%", "Hạt Phỉ Nướng", "Caramel Cháy"),
                "Dày dặn, đậm đà với lớp Crema óng ánh màu hổ phách, nốt hương socola đắng và hạt phỉ nướng nồng nàn."
        ));

        SENSORY_KNOWLEDGE_BASE.put("americano-da-specialty", new SensoryVector(
                3.2, 3.0, 3.5, 3.2, 3.9,
                "85.0 SCA", "Medium Roast", "Arabica Cầu Đất",
                List.of("Vỏ Cam Khô", "Socola Sữa", "Mạch Nha"),
                "Thanh mát, sảng khoái với vị đắng êm dịu và nốt hương vỏ cam khô tinh tế."
        ));

        SENSORY_KNOWLEDGE_BASE.put("ca-phe-muoi-bien-nghe-thuat", new SensoryVector(
                1.8, 4.6, 4.4, 3.4, 4.3,
                "86.0 SCA", "Medium Roast", "Phin Blend Đậm Vị",
                List.of("Kem Béo Mặn", "Muối Hồng Himalaya", "Caramel"),
                "Lớp kem muối biển bồng bềnh mịn màng làm thăng hoa vị đắng dịu ngọt của cà phê rang mộc."
        ));

        SENSORY_KNOWLEDGE_BASE.put("latte-hanh-nhan-macchiato", new SensoryVector(
                1.4, 4.2, 4.5, 2.0, 4.0,
                "85.0 SCA", "Medium Roast", "Arabica & Sữa Tươi Thanh Trùng",
                List.of("Bơ Hạnh Nhân", "Vani Bourbon", "Sữa Mềm Mượt"),
                "Sự hòa quyện êm dịu tuyệt hảo giữa espresso hảo hạng và vị ngọt bùi của hạnh nhân cao cấp."
        ));

        SENSORY_KNOWLEDGE_BASE.put("tra-oolong-sen-vang-co-do", new SensoryVector(
                2.2, 2.8, 4.8, 1.0, 5.0,
                "Tuyệt Phẩm Trà", "Lên Men Bán Phần", "Bảo Lộc, Lâm Đồng",
                List.of("Hạt Sen Huế", "Hương Hoa Mộc Lan", "Mật Hoa"),
                "Hương trà Oolong thanh cao quyện cùng bùi bùi của hạt sen Huế ngào đường phèn thanh khiết."
        ));

        SENSORY_KNOWLEDGE_BASE.put("tra-dao-cam-sa-hoang-gia", new SensoryVector(
                4.2, 2.2, 4.6, 1.0, 4.7,
                "Trà Thủ Công", "Trà Đen Ceylon", "Thảo mộc tươi",
                List.of("Đào Giòn", "Cam Tươi", "Sả Cây Tinh Dầu"),
                "Vị chua thanh mát lành kết hợp sả tươi và đào giòn mọng mang lại năng lượng tức thì."
        ));
    }

    @Override
    public List<TasteMatchResultDto> matchPalate(double acidity, double body, double sweetness, double bitterness, double aroma, int limit) {
        log.info("Calculating Palate Match via Cosine Similarity for User Vector: [Acid: {}, Body: {}, Sweet: {}, Bitter: {}, Aroma: {}]",
                acidity, body, sweetness, bitterness, aroma);

        double[] userVec = new double[]{acidity, body, sweetness, bitterness, aroma};
        double userNorm = vectorNorm(userVec);

        List<Product> allProducts = productRepository.findAll();
        List<TasteMatchResultDto> results = new ArrayList<>();

        for (Product product : allProducts) {
            SensoryVector vector = SENSORY_KNOWLEDGE_BASE.get(product.getSlug());
            if (vector == null) {
                vector = deriveFallbackVector(product);
            }

            double[] prodVec = new double[]{vector.acidity(), vector.body(), vector.sweetness(), vector.bitterness(), vector.aroma()};
            double prodNorm = vectorNorm(prodVec);

            double dotProduct = dotProduct(userVec, prodVec);
            double cosineSimilarity = (userNorm > 0 && prodNorm > 0) ? (dotProduct / (userNorm * prodNorm)) : 0.0;
            cosineSimilarity = Math.max(0.0, Math.min(1.0, cosineSimilarity));
            double matchPercent = Math.round(cosineSimilarity * 1000.0) / 10.0;

            results.add(TasteMatchResultDto.builder()
                    .productId(product.getId())
                    .productName(product.getName())
                    .productSlug(product.getSlug())
                    .productImageUrl(product.getImageUrl())
                    .price(product.getBasePrice())
                    .categoryName(product.getCategory() != null ? product.getCategory().getName() : "Specialty")
                    .matchScorePercent(matchPercent)
                    .cosineSimilarity(Math.round(cosineSimilarity * 1000.0) / 1000.0)
                    .scaCuppingScore(vector.scaScore())
                    .roastLevel(vector.roastLevel())
                    .terroir(vector.terroir())
                    .tastingNotes(vector.notes())
                    .sensoryVerdict(vector.verdict())
                    .acidity(vector.acidity())
                    .body(vector.body())
                    .sweetness(vector.sweetness())
                    .bitterness(vector.bitterness())
                    .aroma(vector.aroma())
                    .product(product)
                    .build());
        }

        return results.stream()
                .sorted(Comparator.comparingDouble(TasteMatchResultDto::getMatchScorePercent).reversed())
                .limit(Math.max(1, limit))
                .collect(Collectors.toList());
    }

    @Override
    public List<TasteMatchResultDto> filterByRoastAndNotes(String roastLevel, String flavorKeyword, int limit) {
        String roastQuery = (roastLevel != null) ? roastLevel.trim().toLowerCase() : "";
        String noteQuery = (flavorKeyword != null) ? flavorKeyword.trim().toLowerCase() : "";

        List<TasteMatchResultDto> allMatches = matchPalate(3.0, 3.0, 3.0, 3.0, 3.0, 50);

        return allMatches.stream()
                .filter(dto -> {
                    if (!roastQuery.isEmpty()) {
                        String roast = dto.getRoastLevel() != null ? dto.getRoastLevel().toLowerCase() : "";
                        if (!roast.contains(roastQuery)) return false;
                    }
                    if (!noteQuery.isEmpty()) {
                        boolean matchNote = dto.getTastingNotes() != null && dto.getTastingNotes().stream()
                                .anyMatch(note -> note.toLowerCase().contains(noteQuery));
                        String verdict = dto.getSensoryVerdict() != null ? dto.getSensoryVerdict().toLowerCase() : "";
                        if (!matchNote && !verdict.contains(noteQuery)) return false;
                    }
                    return true;
                })
                .limit(Math.max(1, limit))
                .collect(Collectors.toList());
    }

    private double dotProduct(double[] a, double[] b) {
        double sum = 0.0;
        for (int i = 0; i < a.length; i++) {
            sum += a[i] * b[i];
        }
        return sum;
    }

    private double vectorNorm(double[] v) {
        double sum = 0.0;
        for (double val : v) {
            sum += val * val;
        }
        return Math.sqrt(sum);
    }

    private SensoryVector deriveFallbackVector(Product p) {
        String cat = (p.getCategory() != null && p.getCategory().getName() != null)
                ? p.getCategory().getName().toLowerCase()
                : "";

        if (cat.contains("cà phê") || cat.contains("coffee")) {
            return new SensoryVector(2.8, 3.8, 3.5, 3.8, 4.0, "84.0 SCA", "Medium Roast", "Đà Lạt, Lâm Đồng",
                    List.of("Socola", "Hạt Rang", "Caramel"), "Hương vị cà phê thơm đầm, hài hòa dễ uống.");
        } else if (cat.contains("trà") || cat.contains("tea")) {
            return new SensoryVector(3.2, 2.0, 4.5, 1.2, 4.8, "Trà Thủ Công", "Thanh Khiết", "Bảo Lộc, Lâm Đồng",
                    List.of("Hương Hoa", "Trái Cây Tươi", "Mật Ong"), "Vị trà nhẹ nhàng thơm mát và ngọt hậu sảng khoái.");
        } else {
            return new SensoryVector(2.0, 3.5, 4.8, 1.0, 3.8, "Artisanal Pastry", "Thủ công", "Bơ Pháp Elle & Vire",
                    List.of("Bơ Tươi", "Vani", "Đường Nâu"), "Thơm lừng bơ Pháp giòn rụm và ngậy béo.");
        }
    }
}
