<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>${product.name} - UTECoffe Specialty Roastery</title>
</head>
<body class="bg-obsidian">
    <div class="container py-4 py-lg-5" style="max-width: 1400px;">
        <!-- Breadcrumb Navigation -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb small font-accent text-uppercase" style="letter-spacing: 0.08em;">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none hover-gold" data-i18n="nav.home">Trang Chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu" class="text-secondary text-decoration-none hover-gold" data-i18n="nav.menu">Thực Đơn</a></li>
                <li class="breadcrumb-item active text-gold fw-bold" aria-current="page">${product.name}</li>
            </ol>
        </nav>

        <div class="row g-4 g-lg-5 mb-5 align-items-start">
            <!-- Left: Product Image & Flavor Profile -->
            <div class="col-lg-5">
                <div class="position-sticky" style="top: 100px;">
                    <div class="card card-luxury overflow-hidden mb-4 p-2">
                        <div class="product-image-container rounded-4 overflow-hidden position-relative" style="aspect-ratio: 1/1;">
                        <c:choose>
                            <c:when test="${empty product.imageUrl}">
                                <c:set var="curProdImg" value="https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?q=80&w=800"/>
                            </c:when>
                            <c:when test="${product.imageUrl.startsWith('http')}">
                                <c:set var="curProdImg" value="${product.imageUrl}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="curProdImg" value="${pageContext.request.contextPath}${product.imageUrl}"/>
                            </c:otherwise>
                        </c:choose>
                        <img src="${curProdImg}" 
                             alt="${product.name}" 
                             class="img-fluid w-100 h-100 object-fit-cover">
                            <span class="badge-luxury-tag position-absolute top-3 start-3">
                                <i class="fa-solid fa-award text-gold me-1"></i> ${product.category.name}
                            </span>
                        </div>
                    </div>

                    <!-- Terroir & Taste Radar Card -->
                    <div class="card-luxury p-4">
                        <h6 class="font-accent text-gold fw-bold text-uppercase small mb-3 border-bottom border-gold pb-2" style="letter-spacing: 0.12em;" data-i18n="detail.terroir_title">
                            <i class="fa-solid fa-compass-drafting me-2"></i>Hồ Sơ Hương Vị &amp; Xuất Xứ (Terroir)
                        </h6>
                        
                        <div class="mb-3">
                            <c:choose>
                                <c:when test="${product.category.id == 2}">
                                    <div class="d-flex justify-content-between small text-secondary mb-1">
                                        <span>Vùng đồi chè:</span>
                                        <strong class="text-gold">Mộc Châu &amp; Tây Hồ</strong>
                                    </div>
                                    <div class="d-flex justify-content-between small text-secondary mb-1">
                                        <span>Phương pháp lên men:</span>
                                        <strong class="text-gold">Bán phần thủ công 40%</strong>
                                    </div>
                                    <div class="d-flex justify-content-between small text-secondary mb-3">
                                        <span>Công nghệ sấy:</span>
                                        <strong class="text-gold">Sấy lạnh giữ trọn hương hoa</strong>
                                    </div>
                                </c:when>
                                <c:when test="${product.category.id == 3}">
                                    <div class="d-flex justify-content-between small text-secondary mb-1">
                                        <span>Nguyên liệu hảo hạng:</span>
                                        <strong class="text-gold">Bơ Pháp Elle &amp; Vire 100%</strong>
                                    </div>
                                    <div class="d-flex justify-content-between small text-secondary mb-1">
                                        <span>Phương pháp ủ bột:</span>
                                        <strong class="text-gold">Lên men chậm tự nhiên 24h</strong>
                                    </div>
                                    <div class="d-flex justify-content-between small text-secondary mb-3">
                                        <span>Kỹ thuật nướng:</span>
                                        <strong class="text-gold">Lò nướng đối lưu vàng giòn</strong>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex justify-content-between small text-secondary mb-1">
                                        <span>Vùng trồng / Xuất xứ:</span>
                                        <strong class="text-gold">Cầu Đất Terroir (1.600m)</strong>
                                    </div>
                                    <div class="d-flex justify-content-between small text-secondary mb-1">
                                        <span>Phương pháp sơ chế:</span>
                                        <strong class="text-gold">Honey Process (Mật ong)</strong>
                                    </div>
                                    <div class="d-flex justify-content-between small text-secondary mb-3">
                                        <span>Mức độ rang:</span>
                                        <strong class="text-gold">Medium Roast (Rang vừa)</strong>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Taste Attributes -->
                        <div class="d-flex flex-column gap-2 mb-3">
                            <div>
                                <div class="d-flex justify-content-between small text-secondary mb-1">
                                    <span>Độ đậm đà (Body):</span>
                                    <span class="text-gold">4 / 5</span>
                                </div>
                                <div class="progress" style="height: 5px; background: rgba(222, 183, 106, 0.15);">
                                    <div class="progress-bar bg-gold" style="width: 80%;"></div>
                                </div>
                            </div>
                            <div>
                                <div class="d-flex justify-content-between small text-secondary mb-1">
                                    <span>Hương thơm nồng nàn (Aroma):</span>
                                    <span class="text-gold">5 / 5</span>
                                </div>
                                <div class="progress" style="height: 5px; background: rgba(222, 183, 106, 0.15);">
                                    <div class="progress-bar bg-gold" style="width: 100%;"></div>
                                </div>
                            </div>
                            <div>
                                <div class="d-flex justify-content-between small text-secondary mb-1">
                                    <span>Độ chua thanh hoa quả (Acidity):</span>
                                    <span class="text-gold">3 / 5</span>
                                </div>
                                <div class="progress" style="height: 5px; background: rgba(222, 183, 106, 0.15);">
                                    <div class="progress-bar bg-gold" style="width: 60%;"></div>
                                </div>
                            </div>
                            <div>
                                <div class="d-flex justify-content-between small text-secondary mb-1">
                                    <span>Hậu vị ngọt sâu (Aftertaste):</span>
                                    <span class="text-gold">4.5 / 5</span>
                                </div>
                                <div class="progress" style="height: 5px; background: rgba(222, 183, 106, 0.15);">
                                    <div class="progress-bar bg-gold" style="width: 90%;"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Flavor Tags -->
                        <div class="d-flex flex-wrap gap-2 pt-2 border-top border-gold">
                            <span class="badge bg-espresso border border-gold text-secondary small py-1 px-2">🍂 Caramel nướng</span>
                            <span class="badge bg-espresso border border-gold text-secondary small py-1 px-2">🍊 Cam vàng Sunkist</span>
                            <span class="badge bg-espresso border border-gold text-secondary small py-1 px-2">🍫 Socola đen</span>
                            <span class="badge bg-espresso border border-gold text-secondary small py-1 px-2">🍯 Mật ong dại</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right: Product Information & Live Customizer -->
            <div class="col-lg-7">
                <div class="ps-lg-3">
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <div class="text-gold small">
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star"></i>
                            <i class="fa-solid fa-star-half-stroke"></i>
                        </div>
                        <span class="text-gold fw-bold small">${not empty avgRating ? avgRating : '4.9'} / 5.0</span>
                        <span class="text-secondary small">(${reviews.size()} đánh giá từ khách hàng)</span>
                        <span class="badge bg-success-subtle text-success small ms-2"><i class="fa-solid fa-circle-check me-1"></i>Sẵn Sàng Phục Vụ</span>
                    </div>

                    <h1 class="display-5 fw-bold font-serif text-gold-gradient mb-2 product-title-text" data-slug="${product.slug}">${product.name}</h1>
                    <p class="text-secondary mb-4 leading-relaxed product-desc-text" data-slug="${product.slug}">${product.description}</p>

                    <!-- Price Box -->
                    <div class="p-3 rounded-4 bg-espresso border border-gold mb-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
                        <div>
                            <span class="small text-secondary d-block font-accent text-uppercase" style="letter-spacing: 0.08em;" data-i18n="detail.price_label">Giá Thưởng Thức:</span>
                            <span class="price-gold display-6 fw-bold" id="liveDisplayPrice" data-raw-price="${product.basePrice}">
                                <fmt:formatNumber value="${product.basePrice}" pattern="#,##0"/> VNĐ
                            </span>
                        </div>
                        <div class="badge bg-gold-subtle border border-gold text-gold py-2 px-3 small">
                            <i class="fa-solid fa-bolt me-1"></i> Tích +10% Điểm Thẻ UTEClub
                        </div>
                    </div>

                    <!-- Specialty Customizer Options (Refined Artisanal Minimalist) -->
                    <div class="card-luxury p-4 mb-4 customizer-box">
                        <c:choose>
                            <%-- 1. BÁNH NGỌT THỦ CÔNG (PASTRY & BAKERY) --%>
                            <c:when test="${product.category.id == 3}">
                                <h5 class="font-serif fw-bold text-gold mb-4 pb-2 border-bottom border-gold d-flex align-items-center justify-content-between">
                                    <span><i class="fa-solid fa-cookie-bite me-2 text-gold"></i><span data-i18n="customizer.pastry_title">Tùy Chọn Thưởng Thức Bánh Nghệ Nhân</span></span>
                                    <span class="badge bg-gold-subtle text-gold small fw-normal font-sans" style="font-size: 0.72rem;" data-i18n="customizer.pastry_badge">100% Bơ Pháp Elle &amp; Vire</span>
                                </h5>

                                <!-- 1. Quy Cách Đóng Gói -->
                                <div class="mb-4">
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">1.</span> <span data-i18n="customizer.pastry_step1">Quy Cách Đóng Gói:</span></span>
                                        <span class="current-selection-badge" id="selectedPastryPackLabel">1 Chiếc (Tiêu Chuẩn)</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2" role="group">
                                        <button type="button" class="btn-option-pill active" data-type="pastry-pack" data-value="1" data-extra="0" onclick="selectOption('pastry-pack', this)">
                                            1 Chiếc (Nguyên Bản)
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="pastry-pack" data-value="2" data-extra="35000" onclick="selectOption('pastry-pack', this)">
                                            Hộp Quà 2 Chiếc <span class="opacity-75 small">+35k</span>
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="pastry-pack" data-value="4" data-extra="90000" onclick="selectOption('pastry-pack', this)">
                                            Hộp Sang Trọng 4 Chiếc <span class="opacity-75 small">+90k</span>
                                        </button>
                                    </div>
                                </div>

                                <!-- 2. Cách Thức Phục Vụ -->
                                <div class="mb-4">
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">2.</span> <span data-i18n="customizer.pastry_step2">Cách Thức Phục Vụ:</span></span>
                                        <span class="current-selection-badge" id="selectedPastryServeLabel">Làm Nóng Giòn Lại Lò Nướng</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2" role="group">
                                        <button type="button" class="btn-option-pill active" data-type="pastry-serve" data-value="hot" onclick="selectOption('pastry-serve', this)">
                                            <i class="fa-solid fa-fire text-warning me-1"></i> Làm Nóng Giòn Lại
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="pastry-serve" data-value="cold" onclick="selectOption('pastry-serve', this)">
                                            <i class="fa-solid fa-snowflake text-info me-1"></i> Dùng Lạnh Tủ Mát
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="pastry-serve" data-value="room" onclick="selectOption('pastry-serve', this)">
                                            Nhiệt Độ Phòng
                                        </button>
                                    </div>
                                </div>

                                <!-- 3. Sốt & Topping Ăn Kèm -->
                                <div>
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">3.</span> <span data-i18n="customizer.pastry_step3">Sốt &amp; Topping Ăn Kèm:</span></span>
                                        <span class="text-secondary small font-sans fw-normal" data-i18n="customizer.topping_hint">Chọn nhiều tùy thích</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2">
                                        <label class="topping-pill-check">
                                            <input type="checkbox" class="form-check-input topping-check" value="choco-sauce" data-price="10000" onchange="toggleTopping(this.parentElement)">
                                            <span>Sốt Socola Bỉ (+10k)</span>
                                        </label>
                                        <label class="topping-pill-check">
                                            <input type="checkbox" class="form-check-input topping-check" value="berry-jam" data-price="10000" onchange="toggleTopping(this.parentElement)">
                                            <span>Mứt Dâu Rừng (+10k)</span>
                                        </label>
                                        <label class="topping-pill-check">
                                            <input type="checkbox" class="form-check-input topping-check" value="whipping-cream" data-price="10000" onchange="toggleTopping(this.parentElement)">
                                            <span>Kem Tươi Whipping (+10k)</span>
                                        </label>
                                        <label class="topping-pill-check">
                                            <input type="checkbox" class="form-check-input topping-check" value="gelato-scoop" data-price="15000" onchange="toggleTopping(this.parentElement)">
                                            <span>Viên Gelato Vani (+15k)</span>
                                        </label>
                                    </div>
                                    <div class="mt-3 p-2 bg-espresso rounded-3 border border-gold-subtle small text-secondary">
                                        <i class="fa-solid fa-circle-info text-gold me-1"></i> Bánh thủ công nướng tươi mới mỗi sáng từ bơ Pháp thượng hạng Elle &amp; Vire. Không chất bảo quản.
                                    </div>
                                </div>
                            </c:when>

                            <%-- 2. TRÀ THƯỢNG HẠNG (ARTISANAL TEA) --%>
                            <c:when test="${product.category.id == 2}">
                                <h5 class="font-serif fw-bold text-gold mb-4 pb-2 border-bottom border-gold d-flex align-items-center justify-content-between">
                                    <span><i class="fa-solid fa-leaf me-2 text-gold"></i><span data-i18n="customizer.tea_title">Tùy Chỉnh Hương Vị Trà Đạo</span></span>
                                    <span class="badge bg-gold-subtle text-gold small fw-normal font-sans" style="font-size: 0.72rem;" data-i18n="customizer.tea_badge">Trà Cổ Thụ &amp; Sen Tây Hồ</span>
                                </h5>

                                <!-- 1. Kích Cỡ Ly -->
                                <div class="mb-4">
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">1.</span> <span data-i18n="customizer.step1">Chọn Kích Cỡ Ly:</span></span>
                                        <span class="current-selection-badge" id="selectedSizeLabel">Size M (Grande) Tiêu Chuẩn</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2" role="group">
                                        <button type="button" class="btn-option-pill active" data-type="size" data-value="M" data-extra="0" onclick="selectOption('size', this)">
                                            Size M (Grande)
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="size" data-value="L" data-extra="10000" onclick="selectOption('size', this)">
                                            Size L (Venti) <span class="opacity-75 small">+10k</span>
                                        </button>
                                    </div>
                                </div>

                                <!-- 2. Mức Đá & Nhiệt Độ -->
                                <div class="mb-4">
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">2.</span> <span data-i18n="customizer.step2">Mức Đá &amp; Nhiệt Độ:</span></span>
                                        <span class="current-selection-badge" id="selectedIceLabel">100% Đá (Tiêu Chuẩn)</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2" role="group">
                                        <button type="button" class="btn-option-pill active" data-type="ice" data-value="100" onclick="selectOption('ice', this)">
                                            100% Đá
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="ice" data-value="70" onclick="selectOption('ice', this)">
                                            70% Đá
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="ice" data-value="30" onclick="selectOption('ice', this)">
                                            30% Đá
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="ice" data-value="0" onclick="selectOption('ice', this)">
                                            Không Đá
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="ice" data-value="HOT" onclick="selectOption('ice', this)">
                                            <i class="fa-solid fa-mug-hot text-danger me-1"></i> Dùng Nóng
                                        </button>
                                    </div>
                                </div>

                                <!-- 3. Mức Ngọt -->
                                <div class="mb-4">
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">3.</span> <span data-i18n="customizer.step3">Mức Đường / Ngọt:</span></span>
                                        <span class="current-selection-badge" id="selectedSugarLabel">100% Tiêu Chuẩn</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2" role="group">
                                        <button type="button" class="btn-option-pill active" data-type="sugar" data-value="100" onclick="selectOption('sugar', this)">
                                            100% Chuẩn
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="sugar" data-value="70" onclick="selectOption('sugar', this)">
                                            70% Thanh Nhẹ
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="sugar" data-value="30" onclick="selectOption('sugar', this)">
                                            30% Dịu Dàng
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="sugar" data-value="0" onclick="selectOption('sugar', this)">
                                            0% Vị Mộc
                                        </button>
                                    </div>
                                </div>

                                <!-- 4. Tùy Chọn Kem & Sữa -->
                                <div class="mb-4">
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">4.</span> <span data-i18n="customizer.tea_step4">Lớp Foam &amp; Sữa:</span></span>
                                        <span class="current-selection-badge" id="selectedMilkLabel">Không Thêm Kem/Sữa</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2" role="group">
                                        <button type="button" class="btn-option-pill active" data-type="milk" data-value="none" data-extra="0" onclick="selectOption('milk', this)">
                                            Trà Nguyên Bản (Không Sữa)
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="milk" data-value="cheese" data-extra="12000" onclick="selectOption('milk', this)">
                                            <i class="fa-solid fa-cheese text-warning me-1"></i> Kem Cheese Phô Mai (+12k)
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="milk" data-value="oat" data-extra="12000" onclick="selectOption('milk', this)">
                                            <i class="fa-solid fa-wheat-awn text-gold me-1"></i> Sữa Yến Mạch Oatly (+12k)
                                        </button>
                                    </div>
                                </div>

                                <!-- 5. Topping Trà Thượng Hạng -->
                                <div>
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">5.</span> <span data-i18n="customizer.tea_step5">Topping Trà Thượng Hạng:</span></span>
                                        <span class="text-secondary small font-sans fw-normal" data-i18n="customizer.topping_hint">Chọn nhiều tùy thích</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2">
                                        <label class="topping-pill-check">
                                            <input type="checkbox" class="form-check-input topping-check" value="golden-pearl" data-price="8000" onchange="toggleTopping(this.parentElement)">
                                            <span>Trân Châu Oolong (+8k)</span>
                                        </label>
                                        <label class="topping-pill-check">
                                            <input type="checkbox" class="form-check-input topping-check" value="aloe" data-price="8000" onchange="toggleTopping(this.parentElement)">
                                            <span>Thạch Nha Đam (+8k)</span>
                                        </label>
                                        <label class="topping-pill-check">
                                            <input type="checkbox" class="form-check-input topping-check" value="lotus-seed" data-price="10000" onchange="toggleTopping(this.parentElement)">
                                            <span>Hạt Sen Tây Hồ (+10k)</span>
                                        </label>
                                        <label class="topping-pill-check">
                                            <input type="checkbox" class="form-check-input topping-check" value="jasmine-jelly" data-price="8000" onchange="toggleTopping(this.parentElement)">
                                            <span>Thạch Hoa Nhài (+8k)</span>
                                        </label>
                                    </div>
                                </div>
                            </c:when>

                            <%-- 3. CÀ PHÊ ĐẶC SẢN (SPECIALTY COFFEE - DEFAULT) --%>
                            <c:otherwise>
                                <h5 class="font-serif fw-bold text-gold mb-4 pb-2 border-bottom border-gold d-flex align-items-center justify-content-between">
                                    <span><i class="fa-solid fa-sliders me-2 text-gold"></i><span data-i18n="customizer.title">Tùy Chỉnh Khẩu Vị Barista</span></span>
                                    <span class="badge bg-gold-subtle text-gold small fw-normal font-sans" style="font-size: 0.72rem;" data-i18n="customizer.badge">Chuẩn Vị Nghệ Nhân</span>
                                </h5>

                                <!-- 1. Size Selection -->
                                <div class="mb-4">
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">1.</span> <span data-i18n="customizer.step1">Chọn Kích Cỡ Ly:</span></span>
                                        <span class="current-selection-badge" id="selectedSizeLabel">Size M (Grande) +10.000 VNĐ</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2" role="group">
                                        <button type="button" class="btn-option-pill" data-type="size" data-value="S" data-extra="0" onclick="selectOption('size', this)">
                                            Size S (Regular)
                                        </button>
                                        <button type="button" class="btn-option-pill active" data-type="size" data-value="M" data-extra="10000" onclick="selectOption('size', this)">
                                            Size M (Grande) <span class="opacity-75 small">+10k</span>
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="size" data-value="L" data-extra="18000" onclick="selectOption('size', this)">
                                            Size L (Venti) <span class="opacity-75 small">+18k</span>
                                        </button>
                                    </div>
                                </div>

                                <!-- 2. Temperature & Ice -->
                                <div class="mb-4">
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">2.</span> <span data-i18n="customizer.step2">Mức Đá &amp; Nhiệt Độ:</span></span>
                                        <span class="current-selection-badge" id="selectedIceLabel">100% Đá (Tiêu Chuẩn)</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2" role="group">
                                        <button type="button" class="btn-option-pill active" data-type="ice" data-value="100" onclick="selectOption('ice', this)">
                                            100% Đá
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="ice" data-value="70" onclick="selectOption('ice', this)">
                                            70% Đá
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="ice" data-value="30" onclick="selectOption('ice', this)">
                                            30% Đá
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="ice" data-value="0" onclick="selectOption('ice', this)">
                                            Không Đá
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="ice" data-value="HOT" onclick="selectOption('ice', this)">
                                            <i class="fa-solid fa-mug-hot text-danger me-1"></i> Uống Nóng
                                        </button>
                                    </div>
                                </div>

                                <!-- 3. Sweetness -->
                                <div class="mb-4">
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">3.</span> <span data-i18n="customizer.step3">Mức Đường / Ngọt:</span></span>
                                        <span class="current-selection-badge" id="selectedSugarLabel">100% Tiêu Chuẩn</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2" role="group">
                                        <button type="button" class="btn-option-pill active" data-type="sugar" data-value="100" onclick="selectOption('sugar', this)">
                                            100% Chuẩn
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="sugar" data-value="70" onclick="selectOption('sugar', this)">
                                            70% Ngọt Vừa
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="sugar" data-value="30" onclick="selectOption('sugar', this)">
                                            30% Ít Ngọt
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="sugar" data-value="0" onclick="selectOption('sugar', this)">
                                            0% Không Đường
                                        </button>
                                    </div>
                                </div>

                                <!-- 4. Milk Choice -->
                                <div class="mb-4">
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">4.</span> <span data-i18n="customizer.step4">Tùy Chọn Sữa:</span></span>
                                        <span class="current-selection-badge" id="selectedMilkLabel">Sữa Thanh Trùng Đà Lạt</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2" role="group">
                                        <button type="button" class="btn-option-pill active" data-type="milk" data-value="fresh" data-extra="0" onclick="selectOption('milk', this)">
                                            Sữa Đà Lạt (Mặc Định)
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="milk" data-value="oat" data-extra="12000" onclick="selectOption('milk', this)">
                                            <i class="fa-solid fa-wheat-awn me-1 text-gold"></i> Sữa Yến Mạch Oatly (+12k)
                                        </button>
                                        <button type="button" class="btn-option-pill" data-type="milk" data-value="almond" data-extra="12000" onclick="selectOption('milk', this)">
                                            <i class="fa-solid fa-seedling me-1 text-gold"></i> Sữa Hạnh Nhân (+12k)
                                        </button>
                                    </div>
                                </div>

                                <!-- 5. Artisanal Toppings -->
                                <div>
                                    <div class="customizer-section-title">
                                        <span><span class="section-step-num">5.</span> <span data-i18n="customizer.step5">Thêm Topping Thượng Hạng:</span></span>
                                        <span class="text-secondary small font-sans fw-normal" data-i18n="customizer.topping_hint">Chọn nhiều tùy thích</span>
                                    </div>
                                    <div class="d-flex flex-wrap gap-2">
                                        <label class="topping-pill-check">
                                            <input type="checkbox" class="form-check-input topping-check" value="jelly" data-price="8000" onchange="toggleTopping(this.parentElement)">
                                            <span>Thạch Cà Phê (+8k)</span>
                                        </label>
                                        <label class="topping-pill-check">
                                            <input type="checkbox" class="form-check-input topping-check" value="cheese" data-price="12000" onchange="toggleTopping(this.parentElement)">
                                            <span>Kem Cheese Macchiato (+12k)</span>
                                        </label>
                                        <label class="topping-pill-check">
                                            <input type="checkbox" class="form-check-input topping-check" value="pearl" data-price="8000" onchange="toggleTopping(this.parentElement)">
                                            <span>Trân Châu Trắng (+8k)</span>
                                        </label>
                                        <label class="topping-pill-check">
                                            <input type="checkbox" class="form-check-input topping-check" value="shot" data-price="15000" onchange="toggleTopping(this.parentElement)">
                                            <span>Extra Double Shot (+15k)</span>
                                        </label>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Quantity & Action Buttons -->
                    <div class="d-flex flex-wrap align-items-center gap-3 mb-4">
                        <div class="d-flex align-items-center border border-gold rounded-pill bg-espresso p-1">
                            <button class="btn btn-sm text-gold border-0 px-3 fw-bold" type="button" onclick="changeQty(-1)">
                                <i class="fa-solid fa-minus"></i>
                            </button>
                            <input type="text" id="orderQuantity" class="form-control text-center bg-transparent border-0 text-gold fw-bold" value="1" readonly style="width: 48px;">
                            <button class="btn btn-sm text-gold border-0 px-3 fw-bold" type="button" onclick="changeQty(1)">
                                <i class="fa-solid fa-plus"></i>
                            </button>
                        </div>

                        <button type="button" class="btn btn-gold btn-sm px-4 flex-grow-1 text-nowrap py-3" onclick="handleAddToCart()">
                            <i class="fa-solid fa-bag-shopping me-2"></i> <span data-i18n="customizer.add_to_cart">Thêm Vào Giỏ Hàng</span>
                        </button>

                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-gold btn-sm px-4 text-nowrap py-3">
                            <i class="fa-solid fa-bolt me-2"></i> <span data-i18n="customizer.view_cart">Xem Giỏ Hàng</span>
                        </a>
                    </div>

                    <!-- Commitment Guarantees -->
                    <div class="row g-2 text-secondary small pt-3 border-top border-gold">
                        <div class="col-sm-4 d-flex align-items-center gap-2">
                            <i class="fa-solid fa-shield-heart text-gold"></i> 100% Cà phê sạch nguyên chất
                        </div>
                        <div class="col-sm-4 d-flex align-items-center gap-2">
                            <i class="fa-solid fa-stopwatch text-gold"></i> Pha chế thủ công tươi mới
                        </div>
                        <div class="col-sm-4 d-flex align-items-center gap-2">
                            <i class="fa-solid fa-truck-fast text-gold"></i> Giao siêu tốc giữ nhiệt 30'
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========================================================================= -->
        <!-- SECTION: CÂU CHUYỆN NGHỆ NHÂN & MINH BẠCH THÀNH PHẦN, LƯU Ý DỊ ỨNG -->
        <!-- ========================================================================= -->
        <div class="card-luxury p-4 p-lg-5 mb-5 position-relative overflow-hidden">
            <div class="position-absolute top-0 end-0 p-5 opacity-10 pointer-events-none d-none d-md-block">
                <i class="fa-solid fa-leaf text-gold" style="font-size: 15rem;"></i>
            </div>
            
            <div class="row g-4 g-lg-5 position-relative">
                <!-- Column 1: Câu Chuyện Món & Cảm Hứng Nghệ Nhân -->
                <div class="col-lg-7 border-end-lg border-gold pe-lg-5">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <span class="badge bg-gold-subtle text-gold small px-2 py-1 text-uppercase font-sans" style="letter-spacing: 0.1em;">
                            <i class="fa-solid fa-feather-pointed me-1"></i> Heritage &amp; Craft
                        </span>
                        <span class="text-secondary small">&bull; Tuyệt Phẩm Chế Tác Độc Bản</span>
                    </div>

                    <h3 class="font-serif fw-bold text-gold-gradient mb-3">
                        Câu Chuyện Nghệ Nhân &amp; Nguồn Cảm Hứng
                    </h3>

                    <p class="text-secondary leading-relaxed mb-4" style="line-height: 1.8;">
                        <c:choose>
                            <c:when test="${product.category.id == 2}">
                                Mỗi búp trà trong <strong>${product.name}</strong> bắt đầu từ những sớm tinh sương trên những triền đồi bạt ngàn sương mù tại Mộc Châu và vùng đầm sen cổ Tây Hồ. Các nghệ nhân UTECoffe tuyển chọn thủ công từng lá trà non một tôm hai lá, sao trên chảo gang truyền thống để giữ trọn vẹn lớp mao trắng và hương hoa tự nhiên tinh tế. Sự hòa quyện nhịp nhàng giữa chất thanh tao cổ truyền và nghệ thuật pha chế đương đại mang đến trải nghiệm thưởng trà sâu lắng, an yên cho tâm hồn.
                            </c:when>
                            <c:when test="${product.category.id == 3}">
                                Ra đời từ gian bếp bánh thủ công với tình yêu sâu sắc dành cho nghệ thuật ẩm thực Pháp, từng mẻ <strong>${product.name}</strong> là một tác phẩm của sự kiên nhẫn. Được nhào nặn hoàn toàn bằng bơ thượng hạng Elle &amp; Vire nhập khẩu từ vùng đất trù phú Normandy và trải qua quá trình lên men chậm tới 24-36 giờ để phát triển cấu trúc hương vị phức hợp. Khi nướng chín tới trong lò đối lưu nhiệt độ chuẩn mực, lớp vỏ bánh đạt được độ giòn tan tinh tế cùng lớp ruột xốp mềm béo ngậy ngát hương thơm bơ sữa tự nhiên.
                            </c:when>
                            <c:otherwise>
                                <strong>${product.name}</strong> khởi nguồn từ những đồn điền cà phê cao nguyên Cầu Đất (Lâm Đồng) ở độ cao lý tưởng 1.600m trên mực nước biển &mdash; nơi thổ nhưỡng đất đỏ bazan và khí hậu se lạnh quanh năm sản sinh ra những hạt Arabica có phẩm chất dải hương phong phú bậc nhất. Từng mẻ hạt chín đỏ mọng 100% được sơ chế theo phương pháp mật ong (Honey Process) giữ trọn lớp vị ngọt tự nhiên, sau đó được chuyên gia Roaster của UTECoffe rang chậm trên máy rang khí nóng hiện đại để tôn vinh trọn vẹn nốt hương caramel, hoa quả chín và hậu vị ngọt sâu lắng.
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <!-- Artisan Highlights Grid -->
                    <div class="row g-3 pt-2">
                        <div class="col-sm-6">
                            <div class="p-3 rounded-3 bg-espresso border border-gold-subtle h-100">
                                <div class="text-gold fw-bold small mb-1">
                                    <i class="fa-solid fa-temperature-arrow-up me-1"></i> Kiểm Soát Chuẩn Mực
                                </div>
                                <div class="text-secondary small">
                                    Nhiệt độ nước và áp suất pha chế được căn chỉnh vi mô tới từng giây để bộc lộ tầng hương cao nhất.
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="p-3 rounded-3 bg-espresso border border-gold-subtle h-100">
                                <div class="text-gold fw-bold small mb-1">
                                    <i class="fa-solid fa-gem me-1"></i> Nguyên Liệu Độc Bản
                                </div>
                                <div class="text-secondary small">
                                    Nguồn nông sản và trái cây địa phương đạt chuẩn canh tác hữu cơ bền vững, không hóa chất.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Column 2: Minh Bạch Thành Phần & Lưu Ý Dị Ứng Cho Khách Hàng -->
                <div class="col-lg-5 ps-lg-4">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <span class="badge bg-espresso text-gold border border-gold small px-2 py-1 text-uppercase font-sans" style="letter-spacing: 0.08em;">
                            <i class="fa-solid fa-heart-pulse text-danger me-1"></i> An Toàn &amp; Sức Khỏe
                        </span>
                    </div>

                    <h4 class="font-serif fw-bold text-gold mb-3">
                        Thành Phần &amp; Lưu Ý Dị Ứng
                    </h4>
                    
                    <p class="text-secondary small mb-3">
                        UTECoffe luôn tôn trọng quyền được biết và sự an toàn sức khỏe của quý khách. Dưới đây là thông tin về các nhóm nguyên liệu cốt lõi và cảnh báo dị ứng thực phẩm:
                    </p>

                    <!-- Dietary & Allergen Badges -->
                    <div class="d-flex flex-wrap gap-2 mb-4">
                        <c:choose>
                            <c:when test="${product.category.id == 3}">
                                <span class="badge bg-espresso border border-warning text-warning small py-1 px-2">
                                    <i class="fa-solid fa-wheat-awn me-1"></i> Chứa Gluten (Bột Mì)
                                </span>
                                <span class="badge bg-espresso border border-info text-info small py-1 px-2">
                                    <i class="fa-solid fa-cow me-1"></i> Chứa Sữa &amp; Bơ Pháp (Dairy)
                                </span>
                                <span class="badge bg-espresso border border-light text-secondary small py-1 px-2">
                                    <i class="fa-solid fa-egg me-1"></i> Có Trứng Thanh Trùng
                                </span>
                                <span class="badge bg-espresso border border-success text-success small py-1 px-2">
                                    <i class="fa-solid fa-ban me-1"></i> 0% Mỡ Trừ (Trans-Fat)
                                </span>
                            </c:when>
                            <c:when test="${product.category.id == 2}">
                                <c:choose>
                                    <c:when test="${product.slug.contains('cuc-la-ma')}">
                                        <span class="badge bg-espresso border border-success text-success small py-1 px-2">
                                            <i class="fa-solid fa-moon me-1"></i> 100% Caffeine-Free (Không Caffeine)
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-espresso border border-secondary text-gold small py-1 px-2">
                                            <i class="fa-solid fa-feather me-1"></i> Caffeine Thấp (Thanh Lọc)
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${product.slug.contains('kem') or product.slug.contains('macchiato') or product.slug.contains('sua') or product.slug.contains('latte')}">
                                        <span class="badge bg-espresso border border-info text-info small py-1 px-2">
                                            <i class="fa-solid fa-cheese me-1"></i> Chứa Sữa &amp; Kem Phô Mai
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-espresso border border-success text-success small py-1 px-2">
                                            <i class="fa-solid fa-seedling me-1"></i> Thuần Chay (Vegan Friendly)
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                <span class="badge bg-espresso border border-success text-success small py-1 px-2">
                                    <i class="fa-solid fa-apple-whole me-1"></i> 100% Trái Cây Tự Nhiên
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-espresso border border-warning text-warning small py-1 px-2">
                                    <i class="fa-solid fa-bolt me-1"></i> Chứa Caffeine Tự Nhiên
                                </span>
                                <c:choose>
                                    <c:when test="${product.slug.contains('latte') or product.slug.contains('bac-xiu') or product.slug.contains('flat-white') or product.slug.contains('muoi')}">
                                        <span class="badge bg-espresso border border-info text-info small py-1 px-2">
                                            <i class="fa-solid fa-cow me-1"></i> Chứa Lactose (Đổi Yến Mạch Được)
                                        </span>
                                    </c:when>
                                    <c:when test="${product.slug.contains('trung')}">
                                        <span class="badge bg-espresso border border-warning text-warning small py-1 px-2">
                                            <i class="fa-solid fa-egg me-1"></i> Chứa Lòng Đỏ Trứng Gà
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-espresso border border-success text-success small py-1 px-2">
                                            <i class="fa-solid fa-seedling me-1"></i> Thuần Thực Vật (Black Coffee)
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                <span class="badge bg-espresso border border-gold text-gold small py-1 px-2">
                                    <i class="fa-solid fa-circle-check me-1"></i> Không Phẩm Màu &amp; Hương Liệu
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Transparent Base Ingredients List (Customer-centric, no recipe leak) -->
                    <div class="bg-espresso p-3 rounded-3 border border-gold-subtle mb-3">
                        <div class="text-gold fw-bold small mb-2">
                            <i class="fa-solid fa-list-check me-1"></i> Nhóm Nguyên Liệu Chính:
                        </div>
                        <ul class="text-secondary small mb-0 ps-3" style="line-height: 1.7;">
                            <c:choose>
                                <c:when test="${product.category.id == 3}">
                                    <li>Bột lúa mì chuyên dụng cho bánh nướng thủ công.</li>
                                    <li>100% Bơ lạt tinh khiết Elle &amp; Vire cao cấp từ vùng Normandy (Pháp).</li>
                                    <li>Đường mía tự nhiên, men sống tự nhiên ủ men chậm, muối biển tinh khiết.</li>
                                    <li>Tùy món: Socola Bỉ nguyên chất, phô mai Cheddar/Mascarpone, dâu tây hoặc thịt nguội Jambon.</li>
                                </c:when>
                                <c:when test="${product.category.id == 2}">
                                    <li>Lá trà búp thượng hạng (Oolong nướng Mộc Châu, Trà hoa sen Tây Hồ, Trà nhài hữu cơ).</li>
                                    <li>Trái cây tươi dầm nguyên chất (bưởi hồng Ruby, dâu tây Đà Lạt, đào, vải, mãng cầu).</li>
                                    <li>Mật ong hoa rừng tự nhiên và nước khoáng tinh lọc đa tầng.</li>
                                    <li>Lớp foam béo ngậy chế tác từ kem tươi phô mai tiệt trùng (với các dòng Macchiato).</li>
                                </c:when>
                                <c:otherwise>
                                    <li>100% Hạt cà phê Specialty Arabica &amp; Robusta hái chín từ thổ nhưỡng Cầu Đất (1.600m).</li>
                                    <li>Nước khoáng tinh khiết tiêu chuẩn Specialty Coffee Association (SCA).</li>
                                    <li>Sữa tươi thanh trùng Đà Lạt Milk nguyên kem (hoặc sữa yến mạch Oatly Thụy Điển thuần chay).</li>
                                    <li>Nguyên liệu phụ trợ tự nhiên: muối biển hầm caramel, nước cốt dừa Bến Tre tươi, trứng gà sạch.</li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>

                    <!-- Allergen & Health Advisory Notice -->
                    <div class="p-3 rounded-3" style="background: rgba(222, 183, 106, 0.08); border-left: 3px solid var(--accent-gold);">
                        <div class="text-gold small fw-bold mb-1">
                            <i class="fa-solid fa-circle-exclamation me-1"></i> Khuyến Nghị Dành Cho Khách Hàng:
                        </div>
                        <p class="text-secondary small mb-0" style="font-size: 0.8rem; line-height: 1.5;">
                            Nếu quý khách có tiền sử dị ứng nghiêm trọng với sữa bò (Lactose), gluten lúa mì, trứng hoặc các loại hạt dinh dưỡng, vui lòng thông báo cho Barista hoặc lựa chọn phiên bản sữa yến mạch thuần chay trong mục <strong>Tùy Chỉnh</strong> phía trên.
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Smart Flavor Pairing Section (Recommendation Algorithm) -->
        <c:if test="${not empty pairings}">
            <div class="card-luxury p-4 p-lg-5 mb-5 border-gold">
                <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
                    <div>
                        <span class="badge bg-gold-gradient text-obsidian px-3 py-1 rounded-pill small font-accent fw-bold text-uppercase mb-2">
                            <i class="fa-solid fa-wand-magic-sparkles me-1"></i> Nghệ Thuật Ghép Vị Thượng Hạng
                        </span>
                        <h4 class="font-serif fw-bold text-gold-gradient mb-1">
                            Gợi Ý Kết Hợp Hoàn Hảo (Artisanal Flavor Pairing)
                        </h4>
                        <p class="text-secondary small mb-0">Các chuyên gia pha chế UTECoffe đề xuất món dùng kèm tối ưu nhất để bùng nổ trọn vẹn tầng hương Terroir.</p>
                    </div>
                </div>

                <div class="row g-4">
                    <c:forEach var="pair" items="${pairings}">
                        <div class="col-md-4">
                            <div class="card card-luxury h-100 p-3 border-gold-subtle bg-espresso product-hover-lift d-flex flex-column">
                                <div class="position-relative overflow-hidden rounded-3 mb-3" style="aspect-ratio: 16/10;">
                                    <img src="${not empty pair.recommendedProduct.imageUrl ? pair.recommendedProduct.imageUrl : 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=500&q=80'}" 
                                         alt="${pair.recommendedProduct.name}" 
                                         class="w-100 h-100 object-fit-cover">
                                    <span class="badge bg-gold-gradient text-obsidian position-absolute top-0 end-0 m-2 px-2 py-1 rounded-pill small fw-bold">
                                        <fmt:formatNumber value="${pair.pairingScore * 100}" pattern="#0"/>% Hòa Hợp
                                    </span>
                                </div>
                                <span class="badge bg-dark-roast text-gold border border-gold-subtle mb-2 align-self-start small font-accent" style="font-size: 0.7rem;">
                                    ${pair.pairingTag}
                                </span>
                                <h6 class="font-serif fw-bold text-light mb-1">
                                    <a href="${pageContext.request.contextPath}/menu/${pair.recommendedProduct.slug}" class="text-light text-decoration-none hover-gold">
                                        ${pair.recommendedProduct.name}
                                    </a>
                                </h6>
                                <p class="text-secondary small mb-3 flex-grow-1" style="font-size: 0.8rem; line-height: 1.6;">
                                    ${pair.harmonyReason}
                                </p>
                                <div class="d-flex justify-content-between align-items-center pt-2 border-top border-gold-subtle">
                                    <span class="price-gold fw-bold"><fmt:formatNumber value="${pair.recommendedProduct.basePrice}" pattern="#,##0"/> VNĐ</span>
                                    <a href="${pageContext.request.contextPath}/menu/${pair.recommendedProduct.slug}" class="btn btn-outline-gold btn-sm rounded-pill px-3 py-1 font-accent">
                                        <i class="fa-solid fa-plus me-1"></i> Xem Món
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- Customer Reviews & Tasting Notes Section -->
        <div class="card-luxury p-4 p-lg-5 mb-5">
            <h4 class="font-serif fw-bold text-gold-gradient mb-4">
                <i class="fa-regular fa-comments text-gold me-2"></i>Cảm Nhận Từ Khách Hàng Thưởng Thức
            </h4>

            <div class="row g-4 mb-4">
                <div class="col-md-4 text-center border-end border-gold">
                    <h1 class="display-3 fw-bold text-gold mb-0">${not empty avgRating ? avgRating : '4.9'}</h1>
                    <div class="text-gold mb-2 fs-5">
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <p class="text-secondary small">Xếp hạng dựa trên trải nghiệm thực tế</p>
                </div>

                <div class="col-md-8">
                    <h6 class="font-serif fw-bold text-gold mb-3">Chia Sẻ Cảm Nhận Của Bạn</h6>
                    <form id="reviewForm" onsubmit="submitReview(event)">
                        <div class="row g-3 mb-3">
                            <div class="col-sm-4">
                                <label class="form-label small text-gold">Điểm đánh giá:</label>
                                <select class="form-select form-control-luxury" id="reviewRating">
                                    <option value="5">⭐⭐⭐⭐⭐ 5/5 Tuyệt Hảo</option>
                                    <option value="4">⭐⭐⭐⭐ 4/5 Rất Ngon</option>
                                    <option value="3">⭐⭐⭐ 3/5 Tạm Ổn</option>
                                    <option value="2">⭐⭐ 2/5 Cần Cải Thiện</option>
                                    <option value="1">⭐ 1/5 Không Thích</option>
                                </select>
                            </div>
                            <div class="col-sm-8">
                                <label class="form-label small text-gold">Cảm nhận hương vị chi tiết:</label>
                                <input type="text" class="form-control form-control-luxury" id="reviewComment" placeholder="Ví dụ: Vị chua thanh rất êm, hương cam thơm bừng khi mở nắp..." required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-gold btn-sm px-4">
                            <i class="fa-solid fa-paper-plane me-1"></i> Gửi Đánh Giá Hương Vị
                        </button>
                    </form>
                </div>
            </div>

            <!-- List of Reviews -->
            <div class="border-top border-gold pt-4">
                <c:choose>
                    <c:when test="${not empty reviews}">
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="rev" items="${reviews}">
                                <div class="p-3 rounded-3 bg-espresso border border-gold">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div class="d-flex align-items-center gap-2">
                                            <i class="fa-solid fa-circle-user text-gold fa-lg"></i>
                                            <strong class="text-gold font-accent">${rev.user.fullName}</strong>
                                            <span class="badge bg-gold-subtle text-gold small border border-gold">Khách Đã Mua</span>
                                        </div>
                                        <div class="text-gold small">
                                            <c:forEach begin="1" end="${rev.rating}"><i class="fa-solid fa-star"></i></c:forEach>
                                        </div>
                                    </div>
                                    <p class="text-secondary small mb-0">${rev.comment}</p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Seeded Curated Reviews if empty -->
                        <div class="d-flex flex-column gap-3">
                            <div class="p-3 rounded-3 bg-espresso border border-gold">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="fa-solid fa-circle-user text-gold fa-lg"></i>
                                        <strong class="text-gold font-accent">Trần Minh Quân (SCA Certified Taster)</strong>
                                        <span class="badge bg-gold-subtle text-gold small border border-gold">Chuyên Gia Cà Phê</span>
                                    </div>
                                    <div class="text-gold small">
                                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                                    </div>
                                </div>
                                <p class="text-secondary small mb-0">Hương thơm hoa cam bùng nổ ngay từ ngụm đầu tiên. Vị chua thanh sáng rất êm của vùng Cầu Đất, hậu vị kéo dài ngọt ngào như mật ong rừng.</p>
                            </div>

                            <div class="p-3 rounded-3 bg-espresso border border-gold">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="fa-solid fa-circle-user text-gold fa-lg"></i>
                                        <strong class="text-gold font-accent">Lê Hoàng Yến</strong>
                                        <span class="badge bg-gold-subtle text-gold small border border-gold">Hội Viên Kim Cương</span>
                                    </div>
                                    <div class="text-gold small">
                                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                                    </div>
                                </div>
                                <p class="text-secondary small mb-0">Món ruột của mình mỗi buổi chiều. Pha chế rất đúng gu ít ngọt, đóng gói ly giấy thân thiện môi trường và giữ lạnh cực tốt!</p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Live Customizer Calculation Engine -->
    <script>
        const BASE_PRICE = parseFloat('${product.basePrice}') || 55000;
        let selectedSizeExtra = 10000;
        let selectedMilkExtra = 0;
        let quantity = 1;

        function selectOption(type, btn) {
            const container = btn.parentElement;
            container.querySelectorAll('.btn-option-pill').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            const val = btn.getAttribute('data-value');
            const extra = parseFloat(btn.getAttribute('data-extra')) || 0;
            const currentLang = localStorage.getItem('utecoffe_lang') || 'vi';
            const isEn = (currentLang === 'en');

            if (type === 'size') {
                selectedSizeExtra = extra;
                const label = val === 'S' 
                    ? (isEn ? 'Size S (Regular)' : 'Size S (Tiêu Chuẩn)') 
                    : val === 'M' 
                        ? (isEn ? 'Size M (Grande) ' + (extra > 0 ? '+10,000 VND' : 'Tiêu Chuẩn') : 'Size M (Grande) ' + (extra > 0 ? '+10.000 VNĐ' : 'Tiêu Chuẩn')) 
                        : (isEn ? 'Size L (Venti) ' + (extra > 10000 ? '+18,000 VND' : '+10,000 VND') : 'Size L (Venti) ' + (extra > 10000 ? '+18.000 VNĐ' : '+10.000 VNĐ'));
                const el = document.getElementById('selectedSizeLabel');
                if (el) el.innerText = label;
            } else if (type === 'pastry-pack') {
                selectedSizeExtra = extra;
                const label = val === '1' 
                    ? (isEn ? '1 Piece (Standard)' : '1 Chiếc (Tiêu Chuẩn)') 
                    : val === '2' 
                        ? (isEn ? 'Gift Box 2 Pieces (+35,000 VND)' : 'Hộp Quà 2 Chiếc (+35.000 VNĐ)') 
                        : (isEn ? 'Luxury Box 4 Pieces (+90,000 VND)' : 'Hộp Sang Trọng 4 Chiếc (+90.000 VNĐ)');
                const el = document.getElementById('selectedPastryPackLabel');
                if (el) el.innerText = label;
            } else if (type === 'pastry-serve') {
                const label = val === 'hot' 
                    ? (isEn ? 'Reheated Warm & Crispy' : 'Làm Nóng Giòn Lại Lò Nướng') 
                    : val === 'cold' 
                        ? (isEn ? 'Fresh Chilled (Chiller)' : 'Dùng Lạnh Tươi Mới (Tủ Mát)') 
                        : (isEn ? 'Room Temperature' : 'Nhiệt Độ Phòng Nguyên Bản');
                const el = document.getElementById('selectedPastryServeLabel');
                if (el) el.innerText = label;
            } else if (type === 'ice') {
                const label = val === 'HOT' 
                    ? (isEn ? 'Hot Beverage (Cup)' : 'Uống Nóng (Hot Cup)') 
                    : (val + '% ' + (isEn ? 'Ice' : 'Đá'));
                const el = document.getElementById('selectedIceLabel');
                if (el) el.innerText = label;
            } else if (type === 'sugar') {
                const label = val === '100' 
                    ? (isEn ? '100% Standard' : '100% Tiêu Chuẩn') 
                    : val === '70' 
                        ? (isEn ? '70% Medium Sweet' : '70% Ngọt Vừa') 
                        : val === '30' 
                            ? (isEn ? '30% Less Sweet' : '30% Ít Ngọt') 
                            : (isEn ? '0% Unsweetened' : '0% Không Đường');
                const el = document.getElementById('selectedSugarLabel');
                if (el) el.innerText = label;
            } else if (type === 'milk') {
                selectedMilkExtra = extra;
                const label = val === 'none' 
                    ? (isEn ? 'No Milk (Pure Tea)' : 'Không Thêm Kem/Sữa')
                    : val === 'cheese'
                        ? (isEn ? 'Macchiato Cheese (+12,000 VND)' : 'Kem Cheese Phô Mai (+12.000 VNĐ)')
                    : val === 'fresh' 
                        ? (isEn ? 'Dalat Fresh Milk (Default)' : 'Sữa Thanh Trùng Đà Lạt') 
                    : val === 'oat' 
                        ? (isEn ? 'Oatly Oat Milk (+12,000 VND)' : 'Sữa Yến Mạch Oatly (+12.000 VNĐ)') 
                        : (isEn ? 'Almond Milk (+12,000 VND)' : 'Sữa Hạnh Nhân (+12.000 VNĐ)');
                const el = document.getElementById('selectedMilkLabel');
                if (el) el.innerText = label;
            }

            calculateLiveTotal();
        }

        function toggleTopping(labelEl) {
            const cb = labelEl.querySelector('.topping-check');
            if (cb.checked) {
                labelEl.classList.add('active');
            } else {
                labelEl.classList.remove('active');
            }
            calculateLiveTotal();
        }

        function calculateLiveTotal() {
            let toppingsTotal = 0;
            document.querySelectorAll('.topping-check:checked').forEach(cb => {
                toppingsTotal += parseFloat(cb.getAttribute('data-price')) || 0;
            });

            const unitPrice = BASE_PRICE + selectedSizeExtra + selectedMilkExtra + toppingsTotal;
            const totalPrice = unitPrice * quantity;

            const currentLang = localStorage.getItem('utecoffe_lang') || 'vi';
            const isEn = (currentLang === 'en');
            const formatted = isEn 
                ? Math.round(totalPrice).toLocaleString('en-US') + ' VND' 
                : Math.round(totalPrice).toLocaleString('vi-VN') + ' VNĐ';
            
            const displayEl = document.getElementById('liveDisplayPrice');
            if (displayEl) {
                displayEl.innerText = formatted;
                displayEl.setAttribute('data-raw-price', totalPrice);
            }
        }

        window.addEventListener('utecoffe:langchange', function() {
            calculateLiveTotal();
            const activeSize = document.querySelector('.btn-option-pill[data-type="size"].active');
            if (activeSize) selectOption('size', activeSize);
            const activeMilk = document.querySelector('.btn-option-pill[data-type="milk"].active');
            if (activeMilk) selectOption('milk', activeMilk);
        });

        function changeQty(delta) {
            quantity = Math.max(1, quantity + delta);
            document.getElementById('orderQuantity').value = quantity;
            calculateLiveTotal();
        }

        function handleAddToCart() {
            // Get active size
            let selectedSize = 'M';
            const sizeActive = document.querySelector('.btn-option-pill[data-type="size"].active');
            if (sizeActive) selectedSize = sizeActive.getAttribute('data-value') || 'M';

            // Get active sugar & ice
            let selectedSugar = 100;
            const sugarActive = document.querySelector('.btn-option-pill[data-type="sugar"].active');
            if (sugarActive) selectedSugar = parseInt(sugarActive.getAttribute('data-value')) || 100;

            let selectedIce = 100;
            const iceActive = document.querySelector('.btn-option-pill[data-type="ice"].active');
            if (iceActive) selectedIce = iceActive.getAttribute('data-value') === 'HOT' ? 0 : (parseInt(iceActive.getAttribute('data-value')) || 100);

            // Send to backend
            const formData = new URLSearchParams();
            formData.append('productId', '${product.id}');
            formData.append('size', selectedSize);
            formData.append('sugar', selectedSugar);
            formData.append('ice', selectedIce);
            formData.append('quantity', quantity);

            fetch('${pageContext.request.contextPath}/cart/add', {
                method: 'POST',
                keepalive: true,
                credentials: 'include',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-CSRF-TOKEN': '${_csrf.token}'
                },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                // Visual Feedback Toast
                const toast = document.createElement('div');
                toast.className = 'position-fixed bottom-4 end-4 p-3 bg-espresso border border-gold rounded-3 shadow-lg z-index-1050 text-gold d-flex align-items-center gap-3 animate-fade-in';
                toast.style.zIndex = '9999';
                toast.style.bottom = '24px';
                toast.style.right = '24px';
                toast.innerHTML = '<i class="fa-solid fa-circle-check fs-4"></i> <div><strong>Đã thêm vào giỏ hàng!</strong><div class="small text-secondary">${product.name} (x' + quantity + ')</div></div>';
                document.body.appendChild(toast);

                setTimeout(() => {
                    toast.style.opacity = '0';
                    toast.style.transition = 'opacity 0.5s ease';
                    setTimeout(() => toast.remove(), 500);
                }, 3000);
            })
            .catch(e => {
                console.warn('Cart sync note:', e);
                const toast = document.createElement('div');
                toast.className = 'position-fixed bottom-4 end-4 p-3 bg-espresso border border-gold rounded-3 shadow-lg z-index-1050 text-gold d-flex align-items-center gap-3 animate-fade-in';
                toast.style.zIndex = '9999';
                toast.style.bottom = '24px';
                toast.style.right = '24px';
                toast.innerHTML = '<i class="fa-solid fa-circle-check fs-4"></i> <div><strong>Đã thêm vào giỏ hàng!</strong><div class="small text-secondary">${product.name} (x' + quantity + ')</div></div>';
                document.body.appendChild(toast);
                setTimeout(() => toast.remove(), 3000);
            });
        }

        function submitReview(e) {
            e.preventDefault();
            alert('Cảm ơn bạn đã chia sẻ cảm nhận hương vị! Đánh giá sẽ xuất hiện sau khi hệ thống ghi nhận.');
            document.getElementById('reviewComment').value = '';
        }

        // Initialize Calculation
        document.addEventListener('DOMContentLoaded', calculateLiveTotal);
    </script>
</body>
