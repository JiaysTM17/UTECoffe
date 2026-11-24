/**
 * UTECoffe Luxury Experience & Interaction Engine
 * Features:
 *  1. Dual Luxury Theme Switcher (Obsidian Espresso & Alabaster Cream)
 *  2. Bilingual i18n Switcher (Vietnamese & English)
 *  3. Dynamic Active Navigation Link Highlighter
 *  4. High-Precision Artisanal Number Counter Animation (IntersectionObserver)
 *  5. Glassmorphism Sticky Navbar Scroll Effect
 */

(function () {
    'use strict';

    // -------------------------------------------------------------------------
    // 1. Bilingual i18n Dictionary
    // -------------------------------------------------------------------------
    const I18N_DICTIONARY = {
        vi: {
            // Top Announcement Bar
            'topbar.location': 'Flagship: 01 Võ Văn Ngân, TP. Thủ Đức, TP.HCM',
            'topbar.promo': 'ƯU ĐÃI 20% ĐƠN ĐẦU TIÊN • FREESHIP TOÀN QUỐC TỪ 150.000₫',
            'topbar.hours': '07:00 - 22:30',
            'topbar.hotline': 'Hotline: 1900 2026',

            // Navigation Menu
            'nav.home': 'Trang Chủ',
            'nav.menu': 'Thực Đơn',
            'nav.story': 'Câu Chuyện',
            'nav.reservation': 'Đặt Bàn',
            'nav.stores': 'Chi Nhánh',
            'nav.cart': 'Giỏ Hàng',
            'nav.login': 'Đăng Nhập',
            'nav.profile': 'Hồ Sơ & UTEClub',
            'nav.admin': 'Trang Quản Trị',
            'nav.kds': 'Quầy Pha Chế KDS',
            'nav.logout': 'Đăng Xuất',

            // Hero Section
            'hero.tag': 'DI SẢN CÀ PHÊ & TRÀ ĐẶC SẢN NGUYÊN BẢN',
            'hero.title': 'Nghệ Thuật Rang Mộc & Tách Cà Phê Hoàn Hảo',
            'hero.desc': 'Tận hưởng tinh hoa từ độ cao 1.600m cao nguyên Cầu Đất. Mỗi hạt cà phê tại UTECoffe được tuyển chọn kỹ lưỡng, rang mộc thủ công từng mẻ nhỏ để lưu giữ trọn vẹn dải hương hoa quả phong phú và hậu vị ngọt sâu.',
            'hero.btn_menu': 'Khám Phá Thực Đơn',
            'hero.btn_reserve': 'Đặt Bàn Thưởng Thức',
            'hero.stat1_label': 'Điểm Cupping Đặc Sản',
            'hero.stat2_label': 'Độ Cao Cầu Đất Terroir',
            'hero.stat3_label': 'Cửa Hàng Flagship',
            'hero.badge_artisan': 'ARTISANAL ROASTERS',

            // Categories Section
            'cat.subtitle': 'BỘ SƯU TẬP TUYỂN CHỌN',
            'cat.title': 'Dòng Thức Uống Đặc Trưng',
            'cat.tea': 'Trà Thượng Hạng',
            'cat.coffee': 'Cà Phê Đặc Sản',
            'cat.pastry': 'Bánh Nghệ Nhân',

            // Featured Products Section
            'feat.subtitle': 'SIGNATURE SELECTION',
            'feat.title': 'Bộ Sưu Tập Mùa Thu Hoạch',
            'feat.view_all': 'Xem Toàn Bộ Thực Đơn',
            'feat.add_cart': 'Thêm Giỏ Hàng',

            // Footer
            'footer.desc': 'Thương hiệu chuỗi bán lẻ trà và cà phê đặc sản nguyên bản kết hợp mô hình thương mại đa kênh OMO hiện đại.',
            'footer.explore': 'Khám Phá',
            'footer.policy': 'Chính Sách & Hỗ Trợ',
            'footer.newsletter': 'Bản Tin Nghệ Nhân',
            'footer.newsletter_desc': 'Đăng ký nhận thông tin mẻ rang mới và ưu đãi hội viên:',
            'footer.subscribe': 'Đăng Ký',
            'footer.rights': 'Bản quyền thuộc về UTECoffe Roastery. Thiết kế & phát triển cho đồ án F&B Thương mại điện tử 2026.',

            // Menu & Products
            'menu.title': 'Thực Đơn Nghệ Nhân',
            'menu.subtitle': 'BỘ SƯU TẬP HƯƠNG VỊ 2026',
            'menu.filter_all': 'Tất Cả Món',
            'menu.original_price': 'Giá nguyên bản:',
            'menu.customize': 'Tùy Chỉnh',
            'terroir.coffee': 'Cao Nguyên Cầu Đất 1.600m',
            'terroir.tea': 'Trà Cổ Thụ & Sen Tây Hồ',
            'terroir.pastry': 'Bơ Pháp Elle & Vire 100%',

            // Customizer & Detail
            'detail.price_label': 'Giá Thưởng Thức:',
            'customizer.title': 'Tùy Chỉnh Khẩu Vị Barista',
            'customizer.badge': 'Chuẩn Vị Nghệ Nhân',
            'customizer.step1': 'Chọn Kích Cỡ Ly:',
            'customizer.step2': 'Mức Đá & Nhiệt Độ:',
            'customizer.step3': 'Mức Đường / Ngọt:',
            'customizer.step4': 'Tùy Chọn Sữa:',
            'customizer.step5': 'Thêm Topping Thượng Hạng:',
            'customizer.pastry_title': 'Tùy Chọn Thưởng Thức Bánh Nghệ Nhân',
            'customizer.pastry_badge': '100% Bơ Pháp Elle & Vire',
            'customizer.pastry_step1': 'Quy Cách Đóng Gói:',
            'customizer.pastry_step2': 'Cách Thức Phục Vụ:',
            'customizer.pastry_step3': 'Sốt & Topping Ăn Kèm:',
            'customizer.tea_title': 'Tùy Chỉnh Hương Vị Trà Đạo',
            'customizer.tea_badge': 'Trà Cổ Thụ & Sen Tây Hồ',
            'customizer.tea_step4': 'Lớp Foam & Sữa:',
            'customizer.tea_step5': 'Topping Trà Thượng Hạng:',
            'customizer.topping_hint': 'Chọn nhiều tùy thích',
            'customizer.add_to_cart': 'Thêm Vào Giỏ Hàng',
            'customizer.view_cart': 'Xem Giỏ Hàng',

            // 4 Artisanal Pillars
            'pillars.subtitle': 'Triết Lý Cà Phê Thủ Công',
            'pillars.title': 'Hành Trình Từ Nông Trại Đến Tách Cà Phê',
            'pillar.terroir_title': 'Terroir 1.600m',
            'pillar.terroir_desc': 'Hạt cà phê phát triển chậm trong sương mù và đất bazan Cầu Đất, tích tụ hương vị hoa quả sâu lắng.',
            'pillar.roast_title': 'Rang Mộc Artisanal',
            'pillar.roast_desc': 'Rang theo mẻ nhỏ (Micro-batch) bằng công nghệ trống rang Giesen cao cấp, giữ vẹn nguyên tính độc bản.',
            'pillar.brew_title': 'Pha Chế Chuẩn Mực',
            'pillar.brew_desc': 'Đội ngũ Barista được đào tạo theo tiêu chuẩn Specialty Coffee Association (SCA) quốc tế.',
            'pillar.space_title': 'Không Gian Roastery',
            'pillar.space_desc': 'Kiến trúc kết hợp hài hòa giữa kim loại trầm ấm, gỗ sồi và hương thơm nồng nàn của mẻ rang mới.',

            // Table Booking & Loyalty Banner
            'banner.loyalty_tag': 'Đặc Quyền Hội Viên UTEClub • Bấm Xem Chi Tiết',
            'banner.table_title': 'Đặt Bàn Trực Tuyến & Tích Điểm Tự Động Cho Mọi Đơn Hàng',
            'banner.table_desc': 'Thưởng thức không gian tinh tế tại 3 chi nhánh Flagship (Thủ Đức, Quận 1, Bình Thạnh). Tích lũy 10% giá trị đơn hàng để nâng hạng thẻ Bạc, Vàng và Kim Cương với hàng loạt đặc quyền vô song.',
            'banner.btn_privilege': 'Xem Đặc Quyền',
            'banner.btn_reserve': 'Đặt Bàn Ngay',

            // UTEClub Modal
            'modal.uteclub_tag': 'UTEClub Loyalty Privilege',
            'modal.uteclub_title': 'Đặc Quyền Hội Viên Danh Dự UTECoffe',
            'modal.pillar1_title': 'Tích 10% Mọi Hóa Đơn',
            'modal.pillar1_desc': 'Mỗi 1.000₫ chi tiêu tích 1 điểm, quy đổi đồ uống và quà tặng cao cấp.',
            'modal.pillar2_title': 'Quà Tặng Sinh Nhật',
            'modal.pillar2_desc': 'Tặng 01 thức uống Signature và thiệp chúc mừng riêng biệt trong tháng sinh nhật.',
            'modal.pillar3_title': 'Free Up-size Thứ 5',
            'modal.pillar3_desc': 'Miễn phí nâng cỡ ly Size M lên Size L trên toàn bộ thực đơn vào mỗi thứ Năm.',
            'modal.pillar4_title': 'Ưu Tiên VIP Lounge',
            'modal.pillar4_desc': 'Giữ chỗ bàn trung tâm và phòng họp riêng tư với hệ thống đặt bàn ưu tiên.',
            'modal.tiers_badge': '4 Hạng Thẻ Hội Viên',
            'modal.tiers_title': 'Hành Trình Thăng Hạng & Tích Lũy',
            'modal.tiers_desc': 'Thăng hạng tức thì theo điểm tích lũy trọn đời (1.000₫ thanh toán = 1 Điểm UTEClub)',
            'modal.tier_bronze_badge': 'HẠNG ĐỒNG',
            'modal.tier_bronze_pts': '0 - 499 điểm',
            'modal.tier_bronze_name': 'Thành Viên Khởi Đầu',
            'modal.tier_bronze_desc': 'Kích hoạt ngay khi tạo tài khoản miễn phí tại UTECoffe.',
            'modal.tier_bronze_b1': 'Tặng Voucher 20% đơn hàng đầu tiên',
            'modal.tier_bronze_b2': 'Tích lũy 10% điểm cho mọi đơn hàng',
            'modal.tier_bronze_b3': 'Nhận tin mẻ rang specialty mới sớm nhất',
            'modal.tier_silver_badge': 'HẠNG BẠC',
            'modal.tier_silver_pts': '500 - 1.499 điểm',
            'modal.tier_silver_name': 'Hội Viên Bạc',
            'modal.tier_silver_desc': 'Dành cho khách hàng thân thiết thường xuyên ghé thăm.',
            'modal.tier_silver_b1': 'Tất cả quyền lợi Hạng Đồng',
            'modal.tier_silver_b2': 'Tặng Voucher 10% mỗi đầu tháng',
            'modal.tier_silver_b3': 'Miễn phí nâng size (Size L) thứ 5',
            'modal.tier_silver_b4': 'Tặng 1 phần topping tự chọn hàng tháng',
            'modal.tier_gold_popular': 'PHỔ BIẾN NHẤT',
            'modal.tier_gold_badge': 'HẠNG VÀNG',
            'modal.tier_gold_pts': '1.500 - 2.999 điểm',
            'modal.tier_gold_name': 'Hội Viên Vàng VIP',
            'modal.tier_gold_desc': 'Trải nghiệm dịch vụ chuyên biệt và ưu đãi giảm giá sâu.',
            'modal.tier_gold_b1': 'Giảm trực tiếp 10% trên toàn bộ thực đơn',
            'modal.tier_gold_b2': '01 Ly cà phê Signature miễn phí dịp Sinh Nhật',
            'modal.tier_gold_b3': 'Ưu tiên giữ bàn đẹp tại VIP Lounge',
            'modal.tier_gold_b4': 'Đổi điểm lấy voucher thanh toán trực tiếp',
            'modal.tier_diamond_badge': 'KIM CƯƠNG',
            'modal.tier_diamond_pts': '3.000+ điểm',
            'modal.tier_diamond_name': 'Thượng Khách Kim Cương',
            'modal.tier_diamond_desc': 'Đỉnh cao đặc quyền cá nhân hóa và trải nghiệm roastery độc bản.',
            'modal.tier_diamond_b1': 'Giảm trực tiếp 15% trọn đời mọi đơn hàng',
            'modal.tier_diamond_b2': 'Tặng 01 phần bánh sừng bò thủ công mỗi tuần',
            'modal.tier_diamond_b3': 'Vé mời VIP Private Cupping cùng Master Roaster',
            'modal.tier_diamond_b4': 'Đường dây hỗ trợ & đặt bàn ưu tiên 24/7',
            'modal.btn_close': 'Đóng',
            'modal.btn_details': 'Xem Chi Tiết Đầy Đủ',
            'modal.btn_register': 'Đăng Ký UTEClub Miễn Phí',

            // Menu Details & Callout
            'menu.hero_desc': 'Trải nghiệm những nốt hương tinh tuyển từ cao nguyên Cầu Đất 1.600m và đồi chè cổ thụ. Mỗi mẻ rang được các Master Roaster chế tác thủ công để tôn vinh sự nguyên bản.',
            'menu.search_placeholder': 'Tìm kiếm cà phê, trà hoa, cold brew, bánh mộc...',
            'menu.taste_btn': '✨ Trải Nghiệm AI Cupping: Tìm Cà Phê Hợp Gu (Sensory Matcher)',
            'menu.taste_title': 'Định Hình Khẩu Vị Cảm Quan (Vector Space Model)',
            'menu.taste_subtitle': 'Thuật toán Cosine Similarity đối chiếu gu của bạn với thông số SCA Cupping của các mẻ rang đặc sản',
            'menu.taste_acidity': 'Độ Chua Thanh (Acidity)',
            'menu.taste_body': 'Thể Chất / Đậm Đà (Body)',
            'menu.taste_sweetness': 'Ngọt Hậu (Sweetness)',
            'menu.taste_bitterness': 'Đắng Dịu (Bitterness)',
            'menu.taste_aroma': 'Hương Hoa / Trái Cây (Aroma)',
            'menu.taste_run': 'PHÂN TÍCH GU CẢM QUAN HOÀN HẢO',
            'menu.taste_result_title': 'Cà Phê Phù Hợp Nhất Với Khẩu Vị Của Bạn:',
            'menu.sort_label': 'Sắp xếp:',
            'menu.empty_title': 'Không Tìm Thấy Món Phù Hợp',
            'menu.empty_desc': 'Rất tiếc chúng tôi chưa tìm thấy thức uống phù hợp với từ khóa của bạn. Hãy thử tìm kiếm từ khóa khác hoặc khám phá toàn bộ thực đơn.',
            'menu.empty_reset': 'Xem Toàn Bộ Thực Đơn',
            'menu.sca_badge': 'Tiêu Chuẩn Quốc Tế SCA',
            'menu.sca_title': 'Tùy Chỉnh Tách Cà Phê Của Riêng Bạn',
            'menu.sca_desc': 'Tất cả thức uống tại UTECoffe đều cho phép cá nhân hóa: Lựa chọn 3 size (S/M/L), thêm các loại hạt, thạch trà thủ công, điều chỉnh độ đậm hạt, hương hoa và tỷ lệ sữa để tạo nên ly cà phê chuẩn gu của bạn.',
            'menu.sca_btn_story': 'Tìm Hiểu Nghệ Thuật Rang Mộc',
            'menu.sca_btn_reserve': 'Đặt Bàn Thưởng Thức Tại Quán',

            // Stores & Story & Reservation
            'stores.subtitle': 'KHÔNG GIAN THƯỞNG THỨC NGHỆ THUẬT',
            'stores.desc': 'Mỗi không gian UTECoffe là sự giao thoa hài hòa giữa kiến trúc tối giản hiện đại và hơi thở mộc mạc của xưởng rang cà phê, mang đến trải nghiệm thưởng thức trọn vẹn mọi giác quan.',
            'stores.filter_all': 'Tất Cả Chi Nhánh',
            'stores.filter_thuduc': 'TP. Thủ Đức (Flagship)',
            'stores.filter_quan1': 'Quận 1 (Trung Tâm)',
            'stores.filter_binhthanh': 'Bình Thạnh (Garden)',
            'stores.btn_gps': 'Tìm Chi Nhánh Gần Nhất',
            'story.badge': 'KHỞI NGUỒN TỪ ĐAM MÊ NGUYÊN BẢN',
            'story.desc': 'Tại UTECoffe, chúng tôi tin rằng mỗi tách cà phê là một tác phẩm nghệ thuật sống động, kết tinh từ thổ nhưỡng bazan huyền thoại Cầu Đất 1.600m và sự tỉ mỉ của những nghệ nhân rang mộc thủ công.',
            'story.stat1': 'Độ Cao Thổ Nhưỡng',
            'story.stat2': 'Điểm Cupping Quốc Tế',
            'story.stat3': 'Trái Chín Hái Thủ Công',
            'story.stat4': 'Lên Men Chậm Tự Nhiên',
            'res.badge': 'DỊCH VỤ TIẾP ĐÓN CHU ĐÁO',
            'res.desc': 'Giữ trước vị trí thưởng thức lý tưởng tại UTECoffe để những buổi gặp gỡ, trò chuyện hay làm việc của bạn trở nên trọn vẹn và thư thái nhất.',
            'res.perk_title': 'ĐẶC QUYỀN ĐẶT BÀN TRỰC TUYẾN:',
            'res.perk_desc': 'Mỗi lượt đặt chỗ trực tuyến qua website được tặng kèm 01 shot Cold Brew Cam Vàng Signature dùng thử trước khi bắt đầu thưởng thức.',

            // In Development Modal
            'in_dev.title': 'Thông Báo Trải Nghiệm',
            'in_dev.default_feature': 'Kênh Truyền Thông Đang Nâng Cấp',
            'in_dev.desc': 'UTECOFFE Official đang trong quá trình hoàn thiện nội dung và chuẩn bị ra mắt độc quyền trên nền tảng này nhằm mang đến trải nghiệm tinh tế và trọn vẹn nhất cho bạn. Xin vui lòng đón chờ trong thời gian sớm nhất!',
            'in_dev.btn_understand': 'Đã Hiểu & Đón Chờ',
            'in_dev.btn_explore': 'Khám Phá Menu'
        },
        en: {
            // Top Announcement Bar
            'topbar.location': 'Flagship: 01 Vo Van Ngan, Thu Duc City, HCMC',
            'topbar.promo': '20% OFF FIRST ORDER • FREE SHIPPING NATIONWIDE OVER 150,000₫',
            'topbar.hours': '07:00 AM - 10:30 PM',
            'topbar.hotline': 'Hotline: 1900 2026',

            // Navigation Menu
            'nav.home': 'Home',
            'nav.menu': 'Menu',
            'nav.story': 'Our Story',
            'nav.reservation': 'Reservations',
            'nav.stores': 'Roasteries',
            'nav.cart': 'Cart',
            'nav.login': 'Sign In',
            'nav.profile': 'Profile & UTEClub',
            'nav.admin': 'Admin Suite',
            'nav.kds': 'Barista KDS',
            'nav.logout': 'Sign Out',

            // Hero Section
            'hero.tag': 'AUTHENTIC SPECIALTY COFFEE & CAMELLIA TEA HERITAGE',
            'hero.title': 'The Art of Artisanal Roasting & The Perfect Cup',
            'hero.desc': 'Savoring perfection from 1,600m Cau Dat highlands. Each coffee bean is ethically harvested, small-batch micro-roasted to preserve exquisite floral aromas, vibrant fruit notes, and a velvety lingering sweetness.',
            'hero.btn_menu': 'Explore Menu',
            'hero.btn_reserve': 'Reserve a Table',
            'hero.stat1_label': 'SCA Cupping Score',
            'hero.stat2_label': 'Highland Terroir Altitude',
            'hero.stat3_label': 'Flagship Roasteries',
            'hero.badge_artisan': 'ARTISANAL ROASTERS',

            // Categories Section
            'cat.subtitle': 'CURATED COLLECTIONS',
            'cat.title': 'Signature Beverage Craft',
            'cat.tea': 'Premier Teas',
            'cat.coffee': 'Specialty Coffees',
            'cat.pastry': 'Artisan Pastries',

            // Featured Products Section
            'feat.subtitle': 'SIGNATURE SELECTION',
            'feat.title': 'Harvest Micro-Lot Series',
            'feat.view_all': 'View Full Menu',
            'feat.add_cart': 'Add to Cart',

            // Footer
            'footer.desc': 'Artisanal specialty coffee & tea roastery with integrated Online-Merge-Offline (OMO) omnichannel experience.',
            'footer.explore': 'Explore',
            'footer.policy': 'Policies & Support',
            'footer.newsletter': 'Roaster Digest',
            'footer.newsletter_desc': 'Subscribe for exclusive fresh batch releases and member privileges:',
            'footer.subscribe': 'Subscribe',
            'footer.rights': 'All rights reserved © UTECoffe Roastery. Designed & developed for 2026 F&B Ecommerce Platform.',

            // Menu & Products
            'menu.title': 'Artisan Menu',
            'menu.subtitle': '2026 FLAVOR SELECTION',
            'menu.filter_all': 'All Items',
            'menu.original_price': 'Original Price:',
            'menu.customize': 'Customize',
            'terroir.coffee': 'Cau Dat Highlands 1,600m',
            'terroir.tea': 'Ancient Camellia & Tay Ho Lotus',
            'terroir.pastry': '100% French Elle & Vire Butter',

            // Customizer & Detail
            'detail.price_label': 'Crafted Price:',
            'customizer.title': 'Barista Taste Customizer',
            'customizer.badge': 'Artisan Precision',
            'customizer.step1': 'Choose Cup Size:',
            'customizer.step2': 'Ice & Temperature:',
            'customizer.step3': 'Sweetness Level:',
            'customizer.step4': 'Milk Selection:',
            'customizer.step5': 'Artisan Toppings:',
            'customizer.pastry_title': 'Artisan Pastry Serving Options',
            'customizer.pastry_badge': '100% French Elle & Vire Butter',
            'customizer.pastry_step1': 'Packaging & Portion:',
            'customizer.pastry_step2': 'Serving Method:',
            'customizer.pastry_step3': 'Sauce & Accompaniment:',
            'customizer.tea_title': 'Artisanal Tea Customizer',
            'customizer.tea_badge': 'Ancient Camellia & Tay Ho Lotus',
            'customizer.tea_step4': 'Foam & Milk Options:',
            'customizer.tea_step5': 'Artisanal Tea Toppings:',
            'customizer.topping_hint': 'Select multiple toppings',
            'customizer.add_to_cart': 'Add to Cart',
            'customizer.view_cart': 'View Cart',

            // 4 Artisanal Pillars
            'pillars.subtitle': 'Artisan Coffee Philosophy',
            'pillars.title': 'The Journey From Farm To Cup',
            'pillar.terroir_title': 'Terroir 1,600m',
            'pillar.terroir_desc': 'Coffee cherries mature slowly in misty Cau Dat basalt soil, concentrating deep floral and fruit notes.',
            'pillar.roast_title': 'Artisanal Drum Roasting',
            'pillar.roast_desc': 'Micro-batch roasted using premium Giesen drum technology to preserve unique origin profiles.',
            'pillar.brew_title': 'SCA Standard Extraction',
            'pillar.brew_desc': 'Baristas rigorously trained and certified under Specialty Coffee Association (SCA) standards.',
            'pillar.space_title': 'Artisan Roastery Space',
            'pillar.space_desc': 'Harmonious architectural blend of brushed metal, aged oak, and the intoxicating scent of fresh roasts.',

            // Table Booking & Loyalty Banner
            'banner.loyalty_tag': 'UTEClub Loyalty Privilege • Click for Details',
            'banner.table_title': 'Online Reservations & Automatic Loyalty Points on Every Order',
            'banner.table_desc': 'Experience refined spaces at 3 Flagship roasteries (Thu Duc, District 1, Binh Thanh). Earn 10% points on every order to unlock Silver, Gold, and Diamond tiers with incomparable privileges.',
            'banner.btn_privilege': 'View Privileges',
            'banner.btn_reserve': 'Reserve Table Now',

            // UTEClub Modal
            'modal.uteclub_tag': 'UTEClub Loyalty Privilege',
            'modal.uteclub_title': 'UTECoffe Honorary Member Privileges',
            'modal.pillar1_title': '10% Cashback on Every Bill',
            'modal.pillar1_desc': 'Every 1,000₫ spent earns 1 point, redeemable for premium beverages and artisanal gifts.',
            'modal.pillar2_title': 'Birthday Celebration Gift',
            'modal.pillar2_desc': 'Complimentary Signature drink and personalized birthday greeting during your birth month.',
            'modal.pillar3_title': 'Free Up-size Every Thursday',
            'modal.pillar3_desc': 'Free cup size upgrade from M to L across the entire menu every Thursday.',
            'modal.pillar4_title': 'VIP Lounge Priority',
            'modal.pillar4_desc': 'Guaranteed prime center table and private meeting suite reservations.',
            'modal.tiers_badge': '4 Membership Tiers',
            'modal.tiers_title': 'Tier Progression & Accumulation Journey',
            'modal.tiers_desc': 'Instant tier progression based on lifetime points (1,000₫ paid = 1 UTEClub Point)',
            'modal.tier_bronze_badge': 'BRONZE TIER',
            'modal.tier_bronze_pts': '0 - 499 pts',
            'modal.tier_bronze_name': 'Starter Member',
            'modal.tier_bronze_desc': 'Activated immediately upon creating a free account at UTECoffe.',
            'modal.tier_bronze_b1': '20% welcome discount voucher for first order',
            'modal.tier_bronze_b2': '10% points accumulation on all purchases',
            'modal.tier_bronze_b3': 'Early access announcements for fresh micro-lot batches',
            'modal.tier_silver_badge': 'SILVER TIER',
            'modal.tier_silver_pts': '500 - 1,499 pts',
            'modal.tier_silver_name': 'Silver Member',
            'modal.tier_silver_desc': 'Dedicated to loyal guests who regularly visit our roasteries.',
            'modal.tier_silver_b1': 'All Bronze tier privileges included',
            'modal.tier_silver_b2': '10% discount voucher at the start of each month',
            'modal.tier_silver_b3': 'Complimentary size upgrade (Size L) every Thursday',
            'modal.tier_silver_b4': '1 complimentary artisan topping choice each month',
            'modal.tier_gold_popular': 'MOST POPULAR',
            'modal.tier_gold_badge': 'GOLD TIER',
            'modal.tier_gold_pts': '1,500 - 2,999 pts',
            'modal.tier_gold_name': 'VIP Gold Member',
            'modal.tier_gold_desc': 'Experience bespoke service and exclusive deep discounts.',
            'modal.tier_gold_b1': 'Direct 10% discount on the entire artisan menu',
            'modal.tier_gold_b2': '01 complimentary Signature beverage on your Birthday',
            'modal.tier_gold_b3': 'Priority prime seating at VIP Lounge',
            'modal.tier_gold_b4': 'Redeem points directly for payment vouchers',
            'modal.tier_diamond_badge': 'DIAMOND TIER',
            'modal.tier_diamond_pts': '3,000+ pts',
            'modal.tier_diamond_name': 'Diamond Connoisseur',
            'modal.tier_diamond_desc': 'Pinnacle of personalized privilege and exclusive roastery craft.',
            'modal.tier_diamond_b1': 'Direct 15% lifetime discount on every order',
            'modal.tier_diamond_b2': '01 complimentary artisan French croissant each week',
            'modal.tier_diamond_b3': 'VIP invitations to Private Cupping with Master Roasters',
            'modal.tier_diamond_b4': 'Dedicated 24/7 concierge & priority table booking',
            'modal.btn_close': 'Close',
            'modal.btn_details': 'View Full Privileges',
            'modal.btn_register': 'Join UTEClub Free',

            // Menu Details & Callout
            'menu.hero_desc': 'Savor exquisite flavor profiles from 1,600m Cau Dat highlands and ancient tea estates. Each batch is micro-roasted by Master Roasters to honor its terroir.',
            'menu.search_placeholder': 'Search specialty coffee, artisan tea, cold brew, pastries...',
            'menu.taste_btn': '✨ AI Cupping Experience: Find Your Coffee Match (Sensory Matcher)',
            'menu.taste_title': 'Sensory Flavor Profiling (Vector Space Model)',
            'menu.taste_subtitle': 'Cosine Similarity algorithm matches your palate against SCA Cupping specs of artisanal micro-lots',
            'menu.taste_acidity': 'Acidity & Brightness',
            'menu.taste_body': 'Body & Mouthfeel',
            'menu.taste_sweetness': 'Sweetness & Aftertaste',
            'menu.taste_bitterness': 'Pleasant Bitterness',
            'menu.taste_aroma': 'Floral & Fruit Aroma',
            'menu.taste_run': 'ANALYZE SENSORY PALATE MATCH',
            'menu.taste_result_title': 'Best Coffee Matches For Your Palate:',
            'menu.sort_label': 'Sort by:',
            'menu.empty_title': 'No Matching Beverages Found',
            'menu.empty_desc': 'We could not find items matching your search. Please try another keyword or explore the full menu.',
            'menu.empty_reset': 'View Entire Menu',
            'menu.sca_badge': 'International SCA Standards',
            'menu.sca_title': 'Craft Your Signature Coffee Cup',
            'menu.sca_desc': 'Every beverage at UTECoffe is fully customizable: Choose from 3 sizes (S/M/L), add artisanal toppings, adjust roast intensity, floral notes, and milk ratios to match your taste.',
            'menu.sca_btn_story': 'Discover Roasting Craftsmanship',
            'menu.sca_btn_reserve': 'Reserve a Table at Roastery',

            // Stores & Story & Reservation
            'stores.subtitle': 'ARTISANAL ROASTERY SPACES',
            'stores.desc': 'Every UTECoffe space harmonizes modern minimalist design with the rustic warmth of an artisanal roastery, delivering a multisensory coffee experience.',
            'stores.filter_all': 'All Locations',
            'stores.filter_thuduc': 'Thu Duc City (Flagship)',
            'stores.filter_quan1': 'District 1 (Downtown)',
            'stores.filter_binhthanh': 'Binh Thanh (Garden)',
            'stores.btn_gps': 'Find Nearest Roastery',
            'story.badge': 'BORN FROM AUTHENTIC PASSION',
            'story.desc': 'At UTECoffe, we believe every cup of coffee is a living work of art, born from the legendary 1,600m Cau Dat basalt terroir and the meticulous craft of artisanal roasters.',
            'story.stat1': 'Highland Terroir Altitude',
            'story.stat2': 'International Cupping Score',
            'story.stat3': 'Hand-Picked Ripe Cherries',
            'story.stat4': 'Natural Slow Fermentation',
            'res.badge': 'ATTENTIVE GUEST CONCIERGE',
            'res.desc': 'Reserve your ideal table in advance at UTECoffe to make your meetings, conversations, or focus sessions smooth and serene.',
            'res.perk_title': 'ONLINE BOOKING PRIVILEGE:',
            'res.perk_desc': 'Every online reservation booked via our website includes 01 complimentary tasting shot of Signature Valencia Orange Cold Brew.',

            // In Development Modal
            'in_dev.title': 'Experience Notice',
            'in_dev.default_feature': 'Official Channel In Development',
            'in_dev.desc': 'UTECOFFE Official is curating exclusive content and preparing to launch on this platform to deliver the most refined experience. Thank you for your patience and support!',
            'in_dev.btn_understand': 'Understood & Anticipating',
            'in_dev.btn_explore': 'Explore Menu'
        }
    };

    // -------------------------------------------------------------------------
    // 2. Theme Management (Dark / Light)
    // -------------------------------------------------------------------------
    function initTheme() {
        const savedTheme = localStorage.getItem('utecoffe_theme') || 'dark';
        applyTheme(savedTheme, false);

        const themeToggleBtn = document.getElementById('themeToggleBtn');
        if (themeToggleBtn) {
            themeToggleBtn.addEventListener('click', function () {
                const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
                const nextTheme = currentTheme === 'dark' ? 'light' : 'dark';
                applyTheme(nextTheme, true);
            });
        }
    }

    function applyTheme(theme, animate) {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('utecoffe_theme', theme);

        // Update Logo Image
        const logoImgs = document.querySelectorAll('#navbarLogo, .brand-logo-img');
        const contextPath = window.UTECOFFE_CONTEXT_PATH || '';
        const darkLogoSrc = contextPath + '/assets/images/logo_dark.svg';
        const lightLogoSrc = contextPath + '/assets/images/logo_light.svg';

        logoImgs.forEach(img => {
            img.src = (theme === 'light') ? lightLogoSrc : darkLogoSrc;
        });

        // Update Theme Button Title
        const themeBtn = document.getElementById('themeToggleBtn');
        if (themeBtn) {
            themeBtn.setAttribute('title', theme === 'dark' ? 'Chuyển sang giao diện Sáng (Alabaster Cream)' : 'Chuyển sang giao diện Tối (Obsidian Espresso)');
        }
    }

    // -------------------------------------------------------------------------
    // 3. Bilingual i18n Management (VN / EN)
    // -------------------------------------------------------------------------
    function initLanguage() {
        const savedLang = localStorage.getItem('utecoffe_lang') || 'vi';
        applyLanguage(savedLang);

        const langButtons = document.querySelectorAll('.btn-lang-toggle');
        langButtons.forEach(btn => {
            btn.addEventListener('click', function () {
                const lang = this.getAttribute('data-lang');
                if (lang) {
                    applyLanguage(lang);
                }
            });
        });
    }

    // Helper: Strip Vietnamese Diacritics
    function removeVietnameseAccents(str) {
        if (!str) return '';
        return str.normalize('NFD')
                  .replace(/[\u0300-\u036f]/g, '')
                  .replace(/đ/g, 'd').replace(/Đ/g, 'D');
    }

    // Comprehensive Bilingual Product Catalog
    const PRODUCT_I18N_CATALOG = {
        // Specialty Coffees
        'cold-brew-cam-vang-specialty': {
            en_name: 'Specialty Cold Brew with Valencia Orange',
            en_desc: '18-hour slow-steeped Arabica paired with fresh, sun-ripened Sunkist orange juice.'
        },
        'espresso-tonic-signature': {
            en_name: 'Espresso Tonic Signature',
            en_desc: 'Robust double-shot Cau Dat espresso layered over crisp premium tonic and fresh lemon slice.'
        },
        'ca-phe-muoi-hoang-gia': {
            en_name: 'Imperial Salted Cream Coffee',
            en_desc: 'Fine Cau Dat Robusta topped with velvety royal salted caramel cream.'
        },
        'pour-over-v60-bourbon-cau-dat': {
            en_name: 'Pour-Over V60 Cau Dat Bourbon',
            en_desc: 'Hand-poured drop by drop; delicate notes of white jasmine and crisp wild berries.'
        },
        'latte-sua-yen-mach-oatly': {
            en_name: 'Oatly Oat Milk Artisan Latte',
            en_desc: 'Rich artisan espresso harmoniously blended with Swedish Oatly oat milk; naturally creamy & 100% plant-based.'
        },
        'flat-white-cau-dat-double-shot': {
            en_name: 'Cau Dat Double Shot Flat White',
            en_desc: 'Silky microfoam milk perfectly steamed with a bold double shot of Cau Dat espresso.'
        },
        'affogato-gelato-vani': {
            en_name: 'Madagascar Vanilla Gelato Affogato',
            en_desc: 'Single shot hot espresso poured over artisanal vanilla gelato for a sublime temperature contrast.'
        },
        'ca-phe-trung-ha-noi-specialty': {
            en_name: 'Hanoi Egg Cream Coffee Specialty',
            en_desc: 'Traditional phin coffee crowned with fluffy, cloud-like sweet egg foam; rich, velvety and authentic.'
        },
        'cold-brew-u-thung-go-soi': {
            en_name: 'Oak Barrel Aged Cold Brew',
            en_desc: 'Cau Dat Arabica slow-steeped 48 hours in charred oak barrels; deep vanilla, smoke and caramel notes.'
        },
        'ca-phe-dua-non-ben-tre': {
            en_name: 'Ben Tre Tender Coconut Coffee',
            en_desc: 'Artisan espresso over freshly blended Ben Tre young coconut milk topped with toasted coconut crisps.'
        },
        'cold-brew-sparkling-yuzu': {
            en_name: 'Sparkling Yuzu Cold Brew',
            en_desc: '24-hour steeped cold brew infused with Japanese Yuzu citrus and effervescent sparkling bubbles.'
        },
        'ca-phe-bac-xiu-4-tang-cau-dat': {
            en_name: '4-Layer Artisanal Bac Xiu',
            en_desc: 'Four-tiered visual masterpiece: premium condensed milk, fresh Dalat milk, espresso, and silky microfoam.'
        },
        'single-origin-geisha-panama-pour-over': {
            en_name: 'Panama Geisha Single-Origin Pour-Over',
            en_desc: 'World-renowned rare Geisha varietal hand-brewed at your table; blooming orange blossoms, apricot and raw honey.'
        },

        // Artisanal Teas
        'tra-oolong-kem-phomai-vang': {
            en_name: 'Roasted Oolong with Golden Cheese Foam',
            en_desc: 'Charcoal-roasted Moc Chau Oolong topped with a luscious savory cheese macchiato crown.'
        },
        'tra-sen-vang-macchiato-tay-ho': {
            en_name: 'Royal Tay Ho Lotus Macchiato Tea',
            en_desc: 'Fragrant West Lake lotus tea served with tender lotus seeds, crunchy water chestnuts, and silky cream foam.'
        },
        'tra-nhai-mang-cau-dak-lak': {
            en_name: 'Jasmine Soursop Refreshing Tea',
            en_desc: 'Pure jasmine green tea paired with crushed sweet-tart Dak Lak soursop pulp.'
        },
        'tra-dao-cam-sa-thao-moc': {
            en_name: 'Botanical Peach Orange Lemongrass Tea',
            en_desc: 'Fresh warm lemongrass, sun-kissed juicy orange slices, and sweet crisp marinated peach slices.'
        },
        'matcha-latte-uji-kyoto': {
            en_name: 'Ceremonial Uji Kyoto Matcha Latte',
            en_desc: 'Authentic stone-ground ceremonial matcha from Uji, Kyoto blended with velvety fresh Dalat milk.'
        },
        'tra-sua-oolong-rang-khoi': {
            en_name: 'Smoked Roasted Oolong Milk Tea',
            en_desc: 'Charcoal-fired roasted Oolong tea married with rich dairy milk and chewy golden boba pearls.'
        },
        'tra-vai-hoa-hong-damask': {
            en_name: 'Damascus Rose & Lychee Royal Tea',
            en_desc: 'Artisan black tea scented with Damascus rosebuds and infused with luscious, sweet lychee fruit.'
        },
        'tra-long-nhan-hat-chia-hung-yen': {
            en_name: 'Hung Yen Longan & Chia Wellness Tea',
            en_desc: 'Ancient black tea with royal Hung Yen thick-fleshed longan fruit and organic chia seeds.'
        },
        'hojicha-latte-rang-cui-nhat-ban': {
            en_name: 'Wood-Fired Japanese Hojicha Latte',
            en_desc: 'Traditional wood-roasted Japanese Hojicha green tea; nutty, toasty aroma with minimal caffeine.'
        },
        'tra-buoi-hong-ruby-mat-ong': {
            en_name: 'Ruby Pink Grapefruit & Wild Mint Honey Tea',
            en_desc: 'Floral green tea mixed with juicy Ruby grapefruit pulp and refreshing cool mint blossom honey.'
        },
        'tra-dau-tay-da-lat-macchiato': {
            en_name: 'Dalat Fresh Strawberry Macchiato',
            en_desc: 'Organic jasmine tea base combined with muddled Japanese-variety Dalat strawberries, topped with salted cream.'
        },
        'tra-thao-moc-cuc-la-ma-tao-do': {
            en_name: 'Chamomile, Jujube & Goji Berry Herbal Tea',
            en_desc: 'Soothing organic Chamomile blossoms infused with slow-simmered Xinjiang red dates and goji berries.'
        },

        // Pastries
        'croissant-bo-phap-thu-cong': {
            en_name: 'Handcrafted French Butter Croissant',
            en_desc: 'Flaky thousand-layer croissant baked with 100% Elle & Vire French butter for true Parisian flavor.'
        },
        'pain-au-chocolat-bo-tuoi': {
            en_name: 'Fresh Butter Pain au Chocolat',
            en_desc: 'Crisp Parisian laminated pastry rolled with rich molten Belgian dark chocolate batons.'
        },
        'tiramisu-espresso-mascarpone': {
            en_name: 'Espresso Mascarpone Artisan Tiramisu',
            en_desc: 'Classic Italian ladyfingers steeped in Cau Dat espresso, layered with silky mascarpone and cocoa.'
        },
        'canele-de-bordeaux-truyen-thong': {
            en_name: 'Traditional Canelé de Bordeaux',
            en_desc: 'Caramelized crisp dark crust enveloping a soft, custardy center infused with pure vanilla and dark rum.'
        },
        'mousse-dau-tam-rung-da-lat': {
            en_name: 'Dalat Wild Mulberry Velvet Mousse',
            en_desc: 'Delicate, airy mousse crafted from fresh wild Dalat mulberries with a refreshing sweet-tart profile.'
        },
        'basque-burnt-cheesecake': {
            en_name: 'Basque Burnt Cheesecake San Sebastián',
            en_desc: 'San Sebastián-style caramelized burnt top with an ultra-creamy, molten cheesecake core.'
        }
    };

    const CATEGORY_I18N = {
        'Cà Phê Đặc Sản': 'Specialty Coffee',
        'Trà Thượng Hạng': 'Artisan Tea',
        'Bánh Ngọt Thủ Công': 'Artisan Pastry',
        'Bánh Nghệ Nhân': 'Artisan Pastry',
        'Rang Mộc': 'Artisan Roasted',
        'Bán Chạy': 'Best Seller',
        'Signature': 'Signature',
        'Đang Hoạt Động': 'Operational'
    };

    function applyLanguage(lang) {
        localStorage.setItem('utecoffe_lang', lang);

        // Update Toggle Buttons
        document.querySelectorAll('.btn-lang-toggle').forEach(btn => {
            if (btn.getAttribute('data-lang') === lang) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });

        // Translate data-i18n elements
        const dict = I18N_DICTIONARY[lang] || I18N_DICTIONARY.vi;
        document.querySelectorAll('[data-i18n]').forEach(el => {
            const key = el.getAttribute('data-i18n');
            if (dict[key]) {
                el.textContent = dict[key];
            }
        });

        // Translate data-i18n-placeholder elements
        document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
            const key = el.getAttribute('data-i18n-placeholder');
            if (dict[key]) {
                el.setAttribute('placeholder', dict[key]);
            }
        });

        // Translate Category Filter Buttons
        document.querySelectorAll('.filter-btn[data-category-name]').forEach(el => {
            const name = el.getAttribute('data-category-name');
            if (lang === 'en') {
                el.textContent = CATEGORY_I18N[name] || removeVietnameseAccents(name);
            } else {
                el.textContent = name;
            }
        });

        // Translate Product Titles
        document.querySelectorAll('.product-title-text').forEach(el => {
            const slug = el.getAttribute('data-slug');
            if (!el.getAttribute('data-vi-title')) {
                el.setAttribute('data-vi-title', el.textContent.trim());
            }
            if (lang === 'en') {
                if (PRODUCT_I18N_CATALOG[slug] && PRODUCT_I18N_CATALOG[slug].en_name) {
                    el.textContent = PRODUCT_I18N_CATALOG[slug].en_name;
                } else {
                    el.textContent = removeVietnameseAccents(el.getAttribute('data-vi-title'));
                }
            } else {
                el.textContent = el.getAttribute('data-vi-title');
            }
        });

        // Translate Product Descriptions
        document.querySelectorAll('.product-desc-text').forEach(el => {
            const slug = el.getAttribute('data-slug');
            if (!el.getAttribute('data-vi-desc')) {
                el.setAttribute('data-vi-desc', el.textContent.trim());
            }
            if (lang === 'en') {
                if (PRODUCT_I18N_CATALOG[slug] && PRODUCT_I18N_CATALOG[slug].en_desc) {
                    el.textContent = PRODUCT_I18N_CATALOG[slug].en_desc;
                } else {
                    el.textContent = removeVietnameseAccents(el.getAttribute('data-vi-desc'));
                }
            } else {
                el.textContent = el.getAttribute('data-vi-desc');
            }
        });

        // Translate Category Badges
        document.querySelectorAll('.product-category-badge').forEach(el => {
            if (!el.getAttribute('data-vi-cat')) {
                el.setAttribute('data-vi-cat', el.textContent.trim());
            }
            const vi = el.getAttribute('data-vi-cat');
            if (lang === 'en') {
                el.textContent = CATEGORY_I18N[vi] || removeVietnameseAccents(vi);
            } else {
                el.textContent = vi;
            }
        });

        // Translate Special Badges (Rang Mộc, Bán Chạy)
        document.querySelectorAll('.roast-badge').forEach(el => {
            if (lang === 'en') {
                el.innerHTML = '<i class="fa-solid fa-fire-flame-curved me-1 text-gold"></i> Artisan Roasted';
            } else {
                el.innerHTML = '<i class="fa-solid fa-fire-flame-curved me-1 text-gold"></i> Rang Mộc';
            }
        });

        document.querySelectorAll('.badge-luxury-tag').forEach(el => {
            if (lang === 'en') {
                el.innerHTML = '<i class="fa-solid fa-star text-gold me-1"></i> Best Seller';
            } else {
                el.innerHTML = '<i class="fa-solid fa-star text-gold me-1"></i> Bán Chạy';
            }
        });

        // Translate Menu Sort Dropdown
        const sortSelect = document.getElementById('menuSortSelect');
        if (sortSelect) {
            const opt = sortSelect.options;
            if (lang === 'en') {
                if (opt[0]) opt[0].text = 'Featured Selection';
                if (opt[1]) opt[1].text = 'Price: Low → High';
                if (opt[2]) opt[2].text = 'Price: High → Low';
                if (opt[3]) opt[3].text = 'Name: A → Z';
            } else {
                if (opt[0]) opt[0].text = 'Nổi bật nhất';
                if (opt[1]) opt[1].text = 'Giá: Thấp → Cao';
                if (opt[2]) opt[2].text = 'Giá: Cao → Thấp';
                if (opt[3]) opt[3].text = 'Tên: A → Z';
            }
        }

        // Translate & Convert Currency (1 USD = 24,500 VND)
        const RATE = 24500;
        document.querySelectorAll('[data-raw-price], [data-vnd], .product-price-val').forEach(el => {
            let vnd = parseFloat(el.getAttribute('data-vnd') || el.getAttribute('data-raw-price'));
            if (isNaN(vnd) || vnd <= 0) {
                // Try parse from text content
                const matched = el.textContent.replace(/[^0-9]/g, '');
                if (matched) {
                    vnd = parseFloat(matched);
                    el.setAttribute('data-vnd', vnd);
                }
            }
            if (!isNaN(vnd) && vnd > 0) {
                if (lang === 'en') {
                    const usd = (vnd / RATE).toFixed(2);
                    el.textContent = '$' + usd + ' USD';
                } else {
                    el.textContent = Math.round(vnd).toLocaleString('vi-VN') + ' VNĐ';
                }
            }
        });

        // Update document lang attribute
        document.documentElement.setAttribute('lang', lang);

        // Notify page-specific listeners
        window.dispatchEvent(new CustomEvent('utecoffe:langchange', { detail: { lang } }));
    }

    // -------------------------------------------------------------------------
    // 4. Dynamic Active Navigation Link Highlighter
    // -------------------------------------------------------------------------
    function initActiveNavLinks() {
        const currentPath = window.location.pathname.replace(/\/$/, '') || '/';
        const navLinks = document.querySelectorAll('.nav-link-luxury');

        navLinks.forEach(link => {
            const href = link.getAttribute('href');
            if (!href) return;

            try {
                const url = new URL(href, window.location.origin);
                const linkPath = url.pathname.replace(/\/$/, '') || '/';

                // Exact match or sub-route match
                if (linkPath === currentPath) {
                    link.classList.add('active');
                } else if (linkPath !== '/' && currentPath.startsWith(linkPath)) {
                    link.classList.add('active');
                } else {
                    link.classList.remove('active');
                }
            } catch (e) {
                // Ignore parse errors for anchors
            }
        });
    }

    // -------------------------------------------------------------------------
    // 5. Artisanal Number Counter Animation
    // -------------------------------------------------------------------------
    function initCounterAnimation() {
        const counters = document.querySelectorAll('[data-counter]');
        if (!counters.length) return;

        const observerOptions = {
            threshold: 0.25,
            rootMargin: '0px 0px -40px 0px'
        };

        const counterObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const el = entry.target;
                    animateCounter(el);
                    observer.unobserve(el);
                }
            });
        }, observerOptions);

        counters.forEach(counter => counterObserver.observe(counter));
    }

    function animateCounter(el) {
        const targetValue = parseFloat(el.getAttribute('data-counter')) || 0;
        const prefix = el.getAttribute('data-counter-prefix') || '';
        const suffix = el.getAttribute('data-counter-suffix') || '';
        const isDecimal = targetValue % 1 !== 0;
        const hasCommaFormat = el.getAttribute('data-counter-format') === 'comma';
        const duration = parseInt(el.getAttribute('data-counter-duration')) || 1800; // ms

        const startTime = performance.now();

        function updateCounter(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);

            // Ease Out Cubic function: 1 - pow(1 - x, 3)
            const easeProgress = 1 - Math.pow(1 - progress, 3);
            const currentValue = targetValue * easeProgress;

            let formattedValue;
            if (isDecimal) {
                formattedValue = currentValue.toFixed(1);
            } else {
                formattedValue = Math.floor(currentValue);
            }

            if (hasCommaFormat) {
                // e.g. 1,600 or 1.600
                formattedValue = formattedValue.toLocaleString('vi-VN');
            }

            el.textContent = prefix + formattedValue + suffix;

            if (progress < 1) {
                requestAnimationFrame(updateCounter);
            } else {
                let finalFormatted = isDecimal ? targetValue.toFixed(1) : targetValue;
                if (hasCommaFormat) {
                    finalFormatted = finalFormatted.toLocaleString('vi-VN');
                }
                el.textContent = prefix + finalFormatted + suffix;
            }
        }

        requestAnimationFrame(updateCounter);
    }

    // -------------------------------------------------------------------------
    // 6. Sticky Navbar Scrolled Effect
    // -------------------------------------------------------------------------
    function initNavbarScroll() {
        const navbar = document.querySelector('.navbar-luxury');
        if (!navbar) return;

        window.addEventListener('scroll', function () {
            if (window.scrollY > 30) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        }, { passive: true });
    }

    // -------------------------------------------------------------------------
    // Initialize All Features on DOMContentLoaded
    // -------------------------------------------------------------------------
    document.addEventListener('DOMContentLoaded', function () {
        initTheme();
        initLanguage();
        initActiveNavLinks();
        initCounterAnimation();
        initNavbarScroll();
    });

})();
