<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Thực Đơn Cà Phê &amp; Trà Đặc Sản - UTECoffe Specialty Roastery</title>
</head>
<body class="bg-obsidian">

    <!-- Header Luxury Hero Banner -->
    <div class="py-5 bg-espresso border-bottom border-gold text-center position-relative overflow-hidden">
        <div class="container py-4 position-relative" style="z-index: 2;">
            <span class="badge bg-gold-subtle text-gold px-3 py-1 rounded-pill small font-accent mb-3 text-uppercase" style="letter-spacing: 0.15em;" data-i18n="feat.subtitle">
                <i class="fa-solid fa-gem me-1"></i> BỘ SƯU TẬP HƯƠNG VỊ 2026
            </span>
            <h1 class="font-serif display-4 fw-bold text-gold-gradient mb-3" data-i18n="nav.menu">
                Thực Đơn Nghệ Nhân
            </h1>
            <p class="text-secondary mx-auto fs-6 mb-4" style="max-width: 680px; line-height: 1.7;">
                Trải nghiệm những nốt hương tinh tuyển từ cao nguyên Cầu Đất 1.600m và đồi chè cổ thụ. Mỗi mẻ rang được các Master Roaster chế tác thủ công để tôn vinh sự nguyên bản.
            </p>

            <!-- Search Bar in Hero -->
            <div class="mx-auto" style="max-width: 540px;">
                <div class="input-group search-input-group shadow-sm">
                    <span class="input-group-text bg-card-dark border-gold text-gold ps-3">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </span>
                    <input type="text" id="menuSearchInput" class="form-control form-control-luxury border-start-0 ps-2" 
                           placeholder="Tìm kiếm cà phê, trà hoa, cold brew, bánh mộc..." 
                           aria-label="Tìm kiếm thức uống">
                    <button class="btn btn-outline-gold px-3" type="button" id="clearSearchBtn" style="display: none;">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
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
                       class="btn ${empty selectedCategoryId ? 'btn-gold' : 'btn-outline-gold'} btn-sm px-4 py-2 rounded-pill fw-semibold font-accent filter-btn ${empty selectedCategoryId ? 'active' : ''}" 
                       data-cat="all">
                        <i class="fa-solid fa-layer-group me-1"></i> Tất Cả Món (<span id="totalProductCount">${products.size()}</span>)
                    </a>
                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/menu?categoryId=${cat.id}" 
                           class="btn ${selectedCategoryId == cat.id ? 'btn-gold' : 'btn-outline-gold'} btn-sm px-4 py-2 rounded-pill fw-semibold font-accent filter-btn ${selectedCategoryId == cat.id ? 'active' : ''}"
                           data-cat="${cat.id}">
                            ${cat.name}
                        </a>
                    </c:forEach>
                </div>
            </div>

            <div class="col-lg-3 text-lg-end">
                <div class="d-inline-flex align-items-center gap-2">
                    <span class="small text-secondary text-nowrap"><i class="fa-solid fa-arrow-down-short-wide text-gold me-1"></i>Sắp xếp:</span>
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
                <h4 class="font-serif fw-bold text-gold-gradient mb-2">Không Tìm Thấy Món Phù Hợp</h4>
                <p class="text-secondary small mb-4">Rất tiếc chúng tôi chưa tìm thấy thức uống phù hợp với từ khóa của bạn. Hãy thử tìm kiếm từ khóa khác hoặc khám phá toàn bộ thực đơn.</p>
                <button type="button" class="btn btn-gold btn-sm px-4" id="resetFiltersBtn">
                    <i class="fa-solid fa-rotate-left me-1"></i> Xem Toàn Bộ Thực Đơn
                </button>
            </div>
        </div>

        <!-- Product Cards Grid -->
        <div class="row g-4" id="productGridContainer">
            <c:forEach var="prod" items="${products}">
                <div class="col-lg-3 col-md-6 product-card-col" 
                     data-name="${prod.name.toLowerCase()}" 
                     data-desc="${not empty prod.description ? prod.description.toLowerCase() : ''}"
                     data-cat="${prod.category.id}"
                     data-price="${prod.basePrice}">
                    <div class="card card-luxury h-100 d-flex flex-column product-hover-lift">
                        <!-- Product Image & Badges (Clickable directly to Story & Details) -->
                        <c:choose>
                            <c:when test="${empty prod.imageUrl}">
                                <c:set var="curProdImg" value="https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=500&q=80"/>
                            </c:when>
                            <c:when test="${prod.imageUrl.startsWith('http')}">
                                <c:set var="curProdImg" value="${prod.imageUrl}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="curProdImg" value="${pageContext.request.contextPath}${prod.imageUrl}"/>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/menu/${prod.slug}" class="product-image-container position-relative overflow-hidden d-block text-decoration-none" style="aspect-ratio: 4/3; cursor: pointer;" title="${prod.name} - Khám phá câu chuyện &amp; thành phần">
                            <img src="${curProdImg}" 
                                 alt="${prod.name}" 
                                 class="product-thumb-img w-100 h-100 object-fit-cover"
                                 loading="lazy">
                            <span class="badge-luxury-tag position-absolute top-0 start-0 m-3">
                                ${prod.category.name}
                            </span>
                            <span class="badge bg-gold-gradient text-obsidian fw-bold position-absolute top-0 end-0 m-3 px-2 py-1 rounded-pill small">
                                <i class="fa-solid fa-award me-1"></i> Special
                            </span>
                        </a>

                        <!-- Card Body -->
                        <div class="card-body p-4 d-flex flex-column flex-grow-1">
                            <!-- Tasting Notes / Terroir Mini-Pill -->
                            <div class="mb-2">
                                <c:choose>
                                    <c:when test="${prod.category.id == 2}">
                                        <span class="badge bg-espresso text-gold border border-gold-subtle px-2 py-1 rounded-pill" style="font-size: 0.72rem; letter-spacing: 0.05em;">
                                            <i class="fa-solid fa-leaf me-1 text-success"></i> <span data-i18n="terroir.tea">Trà Cổ Thụ &amp; Sen Tây Hồ</span>
                                        </span>
                                    </c:when>
                                    <c:when test="${prod.category.id == 3}">
                                        <span class="badge bg-espresso text-gold border border-gold-subtle px-2 py-1 rounded-pill" style="font-size: 0.72rem; letter-spacing: 0.05em;">
                                            <i class="fa-solid fa-wheat-awn me-1 text-warning"></i> <span data-i18n="terroir.pastry">Bơ Pháp Elle &amp; Vire 100%</span>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-espresso text-gold border border-gold-subtle px-2 py-1 rounded-pill" style="font-size: 0.72rem; letter-spacing: 0.05em;">
                                            <i class="fa-solid fa-seedling me-1"></i> <span data-i18n="terroir.coffee">Cao Nguyên Cầu Đất 1.600m</span>
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <h5 class="font-serif fw-bold mb-2">
                                <a href="${pageContext.request.contextPath}/menu/${prod.slug}" class="text-primary text-decoration-none hover-gold product-title-link">
                                    ${prod.name}
                                </a>
                            </h5>
                            
                            <p class="text-secondary small flex-grow-1 mb-3 text-truncate-2" style="min-height: 2.6rem;">
                                ${not empty prod.description ? prod.description : 'Tuyệt phẩm thức uống được pha chế thủ công theo tỷ lệ vàng độc quyền tại UTECoffe.'}
                            </p>

                            <!-- Price & Customization Action Button -->
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top border-gold mt-auto gap-2">
                                <div class="d-flex flex-column text-nowrap" style="min-width: 0;">
                                    <span class="small text-secondary" style="font-size: 0.75rem;" data-i18n="menu.original_price">Giá nguyên bản:</span>
                                    <span class="price-gold fw-bold fs-5 text-nowrap" data-raw-price="${prod.basePrice}" style="white-space: nowrap !important; letter-spacing: -0.02em;">
                                        <fmt:formatNumber value="${prod.basePrice}" pattern="#,##0"/> VNĐ
                                    </span>
                                </div>
                                <a href="${pageContext.request.contextPath}/menu/${prod.slug}" class="btn btn-gold btn-sm px-3 rounded-pill fw-semibold text-nowrap flex-shrink-0">
                                    <i class="fa-solid fa-sliders me-1"></i> <span data-i18n="menu.customize">Tùy Chỉnh</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Bottom Roastery Story Callout -->
        <div class="mt-5 pt-4">
            <div class="card-luxury p-4 p-md-5 text-center bg-espresso position-relative overflow-hidden">
                <div class="position-relative" style="z-index: 2;">
                    <i class="fa-solid fa-mortar-pestle text-gold display-4 mb-3"></i>
                    <h3 class="font-serif fw-bold text-gold-gradient mb-2">Bạn Muốn Tìm Hương Vị Riêng Cho Mình?</h3>
                    <p class="text-secondary mx-auto mb-4" style="max-width: 600px;">
                        Các Barista giàu kinh nghiệm của chúng tôi luôn sẵn sàng hỗ trợ điều chỉnh độ đậm hạt, hương hoa và tỷ lệ sữa để tạo nên ly cà phê chuẩn gu của bạn.
                    </p>
                    <div class="d-flex justify-content-center gap-3 flex-wrap">
                        <a href="${pageContext.request.contextPath}/story" class="btn btn-outline-gold px-4 py-2 rounded-pill font-accent">
                            <i class="fa-solid fa-book-open me-1"></i> Tìm Hiểu Nghệ Thuật Rang Mộc
                        </a>
                        <a href="${pageContext.request.contextPath}/reservation" class="btn btn-gold px-4 py-2 rounded-pill font-accent">
                            <i class="fa-solid fa-calendar-check me-1"></i> Đặt Bàn Thưởng Thức Tại Quán
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

            if (!searchInput || !productGrid) return;

            const cards = Array.from(productGrid.querySelectorAll('.product-card-col'));

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

            searchInput.addEventListener('input', filterAndSort);
            if (clearSearchBtn) {
                clearSearchBtn.addEventListener('click', function () {
                    searchInput.value = '';
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
                    filterAndSort();
                });
            }
        });
    </script>
</body>
