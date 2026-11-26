<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Thực Đơn Cà Phê &amp; Trà Đặc Sản - UTECoffe Specialty Roastery</title>
    <style>
        .custom-gold-range {
            accent-color: #DEB76A;
        }
        .fuzzy-suggestion-item {
            cursor: pointer;
            transition: background 0.2s;
        }
        .fuzzy-suggestion-item:hover {
            background: rgba(222, 183, 106, 0.15) !important;
        }
    </style>
</head>
<body class="bg-obsidian">

    <!-- Header Luxury Hero Banner -->
    <div class="py-5 bg-espresso border-bottom border-gold text-center position-relative overflow-hidden">
        <div class="container py-4 position-relative" style="z-index: 2;">
            <span class="badge bg-gold-subtle text-gold px-3 py-1 rounded-2 small mb-3 fw-medium" data-i18n="feat.subtitle">
                <i class="fa-solid fa-gem me-1"></i> Bộ Sưu Tập Hương Vị 2026
            </span>
            <h1 class="font-serif display-4 fw-bold text-primary mb-3" data-i18n="nav.menu">
                Thực Đơn Nghệ Nhân
            </h1>
            <p class="text-secondary mx-auto fs-6 mb-4" style="max-width: 680px; line-height: 1.7;" data-i18n="menu.hero_desc">
                Trải nghiệm những nốt hương tinh tuyển từ cao nguyên Cầu Đất 1.600m và đồi chè cổ thụ. Mỗi mẻ rang được các Master Roaster chế tác thủ công để tôn vinh sự nguyên bản.
            </p>

            <!-- Search Bar in Hero with Smart Fuzzy Suggestions -->
            <div class="mx-auto position-relative" style="max-width: 540px;">
                <div class="input-group search-input-group shadow-sm">
                    <span class="input-group-text bg-card-dark border-gold text-gold ps-3">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </span>
                    <input type="text" id="menuSearchInput" class="form-control form-control-luxury border-start-0 ps-2" 
                           placeholder="Tìm kiếm cà phê, trà hoa, cold brew, bánh mộc..." 
                           data-i18n-placeholder="menu.search_placeholder"
                           aria-label="Tìm kiếm thức uống" autocomplete="off">
                    <button class="btn btn-outline-gold px-3" type="button" id="clearSearchBtn" style="display: none;">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                </div>

                <!-- Fuzzy Search Suggestions Dropdown -->
                <div id="fuzzySuggestionsBox" class="position-absolute w-100 bg-card-dark border border-gold rounded-3 shadow-lg mt-1 p-2 text-start d-none" style="z-index: 1050;">
                    <div class="d-flex justify-content-between align-items-center px-2 py-1 border-bottom border-gold-subtle mb-1">
                        <small class="text-gold font-accent"><i class="fa-solid fa-wand-magic-sparkles me-1"></i> Gợi ý tìm kiếm phù hợp</small>
                        <span class="badge bg-gold-subtle text-gold small">Gợi ý</span>
                    </div>
                    <div id="fuzzySuggestionsList" class="d-flex flex-column gap-1"></div>
                </div>
            </div>

            <!-- Taste Matcher Trigger Button -->
            <div class="mt-3">
                <button class="btn btn-dark-roast border border-gold text-gold rounded-2 px-3.5 py-2 shadow-sm" type="button" data-bs-toggle="collapse" data-bs-target="#tasteMatcherCollapse" aria-expanded="false" aria-controls="tasteMatcherCollapse">
                    <i class="fa-solid fa-wand-magic-sparkles text-gold me-2"></i><span data-i18n="menu.taste_btn">Trải Nghiệm Tìm Cà Phê Hợp Gu (Sensory Taste Matcher)</span>
                </button>
            </div>

            <!-- Taste Matcher Collapsible Card -->
            <div class="collapse mt-4 text-start" id="tasteMatcherCollapse">
                <div class="card-luxury p-4 mx-auto border-gold shadow-lg" style="max-width: 820px; background: rgba(26, 21, 18, 0.96); backdrop-filter: blur(12px);">
                    <div class="d-flex justify-content-between align-items-center mb-3 border-bottom border-gold pb-2">
                        <div>
                            <h5 class="font-serif fw-bold text-primary mb-0" data-i18n="menu.taste_title">
                                <i class="fa-solid fa-compass-drafting me-2 text-gold"></i>Định Hình Khẩu Vị Cảm Quan (Artisanal Cupping Profile)
                            </h5>
                            <small class="text-secondary" data-i18n="menu.taste_subtitle">Phân tích gu thưởng thức của bạn để gợi ý các mẻ rang đặc sản chuẩn vị SCA Cupping</small>
                        </div>
                        <span class="badge bg-gold text-dark font-accent fw-bold px-3 py-1">SCA MATCH</span>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small text-gold font-accent d-flex justify-content-between">
                                <span data-i18n="menu.taste_acidity"><i class="fa-solid fa-lemon me-1"></i> Độ Chua Thanh (Acidity)</span>
                                <span class="fw-bold" id="valAcidity">3.5 / 5.0</span>
                            </label>
                            <input type="range" class="form-range custom-gold-range" id="sliderAcidity" min="1.0" max="5.0" step="0.5" value="3.5">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small text-gold font-accent d-flex justify-content-between">
                                <span data-i18n="menu.taste_body"><i class="fa-solid fa-shield-halved me-1"></i> Thể Chất / Đậm Đà (Body)</span>
                                <span class="fw-bold" id="valBody">3.5 / 5.0</span>
                            </label>
                            <input type="range" class="form-range custom-gold-range" id="sliderBody" min="1.0" max="5.0" step="0.5" value="3.5">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small text-gold font-accent d-flex justify-content-between">
                                <span data-i18n="menu.taste_sweetness"><i class="fa-solid fa-candy-cane me-1"></i> Ngọt Hậu (Sweetness)</span>
                                <span class="fw-bold" id="valSweetness">4.0 / 5.0</span>
                            </label>
                            <input type="range" class="form-range custom-gold-range" id="sliderSweetness" min="1.0" max="5.0" step="0.5" value="4.0">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small text-gold font-accent d-flex justify-content-between">
                                <span data-i18n="menu.taste_bitterness"><i class="fa-solid fa-mug-hot me-1"></i> Đắng Dịu (Bitterness)</span>
                                <span class="fw-bold" id="valBitterness">2.5 / 5.0</span>
                            </label>
                            <input type="range" class="form-range custom-gold-range" id="sliderBitterness" min="1.0" max="5.0" step="0.5" value="2.5">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small text-gold font-accent d-flex justify-content-between">
                                <span data-i18n="menu.taste_aroma"><i class="fa-solid fa-spa me-1"></i> Hương Hoa / Trái Cây (Aroma)</span>
                                <span class="fw-bold" id="valAroma">4.5 / 5.0</span>
                            </label>
                            <input type="range" class="form-range custom-gold-range" id="sliderAroma" min="1.0" max="5.0" step="0.5" value="4.5">
                        </div>
                    </div>

                    <div class="text-center mt-4">
                        <button type="button" class="btn btn-gold px-5 py-2 fw-bold font-accent shadow-lg" id="btnRunTasteMatch">
                            <i class="fa-solid fa-microchip me-2"></i> <span data-i18n="menu.taste_run">PHÂN TÍCH GU CẢM QUAN HOÀN HẢO</span>
                        </button>
                    </div>

                    <!-- Taste Match Results Container -->
                    <div id="tasteMatchResultsArea" class="mt-4 pt-3 border-top border-gold-subtle d-none">
                        <h6 class="text-gold font-accent mb-3"><i class="fa-solid fa-star me-2"></i><span data-i18n="menu.taste_result_title">Cà Phê Phù Hợp Nhất Với Khẩu Vị Của Bạn:</span></h6>
                        <div class="row g-3" id="tasteMatchCardsRow"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content Area -->
    <div class="container py-5">
        <!-- Interactive Controls Bar: Category Filter Pills + Sort Dropdown -->
        <div class="row align-items-center mb-5 g-3">
            <div class="col-lg-9">
                <div class="d-flex flex-wrap gap-2 category-filter-group" role="tablist">
                    <a href="${pageContext.request.contextPath}/menu" 
                       class="btn ${empty selectedCategoryId ? 'btn-gold' : 'btn-outline-gold'} btn-sm px-3.5 py-1.5 rounded-2 fw-medium filter-btn ${empty selectedCategoryId ? 'active' : ''}" 
                       data-cat="all">
                        <i class="fa-solid fa-layer-group me-1"></i> <span data-i18n="menu.filter_all">Tất Cả Món</span> (<span id="totalProductCount">${products.size()}</span>)
                    </a>
                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/menu?categoryId=${cat.id}" 
                           class="btn ${selectedCategoryId == cat.id ? 'btn-gold' : 'btn-outline-gold'} btn-sm px-3.5 py-1.5 rounded-2 fw-medium filter-btn product-category-badge ${selectedCategoryId == cat.id ? 'active' : ''}"
                           data-cat="${cat.id}" data-category-name="${cat.name}">
                            ${cat.name}
                        </a>
                    </c:forEach>
                </div>
            </div>

            <div class="col-lg-3 text-lg-end">
                <div class="d-inline-flex align-items-center gap-2">
                    <span class="small text-secondary text-nowrap"><i class="fa-solid fa-arrow-down-short-wide text-gold me-1"></i><span data-i18n="menu.sort_label">Sắp xếp:</span></span>
                    <select id="menuSortSelect" class="form-select form-control-luxury py-1 px-3 small font-accent" style="width: auto;">
                        <option value="featured">Nổi bật nhất</option>
                        <option value="price-asc">Giá: Thấp &rarr; Cao</option>
                        <option value="price-desc">Giá: Cao &rarr; Thấp</option>
                        <option value="name-asc">Tên: A &rarr; Z</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Empty Results Alert (Hidden by default, shown by JS filter) -->
        <div id="noProductsFoundAlert" class="text-center py-5 d-none">
            <div class="card-luxury p-5 mx-auto" style="max-width: 500px;">
                <i class="fa-solid fa-mug-saucer text-gold display-3 mb-3 opacity-50"></i>
                <h4 class="font-serif fw-bold text-gold-gradient mb-2" data-i18n="menu.empty_title">Không Tìm Thấy Món Phù Hợp</h4>
                <p class="text-secondary small mb-4" data-i18n="menu.empty_desc">Rất tiếc chúng tôi chưa tìm thấy thức uống phù hợp với từ khóa của bạn. Hãy thử tìm kiếm từ khóa khác hoặc khám phá toàn bộ thực đơn.</p>
                <button type="button" class="btn btn-gold btn-sm px-4" id="resetFiltersBtn">
                    <i class="fa-solid fa-rotate-left me-1"></i> <span data-i18n="menu.empty_reset">Xem Toàn Bộ Thực Đơn</span>
                </button>
            </div>
        </div>

        <!-- Product Cards Grid -->
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-4" id="productGridContainer">
            <c:forEach var="p" items="${products}">
                <div class="col product-card-col" 
                     data-name="${p.name.toLowerCase()}" 
                     data-slug="${p.slug}"
                     data-desc="${empty p.description ? '' : p.description.toLowerCase()}" 
                     data-price="${p.basePrice}"
                     data-cat="${p.category.id}">
                    <div class="card-luxury h-100 d-flex flex-column border-gold position-relative overflow-hidden group-hover-glow">
                        <!-- Featured Badge -->
                        <c:if test="${p.isFeatured}">
                            <div class="position-absolute top-0 end-0 m-3" style="z-index: 3;">
                                <span class="badge bg-gold text-dark px-2 py-1 font-accent fw-bold small shadow signature-badge">
                                    <i class="fa-solid fa-award me-1"></i> Signature
                                </span>
                            </div>
                        </c:if>

                        <!-- Product Image Area -->
                        <div class="position-relative overflow-hidden" style="height: 220px; background-color: #120e0c;">
                            <img src="${empty p.imageUrl ? 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=800' : p.imageUrl}" 
                                 class="card-img-top w-100 h-100 object-fit-cover transition-transform" 
                                 alt="${p.name}"
                                 loading="lazy">
                            <div class="card-img-overlay d-flex flex-column justify-content-end p-2 bg-gradient-dark">
                                <span class="badge bg-dark-roast border border-gold-subtle text-gold align-self-start font-accent small product-category-badge" data-category-name="${p.category.name}">
                                    ${p.category.name}
                                </span>
                            </div>
                        </div>

                        <!-- Card Body -->
                        <div class="p-3 d-flex flex-column flex-grow-1">
                            <h5 class="font-serif fw-bold text-primary mb-1 line-clamp-1 product-title-text" title="${p.name}" data-slug="${p.slug}">
                                ${p.name}
                            </h5>
                            <p class="text-secondary small mb-3 flex-grow-1 line-clamp-2 product-desc-text" data-slug="${p.slug}" style="font-size: 0.825rem; line-height: 1.5;">
                                ${empty p.description ? 'Hương vị cà phê đặc sản thủ công cao cấp được tuyển chọn từ các vùng nguyên liệu nổi tiếng.' : p.description}
                            </p>

                            <!-- Price and Action Strip -->
                            <div class="d-flex align-items-center justify-content-between pt-2 border-top border-gold-subtle mt-auto">
                                <div>
                                    <span class="small text-secondary d-block font-accent" style="font-size: 0.75rem;" data-i18n="menu.original_price">Giá nguyên bản:</span>
                                    <span class="fw-bold text-gold fs-6 product-price-val" data-raw-price="${p.basePrice}" data-vnd="${p.basePrice}">
                                        <fmt:formatNumber value="${p.basePrice}" pattern="#,###"/> VNĐ
                                    </span>
                                </div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/menu/${p.slug}" 
                                       class="btn btn-gold btn-sm px-3 fw-semibold">
                                        <i class="fa-solid fa-sliders me-1"></i> <span data-i18n="menu.customize">Tùy Chỉnh</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Craftsmanship Callout Footer Banner -->
        <div class="mt-5 pt-4">
            <div class="card-luxury p-4 p-md-5 border-gold bg-gradient-dark text-center position-relative overflow-hidden">
                <div class="position-relative" style="z-index: 2;">
                    <span class="badge bg-gold-subtle text-gold px-3 py-1 rounded-2 small mb-2 fw-medium" data-i18n="menu.sca_badge">
                        <i class="fa-solid fa-certificate me-1"></i> Tiêu Chuẩn Quốc Tế SCA
                    </span>
                    <h3 class="font-serif fw-bold text-primary mb-3" data-i18n="menu.sca_title">
                        Tùy Chỉnh Tách Cà Phê Của Riêng Bạn
                    </h3>
                    <p class="text-secondary mx-auto mb-4" style="max-width: 620px; font-size: 0.95rem;" data-i18n="menu.sca_desc">
                        Tất cả thức uống tại UTECoffe đều cho phép cá nhân hóa: Lựa chọn 3 size (S/M/L), thêm các loại hạt, thạch trà thủ công, điều chỉnh độ đậm hạt, hương hoa và tỷ lệ sữa để tạo nên ly cà phê chuẩn gu của bạn.
                    </p>
                    <div class="d-flex justify-content-center gap-3 flex-wrap">
                        <a href="${pageContext.request.contextPath}/story" class="btn btn-outline-gold px-4 py-2">
                            <i class="fa-solid fa-book-open me-1"></i> <span data-i18n="menu.sca_btn_story">Tìm Hiểu Nghệ Thuật Rang Mộc</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/reservation" class="btn btn-gold px-4 py-2">
                            <i class="fa-solid fa-calendar-check me-1"></i> <span data-i18n="menu.sca_btn_reserve">Đặt Bàn Thưởng Thức Tại Quán</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Live Search & Sort JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const searchInput = document.getElementById('menuSearchInput');
            const clearSearchBtn = document.getElementById('clearSearchBtn');
            const sortSelect = document.getElementById('menuSortSelect');
            const productGrid = document.getElementById('productGridContainer');
            const noProductsAlert = document.getElementById('noProductsFoundAlert');
            const resetBtn = document.getElementById('resetFiltersBtn');
            const totalCountEl = document.getElementById('totalProductCount');
            const fuzzyBox = document.getElementById('fuzzySuggestionsBox');
            const fuzzyList = document.getElementById('fuzzySuggestionsList');

            if (!searchInput || !productGrid) return;

            const cards = Array.from(productGrid.querySelectorAll('.product-card-col'));

            // 1. Standard Live Filter & Sort
            function filterAndSort() {
                const query = searchInput.value.trim().toLowerCase();
                if (clearSearchBtn) {
                    clearSearchBtn.style.display = query ? 'block' : 'none';
                }

                let visibleCount = 0;
                cards.forEach(card => {
                    const name = card.getAttribute('data-name') || '';
                    const desc = card.getAttribute('data-desc') || '';
                    const matchesQuery = !query || name.includes(query) || desc.includes(query);

                    if (matchesQuery) {
                        card.classList.remove('d-none');
                        visibleCount++;
                    } else {
                        card.classList.add('d-none');
                    }
                });

                if (noProductsAlert) {
                    if (visibleCount === 0) {
                        noProductsAlert.classList.remove('d-none');
                        productGrid.classList.add('d-none');
                    } else {
                        noProductsAlert.classList.add('d-none');
                        productGrid.classList.remove('d-none');
                    }
                }

                if (totalCountEl && !query) {
                    totalCountEl.textContent = cards.length;
                } else if (totalCountEl) {
                    totalCountEl.textContent = visibleCount;
                }

                // Sort visible cards
                const sortMode = sortSelect ? sortSelect.value : 'featured';
                const sortedCards = cards.slice().sort((a, b) => {
                    if (sortMode === 'price-asc') {
                        return parseFloat(a.getAttribute('data-price') || 0) - parseFloat(b.getAttribute('data-price') || 0);
                    } else if (sortMode === 'price-desc') {
                        return parseFloat(b.getAttribute('data-price') || 0) - parseFloat(a.getAttribute('data-price') || 0);
                    } else if (sortMode === 'name-asc') {
                        return (a.getAttribute('data-name') || '').localeCompare(b.getAttribute('data-name') || '');
                    }
                    return 0; // default
                });

                sortedCards.forEach(card => productGrid.appendChild(card));
            }

            // 2. Smart Fuzzy Search API Hook
            let debounceTimer = null;
            searchInput.addEventListener('input', function () {
                filterAndSort();

                const q = searchInput.value.trim();
                clearTimeout(debounceTimer);
                if (q.length < 2) {
                    if (fuzzyBox) fuzzyBox.classList.add('d-none');
                    return;
                }

                debounceTimer = setTimeout(() => {
                    fetch('${pageContext.request.contextPath}/api/products/fuzzy-search?q=' + encodeURIComponent(q) + '&threshold=0.35&limit=4')
                        .then(res => res.json())
                        .then(res => {
                            if (res.success && res.data && res.data.length > 0) {
                                fuzzyList.innerHTML = '';
                                res.data.forEach(item => {
                                    const matchPercent = Math.round(item.matchScore * 100);
                                    const div = document.createElement('div');
                                    div.className = 'fuzzy-suggestion-item p-2 rounded d-flex justify-content-between align-items-center';
                                    div.innerHTML = `
                                        <div>
                                            <span class="text-primary fw-bold">${item.productName}</span>
                                            <small class="text-secondary d-block" style="font-size:0.75rem;">${item.matchHighlight}</small>
                                        </div>
                                        <div class="text-end">
                                            <span class="badge bg-gold-subtle text-gold small">${matchPercent}% khớp</span>
                                            <a href="${pageContext.request.contextPath}/menu/${item.productSlug}" class="btn btn-sm btn-outline-gold py-0 px-2 ms-2 font-accent" style="font-size:0.75rem;">Xem</a>
                                        </div>
                                    `;
                                    div.addEventListener('click', () => {
                                        window.location.href = '${pageContext.request.contextPath}/menu/' + item.productSlug;
                                    });
                                    fuzzyList.appendChild(div);
                                });
                                fuzzyBox.classList.remove('d-none');
                            } else {
                                fuzzyBox.classList.add('d-none');
                            }
                        })
                        .catch(() => {
                            if (fuzzyBox) fuzzyBox.classList.add('d-none');
                        });
                }, 300);
            });

            document.addEventListener('click', function (e) {
                if (fuzzyBox && !fuzzyBox.contains(e.target) && e.target !== searchInput) {
                    fuzzyBox.classList.add('d-none');
                }
            });

            if (clearSearchBtn) {
                clearSearchBtn.addEventListener('click', function () {
                    searchInput.value = '';
                    if (fuzzyBox) fuzzyBox.classList.add('d-none');
                    filterAndSort();
                    searchInput.focus();
                });
            }
            if (sortSelect) {
                sortSelect.addEventListener('change', filterAndSort);
            }
            if (resetBtn) {
                resetBtn.addEventListener('click', function () {
                    searchInput.value = '';
                    if (fuzzyBox) fuzzyBox.classList.add('d-none');
                    filterAndSort();
                });
            }

            // 3. AI Taste Matcher (Cosine Similarity) Slider Listeners & API Call
            const sAcid = document.getElementById('sliderAcidity');
            const sBody = document.getElementById('sliderBody');
            const sSweet = document.getElementById('sliderSweetness');
            const sBit = document.getElementById('sliderBitterness');
            const sAroma = document.getElementById('sliderAroma');

            const vAcid = document.getElementById('valAcidity');
            const vBody = document.getElementById('valBody');
            const vSweet = document.getElementById('valSweetness');
            const vBit = document.getElementById('valBitterness');
            const vAroma = document.getElementById('valAroma');

            if (sAcid) sAcid.addEventListener('input', () => vAcid.textContent = sAcid.value + ' / 5.0');
            if (sBody) sBody.addEventListener('input', () => vBody.textContent = sBody.value + ' / 5.0');
            if (sSweet) sSweet.addEventListener('input', () => vSweet.textContent = sSweet.value + ' / 5.0');
            if (sBit) sBit.addEventListener('input', () => vBit.textContent = sBit.value + ' / 5.0');
            if (sAroma) sAroma.addEventListener('input', () => vAroma.textContent = sAroma.value + ' / 5.0');

            const btnMatch = document.getElementById('btnRunTasteMatch');
            const resultsArea = document.getElementById('tasteMatchResultsArea');
            const cardsRow = document.getElementById('tasteMatchCardsRow');

            if (btnMatch) {
                btnMatch.addEventListener('click', function () {
                    btnMatch.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-2"></i> Đang tìm hương vị phù hợp nhất...';
                    btnMatch.disabled = true;

                    const url = '${pageContext.request.contextPath}/api/products/taste-match?'
                        + 'acidity=' + sAcid.value
                        + '&body=' + sBody.value
                        + '&sweetness=' + sSweet.value
                        + '&bitterness=' + sBit.value
                        + '&aroma=' + sAroma.value
                        + '&limit=3';

                    fetch(url)
                        .then(res => res.json())
                        .then(res => {
                            btnMatch.innerHTML = '<i class="fa-solid fa-microchip me-2"></i> PHÂN TÍCH GU CẢM QUAN HOÀN HẢO';
                            btnMatch.disabled = false;

                            if (res.success && res.data && res.data.length > 0) {
                                cardsRow.innerHTML = '';
                                res.data.forEach(item => {
                                    const col = document.createElement('div');
                                    col.className = 'col-md-4';
                                    const notesHtml = (item.tastingNotes || []).map(n => `<span class="badge bg-dark-roast border border-gold-subtle text-gold me-1 mb-1 font-accent" style="font-size:0.7rem;">${n}</span>`).join('');
                                    const formattedPrice = new Intl.NumberFormat('vi-VN').format(item.price);

                                    col.innerHTML = `
                                        <div class="card-luxury p-3 border-gold h-100 d-flex flex-column" style="background:#140f0c;">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <span class="badge bg-gold text-dark font-accent fw-bold" style="font-size:0.75rem;">
                                                    <i class="fa-solid fa-trophy me-1"></i> ${item.matchScorePercent}% HỢP GU
                                                </span>
                                                <span class="badge bg-gold-subtle text-gold font-accent" style="font-size:0.7rem;">${item.scaCuppingScore}</span>
                                            </div>
                                            <img src="${item.productImageUrl || 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=800'}" class="w-100 rounded mb-2 object-fit-cover" style="height:120px;" alt="${item.productName}">
                                            <h6 class="font-serif fw-bold text-primary mb-1">${item.productName}</h6>
                                            <small class="text-gold font-accent d-block mb-1" style="font-size:0.75rem;"><i class="fa-solid fa-mountain me-1"></i>${item.terroir || 'Cầu Đất, Lâm Đồng'}</small>
                                            <p class="text-secondary small mb-2 flex-grow-1" style="font-size:0.78rem; line-height:1.4;">${item.sensoryVerdict}</p>
                                            <div class="mb-2">${notesHtml}</div>
                                            <div class="d-flex justify-content-between align-items-center mt-auto pt-2 border-top border-gold-subtle">
                                                <span class="fw-bold text-gold fs-6">${formattedPrice} VNĐ</span>
                                                <a href="${pageContext.request.contextPath}/menu/${item.productSlug}" class="btn btn-sm btn-gold rounded-pill px-3 font-accent">
                                                    Thưởng Thức <i class="fa-solid fa-arrow-right ms-1"></i>
                                                </a>
                                            </div>
                                        </div>
                                    `;
                                    cardsRow.appendChild(col);
                                });
                                resultsArea.classList.remove('d-none');
                            }
                        })
                        .catch(err => {
                            btnMatch.innerHTML = '<i class="fa-solid fa-microchip me-2"></i> PHÂN TÍCH GU CẢM QUAN HOÀN HẢO';
                            btnMatch.disabled = false;
                            alert('Không thể kết nối đến máy chủ tính toán ma trận cảm quan.');
                        });
                });
            }
        });
    </script>
</body>
