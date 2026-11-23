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
(1, 1, 'Cold Brew Cam Vang Specialty', 'cold-brew-cam-vang-specialty', 'Ca phe Arabica u lanh 18 tieng ket hop nuoc cam vang Sunkist mong nuoc nguyen chat', 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?q=80&w=800', 59000.00, true, true, NOW(), NOW()),
(2, 1, 'Espresso Tonic Signature', 'espresso-tonic-signature', 'Double shot Espresso Cau Dat dam da tren nen Tonic cao cap va lat chanh vang tuoi mat', 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=800', 55000.00, true, true, NOW(), NOW()),
(3, 2, 'Tra Oolong Kem Phomai Vang', 'tra-oolong-kem-phomai-vang', 'Tra Oolong nuong Moc Chau thom lung ket hop lop macchiato cheese beo ngat', 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=800', 62000.00, true, true, NOW(), NOW()),
(4, 2, 'Tra Sen Vang Macchiato Tay Ho', 'tra-sen-vang-macchiato-tay-ho', 'Tra xanh uop hoa sen Tay Ho thanh nha, hat sen bui mem va kem sua tuoi', 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?q=80&w=800', 58000.00, true, true, NOW(), NOW()),
(5, 3, 'Croissant Bo Phap Thu Cong', 'croissant-bo-phap-thu-cong', 'Banh sung bo Phap nuong gion tan voi 100% bo Elle & Vire cao cap', 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=800', 45000.00, true, true, NOW(), NOW()),
(6, 1, 'Ca Phe Muoi Hoang Gia', 'ca-phe-muoi-hoang-gia', 'Ca phe Robusta moc Cau Dat ket hop lop kem beo man caramel hoang gia', 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?q=80&w=800', 52000.00, true, true, NOW(), NOW()),
(7, 1, 'Pour-Over V60 Bourbon Cau Dat', 'pour-over-v60-bourbon-cau-dat', 'Chiet xuat thu cong tung giot tinh hoa, dai huong hoa nhai trang thanh khiet', 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=800', 68000.00, true, false, NOW(), NOW()),
(8, 1, 'Latte Sua Yen Mach Oatly', 'latte-sua-yen-mach-oatly', 'Espresso rang moc hoa quyen sua yen mach Oatly Thuy Dien beo bui thuan thuc vat', 'https://images.unsplash.com/photo-1534778101976-62847782c213?q=80&w=800', 65000.00, true, false, NOW(), NOW()),
(9, 1, 'Flat White Cau Dat Double Shot', 'flat-white-cau-dat-double-shot', 'Lop bot sua microfoam min mang hoa quyen 2 shot espresso dam da', 'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?q=80&w=800', 59000.00, true, false, NOW(), NOW()),
(10, 2, 'Tra Nhai Mang Cau Dak Lak', 'tra-nhai-mang-cau-dak-lak', 'Nen tra hoa nhai huu co ket hop tep mang cau xiem tuoi mong nuoc chua ngot', 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?q=80&w=800', 55000.00, true, false, NOW(), NOW()),
(11, 2, 'Tra Dao Cam Sa Thao Moc', 'tra-dao-cam-sa-thao-moc', 'Huong thom am nong cua sa tuoi, cam vang va nhung mieng dao gion tan', 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?q=80&w=800', 55000.00, true, false, NOW(), NOW()),
(12, 2, 'Matcha Latte Uji Kyoto', 'matcha-latte-uji-kyoto', 'Bot tra xanh Uji Kyoto hao hang danh bong truyen thong, hau vi umami', 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?q=80&w=800', 65000.00, true, false, NOW(), NOW()),
(13, 3, 'Pain Au Chocolat Bo Tuoi', 'pain-au-chocolat-bo-tuoi', 'Banh cuon bo Phap gion tan ben ngoai, nhan socola dang Bi ngot ngao ben trong', 'https://images.unsplash.com/photo-1608198093002-ad4e005484ec?q=80&w=800', 48000.00, true, false, NOW(), NOW()),
(14, 3, 'Tiramisu Espresso Mascarpone', 'tiramisu-espresso-mascarpone', 'Banh Tiramisu Y truyen thong tam dam espresso Cau Dat va phomai Mascarpone', 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?q=80&w=800', 58000.00, true, false, NOW(), NOW()),
(15, 3, 'Canele De Bordeaux Truyen Thong', 'canele-de-bordeaux-truyen-thong', 'Banh Phap vo caramel gion sam bong bay, ruot mem am deo quanh huong vani', 'https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=800', 42000.00, true, false, NOW(), NOW()),
(16, 3, 'Mousse Dau Tam Rung Da Lat', 'mousse-dau-tam-rung-da-lat', 'Lop banh mousse min mang che tac tu dau tam rung Da Lat tuoi chua ngot', 'https://images.unsplash.com/photo-1587314168485-3236d6710814?q=80&w=800', 52000.00, true, false, NOW(), NOW()),
(17, 1, 'Affogato Gelato Vani', 'affogato-gelato-vani', 'Single shot Espresso Cau Dat dam da rot truc tiep tren vien kem gelato vani Madagascar', 'https://images.unsplash.com/photo-1592663527359-cf6642f54cff?q=80&w=800', 55000.00, true, false, NOW(), NOW()),
(18, 1, 'Ca Phe Trung Ha Noi Specialty', 'ca-phe-trung-ha-noi-specialty', 'Ca phe phin Cau Dat hoa quyen cung lop kem trung danh bong min nhu may thom ngon', 'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=800', 56000.00, true, false, NOW(), NOW()),
(19, 2, 'Tra Sua Oolong Rang Khoi', 'tra-sua-oolong-rang-khoi', 'Tra Oolong say than hoa Moc Chau quyen cung sua tuoi thanh trung Da Lat beo ngay', 'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?q=80&w=800', 58000.00, true, false, NOW(), NOW()),
(20, 2, 'Tra Vai Hoa Hong Damask', 'tra-vai-hoa-hong-damask', 'Tra sen trang u lanh chiet xuat cung canh hoa hong huu co va trai vai tuoi gion ngot', 'https://images.unsplash.com/photo-1556881286-fc6915169721?q=80&w=800', 55000.00, true, false, NOW(), NOW()),
(21, 3, 'Basque Burnt Cheesecake', 'basque-burnt-cheesecake', 'Banh pho mai nuong chay xem be mat San Sebastian voi lop kem pho mai beo ngay tan chay', 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?q=80&w=800', 62000.00, true, false, NOW(), NOW()),
(22, 3, 'Banh Tart Dau Tay & Qua Mong', 'banh-tart-dau-tay-qua-mong', 'Vo banh tart bot hanh nhan nuong vang gion phu kem pastry vani va dau tay Da Lat', 'https://images.unsplash.com/photo-1519869325930-281384150729?q=80&w=800', 55000.00, true, false, NOW(), NOW()),
(23, 1, 'Cold Brew U Thung Go Soi', 'cold-brew-u-thung-go-soi', 'Ca phe Arabica Cau Dat u 48 gio trong thung go soi tao tang huong khoi vanilla caramel', 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?q=80&w=800', 68000.00, true, true, NOW(), NOW()),
(24, 1, 'Ca Phe Dua Non Ben Tre', 'ca-phe-dua-non-ben-tre', 'Espresso Cau Dat dam da rot tren nen cot dua tuoi Ben Tre xay min va com dua non', 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=800', 55000.00, true, false, NOW(), NOW()),
(25, 2, 'Tra Long Nhan Hat Chia Hung Yen', 'tra-long-nhan-hat-chia-hung-yen', 'Tra Shan tuyet co thu u lanh cung long nhan cui day Hung Yen va hat chia huu co', 'https://images.unsplash.com/photo-1597481499750-3e6b22637e12?q=80&w=800', 55000.00, true, false, NOW(), NOW()),
(26, 2, 'Hojicha Latte Rang Cui Nhat Ban', 'hojicha-latte-rang-cui-nhat-ban', 'Bot tra xanh rang cui Shizuoka thom nong huong hat de quyen cung sua tuoi thanh trung', 'https://images.unsplash.com/photo-1579992357154-faf4bde95b3d?q=80&w=800', 62000.00, true, false, NOW(), NOW()),
(27, 3, 'Croffle Bo Nuong Mat Ong Rung', 'croffle-bo-nuong-mat-ong-rung', 'Banh sung bo ep waffle nong gion phu caramel va mat ong hoa bac ha nguyen chat', 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?q=80&w=800', 48000.00, true, false, NOW(), NOW()),
(28, 3, 'Banh Danish Dao & Pho Mai Tuoi', 'banh-danish-dao-pho-mai-tuoi', 'Vo banh nghin lop bo Phap vang uom om tron kem pho mai beo ngay va dao vang tuoi', 'https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?q=80&w=800', 46000.00, true, false, NOW(), NOW()),
(29, 1, 'Cold Brew Sparkling Yuzu', 'cold-brew-sparkling-yuzu', 'Ca phe Arabica Cau Dat u lanh 24 gio phoi cung nuoc ep qua Yuzu Nhat Ban va bot sui sparkling', 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?q=80&w=800', 65000.00, true, true, NOW(), NOW()),
(30, 1, 'Ca Phe Bac Xiu 4 Tang Cau Dat', 'ca-phe-bac-xiu-4-tang-cau-dat', 'Tuyet pham phan tang thi giac nghe thuat sua dac sua tuoi Da Lat ca phe Arabica va bot microfoam', 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?q=80&w=800', 49000.00, true, false, NOW(), NOW()),
(31, 1, 'Single Origin Geisha Panama Pour-Over', 'single-origin-geisha-panama-pour-over', 'Dong hat Geisha quy hiem hang dau the gioi pha thu cong tai ban bung no hoa cam qua mo mat ong', 'https://images.unsplash.com/photo-1518057111178-44a106bad636?q=80&w=800', 85000.00, true, false, NOW(), NOW()),
(32, 2, 'Tra Buoi Hong Ruby Mat Ong', 'tra-buoi-hong-ruby-mat-ong', 'Tra xanh uop hoa buoi ket hop tep buoi hong Ruby mong nuoc va mat ong hoa bac ha thanh loc', 'https://images.unsplash.com/photo-1546173159-315724a31696?q=80&w=800', 55000.00, true, false, NOW(), NOW()),
(33, 2, 'Tra Dau Tay Da Lat Macchiato', 'tra-dau-tay-da-lat-macchiato', 'Nen tra nhai huu co phoi cung dau tay giong Nhat Ban trong tai Da Lat dam tuoi va kem beo man', 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?q=80&w=800', 58000.00, true, true, NOW(), NOW()),
(34, 2, 'Tra Thao Moc Cuc La Ma Tao Do', 'tra-thao-moc-cuc-la-ma-tao-do', 'Tra hoa cuc Chamomile huu co ket hop tao do Tan Cuong va ky tu ninh nhu thu gian giup ngu ngon', 'https://images.unsplash.com/photo-1576092762791-dd9e2220abd1?q=80&w=800', 52000.00, true, false, NOW(), NOW()),
(35, 3, 'Croissant Jambon Pho Mai Phap', 'croissant-jambon-pho-mai-phap', 'Banh sung bo nuong gion rum kep thit nguoi Jambon Phap cao cap pho mai Cheddar va mu tat Dijon', 'https://images.unsplash.com/photo-1509722747041-616f39b57569?q=80&w=800', 58000.00, true, true, NOW(), NOW()),
(36, 3, 'Banh Sourdough Bo Toi La Thyme', 'banh-sourdough-bo-toi-la-thyme', 'Banh mi men tu nhien u 36 gio nuong gion tan tren da phet dam bo Elle & Vire toi nuong va la thyme', 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?q=80&w=800', 45000.00, true, false, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 7. Product Sizes
INSERT INTO product_sizes (id, product_id, size_name, extra_price) VALUES
(1, 1, 'Regular (M)', 0.00), (2, 1, 'Large (L)', 10000.00),
(3, 2, 'Regular (M)', 0.00), (4, 2, 'Large (L)', 10000.00),
(5, 3, 'Regular (M)', 0.00), (6, 3, 'Large (L)', 10000.00),
(7, 4, 'Regular (M)', 0.00), (8, 4, 'Large (L)', 10000.00),
(9, 5, 'Regular (M)', 0.00), (10, 5, 'Large (L)', 10000.00),
(11, 6, 'Regular (M)', 0.00), (12, 6, 'Large (L)', 10000.00),
(13, 7, 'Regular (M)', 0.00), (14, 7, 'Large (L)', 10000.00),
(15, 8, 'Regular (M)', 0.00), (16, 8, 'Large (L)', 10000.00),
(17, 9, 'Regular (M)', 0.00), (18, 9, 'Large (L)', 10000.00),
(19, 10, 'Regular (M)', 0.00), (20, 10, 'Large (L)', 10000.00),
(21, 11, 'Regular (M)', 0.00), (22, 11, 'Large (L)', 10000.00),
(23, 12, 'Regular (M)', 0.00), (24, 12, 'Large (L)', 10000.00),
(25, 13, 'Regular (M)', 0.00), (26, 13, 'Large (L)', 10000.00),
(27, 14, 'Regular (M)', 0.00), (28, 14, 'Large (L)', 10000.00),
(29, 15, 'Regular (M)', 0.00), (30, 15, 'Large (L)', 10000.00),
(31, 16, 'Regular (M)', 0.00), (32, 16, 'Large (L)', 10000.00),
(33, 17, 'Regular (M)', 0.00), (34, 17, 'Large (L)', 10000.00),
(35, 18, 'Regular (M)', 0.00), (36, 18, 'Large (L)', 10000.00),
(37, 19, 'Regular (M)', 0.00), (38, 19, 'Large (L)', 10000.00),
(39, 20, 'Regular (M)', 0.00), (40, 20, 'Large (L)', 10000.00),
(41, 21, 'Regular (M)', 0.00), (42, 21, 'Large (L)', 10000.00),
(43, 22, 'Regular (M)', 0.00), (44, 22, 'Large (L)', 10000.00),
(45, 23, 'Regular (M)', 0.00), (46, 23, 'Large (L)', 10000.00),
(47, 24, 'Regular (M)', 0.00), (48, 24, 'Large (L)', 10000.00),
(49, 25, 'Regular (M)', 0.00), (50, 25, 'Large (L)', 10000.00),
(51, 26, 'Regular (M)', 0.00), (52, 26, 'Large (L)', 10000.00),
(53, 27, 'Regular (M)', 0.00), (54, 27, 'Large (L)', 10000.00),
(55, 28, 'Regular (M)', 0.00), (56, 28, 'Large (L)', 10000.00),
(57, 29, 'Regular (M)', 0.00), (58, 29, 'Large (L)', 10000.00),
(59, 30, 'Regular (M)', 0.00), (60, 30, 'Large (L)', 10000.00),
(61, 31, 'Regular (M)', 0.00), (62, 31, 'Large (L)', 10000.00),
(63, 32, 'Regular (M)', 0.00), (64, 32, 'Large (L)', 10000.00),
(65, 33, 'Regular (M)', 0.00), (66, 33, 'Large (L)', 10000.00),
(67, 34, 'Regular (M)', 0.00), (68, 34, 'Large (L)', 10000.00),
(69, 35, 'Regular (M)', 0.00), (70, 35, 'Large (L)', 10000.00),
(71, 36, 'Regular (M)', 0.00), (72, 36, 'Large (L)', 10000.00)
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
