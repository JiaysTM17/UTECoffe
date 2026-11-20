-- ============================================================================
-- UTECOFFE SPECIALTY TEA & COFFEE PLATFORM - INITIAL SEED DATA
-- ============================================================================

-- 1. Roles
INSERT INTO roles (id, name, description) VALUES 
(1, 'ROLE_ADMIN', 'Quan tri vien he thong toan quyen'),
(2, 'ROLE_STORE_MANAGER', 'Quan ly chi nhanh cua hang va ton kho'),
(3, 'ROLE_BARISTA', 'Nhan vien quay pha che va man hinh KDS'),
(4, 'ROLE_CUSTOMER', 'Khach hang thanh vien UTEClub')
ON CONFLICT (id) DO NOTHING;

-- 2. Initial Admin Account (Password: Admin@2026 -> BCrypt hash)
INSERT INTO users (id, full_name, email, phone_number, password_hash, status, role_id, created_at, updated_at) VALUES
(1, 'Quan Tri Vien UTECoffe', 'admin@utecoffe.vn', '0901234567', '$2a$10$w3qWJpQdFeqf9iH2Q2.vCe93d5XgJ5J9rN6N8fVq2fLqLp2N7m5eO', true, 1, NOW(), NOW()),
(2, 'Barista Truong Thu Duc', 'barista.thuduc@utecoffe.vn', '0907654321', '$2a$10$w3qWJpQdFeqf9iH2Q2.vCe93d5XgJ5J9rN6N8fVq2fLqLp2N7m5eO', true, 3, NOW(), NOW()),
(3, 'Nguyen Van A (Khach Hang)', 'khachhang@gmail.com', '0912345678', '$2a$10$w3qWJpQdFeqf9iH2Q2.vCe93d5XgJ5J9rN6N8fVq2fLqLp2N7m5eO', true, 4, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 3. Flagship Stores
INSERT INTO stores (id, name, address, latitude, longitude, phone_number, opening_time, closing_time, is_active, manager_id) VALUES
(1, 'UTECoffe Flagship Thu Duc', '01 Vo Van Ngan, Linh Chieu, TP. Thu Duc, TP.HCM', 10.8514, 106.7720, '02838968641', '07:00', '22:30', true, 1),
(2, 'UTECoffe Roastery District 1', '68 Le Loi, Ben Nghe, Quan 1, TP.HCM', 10.7735, 106.7001, '02838221999', '06:30', '23:00', true, 1),
(3, 'UTECoffe Artisan Phu My Hung', '101 Nguyen Duc Canh, Tan Phong, Quan 7, TP.HCM', 10.7291, 106.7088, '02854123456', '07:00', '22:00', true, 1)
ON CONFLICT (id) DO NOTHING;

-- 4. Store Tables (Thu Duc Branch)
INSERT INTO store_tables (id, store_id, table_number, capacity, is_occupied, is_active) VALUES
(1, 1, 'T-01', 2, false, true),
(2, 1, 'T-02', 4, false, true),
(3, 1, 'T-03', 4, false, true),
(4, 1, 'VIP-01', 8, false, true)
ON CONFLICT (id) DO NOTHING;

-- 5. Product Categories
INSERT INTO categories (id, name, slug, description, image_url, display_order, is_active) VALUES
(1, 'Ca Phe Dac San (Specialty Coffee)', 'ca-phe-dac-san', 'Arabica Cau Dat va Fine Robusta Buu Long rang moc thu cong', 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=600', 1, true),
(2, 'Tra Thuong Hang (Artisan Tea)', 'tra-thuong-hang', 'Tra Oolong Lam Dong, Tra Shan Tuyet Ha Giang thu hai thu cong', 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=600', 2, true),
(3, 'Banh Ngot Thu Cong (Pastry)', 'banh-ngot-thu-cong', 'Croissant bo Phap, Tiramisu ca phe, Tart trai cay tuoi trong ngay', 'https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=600', 3, true),
(4, 'Hat Ca Phe & Goi Tra (Retail Bags)', 'hat-ca-phe-va-goi-tra', 'Hat rang mien tay nguyen va tra bup kho dong goi bao bi cao cap', 'https://images.unsplash.com/photo-1587734195503-904fca47e0e9?q=80&w=600', 4, true)
ON CONFLICT (id) DO NOTHING;

-- 6. Products
INSERT INTO products (id, category_id, name, slug, description, image_url, base_price, is_available, is_featured, created_at, updated_at) VALUES
(1, 1, 'Cold Brew Cam Vang Specialty', 'cold-brew-cam-vang-specialty', 'Ca phe Arabica u lanh 18 tieng ket hop nuoc cam vang Sunkist nguyen chat', 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?q=80&w=600', 59000.00, true, true, NOW(), NOW()),
(2, 1, 'Espresso Tonic Signature', 'espresso-tonic-signature', 'Double shot Espresso Cau Dat tren nen Tonic cao cap va lat chanh vang', 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=600', 55000.00, true, true, NOW(), NOW()),
(3, 2, 'Tra Oolong Kem Phomai Vang', 'tra-oolong-kem-phomai-vang', 'Tra Oolong nuong Moc Chau ket hop lop macchiato cheese beo ngat', 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=600', 62000.00, true, true, NOW(), NOW()),
(4, 2, 'Tra Sen Vang Macchiato', 'tra-sen-vang-macchiato', 'Tra xanh hoa sen Tay Ho dam vi, hat sen boi mem va kem sua tuoi', 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?q=80&w=600', 58000.00, true, false, NOW(), NOW()),
(5, 3, 'Croissant Bo Phap Thu Cong', 'croissant-bo-phap-thu-cong', 'Banh sung bo Phap nuong gion tan voi 100% bo Elle & Vire cao cap', 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=600', 45000.00, true, false, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 7. Product Sizes
INSERT INTO product_sizes (id, product_id, size_name, extra_price) VALUES
(1, 1, 'Regular (M)', 0.00),
(2, 1, 'Large (L)', 10000.00),
(3, 3, 'Regular (M)', 0.00),
(4, 3, 'Large (L)', 10000.00)
ON CONFLICT (id) DO NOTHING;

-- 8. Toppings
INSERT INTO toppings (id, name, price, image_url, is_available) VALUES
(1, 'Tran Chau Oolong Hoang Kim', 10000.00, '', true),
(2, 'Kem Cheese Kem Man Signature', 15000.00, '', true),
(3, 'Thach Nha Dam Mat Ong', 10000.00, '', true),
(4, 'Shot Espresso Them', 15000.00, '', true)
ON CONFLICT (id) DO NOTHING;

-- 9. Ingredients (BOM)
INSERT INTO ingredients (id, name, sku, unit, min_threshold, current_cost_price) VALUES
(1, 'Hat Ca Phe Arabica Cau Dat', 'ING-CF-ARA', 'gram', 5000.00, 320.00),
(2, 'La Tra Oolong Lam Dong', 'ING-TEA-OOL', 'gram', 3000.00, 450.00),
(3, 'Sua Tuoi Thanh Trung Dalatmilk', 'ING-MILK-DLM', 'ml', 10000.00, 35.00),
(4, 'Siro Cam Vang Nhap Khau', 'ING-SYR-ORG', 'ml', 2000.00, 180.00)
ON CONFLICT (id) DO NOTHING;

-- 10. Store Inventory (Thu Duc Branch)
INSERT INTO store_inventories (id, store_id, ingredient_id, current_stock, safety_stock, last_restocked_at) VALUES
(1, 1, 1, 25000.00, 5000.00, NOW()),
(2, 1, 2, 15000.00, 3000.00, NOW()),
(3, 1, 3, 50000.00, 10000.00, NOW()),
(4, 1, 4, 8000.00, 2000.00, NOW())
ON CONFLICT (id) DO NOTHING;

-- 11. Initial Promotional Coupons
INSERT INTO coupons (id, code, title, description, discount_type, discount_value, min_order_value, max_discount_amount, start_date, end_date, usage_limit, used_count, is_active) VALUES
(1, 'UTECOFFEWELCOME', 'Chao Mung Thanh Vien Moi', 'Giam 20% cho don hang dau tien tren ung dung', 'PERCENTAGE', 20.00, 50000.00, 30000.00, NOW(), NOW() + INTERVAL '30 days', 1000, 0, true),
(2, 'FREESHIP30K', 'Mien Phi Giao Hang 30K', 'Giam 30.000d phi van chuyen cho don tu 100.000d', 'FIXED_AMOUNT', 30000.00, 10000.00, 30000.00, NOW(), NOW() + INTERVAL '30 days', 500, 0, true)
ON CONFLICT (id) DO NOTHING;
