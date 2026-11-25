package com.utecoffe.service;

import com.utecoffe.dto.response.TasteMatchResultDto;
import java.util.List;

public interface TasteProfileService {
    /**
     * Compute Cosine Similarity between user sensory input vector and specialty coffee catalog
     * @param acidity 1.0 -> 5.0 (Độ chua thanh)
     * @param body 1.0 -> 5.0 (Thể chất/Đậm đà)
     * @param sweetness 1.0 -> 5.0 (Độ ngọt hậu)
     * @param bitterness 1.0 -> 5.0 (Độ đắng dịu)
     * @param aroma 1.0 -> 5.0 (Hương thơm hoa cỏ/trái cây)
     * @param limit Maximum results to return
     * @return List of ranked specialty coffee recommendations sorted by cosine similarity desc
     */
    List<TasteMatchResultDto> matchPalate(double acidity, double body, double sweetness, double bitterness, double aroma, int limit);
}
