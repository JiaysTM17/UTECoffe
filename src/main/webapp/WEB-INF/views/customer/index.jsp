<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Trang Chủ - UTECoffe Specialty Tea &amp; Coffee Roastery</title>
</head>
<body>

    <!-- Cinematic Hero Section -->
    <section class="hero-luxury py-5 position-relative">
        <div class="container py-lg-5">
            <div class="row align-items-center g-5">
                <div class="col-lg-7">
                    <div class="d-inline-flex align-items-center gap-2 px-3 py-1 rounded-pill mb-3 border border-gold" style="background: var(--gold-subtle);">
                        <i class="fa-solid fa-sparkles text-gold small"></i>
                        <span class="text-gold font-accent fw-bold small text-uppercase" style="letter-spacing: 0.15em;" data-i18n="hero.tag">Di Sản Cà Phê &amp; Trà Đặc Sản Nguyên Bản</span>
                    </div>
                    <h1 class="display-3 fw-bold font-serif mb-3 text-gold-gradient" style="line-height: 1.15;" data-i18n="hero.title">
                        Nghệ Thuật Rang Mộc &amp; Tách Cà Phê Hoàn Hảo
                    </h1>
                    <p class="lead text-secondary mb-4 pe-lg-4" style="font-weight: 300;" data-i18n="hero.desc">
                        Tận hưởng tinh hoa từ độ cao 1.600m cao nguyên Cầu Đất. Mỗi hạt cà phê tại UTECoffe được tuyển chọn kỹ lưỡng, rang mộc thủ công từng mẻ nhỏ để lưu giữ trọn vẹn dải hương hoa quả phong phú và hậu vị ngọt sâu.
                    </p>
                    <div class="d-flex flex-wrap gap-3 mb-5">
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold">
                            <i class="fa-solid fa-mug-hot me-1"></i> <span data-i18n="hero.btn_menu">Khám Phá Thực Đơn</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/reservation" class="btn btn-outline-gold">
                            <i class="fa-solid fa-calendar-check me-1"></i> <span data-i18n="hero.btn_reserve">Đặt Bàn Thưởng Thức</span>
                        </a>
                    </div>

                    <!-- Roastery Highlights Strip with High-Precision Counter Animation -->
                    <div class="row g-3 pt-4 border-top border-gold">
                        <div class="col-sm-4 col-6">
                            <div class="hero-stat-card">
                                <h3 class="font-serif text-gold fw-bold mb-1">
                                    <span class="counter-metric" data-counter="85" data-counter-suffix="+">85+</span> SCA
                                </h3>
                                <div class="text-secondary text-uppercase font-accent fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.08em;" data-i18n="hero.stat1_label">
                                    Điểm Cupping Đặc Sản
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4 col-6">
                            <div class="hero-stat-card">
                                <h3 class="font-serif text-gold fw-bold mb-1">
                                    <span class="counter-metric" data-counter="1600" data-counter-format="comma" data-counter-suffix="m">1.600m</span>
                                </h3>
                                <div class="text-secondary text-uppercase font-accent fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.08em;" data-i18n="hero.stat2_label">
                                    Độ Cao Cầu Đất Terroir
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4 col-6">
                            <div class="hero-stat-card">
                                <h3 class="font-serif text-gold fw-bold mb-1">
                                    <span class="counter-metric" data-counter="3" data-counter-suffix="">03</span>
                                </h3>
                                <div class="text-secondary text-uppercase font-accent fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.08em;" data-i18n="hero.stat3_label">
                                    Cửa Hàng Flagship
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5 text-center">
                    <div class="position-relative d-inline-block">
                        <div class="card-luxury p-3 shadow-lg" style="border-radius: 30px;">
                            <img src="https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=700&q=80" 
                                 alt="UTECOFFE Signature Pour Over" class="img-fluid rounded-4 shadow" style="max-height: 480px; object-fit: cover;">
                        </div>
                        <div class="badge-luxury-tag px-3 py-2 fs-6 shadow pulse-gold" style="top: -15px; right: -15px; left: auto;">
                            <i class="fa-solid fa-award text-gold me-1"></i> <span data-i18n="hero.badge_artisan">Artisanal Roasters</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Signature Seasonal Menu Highlights -->
    <section class="py-5 bg-dark-roast">
        <div class="container py-4">
            <div class="section-title-wrap">
                <span class="section-subtitle" data-i18n="feat.subtitle">Bộ Sưu Tập Tuyển Chọn</span>
                <h2 class="section-title" data-i18n="feat.title">Thức Uống Đặc Sản Nổi Bật</h2>
                <div class="gold-divider"></div>
            </div>

            <div class="row g-4">
                <c:forEach var="prod" items="${featuredProducts}" varStatus="status">
                    <div class="col-lg-3 col-md-6">
                        <div class="card card-luxury h-100 d-flex flex-column">
                            <a href="${pageContext.request.contextPath}/menu/${prod.slug}" class="product-image-container d-block text-decoration-none position-relative" style="cursor: pointer;" title="${prod.name} - Khám phá câu chuyện &amp; thành phần">
                                <img src="${not empty prod.imageUrl ? prod.imageUrl : 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=500&q=80'}" 
                                     alt="${prod.name}">
                                <c:if test="${prod.isFeatured}">
                                    <span class="badge-luxury-tag"><i class="fa-solid fa-star text-gold me-1"></i> Bán Chạy</span>
                                </c:if>
                            </a>
                            <div class="card-body p-4 d-flex flex-column flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="text-gold font-accent small text-uppercase product-category-badge" style="letter-spacing: 0.1em;" data-category-name="${prod.category.name}">${prod.category.name}</span>
                                    <span class="badge bg-espresso text-secondary small border border-gold roast-badge"><i class="fa-solid fa-fire-flame-curved me-1 text-gold"></i> Rang Mộc</span>
                                </div>
                                <h5 class="font-serif fw-bold mb-2" style="min-height: 2.85rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                    <a href="${pageContext.request.contextPath}/menu/${prod.slug}" class="text-primary text-decoration-none hover-gold product-title-text" data-slug="${prod.slug}">${prod.name}</a>
                                </h5>
                                <p class="text-secondary small mb-3 product-desc-text" style="min-height: 2.85rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;" data-slug="${prod.slug}">
                                    ${not empty prod.description ? prod.description : 'Hương vị nguyên bản từ hạt Arabica chín cây tuyển chọn, kết hợp kỹ thuật pha thủ công tinh tế.'}
                                </p>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top border-gold mt-auto gap-2">
                                    <span class="price-gold product-price-val fs-6 fw-bold text-nowrap" data-raw-price="${prod.basePrice}" data-vnd="${prod.basePrice}"><fmt:formatNumber value="${prod.basePrice}" pattern="#,##0"/> VNĐ</span>
                                    <a href="${pageContext.request.contextPath}/menu/${prod.slug}" class="btn btn-gold btn-sm px-3 rounded-pill text-nowrap font-accent fw-semibold">
                                        <i class="fa-solid fa-sliders me-1"></i> <span data-i18n="feat.add_cart">Thêm Giỏ Hàng</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="text-center mt-5">
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-gold px-4 py-2">
                    <span data-i18n="feat.view_all">Xem Toàn Bộ Thực Đơn Đặc Sản</span> <i class="fa-solid fa-arrow-right ms-2"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- 4 Pillars of Artisanal Craftsmanship -->
    <section class="py-5 bg-obsidian border-top border-gold">
        <div class="container py-4">
            <div class="section-title-wrap">
                <span class="section-subtitle" data-i18n="pillars.subtitle">Triết Lý Cà Phê Thủ Công</span>
                <h2 class="section-title" data-i18n="pillars.title">Hành Trình Từ Nông Trại Đến Tách Cà Phê</h2>
                <div class="gold-divider"></div>
            </div>

            <div class="row g-4">
                <div class="col-md-3 col-sm-6">
                    <div class="card-luxury p-4 text-center h-100">
                        <div class="d-inline-flex p-3 rounded-circle mb-3 border border-gold" style="background: var(--gold-subtle);">
                            <i class="fa-solid fa-mountain text-gold fs-3"></i>
                        </div>
                        <h5 class="font-serif fw-bold mb-2 text-primary" data-i18n="pillar.terroir_title">Terroir 1.600m</h5>
                        <p class="text-secondary small mb-0" data-i18n="pillar.terroir_desc">Hạt cà phê phát triển chậm trong sương mù và đất bazan Cầu Đất, tích tụ hương vị hoa quả sâu lắng.</p>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="card-luxury p-4 text-center h-100">
                        <div class="d-inline-flex p-3 rounded-circle mb-3 border border-gold" style="background: var(--gold-subtle);">
                            <i class="fa-solid fa-fire text-gold fs-3"></i>
                        </div>
                        <h5 class="font-serif fw-bold mb-2 text-primary" data-i18n="pillar.roast_title">Rang Mộc Artisanal</h5>
                        <p class="text-secondary small mb-0" data-i18n="pillar.roast_desc">Rang theo mẻ nhỏ (Micro-batch) bằng công nghệ trống rang Giesen cao cấp, giữ vẹn nguyên tính độc bản.</p>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="card-luxury p-4 text-center h-100">
                        <div class="d-inline-flex p-3 rounded-circle mb-3 border border-gold" style="background: var(--gold-subtle);">
                            <i class="fa-solid fa-hand-holding-droplet text-gold fs-3"></i>
                        </div>
                        <h5 class="font-serif fw-bold mb-2 text-primary" data-i18n="pillar.brew_title">Pha Chế Chuẩn Mực</h5>
                        <p class="text-secondary small mb-0" data-i18n="pillar.brew_desc">Đội ngũ Barista được đào tạo theo tiêu chuẩn Specialty Coffee Association (SCA) quốc tế.</p>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="card-luxury p-4 text-center h-100">
                        <div class="d-inline-flex p-3 rounded-circle mb-3 border border-gold" style="background: var(--gold-subtle);">
                            <i class="fa-solid fa-couch text-gold fs-3"></i>
                        </div>
                        <h5 class="font-serif fw-bold mb-2 text-primary" data-i18n="pillar.space_title">Không Gian Roastery</h5>
                        <p class="text-secondary small mb-0" data-i18n="pillar.space_desc">Kiến trúc kết hợp hài hòa giữa kim loại trầm ấm, gỗ sồi và hương thơm nồng nàn của mẻ rang mới.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Table Booking & Membership Banner -->
    <section class="py-5 position-relative bg-espresso" style="border-top: 1px solid var(--border-gold);">
        <div class="container py-3">
            <div class="row align-items-center g-4">
                <div class="col-xl-8 col-lg-8">
                    <button type="button" class="btn btn-link p-0 text-decoration-none text-gold font-accent fw-bold text-uppercase small d-inline-flex align-items-center gap-2 mb-2" data-bs-toggle="modal" data-bs-target="#uteClubPrivilegeModal" style="letter-spacing: 0.12em; cursor: pointer;">
                        <i class="fa-solid fa-crown text-gold"></i>
                        <span data-i18n="banner.loyalty_tag">Đặc Quyền Hội Viên UTEClub</span>
                    </button>
                    <h3 class="font-serif fw-bold mb-2 text-gold-gradient" data-i18n="banner.table_title" style="white-space: normal; letter-spacing: -0.01em;">Đặt Bàn Trực Tuyến &amp; Tích Điểm Tự Động Cho Mọi Đơn Hàng</h3>
                    <p class="text-secondary mb-0 small" data-i18n="banner.table_desc">Thưởng thức không gian tinh tế tại 3 chi nhánh Flagship (Thủ Đức, Quận 1, Bình Thạnh). Tích lũy 10% giá trị đơn hàng để nâng hạng thẻ Bạc, Vàng và Kim Cương với hàng loạt đặc quyền vô song.</p>
                </div>
                <div class="col-xl-4 col-lg-4 text-lg-end">
                    <div class="d-flex flex-column flex-sm-row justify-content-lg-end align-items-stretch align-items-sm-center gap-3">
                        <button type="button" class="btn btn-gold rounded-pill px-4 py-2.5 fw-semibold d-inline-flex align-items-center justify-content-center text-nowrap shadow-gold-sm" data-bs-toggle="modal" data-bs-target="#uteClubPrivilegeModal">
                            <i class="fa-solid fa-crown me-2"></i> <span data-i18n="banner.btn_privilege">Xem Đặc Quyền</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/reservation" class="btn btn-outline-gold rounded-pill px-4 py-2.5 fw-semibold d-inline-flex align-items-center justify-content-center text-nowrap">
                            <i class="fa-solid fa-chair me-2"></i> <span data-i18n="banner.btn_reserve">Đặt Bàn Ngay</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- UTEClub Membership Privileges Modal -->
    <div class="modal fade" id="uteClubPrivilegeModal" tabindex="-1" aria-labelledby="uteClubPrivilegeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content bg-espresso border border-gold shadow-lg" style="box-shadow: 0 15px 50px rgba(0,0,0,0.8), 0 0 25px rgba(212,175,55,0.2) !important;">
                <!-- Modal Header -->
                <div class="modal-header border-bottom border-gold px-4 py-3 position-relative" style="background: linear-gradient(135deg, rgba(212,175,55,0.15) 0%, rgba(20,20,20,0.95) 100%);">
                    <div class="d-flex align-items-center gap-3">
                        <div class="rounded-circle d-flex align-items-center justify-content-center border border-gold" style="width: 48px; height: 48px; background: rgba(212,175,55,0.15);">
                            <i class="fa-solid fa-crown text-gold fs-4"></i>
                        </div>
                        <div>
                            <span class="text-gold font-accent text-uppercase small fw-bold" style="letter-spacing: 0.15em;" data-i18n="modal.uteclub_tag">UTEClub Loyalty Privilege</span>
                            <h4 class="font-serif fw-bold text-gold-gradient mb-0" id="uteClubPrivilegeModalLabel" data-i18n="modal.uteclub_title">Đặc Quyền Hội Viên Danh Dự UTECoffe</h4>
                        </div>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <!-- Modal Body -->
                <div class="modal-body p-4 p-md-5">
                    <!-- 4 Core Pillars -->
                    <div class="row g-3 mb-5">
                        <div class="col-md-6 col-lg-3">
                            <div class="p-3 rounded-3 h-100 border border-gold-subtle text-center" style="background: rgba(255,255,255,0.02);">
                                <div class="text-gold fs-2 mb-2"><i class="fa-solid fa-percent"></i></div>
                                <h6 class="font-serif fw-bold text-gold mb-1" data-i18n="modal.pillar1_title">Tích 10% Mọi Hóa Đơn</h6>
                                <p class="text-secondary small mb-0" data-i18n="modal.pillar1_desc">Mỗi 1.000₫ chi tiêu tích 1 điểm, quy đổi đồ uống và quà tặng cao cấp.</p>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <div class="p-3 rounded-3 h-100 border border-gold-subtle text-center" style="background: rgba(255,255,255,0.02);">
                                <div class="text-gold fs-2 mb-2"><i class="fa-solid fa-cake-candles"></i></div>
                                <h6 class="font-serif fw-bold text-gold mb-1" data-i18n="modal.pillar2_title">Quà Tặng Sinh Nhật</h6>
                                <p class="text-secondary small mb-0" data-i18n="modal.pillar2_desc">Tặng 01 thức uống Signature và thiệp chúc mừng riêng biệt trong tháng sinh nhật.</p>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <div class="p-3 rounded-3 h-100 border border-gold-subtle text-center" style="background: rgba(255,255,255,0.02);">
                                <div class="text-gold fs-2 mb-2"><i class="fa-solid fa-arrow-up-right-dots"></i></div>
                                <h6 class="font-serif fw-bold text-gold mb-1" data-i18n="modal.pillar3_title">Free Up-size Thứ 5</h6>
                                <p class="text-secondary small mb-0" data-i18n="modal.pillar3_desc">Miễn phí nâng cỡ ly Size M lên Size L trên toàn bộ thực đơn vào mỗi thứ Năm.</p>
                            </div>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <div class="p-3 rounded-3 h-100 border border-gold-subtle text-center" style="background: rgba(255,255,255,0.02);">
                                <div class="text-gold fs-2 mb-2"><i class="fa-solid fa-couch"></i></div>
                                <h6 class="font-serif fw-bold text-gold mb-1" data-i18n="modal.pillar4_title">Ưu Tiên VIP Lounge</h6>
                                <p class="text-secondary small mb-0" data-i18n="modal.pillar4_desc">Giữ chỗ bàn trung tâm và phòng họp riêng tư với hệ thống đặt bàn ưu tiên.</p>
                            </div>
                        </div>
                    </div>

                    <!-- 4 Membership Tiers -->
                    <div class="text-center mb-4">
                        <span class="badge bg-gold text-obsidian px-3 py-1 font-accent fw-bold text-uppercase" data-i18n="modal.tiers_badge">4 Hạng Thẻ Hội Viên</span>
                        <h4 class="font-serif fw-bold text-gold-gradient mt-2 mb-1" data-i18n="modal.tiers_title">Hành Trình Thăng Hạng &amp; Tích Lũy</h4>
                        <p class="text-secondary small mb-0" data-i18n="modal.tiers_desc">Thăng hạng tức thì theo điểm tích lũy trọn đời (1.000₫ thanh toán = 1 Điểm UTEClub)</p>
                    </div>

                    <div class="row g-4">
                        <!-- Bronze Tier -->
                        <div class="col-lg-3 col-md-6">
                            <div class="card-luxury p-3 h-100 text-start border position-relative" style="border-color: #cd7f32 !important;">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="badge px-2 py-1 text-white fw-bold" style="background: #cd7f32;" data-i18n="modal.tier_bronze_badge">HẠNG ĐỒNG</span>
                                    <span class="text-secondary small" data-i18n="modal.tier_bronze_pts">0 - 499 điểm</span>
                                </div>
                                <h5 class="font-serif fw-bold text-light mb-2" data-i18n="modal.tier_bronze_name">Thành Viên Khởi Đầu</h5>
                                <p class="text-secondary small mb-3" data-i18n="modal.tier_bronze_desc">Kích hoạt ngay khi tạo tài khoản miễn phí tại UTECoffe.</p>
                                <ul class="list-unstyled small text-secondary d-flex flex-column gap-2 mb-0">
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_bronze_b1">Tặng Voucher 20% đơn hàng đầu tiên</span></li>
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_bronze_b2">Tích lũy 10% điểm cho mọi đơn hàng</span></li>
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_bronze_b3">Nhận tin mẻ rang specialty mới sớm nhất</span></li>
                                </ul>
                            </div>
                        </div>

                        <!-- Silver Tier -->
                        <div class="col-lg-3 col-md-6">
                            <div class="card-luxury p-3 h-100 text-start border position-relative" style="border-color: #c0c0c0 !important;">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="badge px-2 py-1 text-dark fw-bold" style="background: #c0c0c0;" data-i18n="modal.tier_silver_badge">HẠNG BẠC</span>
                                    <span class="text-secondary small" data-i18n="modal.tier_silver_pts">500 - 1.499 điểm</span>
                                </div>
                                <h5 class="font-serif fw-bold text-light mb-2" data-i18n="modal.tier_silver_name">Hội Viên Bạc</h5>
                                <p class="text-secondary small mb-3" data-i18n="modal.tier_silver_desc">Dành cho khách hàng thân thiết thường xuyên ghé thăm.</p>
                                <ul class="list-unstyled small text-secondary d-flex flex-column gap-2 mb-0">
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_silver_b1">Tất cả quyền lợi Hạng Đồng</span></li>
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_silver_b2">Tặng Voucher 10% mỗi đầu tháng</span></li>
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_silver_b3">Miễn phí nâng size (Size L) thứ 5</span></li>
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_silver_b4">Tặng 1 phần topping tự chọn hàng tháng</span></li>
                                </ul>
                            </div>
                        </div>

                        <!-- Gold Tier -->
                        <div class="col-lg-3 col-md-6">
                            <div class="card-luxury p-3 h-100 text-start border position-relative" style="border-color: #ffd700 !important; background: linear-gradient(180deg, rgba(212,175,55,0.06) 0%, rgba(20,20,20,0.6) 100%);">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="badge px-2 py-1 text-dark fw-bold" style="background: #ffd700;" data-i18n="modal.tier_gold_badge">HẠNG VÀNG</span>
                                    <span class="text-gold small fw-bold" data-i18n="modal.tier_gold_pts">1.500 - 2.999 điểm</span>
                                </div>
                                <h5 class="font-serif fw-bold text-gold-gradient mb-2" data-i18n="modal.tier_gold_name">Hội Viên Vàng VIP</h5>
                                <p class="text-secondary small mb-3" data-i18n="modal.tier_gold_desc">Trải nghiệm dịch vụ chuyên biệt và ưu đãi giảm giá sâu.</p>
                                <ul class="list-unstyled small text-secondary d-flex flex-column gap-2 mb-0">
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_gold_b1">Giảm trực tiếp 10% trên toàn bộ thực đơn</span></li>
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_gold_b2">01 Ly cà phê Signature miễn phí dịp Sinh Nhật</span></li>
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_gold_b3">Ưu tiên giữ bàn đẹp tại VIP Lounge</span></li>
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_gold_b4">Đổi điểm lấy voucher thanh toán trực tiếp</span></li>
                                </ul>
                            </div>
                        </div>

                        <!-- Diamond Tier -->
                        <div class="col-lg-3 col-md-6">
                            <div class="card-luxury p-3 h-100 text-start border position-relative" style="border-color: #b9f2ff !important; background: linear-gradient(180deg, rgba(185,242,255,0.08) 0%, rgba(20,20,20,0.6) 100%);">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="badge px-2 py-1 text-dark fw-bold" style="background: #b9f2ff;" data-i18n="modal.tier_diamond_badge">KIM CƯƠNG</span>
                                    <span class="text-info small fw-bold" data-i18n="modal.tier_diamond_pts">3.000+ điểm</span>
                                </div>
                                <h5 class="font-serif fw-bold text-light mb-2" data-i18n="modal.tier_diamond_name">Thượng Khách Kim Cương</h5>
                                <p class="text-secondary small mb-3" data-i18n="modal.tier_diamond_desc">Đỉnh cao đặc quyền cá nhân hóa và trải nghiệm roastery độc bản.</p>
                                <ul class="list-unstyled small text-secondary d-flex flex-column gap-2 mb-0">
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_diamond_b1">Giảm trực tiếp 15% trọn đời mọi đơn hàng</span></li>
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_diamond_b2">Tặng 01 phần bánh sừng bò thủ công mỗi tuần</span></li>
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_diamond_b3">Vé mời VIP Private Cupping cùng Master Roaster</span></li>
                                    <li><i class="fa-solid fa-check text-gold me-2"></i> <span data-i18n="modal.tier_diamond_b4">Đường dây hỗ trợ &amp; đặt bàn ưu tiên 24/7</span></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal Footer -->
                <div class="modal-footer border-top border-gold px-4 py-3 d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
                    <button type="button" class="btn btn-outline-secondary rounded-pill px-4 text-secondary" data-bs-dismiss="modal" data-i18n="modal.btn_close">Đóng</button>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/uteclub" class="btn btn-outline-gold rounded-pill px-4 fw-semibold">
                            <i class="fa-solid fa-arrow-up-right-from-square me-2"></i><span data-i18n="modal.btn_details">Xem Chi Tiết Đầy Đủ</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-gold rounded-pill px-4 fw-semibold">
                            <i class="fa-solid fa-user-plus me-2"></i><span data-i18n="modal.btn_register">Đăng Ký UTEClub Miễn Phí</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
