package com.utecoffe;

import com.utecoffe.dto.response.TasteMatchResultDto;
import com.utecoffe.entity.Product;
import com.utecoffe.repository.ProductRepository;
import com.utecoffe.service.impl.TasteProfileServiceImpl;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TasteProfileServiceTest {

    @Mock
    private ProductRepository productRepository;

    @InjectMocks
    private TasteProfileServiceImpl tasteProfileService;

    @Test
    void testMatchPalate_ReturnsRankedMatches() {
        Product p1 = Product.builder().id(1L).slug("cold-brew-cam-vang-specialty").name("Cold Brew Cam Vàng").build();
        Product p2 = Product.builder().id(2L).slug("espresso-signature-utecoffe").name("Espresso Signature").build();

        when(productRepository.findAll()).thenReturn(List.of(p1, p2));

        // High acidity, high aroma query -> should match cold brew cam vang
        List<TasteMatchResultDto> results = tasteProfileService.matchPalate(4.5, 2.5, 4.0, 1.5, 4.8, 2);

        assertNotNull(results);
        assertEquals(2, results.size());
        assertEquals("cold-brew-cam-vang-specialty", results.get(0).getProductSlug());
        assertTrue(results.get(0).getMatchScorePercent() > 80.0);
    }

    @Test
    void testFilterByRoastAndNotes_FiltersAccurately() {
        Product p1 = Product.builder().id(1L).slug("cold-brew-cam-vang-specialty").name("Cold Brew Cam Vàng").build();
        Product p2 = Product.builder().id(2L).slug("espresso-signature-utecoffe").name("Espresso Signature").build();

        when(productRepository.findAll()).thenReturn(List.of(p1, p2));

        // Filter by "Light" roast and "Cam"
        List<TasteMatchResultDto> filtered = tasteProfileService.filterByRoastAndNotes("Light", "Cam", 5);

        assertNotNull(filtered);
        assertFalse(filtered.isEmpty());
        assertEquals("cold-brew-cam-vang-specialty", filtered.get(0).getProductSlug());
    }
}
