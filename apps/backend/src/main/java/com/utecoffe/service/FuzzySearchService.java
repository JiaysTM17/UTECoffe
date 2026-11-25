package com.utecoffe.service;

import com.utecoffe.dto.response.FuzzySearchResultDto;
import java.util.List;

public interface FuzzySearchService {
    /**
     * Search products with fault-tolerant fuzzy string matching using Damerau-Levenshtein
     * and N-Gram token similarity algorithms.
     * @param query Search query from user (e.g. "colbrew", "croisan", "capuchino")
     * @param threshold Minimum match score (0.0 to 1.0, e.g. 0.35)
     * @param limit Maximum results to return
     * @return Ranked list of matching products sorted by match score descending
     */
    List<FuzzySearchResultDto> fuzzySearch(String query, double threshold, int limit);
}
