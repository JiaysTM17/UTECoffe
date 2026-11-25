package com.utecoffe.service.impl;

import com.utecoffe.dto.response.FlavorPairingDto;
import com.utecoffe.entity.Product;
import com.utecoffe.repository.OrderItemRepository;
import com.utecoffe.repository.ProductRepository;
import com.utecoffe.service.RecommendationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class RecommendationServiceImpl implements RecommendationService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Override
    public List<FlavorPairingDto> getPairingsForProduct(Long productId) {
        Product target = productRepository.findById(productId).orElse(null);
        if (target == null) return List.of();

        List<Product> allProducts = productRepository.findByIsAvailableTrue();
        List<FlavorPairingDto> pairings = new ArrayList<>();

        String targetName = target.getName().toLowerCase();
        String targetDesc = target.getDescription() != null ? target.getDescription().toLowerCase() : "";
        Long targetCatId = target.getCategory() != null ? target.getCategory().getId() : 1L;

        for (Product candidate : allProducts) {
            if (candidate.getId().equals(target.getId())) continue;

            Long candCatId = candidate.getCategory() != null ? candidate.getCategory().getId() : 1L;
            String candName = candidate.getName().toLowerCase();
            String candDesc = candidate.getDescription() != null ? candidate.getDescription().toLowerCase() : "";

            // Cross-category pairing (Beverage <-> Pastry/Bakery) receives maximum complementarity score
            double score = 0.5;
            String tag = "GỢI Ý HÒA HỢP";
            String reason = "Sự kết hợp cân bằng giữa tầng hương thức uống và món ăn kèm.";

            boolean isBeverage = (targetCatId == 1 || targetCatId == 2); // Cà phê hoặc Trà
            boolean isPastry = (targetCatId == 3); // Bánh ngọt thủ công

            boolean candIsPastry = (candCatId == 3);
            boolean candIsBeverage = (candCatId == 1 || candCatId == 2);

            if (isBeverage && candIsPastry) {
                // Beverage paired with Pastry
                if (targetDesc.contains("cam") || targetDesc.contains("bưởi") || targetDesc.contains("chua") || targetDesc.contains("geisha")) {
                    score = 0.95;
                    tag = "GHÉP VỊ HOÀN HẢO (PERFECT MATCH)";
                    reason = "Vị chua thanh quả mọng và cam chanh tươi mát cân bằng tuyệt hảo với lớp vỏ ngậy bơ Pháp giòn rụm.";
                } else if (targetDesc.contains("muối") || targetDesc.contains("đậm") || targetDesc.contains("caramel") || targetName.contains("espresso")) {
                    score = 0.92;
                    tag = "CẶP ĐÔI QUYẾN RŨ (LUXURY PAIRING)";
                    reason = "Độ đậm đà béo mặn của cà phê nâng tầm vị phô mai mềm mịn và cacao nguyên chất.";
                } else {
                    score = 0.88;
                    tag = "CHEF'S SIGNATURE CHOICE";
                    reason = "Hương thơm rang mộc tinh tế nâng đỡ vị ngọt thanh của bánh nướng thủ công thượng hạng.";
                }
            } else if (isPastry && candIsBeverage) {
                // Pastry paired with Beverage
                score = 0.90;
                tag = "THỨC UỐNG ĐI KÈM LÝ TƯỞNG";
                reason = "Vị đắng êm dịu và nốt hương hoa quả thanh lọc vòm họng sau khi thưởng thức bánh bơ béo.";
            } else {
                // Same category (e.g. Coffee -> Special Pour Over, or Cold Brew -> Tea)
                if (candidate.getIsFeatured() != null && candidate.getIsFeatured()) {
                    score = 0.75;
                    tag = "MÓN BÁN CHẠY CÙNG DÒNG";
                    reason = "Thức uống được yêu thích bậc nhất trong cùng bộ sưu tập đặc sản UTECoffe.";
                }
            }

            pairings.add(FlavorPairingDto.builder()
                    .targetProductId(target.getId())
                    .targetProductName(target.getName())
                    .recommendedProductId(candidate.getId())
                    .recommendedProductName(candidate.getName())
                    .recommendedProductSlug(candidate.getSlug())
                    .recommendedProductImage(candidate.getImageUrl())
                    .recommendedProductPrice(candidate.getBasePrice())
                    .recommendedCategoryName(candidate.getCategory() != null ? candidate.getCategory().getName() : "")
                    .recommendedProduct(candidate)
                    .pairingScore(score)
                    .pairingTag(tag)
                    .harmonyReason(reason)
                    .build());
        }

        // Sort descending by pairing score
        pairings.sort(Comparator.comparingDouble(FlavorPairingDto::getPairingScore).reversed());

        return pairings.stream().limit(3).collect(Collectors.toList());
    }

    @Override
    public List<Product> getTrendingOrPersonalized(Long userId, int limit) {
        List<Product> featured = productRepository.findByIsFeaturedTrueAndIsAvailableTrue();
        if (featured.size() >= limit) {
            return featured.subList(0, limit);
        }
        return productRepository.findByIsAvailableTrue().stream().limit(limit).collect(Collectors.toList());
    }
}
