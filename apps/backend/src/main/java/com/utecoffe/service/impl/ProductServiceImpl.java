package com.utecoffe.service.impl;

import com.utecoffe.entity.Category;
import com.utecoffe.entity.Product;
import com.utecoffe.repository.CategoryRepository;
import com.utecoffe.repository.ProductRepository;
import com.utecoffe.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

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

    @Override
    public List<Product> search(String keyword) {
        return productRepository.searchProducts(keyword);
    }
}
