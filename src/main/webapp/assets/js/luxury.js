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
            'banner.loyalty_tag': 'Đặc Quyền Hội Viên UTEClub',
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
            'modal.tier_bronze_pts': '0 - 499 pts',
            'modal.tier_bronze_name': 'Thành Viên Khởi Đầu',
            'modal.tier_bronze_desc': 'Kích hoạt ngay khi tạo tài khoản miễn phí tại UTECoffe.',
            'modal.tier_bronze_b1': 'Tặng Voucher 20% đơn hàng đầu tiên',
            'modal.tier_bronze_b2': 'Tích lũy 10% điểm cho mọi đơn hàng',
            'modal.tier_bronze_b3': 'Nhận tin mẻ rang specialty mới sớm nhất',
            'modal.tier_silver_badge': 'HẠNG BẠC',
            'modal.tier_silver_pts': '500 - 1.499 pts',
            'modal.tier_silver_name': 'Hội Viên Bạc',
            'modal.tier_silver_desc': 'Dành cho khách hàng thân thiết thường xuyên ghé thăm.',
            'modal.tier_silver_b1': 'Tất cả quyền lợi Hạng Đồng',
            'modal.tier_silver_b2': 'Tặng Voucher 10% mỗi đầu tháng',
            'modal.tier_silver_b3': 'Miễn phí nâng size (Size L) thứ 5',
            'modal.tier_silver_b4': 'Tặng 1 phần topping tự chọn hàng tháng',
            'modal.tier_gold_popular': 'PHỔ BIẾN NHẤT',
            'modal.tier_gold_badge': 'HẠNG VÀNG',
            'modal.tier_gold_pts': '1.500 - 2.999 pts',
            'modal.tier_gold_name': 'Hội Viên Vàng VIP',
            'modal.tier_gold_desc': 'Trải nghiệm dịch vụ chuyên biệt và ưu đãi giảm giá sâu.',
            'modal.tier_gold_b1': 'Giảm trực tiếp 10% trên toàn bộ thực đơn',
            'modal.tier_gold_b2': '01 Ly cà phê Signature miễn phí dịp Sinh Nhật',
            'modal.tier_gold_b3': 'Ưu tiên giữ bàn đẹp tại VIP Lounge',
            'modal.tier_gold_b4': 'Đổi điểm lấy voucher thanh toán trực tiếp',
            'modal.tier_diamond_badge': 'KIM CƯƠNG',
            'modal.tier_diamond_pts': '3.000+ pts',
            'modal.tier_diamond_name': 'Thượng Khách Kim Cương',
            'modal.tier_diamond_desc': 'Đỉnh cao đặc quyền cá nhân hóa và trải nghiệm roastery độc bản.',
            'modal.tier_diamond_b1': 'Giảm trực tiếp 15% trọn đời mọi đơn hàng',
            'modal.tier_diamond_b2': 'Tặng 01 phần bánh sừng bò thủ công mỗi tuần',
            'modal.tier_diamond_b3': 'Vé mời VIP Private Cupping cùng Master Roaster',
            'modal.tier_diamond_b4': 'Đường dây hỗ trợ & đặt bàn ưu tiên 24/7',
            'modal.btn_close': 'Đóng',
            'modal.btn_details': 'Xem Chi Tiết Đầy Đủ',
            'modal.btn_register': 'Đăng Ký UTEClub Miễn Phí',

            // UTEClub Dedicated Page
            'ute.hero_tag': 'UTECLUB LOYALTY PRIVILEGE',
            'ute.hero_title': 'Đặc Quyền Hội Viên UTEClub',
            'ute.hero_desc': 'Hệ thống tri ân khách hàng thân thiết được thiết kế riêng cho những tâm hồn đồng điệu yêu cà phê đặc sản và trà thượng hạng. Tích lũy 10% cho mọi chi tiêu và tận hưởng đẳng cấp dịch vụ chuẩn quốc tế.',
            'ute.btn_register': 'Đăng Ký Hội Viên Miễn Phí',
            'ute.btn_login': 'Đăng Nhập UTEClub',
            'ute.btn_tier': 'Xem Hạng Thẻ Của Bạn',
            'ute.btn_order': 'Đặt Món Tích Điểm Ngay',
            'ute.pillars_tag': '4 TRỤ CỘT ĐẶC QUYỀN',
            'ute.pillars_title': 'Trải Nghiệm Dịch Vụ Vượt Chuẩn',
            'ute.tiers_tag': 'HỆ THỐNG THĂNG HẠNG',
            'ute.tiers_title': '4 Cấp Bậc Hội Viên Danh Dự',
            'ute.tiers_desc': 'Điểm tích lũy trọn đời được ghi nhận minh bạch trên từng đơn hàng. Khi đạt đủ mốc điểm, hệ thống tự động thăng hạng thẻ và mở khóa đặc quyền mới.',
            'ute.benefits_label': 'Đặc Quyền Bao Gồm:',
            'ute.table_tag': 'BẢNG ĐỐI CHIẾU CHI TIẾT',
            'ute.table_title': 'So Sánh Quyền Lợi Theo Hạng Thẻ',
            'ute.th_privilege': 'Đặc Quyền Hội Viên',
            'ute.th_bronze': 'Đồng (Bronze)',
            'ute.th_silver': 'Bạc (Silver)',
            'ute.th_gold': 'Vàng (Gold)',
            'ute.th_diamond': 'Kim Cương (Diamond)',
            'ute.row_condition': 'Điều kiện tích lũy',
            'ute.row_earning': 'Tỷ lệ tích điểm cho mọi đơn',
            'ute.row_discount': 'Ưu đãi giảm giá trực tiếp trên menu',
            'ute.row_voucher': 'Voucher tặng định kỳ hàng tháng',
            'ute.row_upsize': 'Free Up-size Thứ 5 (Size M lên L)',
            'ute.row_birthday': 'Quà tặng thức uống ngày Sinh Nhật',
            'ute.row_croissant': 'Bánh ngọt thủ công miễn phí mỗi tuần',
            'ute.row_vip': 'Ưu tiên giữ chỗ phòng VIP Lounge',
            'ute.row_cupping': 'Tham gia Roastery Tour & Private Cupping',
            'ute.steps_tag': 'HƯỚNG DẪN THAM GIA',
            'ute.steps_title': '4 Bước Trở Thành Hội Viên UTEClub',
            'ute.step1_title': 'Đăng Ký Miễn Phí',
            'ute.step1_desc': 'Tạo tài khoản trực tuyến chỉ với Email hoặc Số điện thoại trong 30 giây.',
            'ute.step2_title': 'Thưởng Thức Đồ Uống',
            'ute.step2_desc': 'Đặt món trực tuyến hoặc đến trực tiếp chuỗi 3 chi nhánh Flagship.',
            'ute.step3_title': 'Tích Điểm Tự Động',
            'ute.step3_desc': 'Mỗi hóa đơn được hệ thống ghi nhận và tích lũy 10% giá trị ngay lập tức.',
            'ute.step4_title': 'Tận Hưởng Đặc Quyền',
            'ute.step4_desc': 'Thăng hạng thẻ, nhận voucher giảm giá và tận hưởng trọn vẹn đặc quyền.',
            'ute.faq_tag': 'CÂU HỎI THƯỜNG GẶP',
            'ute.faq_title': 'Giải Đáp Về Chương Trình UTEClub',
            'ute.faq1_q': 'Điểm UTEClub được tính như thế nào?',
            'ute.faq1_a': 'Cứ mỗi 1.000 VNĐ chi tiêu thực tế cho đơn hàng hoàn tất (sau khi đã áp dụng mã giảm giá nếu có), bạn sẽ được tích lũy 1 Điểm UTEClub. Điểm số được hệ thống ghi nhận tức thời vào tài khoản cá nhân.',
            'ute.faq2_q': 'Hạng thẻ hội viên có thời hạn sử dụng hay bị hạ hạng không?',
            'ute.faq2_a': 'Điểm tích lũy thăng hạng của UTEClub là điểm trọn đời (Lifetime Points). Khi bạn đã thăng hạng thẻ Bạc, Vàng hoặc Kim Cương, bạn sẽ được duy trì thứ hạng của mình và hưởng trọn vẹn đặc quyền mà không lo lắng bị hạ hạng.',
            'ute.faq3_q': 'Làm thế nào để nhận quà tặng sinh nhật?',
            'ute.faq3_a': 'Thành viên từ Hạng Vàng trở lên chỉ cần cập nhật ngày sinh nhật trong mục Thông tin cá nhân. Vào đúng tháng sinh nhật, hệ thống UTECoffe sẽ tự động gửi mã quà tặng 01 ly đồ uống Signature miễn phí vào ví voucher của bạn.',
            'ute.cta_title': 'Sẵn Sàng Trở Thành Hội Viên UTEClub?',
            'ute.cta_desc': 'Đăng ký ngay hôm nay để nhận Voucher ưu đãi 20% cho đơn hàng đầu tiên và mở khóa hàng loạt đặc quyền ẩm thực tinh hoa.',
            'ute.cta_btn_register': 'Đăng Ký Tài Khoản Miễn Phí',
            'ute.cta_btn_reserve': 'Đặt Bàn Thưởng Thức',

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
            'stores.open_now': 'Đang Mở Cửa',
            'stores.rating': '4.9 (420+ Đánh giá)',
            'stores.everyday': '(Mở cửa hàng ngày)',
            'stores.wifi': 'WiFi Tốc Độ Cao',
            'stores.parking': 'Giữ Xe Miễn Phí',
            'stores.slowbar': 'Slow Bar Pour-Over',
            'stores.directions': 'Chỉ Đường',
            'stores.reserve': 'Đặt Bàn Trước',
            'stores.cupping_title': 'Đặc Quyền Thử Cà Phê Miễn Phí (Cupping Session)',
            'stores.cupping_desc': 'Mỗi sáng thứ Bảy từ 09:00 - 10:30, các Master Roaster của UTECoffe tổ chức buổi chia sẻ và thử nếm các mẻ hạt đặc sản mới hoàn toàn miễn phí cho thành viên UTEClub.',
            'stores.cupping_btn': 'Đăng Ký Tham Gia Cupping Session',
            'story.badge': 'KHỞI NGUỒN TỪ ĐAM MÊ NGUYÊN BẢN',
            'story.desc': 'Tại UTECoffe, chúng tôi tin rằng mỗi tách cà phê là một tác phẩm nghệ thuật sống động, kết tinh từ thổ nhưỡng bazan huyền thoại Cầu Đất 1.600m và sự tỉ mỉ của những nghệ nhân rang mộc thủ công.',
            'story.stat1': 'Độ Cao Thổ Nhưỡng',
            'story.stat2': 'Điểm Cupping Quốc Tế',
            'story.stat3': 'Trái Chín Hái Thủ Công',
            'story.stat4': 'Lên Men Chậm Tự Nhiên',
            'story.ch1_badge': 'Chương I • Thổ Nhưỡng',
            'story.ch1_title': 'Độ Cao 1.600m & Sương Mù Cao Nguyên',
            'story.ch1_p1': 'Cầu Đất - Đà Lạt được mệnh danh là thiên đường của cà phê Arabica hảo hạng tại Việt Nam. Độ cao 1.600m so với mực nước biển cùng biên độ nhiệt ngày đêm lớn giúp hạt cà phê phát triển chậm rãi, cô đọng lượng đường tự nhiên và axit hữu cơ thanh nhã.',
            'story.ch1_p2': 'Chúng tôi trực tiếp liên kết cùng các nông hộ tâm huyết, chỉ thu hoạch những trái chín đỏ 100% bằng tay, đảm bảo độ đồng đều và chất lượng cupping đạt chuẩn Specialty Coffee Association (SCA).',
            'story.ch2_badge': 'Chương II • Kỹ Nghệ Rang',
            'story.ch2_title': 'Nghệ Thuật Đánh Thức Dải Hương Bản Độc',
            'story.ch2_p1': 'Rang cà phê không đơn thuần là xử lý nhiệt; đó là cuộc đối thoại giữa nghệ nhân và hạt mầm tự nhiên. Bằng công nghệ trống rang hiện đại kiểm soát luồng khí và nhiệt độ chuẩn xác từng giây, chúng tôi phát triển tối đa dải hương hoa nhài, cam bergamot, mật ong rừng và socola đen đặc trưng.',
            'story.ch2_p2': 'Mỗi mẻ rang mộc hoàn toàn không tẩm ướp phụ gia hay hương liệu nhân tạo, tôn vinh sự tinh khiết tuyệt đối của nông sản quê hương.',
            'story.ch3_badge': 'Chương III • Nghệ Thuật Chiết Xuất',
            'story.ch3_title': 'Tỷ Lệ Vàng Trong Từng Giọt Cà Phê',
            'story.ch3_p1': 'Từ dòng máy Espresso La Marzocco thủ công đến các bình chiết xuất V60 Hario gốm sứ Nhật Bản, mỗi giọt cà phê chiết xuất tại UTECoffe đều tuân thủ biểu đồ TDS chuẩn mực quốc tế.',
            'story.ch3_p2': 'Kỹ thuật ủ lạnh Specialty Cold Brew kéo dài liên tục 18 đến 24 giờ trong nhiệt độ 4°C giúp chiết tách tối đa vị ngọt hậu và loại bỏ hoàn toàn vị đắng gắt, đem lại trải nghiệm thanh tao như dòng vang hảo hạng.',
            'story.ch4_badge': 'PHỔ HƯƠNG VỊ ĐẶC SẢN',
            'story.ch4_title': 'Dải Hương Độc Bản Của UTECoffe',
            'story.ch4_desc': 'Mỗi mẻ cà phê được đánh giá cupping theo tiêu chuẩn khắt khe với 4 nhóm hương vị đặc trưng:',
            'story.wheel_citrus_title': 'Cam Quýt & Bergamot',
            'story.wheel_citrus_desc': 'Axit citric tự nhiên sáng ngời, gợi nhớ hương cam sành và vỏ chanh vàng thanh nhã.',
            'story.wheel_floral_title': 'Hoa Nhài & Bạch Cúc',
            'story.wheel_floral_desc': 'Hương hoa trắng thoang thoảng nở rộ khi pha Pour-over nóng bốc khói nhẹ nhàng.',
            'story.wheel_honey_title': 'Mật Ong Hoa Cà Phê',
            'story.wheel_honey_desc': 'Hậu vị ngọt sâu kéo dài nơi cuống họng, êm dịu và tròn trịa sau từng ngụm thưởng thức.',
            'story.wheel_choco_title': 'Chocolate Đen & Hạt Nướng',
            'story.wheel_choco_desc': 'Vị đắng êm dịu của cacao nguyên chất hòa quyện nốt hạnh nhân nướng thơm bùi.',
            'story.btn_menu': 'Khám Phá Toàn Bộ Thực Đơn',
            'story.btn_reserve': 'Đặt Bàn Thưởng Thức Tại Quán',

            // Reservation Options & Placeholders
            'res.opt_guest1': '1 Người (Bàn Độc Thoại / Bar Slow Bar)',
            'res.opt_guest2': '2 Người (Bàn Đôi Lãng Mạn)',
            'res.opt_guest4': '3 - 4 Người (Bàn Tiêu Chuẩn)',
            'res.opt_guest6': '5 - 6 Người (Bàn Họp / Nhóm Bạn)',
            'res.opt_guest10': 'Phòng Riêng Private (8 - 12 Người)',
            'res.placeholder_name': 'Nguyễn Văn A',
            'res.placeholder_phone': '0901234567',
            'res.placeholder_special': 'Nhập yêu cầu để chúng tôi chuẩn bị tiếp đón chu đáo nhất...',

            // Cart Extra
            'cart.freeship_notice': 'Đơn hàng từ 150.000₫ được MIỄN PHÍ VẬN CHUYỂN TOÀN QUỐC',
            'cart.freeship_badge': 'FREESHIP',
            'cart.free_text': 'Miễn Phí',

            // Login Page
            'login.title': 'Chào Mừng Trở Lại',
            'login.subtitle': 'Đăng nhập để nhận ưu đãi tích điểm UTEClub',
            'login.error': 'Email hoặc mật khẩu không chính xác!',
            'login.logout_msg': 'Bạn đã đăng xuất an toàn.',
            'login.email_label': 'Email hoặc Số Điện Thoại:',
            'login.placeholder_email': 'admin@utecoffe.vn',
            'login.password_label': 'Mật Khẩu:',
            'login.forgot_password': 'Quên mật khẩu?',
            'login.btn_login': 'Đăng Nhập',
            'login.quick_demo': 'Đăng Nhập Nhanh (Demo)',
            'login.no_account': 'Chưa có tài khoản thành viên?',
            'login.register_now': 'Đăng ký ngay',

            // Register Page
            'reg.title': 'Đăng Ký UTEClub',
            'reg.subtitle': 'Gia nhập cộng đồng người yêu trà & cà phê đặc sản',
            'reg.name_label': 'Họ và Tên:',
            'reg.email_label': 'Địa Chỉ Email:',
            'reg.placeholder_email': 'email@gmail.com',
            'reg.phone_label': 'Số Điện Thoại:',
            'reg.password_label': 'Mật Khẩu:',
            'reg.placeholder_password': 'Ít nhất 6 ký tự',
            'reg.btn_submit': 'Tạo Tài Khoản Thành Viên',
            'reg.has_account': 'Đã có tài khoản?',
            'reg.login_now': 'Đăng nhập',
            'res.badge': 'DỊCH VỤ TIẾP ĐÓN CHU ĐÁO',
            'res.desc': 'Giữ trước vị trí thưởng thức lý tưởng tại UTECoffe để những buổi gặp gỡ, trò chuyện hay làm việc của bạn trở nên trọn vẹn và thư thái nhất.',
            'res.perk_title': 'ĐẶC QUYỀN ĐẶT BÀN TRỰC TUYẾN:',
            'res.perk_desc': 'Mỗi lượt đặt chỗ trực tuyến qua website được tặng kèm 01 shot Cold Brew Cam Vàng Signature dùng thử trước khi bắt đầu thưởng thức.',
            'res.store_label': '1. Chọn Chi Nhánh Thưởng Thức:',
            'res.zone_label': '2. Khu Vực Không Gian Ưa Thích:',
            'res.zone_bar_title': 'Quầy Barista',
            'res.zone_bar_desc': 'Trải nghiệm pha chế',
            'res.zone_lounge_title': 'Sofa VIP Lounge',
            'res.zone_lounge_desc': 'Yên tĩnh, sang trọng',
            'res.zone_garden_title': 'Sân Vườn Xanh',
            'res.zone_garden_desc': 'Thoáng đãng tự nhiên',
            'res.zone_work_title': 'Bàn Co-Working',
            'res.zone_work_desc': 'Ổ điện & WiFi mạnh',
            'res.guests_label': '3. Số Lượng Khách:',
            'res.name_label': 'Họ và Tên Quý Khách:',
            'res.phone_label': 'Số Điện Thoại Xác Nhận:',
            'res.date_label': 'Ngày Thưởng Thức:',
            'res.time_label': 'Khung Giờ Hẹn:',
            'res.special_label': 'Yêu Cầu Đặc Biệt (Trang trí hoa tươi, chuẩn bị cà phê Geisha, bánh kỷ niệm...):',
            'res.submit_btn': 'Xác Nhận Giữ Chỗ Trực Tuyến',

            // Order Tracking Page
            'track.badge': 'TRUYỀN DỮ LIỆU THỜI GIAN THỰC (WEBSOCKET)',
            'track.title': 'Hành Trình Tách Cà Phê Của Bạn',
            'track.code_label': 'Mã Đơn Hàng:',
            'track.time_label': 'Đặt lúc:',
            'track.status_label': 'Trạng Thái Hiện Tại',
            'track.eta_label': 'Dự kiến hoàn tất trong:',
            'track.eta_val': '~15 - 25 Phút',
            'track.step1': 'Tiếp Nhận',
            'track.step1_sub': 'Hệ thống xác nhận',
            'track.step2': 'Pha Chế',
            'track.step2_sub': 'Barista chiết xuất',
            'track.step3': 'Giao Hàng',
            'track.step3_sub': 'Đang trên đường tới',
            'track.step4': 'Thưởng Thức',
            'track.step4_sub': 'Giao thành công',
            'track.barista_note': 'Thông điệp từ quầy Barista:',
            'track.items_title': 'Chi Tiết Thức Uống Đã Đặt',
            'track.col_item': 'Thức Uống',
            'track.col_qty': 'Số Lượng',
            'track.col_total': 'Thành Tiền',
            'track.total_paid': 'Tổng Thanh Toán:',
            'track.shipping_title': 'Thông Tin Giao Nhận',
            'track.recipient': 'Người nhận:',
            'track.address': 'Địa chỉ giao:',
            'track.store': 'Chi nhánh chế biến:',
            'track.payment_method': 'Phương thức thanh toán:',
            'track.btn_support': 'Gọi Hotline CSKH',
            'track.btn_order_more': 'Đặt Thêm Món',

            // Footer Links & Contacts
            'footer.link_coffee': 'Cà Phê Đặc Sản',
            'footer.link_tea': 'Trà Thủ Công',
            'footer.link_coldbrew': 'Cold Brew Ủ Lạnh',
            'footer.link_roast': 'Nghệ Thuật Rang Mộc',
            'footer.link_reserve': 'Đặt Bàn Thưởng Thức',
            'footer.link_uteclub': 'Đặc Quyền UTEClub',
            'footer.link_stores': 'Tìm Cửa Hàng Gần Nhất',
            'footer.link_delivery': 'Giao Hàng Siêu Tốc 30\'',
            'footer.link_refund': 'Chính Sách Hoàn Tiền',
            'footer.link_terms': 'Điều Khoản & Bảo Mật',
            'footer.contact_title': 'Xưởng Rang & Trụ Sở',
            'footer.contact_addr': '01 Võ Văn Ngân, P. Linh Chiểu, TP. Thủ Đức, TP. Hồ Chí Minh',
            'footer.contact_hours': 'Giờ hoạt động: 06:30 - 23:00 (Thứ 2 - Chủ Nhật)',
            'footer.contact_hotline': 'Tổng đài đặt món: 1900 2026',
            'footer.payment_partners': 'Đối tác thanh toán bảo mật:',
            'footer.pay_cash': 'Tiền mặt',

            // Cart Page
            'cart.badge': 'TÚI THƯỞNG THỨC NGHỆ NHÂN',
            'cart.title': 'Giỏ Hàng Thức Uống',
            'cart.desc': 'Mỗi ly cà phê và tách trà đều được pha mới ngay khi nhận đơn để đảm bảo độ tươi và hương vị trọn vẹn nhất.',
            'cart.item_list': 'Danh Sách Thức Uống',
            'cart.add_more': 'Chọn Thêm Món',
            'cart.th_beverage': 'Thức Uống',
            'cart.th_unit_price': 'Đơn Giá',
            'cart.th_quantity': 'Số Lượng',
            'cart.th_total': 'Tạm Tính',
            'cart.order_summary': 'Tóm Tắt Đơn Hàng',
            'cart.voucher_label': 'Mã Ưu Đãi / Voucher:',
            'cart.voucher_apply': 'Áp Dụng',
            'cart.subtotal_label': 'Tổng tiền món:',
            'cart.shipping_label': 'Phí vận chuyển:',
            'cart.discount_label': 'Giảm giá voucher:',
            'cart.final_total_label': 'Thành Tiền:',
            'cart.btn_checkout': 'Tiến Hành Thanh Toán',
            'cart.ssl_notice': 'Thanh toán bảo mật SSL 256-bit',
            'cart.empty_title': 'Giỏ Hàng Của Bạn Đang Trống',
            'cart.empty_desc': 'Hãy khám phá thực đơn cà phê rang mộc thủ công và trà hoa tinh tuyển của UTECoffe để chọn cho mình thức uống ưng ý.',
            'cart.empty_btn': 'Khám Phá Thực Đơn Ngay',

            // Checkout Page
            'checkout.badge': 'BẢO MẬT & CHÍNH XÁC',
            'checkout.title': 'Xác Nhận Đơn Hàng',
            'checkout.desc': 'Quý khách vui lòng kiểm tra kỹ thông tin nhận hàng và phương thức thanh toán trước khi hoàn tất.',
            'checkout.step1': '1. Phương Thức Nhận Thức Uống',
            'checkout.delivery': 'Giao Tận Nơi',
            'checkout.delivery_hint': 'Siêu tốc 20 - 35 phút',
            'checkout.takeaway': 'Lấy Tại Quán',
            'checkout.takeaway_hint': 'Chuẩn bị sẵn không chờ',
            'checkout.store_label': 'Chi Nhánh Chế Biến Thức Uống:',
            'checkout.gps_btn': 'Định Vị Gần Nhất',
            'checkout.name_label': 'Họ và Tên Quý Khách:',
            'checkout.phone_label': 'Số Điện Thoại Nhận Hàng:',
            'checkout.addr_label': 'Địa Chỉ Giao Tận Tay:',
            'checkout.shipper_hint': 'Shipper sẽ gọi điện trước khi giao 5 - 10 phút.',
            'checkout.note_label': 'Ghi Chú Cho Barista / Shipper:',
            'checkout.step2': '2. Cổng Thanh Toán An Toàn',

            // Detail Page
            'detail.terroir_title': 'Hồ Sơ Hương Vị & Xuất Xứ (Terroir)',

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
            'banner.loyalty_tag': 'UTEClub Loyalty Privileges',
            'banner.table_title': 'Online Table Reservation & Automatic Reward Points',
            'banner.table_desc': 'Experience refined roastery spaces across 3 Flagship locations. Earn 10% points on every order to unlock bespoke Silver, Gold, and Diamond privileges.',
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

            // UTEClub Dedicated Page
            'ute.hero_tag': 'UTECLUB LOYALTY PRIVILEGE',
            'ute.hero_title': 'UTEClub Loyalty Privileges',
            'ute.hero_desc': 'A bespoke loyalty sanctuary crafted for connoisseurs of specialty coffee and artisanal tea. Earn 10% points on all purchases and savor world-class hospitality.',
            'ute.btn_register': 'Join UTEClub Free',
            'ute.btn_login': 'Sign In to UTEClub',
            'ute.btn_tier': 'View Your Tier Status',
            'ute.btn_order': 'Order & Earn Points',
            'ute.pillars_tag': '4 CORE PRIVILEGE PILLARS',
            'ute.pillars_title': 'Exceptional Hospitality Experience',
            'ute.tiers_tag': 'TIER PROGRESSION SYSTEM',
            'ute.tiers_title': '4 Honorary Membership Tiers',
            'ute.tiers_desc': 'Lifetime points are recorded transparently on every order. Reaching milestones instantly unlocks higher tiers and bespoke roastery privileges.',
            'ute.benefits_label': 'Included Privileges:',
            'ute.table_tag': 'DETAILED COMPARISON MATRIX',
            'ute.table_title': 'Tier Benefit Comparison',
            'ute.th_privilege': 'Member Privilege',
            'ute.th_bronze': 'Bronze',
            'ute.th_silver': 'Silver',
            'ute.th_gold': 'Gold',
            'ute.th_diamond': 'Diamond',
            'ute.row_condition': 'Qualification Points',
            'ute.row_earning': 'Point Accumulation Rate',
            'ute.row_discount': 'Direct Menu Discount',
            'ute.row_voucher': 'Monthly Gift Voucher',
            'ute.row_upsize': 'Free Up-size Thursday (M to L)',
            'ute.row_birthday': 'Birthday Beverage Gift',
            'ute.row_croissant': 'Weekly Free Artisan Croissant',
            'ute.row_vip': 'VIP Lounge Reservation Priority',
            'ute.row_cupping': 'Private Cupping & Roastery Tour',
            'ute.steps_tag': 'HOW TO JOIN',
            'ute.steps_title': '4 Steps to Join UTEClub',
            'ute.step1_title': 'Free Registration',
            'ute.step1_desc': 'Create an online account in 30 seconds with email or phone.',
            'ute.step2_title': 'Savor Crafted Drinks',
            'ute.step2_desc': 'Order online or visit any of our 3 Flagship roasteries.',
            'ute.step3_title': 'Auto Point Accumulation',
            'ute.step3_desc': 'Every receipt is tracked to automatically earn 10% cash value in points.',
            'ute.step4_title': 'Enjoy Exclusive Privileges',
            'ute.step4_desc': 'Progress through tiers, redeem vouchers, and experience bespoke hospitality.',
            'ute.faq_tag': 'FREQUENTLY ASKED QUESTIONS',
            'ute.faq_title': 'Everything About UTEClub',
            'ute.faq1_q': 'How are UTEClub points calculated?',
            'ute.faq1_a': 'For every 1,000 VND spent on completed orders (after voucher discounts), you earn 1 UTEClub point. Points are credited immediately to your member account.',
            'ute.faq2_q': 'Do membership tiers expire or downgrade?',
            'ute.faq2_a': 'UTEClub tier progression uses Lifetime Points. Once you reach Silver, Gold, or Diamond, your tier is permanent and never downgrades.',
            'ute.faq3_q': 'How do I receive my birthday gift?',
            'ute.faq3_a': 'Gold and Diamond members simply update their birthday in their profile. During your birth month, a voucher for 01 complimentary Signature drink is automatically credited to your voucher wallet.',
            'ute.cta_title': 'Ready to Join UTEClub?',
            'ute.cta_desc': 'Sign up today to receive a 20% welcome discount voucher and unlock exquisite culinary privileges.',
            'ute.cta_btn_register': 'Create Free Account',
            'ute.cta_btn_reserve': 'Reserve a Table',

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
            'stores.open_now': 'Open Now',
            'stores.rating': '4.9 (420+ Reviews)',
            'stores.everyday': '(Open Daily)',
            'stores.wifi': 'High-Speed WiFi',
            'stores.parking': 'Complimentary Parking',
            'stores.slowbar': 'Slow Bar Pour-Over',
            'stores.directions': 'Directions',
            'stores.reserve': 'Reserve Table',
            'stores.cupping_title': 'Complimentary Cupping Session Privilege',
            'stores.cupping_desc': 'Every Saturday from 09:00 - 10:30 AM, UTECoffe Master Roasters host complimentary cupping & tasting sessions of freshly roasted micro-lots exclusively for UTEClub members.',
            'stores.cupping_btn': 'Register for Cupping Session',
            'story.badge': 'BORN FROM AUTHENTIC PASSION',
            'story.desc': 'At UTECoffe, we believe every cup of coffee is a living work of art, born from the legendary 1,600m Cau Dat basalt terroir and the meticulous craft of artisanal roasters.',
            'story.stat1': 'Highland Terroir Altitude',
            'story.stat2': 'International Cupping Score',
            'story.stat3': 'Hand-Picked Ripe Cherries',
            'story.stat4': 'Natural Slow Fermentation',
            'story.ch1_badge': 'Chapter I • Terroir',
            'story.ch1_title': '1,600m Altitude & Misty Highlands',
            'story.ch1_p1': 'Cau Dat - Dalat is celebrated as the paradise of premium Arabica coffee in Vietnam. Perched at 1,600m elevation with vast diurnal temperature variations, coffee cherries mature slowly, concentrating natural sugars and refined organic acidity.',
            'story.ch1_p2': 'We partner directly with dedicated smallholder farmers, hand-harvesting 100% ripe red cherries to ensure exceptional consistency and cupping quality meeting Specialty Coffee Association (SCA) standards.',
            'story.ch2_badge': 'Chapter II • Roasting Craft',
            'story.ch2_title': 'The Art of Awakening Signature Aroma Profiles',
            'story.ch2_p1': 'Coffee roasting is far more than thermal processing; it is a delicate conversation between the artisan roaster and the coffee bean. Utilizing advanced drum technology with precision airflow and temperature control, we develop exquisite notes of white jasmine, bergamot, forest honey, and dark chocolate.',
            'story.ch2_p2': 'Every small micro-batch is 100% artisan roasted with zero artificial flavors or additives, honoring the absolute purity of our highland terroir.',
            'story.ch3_badge': 'Chapter III • Extraction Mastery',
            'story.ch3_title': 'The Golden Ratio in Every Drop of Coffee',
            'story.ch3_p1': 'From handcrafted La Marzocco espresso machines to Japanese Hario ceramic V60 pour-over brewers, every extraction at UTECoffe strictly adheres to international SCA Total Dissolved Solids (TDS) brewing standards.',
            'story.ch3_p2': 'Our Specialty Cold Brew slow-steeps for 18 to 24 continuous hours at 4°C, extracting profound natural sweetness while completely eliminating astringent bitterness for a velvety, wine-like elegance.',
            'story.ch4_badge': 'SPECIALTY FLAVOR SPECTRUM',
            'story.ch4_title': 'UTECoffe Signature Flavor Wheel',
            'story.ch4_desc': 'Each harvested batch undergoes rigorous sensory cupping across 4 distinct aroma clusters:',
            'story.wheel_citrus_title': 'Citrus & Bergamot',
            'story.wheel_citrus_desc': 'Vibrant natural citric brightness reminiscent of ripe oranges and fragrant yellow lemon peel.',
            'story.wheel_floral_title': 'White Jasmine & Chrysanthemum',
            'story.wheel_floral_desc': 'Delicate white floral bouquets wafting gently through steaming pour-over extractions.',
            'story.wheel_honey_title': 'Wild Coffee Blossom Honey',
            'story.wheel_honey_desc': 'Deep, lingering sweet finish coating the palate with smooth, rounded satisfaction.',
            'story.wheel_choco_title': 'Dark Chocolate & Toasted Nuts',
            'story.wheel_choco_desc': 'Gentle, comforting bitterness of pure cocoa intertwined with nutty roasted almond notes.',
            'story.btn_menu': 'Explore Full Menu',
            'story.btn_reserve': 'Reserve a Roastery Table',

            // Reservation Options & Placeholders
            'res.opt_guest1': '1 Guest (Solo Table / Slow Bar)',
            'res.opt_guest2': '2 Guests (Romantic Duo Table)',
            'res.opt_guest4': '3 - 4 Guests (Standard Dining Table)',
            'res.opt_guest6': '5 - 6 Guests (Meeting / Group Table)',
            'res.opt_guest10': 'Private VIP Suite (8 - 12 Guests)',
            'res.placeholder_name': 'John Doe',
            'res.placeholder_phone': '0901234567',
            'res.placeholder_special': 'Enter any special requests so our concierge can prepare attentively...',
            'res.badge': 'ATTENTIVE GUEST CONCIERGE',
            'res.desc': 'Reserve your ideal table in advance at UTECoffe to make your meetings, conversations, or focus sessions smooth and serene.',
            'res.perk_title': 'ONLINE BOOKING PRIVILEGE:',
            'res.perk_desc': 'Every online reservation booked via our website includes 01 complimentary tasting shot of Signature Valencia Orange Cold Brew.',
            'res.store_label': '1. Select Roastery Branch:',
            'res.zone_label': '2. Atmosphere & Seating Area:',
            'res.zone_bar_title': 'Barista Bar',
            'res.zone_bar_desc': 'Interactive brew experience',
            'res.zone_lounge_title': 'VIP Lounge Sofa',
            'res.zone_lounge_desc': 'Quiet & refined luxury',
            'res.zone_garden_title': 'Garden Patio',
            'res.zone_garden_desc': 'Breezy natural greenery',
            'res.zone_work_title': 'Co-Working Table',
            'res.zone_work_desc': 'Power outlets & fast WiFi',
            'res.guests_label': '3. Number of Guests:',
            'res.name_label': 'Full Name:',
            'res.phone_label': 'Confirmation Phone Number:',
            'res.date_label': 'Date of Visit:',
            'res.time_label': 'Time Slot:',
            'res.special_label': 'Special Requests (Floral arrangements, Geisha reserve batch, celebration cake...):',
            'res.submit_btn': 'Confirm Online Table Reservation',

            // Order Tracking Page
            'track.badge': 'REAL-TIME DATA STREAM (WEBSOCKET)',
            'track.title': 'Your Cup of Coffee Journey',
            'track.code_label': 'Order Code:',
            'track.time_label': 'Placed at:',
            'track.status_label': 'Current Status',
            'track.eta_label': 'Estimated completion in:',
            'track.eta_val': '~15 - 25 Minutes',
            'track.step1': 'Received',
            'track.step1_sub': 'System confirmed',
            'track.step2': 'Brewing',
            'track.step2_sub': 'Barista extracting',
            'track.step3': 'Delivery',
            'track.step3_sub': 'En route to you',
            'track.step4': 'Enjoy',
            'track.step4_sub': 'Delivered successfully',
            'track.barista_note': 'Message from Barista Counter:',
            'track.items_title': 'Ordered Drinks & Pastries',
            'track.col_item': 'Item',
            'track.col_qty': 'Qty',
            'track.col_total': 'Subtotal',
            'track.total_paid': 'Total Payment:',
            'track.shipping_title': 'Fulfillment & Delivery Details',
            'track.recipient': 'Recipient:',
            'track.address': 'Delivery Address:',
            'track.store': 'Preparation Roastery:',
            'track.payment_method': 'Payment Method:',
            'track.btn_support': 'Call Support Hotline',
            'track.btn_order_more': 'Order More Drinks',

            // Footer Links & Contacts
            'footer.link_coffee': 'Specialty Coffee',
            'footer.link_tea': 'Artisan Tea',
            'footer.link_coldbrew': 'Craft Cold Brew',
            'footer.link_roast': 'Artisanal Roasting',
            'footer.link_reserve': 'Table Reservation',
            'footer.link_uteclub': 'UTEClub Privileges',
            'footer.link_stores': 'Find Nearest Roastery',
            'footer.link_delivery': 'Express 30\' Delivery',
            'footer.link_refund': 'Refund Policy',
            'footer.link_terms': 'Terms & Privacy',
            'footer.contact_title': 'Roastery & Headquarters',
            'footer.contact_addr': '01 Vo Van Ngan, Linh Chieu, Thu Duc City, HCMC',
            'footer.contact_hours': 'Opening Hours: 06:30 AM - 11:00 PM (Mon - Sun)',
            'footer.contact_hotline': 'Order Hotline: 1900 2026',
            'footer.payment_partners': 'Secure Payment Partners:',
            'footer.pay_cash': 'Cash',

            // Cart Page
            'cart.badge': 'ARTISANAL TASTE BAG',
            'cart.title': 'Beverage Cart',
            'cart.desc': 'Every coffee and tea is freshly brewed upon order to ensure maximum freshness and flavor.',
            'cart.item_list': 'Selected Beverages',
            'cart.add_more': 'Add More Items',
            'cart.th_beverage': 'Beverage',
            'cart.th_unit_price': 'Unit Price',
            'cart.th_quantity': 'Quantity',
            'cart.th_total': 'Subtotal',
            'cart.order_summary': 'Order Summary',
            'cart.voucher_label': 'Promotion / Voucher Code:',
            'cart.voucher_apply': 'Apply',
            'cart.subtotal_label': 'Items Subtotal:',
            'cart.shipping_label': 'Shipping Fee:',
            'cart.discount_label': 'Voucher Discount:',
            'cart.final_total_label': 'Total Amount:',
            'cart.btn_checkout': 'Proceed to Checkout',
            'cart.ssl_notice': '256-bit SSL Secure Payment',
            'cart.empty_title': 'Your Cart is Currently Empty',
            'cart.empty_desc': 'Explore our specialty coffee and artisan tea menu to find your perfect cup.',
            'cart.empty_btn': 'Explore Menu Now',
            'cart.freeship_notice': 'Orders from 150,000₫ qualify for FREE NATIONWIDE SHIPPING',
            'cart.freeship_badge': 'FREESHIP',
            'cart.free_text': 'Free',

            // Login Page
            'login.title': 'Welcome Back',
            'login.subtitle': 'Sign in to access your UTEClub loyalty privileges',
            'login.error': 'Invalid email or password!',
            'login.logout_msg': 'You have been securely signed out.',
            'login.email_label': 'Email or Phone Number:',
            'login.placeholder_email': 'admin@utecoffe.vn',
            'login.password_label': 'Password:',
            'login.forgot_password': 'Forgot password?',
            'login.btn_login': 'Sign In',
            'login.quick_demo': 'Quick Demo Sign In',
            'login.no_account': 'Don\'t have an account yet?',
            'login.register_now': 'Register now',

            // Register Page
            'reg.title': 'Join UTEClub',
            'reg.subtitle': 'Become part of our artisanal specialty coffee & tea community',
            'reg.name_label': 'Full Name:',
            'reg.email_label': 'Email Address:',
            'reg.placeholder_email': 'email@gmail.com',
            'reg.phone_label': 'Phone Number:',
            'reg.password_label': 'Password:',
            'reg.placeholder_password': 'At least 6 characters',
            'reg.btn_submit': 'Create Member Account',
            'reg.has_account': 'Already have an account?',
            'reg.login_now': 'Sign in',

            // Checkout Page
            'checkout.badge': 'SECURE & PRECISE',
            'checkout.title': 'Order Confirmation',
            'checkout.desc': 'Please review your delivery details and preferred payment method before finalizing.',
            'checkout.step1': '1. Fulfillment Method',
            'checkout.delivery': 'Delivery',
            'checkout.delivery_hint': 'Express 20 - 35 mins',
            'checkout.takeaway': 'Pick-up in Store',
            'checkout.takeaway_hint': 'Ready on arrival, zero waiting',
            'checkout.store_label': 'Roastery Processing Branch:',
            'checkout.gps_btn': 'Detect Nearest Branch',
            'checkout.name_label': 'Full Name:',
            'checkout.phone_label': 'Phone Number:',
            'checkout.addr_label': 'Delivery Address:',
            'checkout.shipper_hint': 'Courier will call 5 - 10 minutes prior to delivery.',
            'checkout.note_label': 'Notes for Barista / Shipper:',
            'checkout.step2': '2. Secure Payment Gateway',

            // Detail Page
            'detail.terroir_title': 'Flavor Profile & Terroir Origin',

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
        },
        'croissant-jambon-pho-mai-phap': {
            en_name: 'Artisan French Ham & Melted Cheddar Croissant',
            en_desc: 'Crisp Parisian croissant layered with premium French ham, melted cheddar cheese, and a mild Dijon mustard touch.'
        },
        'banh-tart-dau-tay-qua-mong': {
            en_name: 'Fresh Dalat Berry & Strawberry Tart',
            en_desc: 'Golden almond tart crust filled with French vanilla pastry cream and sweet ripe Dalat strawberries.'
        },
        'croffle-bo-nuong-mat-ong-rung': {
            en_name: 'Wild Honey Glazed Butter Croffle',
            en_desc: 'Pressed croissant waffle caramelized with raw forest honey and fragrant mint blossom glaze.'
        },
        'banh-danish-dao-pho-mai-tuoi': {
            en_name: 'Peach & Fresh Cream Cheese Danish',
            en_desc: 'Flaky thousand-layer Danish pastry filled with velvety cream cheese and juicy golden peach slices.'
        },
        'banh-sourdough-bo-toi-la-thyme': {
            en_name: 'Thyme & Roasted Garlic Butter Sourdough',
            en_desc: '36-hour slow-fermented artisan sourdough stone-baked and brushed with aromatic roasted garlic and fresh thyme butter.'
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

        // Translate option[data-i18n] elements in dropdowns
        document.querySelectorAll('option[data-i18n]').forEach(opt => {
            const key = opt.getAttribute('data-i18n');
            if (dict[key]) {
                opt.text = dict[key];
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
                    el.textContent = '$' + usd;
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
