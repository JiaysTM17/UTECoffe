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
(3, 'UTECoffe Garden Binh Thanh', '180 Ung Van Khiem, Phuong 25, Q. Binh Thanh, TP.HCM', 10.8030, 106.7155, '02835128888', '07:00', '22:30', true, 1)
ON CONFLICT (id) DO NOTHING;

-- 4. Store Tables
INSERT INTO store_tables (id, store_id, table_number, capacity, is_occupied, is_active) VALUES
(1, 1, 'T-01', 2, false, true),
(2, 1, 'T-02', 4, false, true),
(3, 1, 'T-03', 4, false, true),
(4, 1, 'VIP-01', 8, false, true),
(5, 2, 'Q1-01', 2, false, true),
(6, 2, 'Q1-VIP', 6, false, true),
(7, 3, 'BT-01', 2, false, true),
(8, 3, 'BT-GARDEN', 8, false, true)
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
(1, 1, 'Cold Brew Cam Vàng Specialty', 'cold-brew-cam-vang-specialty', 'Cà phê Arabica ủ lạnh 18 tiếng kết hợp nước cam vàng Sunkist mọng nước nguyên chất.', '/assets/images/products/coldbrew-cam-vang.jpg', 59000.00, TRUE, TRUE, NOW(), NOW()),
(2, 1, 'Espresso Tonic Signature', 'espresso-tonic-signature', 'Double shot Espresso Cầu Đất đậm đà trên nền nước tonic cao cấp và lát chanh vàng tươi mát.', 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=800', 55000.00, TRUE, TRUE, NOW(), NOW()),
(3, 1, 'Cà Phê Muối Hoàng Gia', 'ca-phe-muoi-hoang-gia', 'Cà phê Robusta mộc Cầu Đất kết hợp lớp kem béo mặn caramel hoàng gia bùng nổ vị giác.', 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?q=80&w=800', 52000.00, TRUE, TRUE, NOW(), NOW()),
(4, 1, 'Pour-Over V60 Bourbon Cầu Đất', 'pour-over-v60-bourbon-cau-dat', 'Chiết xuất thủ công từng giọt tinh hoa, dải hương hoa nhài trắng và quả mọng thanh khiết.', '/assets/images/products/pourover-v60.jpg', 68000.00, TRUE, FALSE, NOW(), NOW()),
(5, 1, 'Latte Sữa Yến Mạch Oatly', 'latte-sua-yen-mach-oatly', 'Espresso rang mộc hòa quyện sữa yến mạch Oatly Thụy Điển béo bùi, thuần thực vật.', 'https://images.unsplash.com/photo-1534778101976-62847782c213?q=80&w=800', 65000.00, TRUE, FALSE, NOW(), NOW()),
(6, 1, 'Flat White Cầu Đất Double Shot', 'flat-white-cau-dat-double-shot', 'Lớp bọt sữa microfoam mịn màng hòa quyện 2 shot espresso đậm đà thơm ngậy.', 'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?q=80&w=800', 59000.00, TRUE, FALSE, NOW(), NOW()),
(7, 1, 'Affogato Gelato Vani', 'affogato-gelato-vani', 'Single shot Espresso Cầu Đất đậm đà rót trực tiếp trên viên kem gelato vani Madagascar ngọt ngào, tạo độ tương phản nhiệt độ và hương vị đỉnh cao.', '/assets/images/products/affogato.jpg', 55000.00, TRUE, FALSE, NOW(), NOW()),
(8, 1, 'Cà Phê Trứng Hà Nội Specialty', 'ca-phe-trung-ha-noi-specialty', 'Cà phê phin Cầu Đất hòa quyện cùng lớp kem trứng đánh bông mịn như mây, thơm bùi béo ngậy không tanh, chuẩn phong vị hoàng thành.', '/assets/images/products/ca-phe-trung.jpg', 56000.00, TRUE, FALSE, NOW(), NOW()),
(9, 1, 'Cold Brew Ủ Thùng Gỗ Sồi', 'cold-brew-u-thung-go-soi', 'Cà phê Arabica Cầu Đất ủ 48 giờ trong thùng gỗ sồi, tạo tầng hương khói gỗ, vanilla và caramel nồng nàn độc bản.', 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?q=80&w=800', 68000.00, TRUE, TRUE, NOW(), NOW()),
(10, 1, 'Cà Phê Dừa Non Bến Tre', 'ca-phe-dua-non-ben-tre', 'Espresso Cầu Đất đậm đà rót trên nền cốt dừa tươi Bến Tre xay mịn cùng cơm dừa non sấy giòn thơm bùi.', 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=800', 55000.00, TRUE, FALSE, NOW(), NOW()),
(11, 1, 'Cold Brew Sparkling Yuzu', 'cold-brew-sparkling-yuzu', 'Cà phê Arabica Cầu Đất ủ lạnh 24 giờ phối cùng nước ép quả Yuzu Nhật Bản và bọt sủi sparkling thanh mát đánh thức mọi giác quan.', '/assets/images/products/coldbrew-sparkling-yuzu.jpg', 65000.00, TRUE, TRUE, NOW(), NOW()),
(12, 1, 'Cà Phê Bạc Xỉu 4 Tầng Cầu Đất', 'ca-phe-bac-xiu-4-tang-cau-dat', 'Tuyệt phẩm phân tầng thị giác nghệ thuật: sữa đặc thượng hạng, sữa tươi thanh trùng Đà Lạt, cà phê Arabica và bọt microfoam bồng bềnh.', 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?q=80&w=800', 49000.00, TRUE, FALSE, NOW(), NOW()),
(13, 1, 'Single Origin Geisha Panama Pour-Over', 'single-origin-geisha-panama-pour-over', 'Dòng hạt Geisha quý hiếm hàng đầu thế giới được pha thủ công tại bàn, bùng nổ nốt hương hoa cam, quả mơ và mật ong rừng nguyên bản.', 'https://images.unsplash.com/photo-1518057111178-44a106bad636?q=80&w=800', 85000.00, TRUE, FALSE, NOW(), NOW()),
(14, 2, 'Trà Oolong Kem Phô Mai Vàng', 'tra-oolong-kem-phomai-vang', 'Trà Oolong nướng Mộc Châu thơm lừng kết hợp lớp macchiato phô mai béo ngậy sánh mịn đỉnh cao.', 'https://images.unsplash.com/photo-1558160074-4d7d8bdf4256?q=80&w=800', 62000.00, TRUE, TRUE, NOW(), NOW()),
(15, 2, 'Trà Sen Vàng Macchiato Tây Hồ', 'tra-sen-vang-macchiato-tay-ho', 'Trà ướp hoa sen bách diệp Tây Hồ ngát hương, hạt sen tươi hầm mềm bùi và củ năng giòn ngọt.', '/assets/images/products/tra-sen-tay-ho.jpg', 65000.00, TRUE, TRUE, NOW(), NOW()),
(16, 2, 'Trà Nhài Mãng Cầu Đắk Lắk', 'tra-nhai-mang-cau-dak-lak', 'Trà hoa nhài thanh khiết kết hợp những tép mãng cầu xiêm Đắk Lắk dầm chua ngọt thanh mát giải nhiệt.', 'https://images.unsplash.com/photo-1556881286-fc6915169721?q=80&w=800', 55000.00, TRUE, FALSE, NOW(), NOW()),
(17, 2, 'Trà Đào Cam Sả Thảo Mộc', 'tra-dao-cam-sa-thao-moc', 'Hương sả tươi nồng ấm, lát cam vàng mọng nước và từng miếng đào ngâm giòn ngọt quyến rũ.', '/assets/images/products/tra-dao-cam-sa.jpg', 52000.00, TRUE, FALSE, NOW(), NOW()),
(18, 2, 'Matcha Latte Uji Kyoto Nguyên Bản', 'matcha-latte-uji-kyoto', 'Bột trà xanh Uji Kyoto nghiền cối đá truyền thống hòa quyện sữa tươi thanh trùng Đà Lạt ngậy ngọt dịu dàng.', 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?q=80&w=800', 65000.00, TRUE, TRUE, NOW(), NOW()),
(19, 2, 'Trà Sữa Oolong Rang Khói', 'tra-sua-oolong-rang-khoi', 'Trà Oolong sao trên than hoa nồng đượm khói ấm quyện sữa béo ngậy và trân châu hoàng kim dẻo dai.', 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=800', 58000.00, TRUE, FALSE, NOW(), NOW()),
(20, 2, 'Trà Vải Hoa Hồng Damask', 'tra-vai-hoa-hong-damask', 'Trà đen hảo hạng ướp nụ hoa hồng Damask thơm ngát, trái vải mọng nước ngọt ngào quý phái.', '/assets/images/products/tra-vai-hoa-hong.jpg', 58000.00, TRUE, FALSE, NOW(), NOW()),
(21, 2, 'Trà Long Nhãn Hạt Chia Hưng Yên', 'tra-long-nhan-hat-chia-hung-yen', 'Trà đen cổ thụ ướp long nhãn cùi dày ngọt thanh tiến vua Hưng Yên kết hợp hạt chia organic thanh lọc cơ thể.', '/assets/images/products/tra-long-nhan.jpg', 54000.00, TRUE, FALSE, NOW(), NOW()),
(22, 2, 'Hojicha Latte Rang Củi Nhật Bản', 'hojicha-latte-rang-cui-nhat-ban', 'Trà xanh Hojicha sao lửa củi truyền thống Nhật Bản, vị thơm khói bánh nướng đặc trưng kết hợp sữa béo ngậy không caffeine.', 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?q=80&w=800', 62000.00, TRUE, FALSE, NOW(), NOW()),
(23, 2, 'Trà Bưởi Hồng Ruby Mật Ong Bạc Hà', 'tra-buoi-hong-ruby-mat-ong', 'Trà xanh ướp hoa bưởi kết hợp tép bưởi hồng Ruby căng mọng chua ngọt và mật ong hoa bạc hà mát lạnh thanh lọc cơ thể.', 'https://images.unsplash.com/photo-1753719055878-8da0e4d1a021?q=80&w=800', 55000.00, TRUE, FALSE, NOW(), NOW()),
(24, 2, 'Trà Dâu Tây Đà Lạt Macchiato Kem Mặn', 'tra-dau-tay-da-lat-macchiato', 'Nền trà nhài hữu cơ phối cùng dâu tây giống Nhật Bản trồng tại Đà Lạt dầm tươi, phủ lớp kem mặn béo ngậy sánh mịn.', 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?q=80&w=800', 58000.00, TRUE, TRUE, NOW(), NOW()),
(25, 2, 'Trà Thảo Mộc Cúc La Mã & Táo Đỏ', 'tra-thao-moc-cuc-la-ma-tao-do', 'Trà hoa cúc Chamomile hữu cơ kết hợp táo đỏ Tân Cương và kỷ tử ninh nhừ, thơm dịu giúp thư giãn và ngủ ngon sâu giấc.', '/assets/images/products/tra-cuc-la-ma.jpg', 52000.00, TRUE, FALSE, NOW(), NOW()),
(26, 3, 'Croissant Bơ Pháp Thủ Công', 'croissant-bo-phap-thu-cong', 'Bánh sừng bò ngàn lớp nướng giòn rụm với 100% bơ Elle & Vire thơm lừng chuẩn vị Paris.', 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=800', 45000.00, TRUE, TRUE, NOW(), NOW()),
(27, 3, 'Pain Au Chocolat Bơ Tươi', 'pain-au-chocolat-bo-tuoi', 'Bánh cuộn bơ Pháp giòn tan bên ngoài, nhân socola đắng Bỉ tan chảy ngọt ngào bên trong.', '/assets/images/products/pain-au-chocolat.jpg', 48000.00, TRUE, FALSE, NOW(), NOW()),
(28, 3, 'Tiramisu Espresso Mascarpone', 'tiramisu-espresso-mascarpone', 'Bánh Tiramisu Ý truyền thống tẩm đẫm espresso Cầu Đất, phô mai Mascarpone và bột cacao.', 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?q=80&w=800', 58000.00, TRUE, FALSE, NOW(), NOW()),
(29, 3, 'Canelé De Bordeaux Truyền Thống', 'canele-de-bordeaux-truyen-thong', 'Bánh Pháp vỏ caramel giòn sẫm bóng bẩy, ruột mềm ẩm dẻo quánh hương vani và rượu rum.', '/assets/images/products/canele-bordeaux.jpg', 42000.00, TRUE, FALSE, NOW(), NOW()),
(30, 3, 'Mousse Dâu Tằm Rừng Đà Lạt', 'mousse-dau-tam-rung-da-lat', 'Lớp bánh mousse mịn màng chế tác từ dâu tằm rừng Đà Lạt tươi chua ngọt sảng khoái.', '/assets/images/products/mousse-dau-tam.jpg', 52000.00, TRUE, FALSE, NOW(), NOW()),
(31, 3, 'Basque Burnt Cheesecake Nướng Cháy', 'basque-burnt-cheesecake', 'Bánh phô mai nướng cháy xém bề mặt theo phong cách San Sebastián với lớp kem phô mai béo ngậy tan chảy ở tâm.', '/assets/images/products/basque-cheesecake.jpg', 62000.00, TRUE, FALSE, NOW(), NOW()),
(32, 3, 'Bánh Tart Dâu Tây & Quả Mọng', 'banh-tart-dau-tay-qua-mong', 'Vỏ bánh tart bột hạnh nhân nướng vàng giòn, phủ kem pastry vani Pháp và dâu tây tươi Đà Lạt căng mọng.', '/assets/images/products/tart-dau-tay.jpg', 55000.00, TRUE, FALSE, NOW(), NOW()),
(33, 3, 'Croffle Bơ Nướng Mật Ong Rừng', 'croffle-bo-nuong-mat-ong-rung', 'Bánh sừng bò ép waffle nóng giòn phủ lớp đường caramel giòn rụm và mật ong hoa bạc hà nguyên chất thơm lừng.', 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?q=80&w=800', 48000.00, TRUE, FALSE, NOW(), NOW()),
(34, 3, 'Bánh Danish Đào & Phô Mai Tươi', 'banh-danish-dao-pho-mai-tuoi', 'Vỏ bánh nghìn lớp bơ Pháp vàng ươm ôm trọn lớp kem phô mai béo ngậy và miếng đào vàng tươi mọng nước thơm ngọt.', '/assets/images/products/danish-dao.jpg', 46000.00, TRUE, FALSE, NOW(), NOW()),
(35, 3, 'Croissant Kẹp Phô Mai & Jambon Pháp', 'croissant-jambon-pho-mai-phap', 'Bánh sừng bò nướng giòn rụm kẹp thịt nguội Jambon Pháp cao cấp, phô mai Cheddar tan chảy và mù tạt vàng Dijon cay dịu.', '/assets/images/products/croissant-jambon.jpg', 58000.00, TRUE, TRUE, NOW(), NOW()),
(36, 3, 'Bánh Sourdough Bơ Tỏi Lá Thyme', 'banh-sourdough-bo-toi-la-thyme', 'Bánh mì men tự nhiên ủ 36 giờ nướng giòn tan trên đá, phết đẫm bơ Elle & Vire tỏi nướng và lá thyme thơm lừng nức mũi.', 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?q=80&w=800', 45000.00, TRUE, FALSE, NOW(), NOW());

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
