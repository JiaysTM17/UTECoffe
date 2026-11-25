package com.utecoffe.service;

import com.utecoffe.entity.Category;
import com.utecoffe.entity.Product;

import java.util.List;

public interface ProductService {
    List<Product> getAllAvailable();
    List<Product> getFeaturedProducts();
    List<Product> getProductsByCategory(Long categoryId);
    Product getProductBySlug(String slug);
    Product getProductById(Long id);
    List<Category> getAllCategories();
    List<Product> search(String keyword);
}
