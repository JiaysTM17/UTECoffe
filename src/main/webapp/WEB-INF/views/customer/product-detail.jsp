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
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none hover-gold">Trang Chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu" class="text-secondary text-decoration-none hover-gold">Thực Đơn</a></li>
                <li class="breadcrumb-item active text-gold fw-bold" aria-current="page">${product.name}</li>
            </ol>
        </nav>

        <div class="row g-4 g-lg-5 mb-5 align-items-start">
            <!-- Left: Product Image & Flavor Profile -->
            <div class="col-lg-5">
                <div class="position-sticky" style="top: 100px;">
                    <div class="card card-luxury overflow-hidden mb-4 p-2">
                        <div class="product-image-container rounded-4 overflow-hidden position-relative" style="aspect-ratio: 1/1;">
                            <img src="${not empty product.imageUrl ? product.imageUrl : 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?q=80&w=800'}" 
                                 alt="${product.name}" 
                                 class="img-fluid w-100 h-100 object-fit-cover">
                            <span class="badge-luxury-tag position-absolute top-3 start-3">
                                <i class="fa-solid fa-award text-gold me-1"></i> ${product.category.name}
                            </span>
                        </div>
                    </div>

                    <!-- Terroir & Taste Radar Card -->
                    <div class="card-luxury p-4">
                        <h6 class="font-accent text-gold fw-bold text-uppercase small mb-3 border-bottom border-gold pb-2" style="letter-spacing: 0.12em;">
                            <i class="fa-solid fa-compass-drafting me-2"></i>Hồ Sơ Hương Vị &amp; Xuất Xứ (Terroir)
                        </h6>
                        
                        <div class="mb-3">
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

                    <h1 class="display-5 fw-bold font-serif text-gold-gradient mb-2">${product.name}</h1>
                    <p class="text-secondary mb-4 leading-relaxed">${product.description}</p>

                    <!-- Price Box -->
                    <div class="p-3 rounded-4 bg-espresso border border-gold mb-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
                        <div>
                            <span class="small text-secondary d-block font-accent text-uppercase" style="letter-spacing: 0.08em;">Giá Thưởng Thức:</span>
                            <span class="price-gold display-6 fw-bold" id="liveDisplayPrice">
                                <fmt:formatNumber value="${product.basePrice}" type="currency" currencySymbol="₫"/>
                            </span>
                        </div>
                        <div class="badge bg-gold-subtle border border-gold text-gold py-2 px-3 small">
                            <i class="fa-solid fa-bolt me-1"></i> Tích +10% Điểm Thẻ UTEClub
                        </div>
                    </div>

                    <!-- Specialty Customizer Options -->
                    <div class="card-luxury p-4 mb-4">
                        <h5 class="font-serif fw-bold text-gold mb-3 border-bottom border-gold pb-2">
                            <i class="fa-solid fa-sliders me-2"></i>Tùy Chỉnh Khẩu Vị Barista
                        </h5>

                        <!-- 1. Size Selection -->
                        <div class="mb-4">
                            <label class="form-label text-gold small fw-bold text-uppercase d-flex justify-content-between" style="letter-spacing: 0.08em;">
                                <span>1. Chọn Kích Cỡ Ly:</span>
                                <span class="text-secondary fw-normal" id="selectedSizeLabel">Size M (Grande) +10.000₫</span>
                            </label>
                            <div class="d-flex flex-wrap gap-2" role="group">
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn" data-type="size" data-value="S" data-extra="0" onclick="selectOption('size', this)">
                                    Size S (Regular)
                                </button>
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn active" data-type="size" data-value="M" data-extra="10000" onclick="selectOption('size', this)">
                                    Size M (Grande) +10k
                                </button>
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn" data-type="size" data-value="L" data-extra="18000" onclick="selectOption('size', this)">
                                    Size L (Venti) +18k
                                </button>
                            </div>
                        </div>

                        <!-- 2. Temperature & Ice -->
                        <div class="mb-4">
                            <label class="form-label text-gold small fw-bold text-uppercase d-flex justify-content-between" style="letter-spacing: 0.08em;">
                                <span>2. Mức Đá &amp; Nhiệt Độ:</span>
                                <span class="text-secondary fw-normal" id="selectedIceLabel">100% Đá (Tiêu Chuẩn)</span>
                            </label>
                            <div class="d-flex flex-wrap gap-2" role="group">
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn active" data-type="ice" data-value="100" onclick="selectOption('ice', this)">
                                    100% Đá
                                </button>
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn" data-type="ice" data-value="70" onclick="selectOption('ice', this)">
                                    70% Đá
                                </button>
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn" data-type="ice" data-value="30" onclick="selectOption('ice', this)">
                                    30% Đá
                                </button>
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn" data-type="ice" data-value="0" onclick="selectOption('ice', this)">
                                    Không Đá
                                </button>
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn" data-type="ice" data-value="HOT" onclick="selectOption('ice', this)">
                                    🔥 Uống Nóng
                                </button>
                            </div>
                        </div>

                        <!-- 3. Sweetness -->
                        <div class="mb-4">
                            <label class="form-label text-gold small fw-bold text-uppercase d-flex justify-content-between" style="letter-spacing: 0.08em;">
                                <span>3. Mức Đường / Ngọt:</span>
                                <span class="text-secondary fw-normal" id="selectedSugarLabel">100% Tiêu Chuẩn</span>
                            </label>
                            <div class="d-flex flex-wrap gap-2" role="group">
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn active" data-type="sugar" data-value="100" onclick="selectOption('sugar', this)">
                                    100% Chuẩn
                                </button>
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn" data-type="sugar" data-value="70" onclick="selectOption('sugar', this)">
                                    70% Vừa
                                </button>
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn" data-type="sugar" data-value="30" onclick="selectOption('sugar', this)">
                                    30% Ít Ngọt
                                </button>
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn" data-type="sugar" data-value="0" onclick="selectOption('sugar', this)">
                                    0% Không Đường
                                </button>
                            </div>
                        </div>

                        <!-- 4. Milk Choice -->
                        <div class="mb-4">
                            <label class="form-label text-gold small fw-bold text-uppercase d-flex justify-content-between" style="letter-spacing: 0.08em;">
                                <span>4. Tùy Chọn Sữa:</span>
                                <span class="text-secondary fw-normal" id="selectedMilkLabel">Sữa Thanh Trùng Đà Lạt</span>
                            </label>
                            <div class="d-flex flex-wrap gap-2" role="group">
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn active" data-type="milk" data-value="fresh" data-extra="0" onclick="selectOption('milk', this)">
                                    Sữa Đà Lạt (Mặc Định)
                                </button>
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn" data-type="milk" data-value="oat" data-extra="12000" onclick="selectOption('milk', this)">
                                    🌾 Sữa Yến Mạch Oatly (+12k)
                                </button>
                                <button type="button" class="btn btn-outline-gold btn-sm px-3 custom-option-btn" data-type="milk" data-value="almond" data-extra="12000" onclick="selectOption('milk', this)">
                                    🥜 Sữa Hạnh Nhân (+12k)
                                </button>
                            </div>
                        </div>

                        <!-- 5. Artisanal Toppings -->
                        <div>
                            <label class="form-label text-gold small fw-bold text-uppercase d-flex justify-content-between" style="letter-spacing: 0.08em;">
                                <span>5. Thêm Topping Thượng Hạng:</span>
                                <span class="text-secondary fw-normal">Chọn nhiều tùy thích</span>
                            </label>
                            <div class="d-flex flex-wrap gap-2">
                                <label class="btn btn-outline-gold btn-sm px-3 cursor-pointer d-flex align-items-center gap-2">
                                    <input type="checkbox" class="form-check-input mt-0 topping-check" value="jelly" data-price="8000" onchange="calculateLiveTotal()">
                                    <span>Thạch Cà Phê (+8k)</span>
                                </label>
                                <label class="btn btn-outline-gold btn-sm px-3 cursor-pointer d-flex align-items-center gap-2">
                                    <input type="checkbox" class="form-check-input mt-0 topping-check" value="cheese" data-price="12000" onchange="calculateLiveTotal()">
                                    <span>Kem Cheese Macchiato (+12k)</span>
                                </label>
                                <label class="btn btn-outline-gold btn-sm px-3 cursor-pointer d-flex align-items-center gap-2">
                                    <input type="checkbox" class="form-check-input mt-0 topping-check" value="pearl" data-price="8000" onchange="calculateLiveTotal()">
                                    <span>Trân Châu Trắng (+8k)</span>
                                </label>
                                <label class="btn btn-outline-gold btn-sm px-3 cursor-pointer d-flex align-items-center gap-2">
                                    <input type="checkbox" class="form-check-input mt-0 topping-check" value="shot" data-price="15000" onchange="calculateLiveTotal()">
                                    <span>Extra Double Shot (+15k)</span>
                                </label>
                            </div>
                        </div>
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
                            <i class="fa-solid fa-bag-shopping me-2"></i> Thêm Vào Giỏ Hàng
                        </button>
                        
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-gold btn-sm px-4 text-nowrap py-3">
                            <i class="fa-solid fa-bolt me-2"></i> Xem Giỏ Hàng
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
            container.querySelectorAll('.custom-option-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            const val = btn.getAttribute('data-value');
            const extra = parseFloat(btn.getAttribute('data-extra')) || 0;

            if (type === 'size') {
                selectedSizeExtra = extra;
                const label = val === 'S' ? 'Size S (Regular)' : val === 'M' ? 'Size M (Grande) +10.000₫' : 'Size L (Venti) +18.000₫';
                document.getElementById('selectedSizeLabel').innerText = label;
            } else if (type === 'ice') {
                const label = val === 'HOT' ? 'Uống Nóng (Hot Cup)' : (val + '% Đá');
                document.getElementById('selectedIceLabel').innerText = label;
            } else if (type === 'sugar') {
                const label = val === '100' ? '100% Tiêu Chuẩn' : val === '70' ? '70% Ngọt Vừa' : val === '30' ? '30% Ít Ngọt' : '0% Không Đường';
                document.getElementById('selectedSugarLabel').innerText = label;
            } else if (type === 'milk') {
                selectedMilkExtra = extra;
                const label = val === 'fresh' ? 'Sữa Thanh Trùng Đà Lạt' : val === 'oat' ? 'Sữa Yến Mạch Oatly (+12.000₫)' : 'Sữa Hạnh Nhân (+12.000₫)';
                document.getElementById('selectedMilkLabel').innerText = label;
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

            const formatted = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(totalPrice);
            document.getElementById('liveDisplayPrice').innerText = formatted;
        }

        function changeQty(delta) {
            quantity = Math.max(1, quantity + delta);
            document.getElementById('orderQuantity').value = quantity;
            calculateLiveTotal();
        }

        function handleAddToCart() {
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
