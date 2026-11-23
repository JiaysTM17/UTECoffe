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
                                    <span class="counter-metric" data-counter="10" data-counter-suffix="">10</span>
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
                            <div class="product-image-container">
                                <img src="${not empty prod.imageUrl ? prod.imageUrl : 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=500&q=80'}" 
                                     alt="${prod.name}">
                                <c:if test="${prod.isFeatured}">
                                    <span class="badge-luxury-tag"><i class="fa-solid fa-star text-gold me-1"></i> Bán Chạy</span>
                                </c:if>
                            </div>
                            <div class="card-body p-4 d-flex flex-column flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="text-gold font-accent small text-uppercase" style="letter-spacing: 0.1em;">${prod.category.name}</span>
                                    <span class="badge bg-espresso text-secondary small border border-gold"><i class="fa-solid fa-fire-flame-curved me-1 text-gold"></i> Rang Mộc</span>
                                </div>
                                <h5 class="font-serif fw-bold mb-2">
                                    <a href="${pageContext.request.contextPath}/menu/${prod.slug}" class="text-primary text-decoration-none hover-gold">${prod.name}</a>
                                </h5>
                                <p class="text-secondary small flex-grow-1 mb-3 text-truncate-2">
                                    ${not empty prod.description ? prod.description : 'Hương vị nguyên bản từ hạt Arabica chín cây tuyển chọn, kết hợp kỹ thuật pha thủ công tinh tế.'}
                                </p>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top border-gold">
                                    <span class="price-gold"><fmt:formatNumber value="${prod.basePrice}" pattern="#,##0"/> VNĐ</span>
                                    <a href="${pageContext.request.contextPath}/menu/${prod.slug}" class="btn btn-gold btn-sm px-3 rounded-pill">
                                        <i class="fa-solid fa-sliders me-1"></i> <span data-i18n="feat.add_cart">Tùy Chỉnh</span>
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
                <span class="section-subtitle">Triết Lý Cà Phê Thủ Công</span>
                <h2 class="section-title">Hành Trình Từ Nông Trại Đến Tách Cà Phê</h2>
                <div class="gold-divider"></div>
            </div>

            <div class="row g-4">
                <div class="col-md-3 col-sm-6">
                    <div class="card-luxury p-4 text-center h-100">
                        <div class="d-inline-flex p-3 rounded-circle mb-3 border border-gold" style="background: var(--gold-subtle);">
                            <i class="fa-solid fa-mountain text-gold fs-3"></i>
                        </div>
                        <h5 class="font-serif fw-bold mb-2 text-primary">Terroir 1.600m</h5>
                        <p class="text-secondary small mb-0">Hạt cà phê phát triển chậm trong sương mù và đất bazan Cầu Đất, tích tụ hương vị hoa quả sâu lắng.</p>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="card-luxury p-4 text-center h-100">
                        <div class="d-inline-flex p-3 rounded-circle mb-3 border border-gold" style="background: var(--gold-subtle);">
                            <i class="fa-solid fa-fire text-gold fs-3"></i>
                        </div>
                        <h5 class="font-serif fw-bold mb-2 text-primary">Rang Mộc Artisanal</h5>
                        <p class="text-secondary small mb-0">Rang theo mẻ nhỏ (Micro-batch) bằng công nghệ trống rang Giesen cao cấp, giữ vẹn nguyên tính độc bản.</p>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="card-luxury p-4 text-center h-100">
                        <div class="d-inline-flex p-3 rounded-circle mb-3 border border-gold" style="background: var(--gold-subtle);">
                            <i class="fa-solid fa-hand-holding-droplet text-gold fs-3"></i>
                        </div>
                        <h5 class="font-serif fw-bold mb-2 text-primary">Pha Chế Chuẩn Mực</h5>
                        <p class="text-secondary small mb-0">Đội ngũ Barista được đào tạo theo tiêu chuẩn Specialty Coffee Association (SCA) quốc tế.</p>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="card-luxury p-4 text-center h-100">
                        <div class="d-inline-flex p-3 rounded-circle mb-3 border border-gold" style="background: var(--gold-subtle);">
                            <i class="fa-solid fa-couch text-gold fs-3"></i>
                        </div>
                        <h5 class="font-serif fw-bold mb-2 text-primary">Không Gian Roastery</h5>
                        <p class="text-secondary small mb-0">Kiến trúc kết hợp hài hòa giữa kim loại trầm ấm, gỗ sồi và hương thơm nồng nàn của mẻ rang mới.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Table Booking & Membership Banner -->
    <section class="py-5 position-relative bg-espresso" style="border-top: 1px solid var(--border-gold);">
        <div class="container py-3">
            <div class="row align-items-center g-4">
                <div class="col-lg-8">
                    <span class="text-gold font-accent fw-bold text-uppercase small" style="letter-spacing: 0.12em;">Đặc Quyền Hội Viên UTEClub</span>
                    <h3 class="font-serif fw-bold mb-2 text-gold-gradient">Đặt Bàn Trực Tuyến &amp; Tích Điểm Tự Động Cho Mọi Đơn Hàng</h3>
                    <p class="text-secondary mb-0 small">Thưởng thức không gian tinh tế tại 10 chi nhánh Flagship. Tích lũy 10% giá trị đơn hàng để nâng hạng thẻ Bạc, Vàng và Kim Cương.</p>
                </div>
                <div class="col-lg-4 text-lg-end">
                    <a href="${pageContext.request.contextPath}/reservation" class="btn btn-gold me-2">
                        <i class="fa-solid fa-chair me-1"></i> Đặt Bàn Ngay
                    </a>
                    <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-outline-gold">
                        Đăng Ký UTEClub
                    </a>
                </div>
            </div>
        </div>
    </section>

</body>
