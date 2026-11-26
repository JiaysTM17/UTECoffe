<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Hệ Thống Cửa Hàng - UTECoffe Flagship Roasteries</title>
</head>
<body class="bg-obsidian">

    <!-- Header Section -->
    <div class="py-5 bg-espresso border-bottom border-gold text-center position-relative overflow-hidden">
        <div class="container py-3 position-relative" style="z-index: 2;">
            <span class="badge bg-gold-subtle text-gold px-3 py-1 rounded-2 small font-accent mb-3 text-uppercase" style="letter-spacing: 0.15em;" data-i18n="stores.subtitle">
                <i class="fa-solid fa-store me-1"></i> KHÔNG GIAN THƯỞNG THỨC NGHỆ THUẬT
            </span>
            <h1 class="font-serif display-4 fw-bold text-primary mb-3" data-i18n="nav.stores">
                Hệ Thống Flagship Roasteries
            </h1>
            <p class="text-secondary mx-auto fs-6 mb-4" style="max-width: 680px; line-height: 1.7;" data-i18n="stores.desc">
                Mỗi không gian UTECoffe là sự giao thoa hài hòa giữa kiến trúc tối giản hiện đại và hơi thở mộc mạc của xưởng rang cà phê, mang đến trải nghiệm thưởng thức trọn vẹn mọi giác quan.
            </p>

            <!-- Quick District Filter Pills & Haversine Distance Calculator -->
            <div class="d-flex justify-content-center flex-wrap gap-2 mb-2">
                <button type="button" class="btn btn-gold btn-sm px-4 py-2 rounded-2 font-accent store-filter-btn active" data-filter="all" data-i18n="stores.filter_all">
                    Tất Cả Chi Nhánh
                </button>
                <button type="button" class="btn btn-outline-gold btn-sm px-4 py-2 rounded-2 font-accent store-filter-btn" data-filter="thuduc" data-i18n="stores.filter_thuduc">
                    TP. Thủ Đức (Flagship)
                </button>
                <button type="button" class="btn btn-outline-gold btn-sm px-4 py-2 rounded-2 font-accent store-filter-btn" data-filter="quan1" data-i18n="stores.filter_quan1">
                    Quận 1 (Trung Tâm)
                </button>
                <button type="button" class="btn btn-outline-gold btn-sm px-4 py-2 rounded-2 font-accent store-filter-btn" data-filter="binhthanh" data-i18n="stores.filter_binhthanh">
                    Bình Thạnh (Garden)
                </button>
                <button type="button" class="btn btn-outline-warning btn-sm px-4 py-2 rounded-2 font-accent" id="btnGpsNearest" onclick="calculateGpsNearest()">
                    <i class="fa-solid fa-location-crosshairs me-1"></i> <span data-i18n="stores.btn_gps">Tìm Chi Nhánh Gần Nhất</span>
                </button>
            </div>
            <div id="gpsStatusNotice" class="text-center small text-gold mt-2 d-none"></div>
        </div>
    </div>

    <!-- Stores Grid -->
    <div class="container py-5">
        <div class="row g-4" id="storesGrid">
            <c:forEach var="st" items="${stores}">
                <c:set var="districtKey" value="thuduc"/>
                <c:set var="storeImg" value="https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&w=700&q=80"/>
                <c:if test="${st.name.toLowerCase().contains('quận 1') || st.address.toLowerCase().contains('quận 1')}">
                    <c:set var="districtKey" value="quan1"/>
                    <c:set var="storeImg" value="https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=700&q=80"/>
                </c:if>
                <c:if test="${st.name.toLowerCase().contains('bình thạnh') || st.address.toLowerCase().contains('bình thạnh')}">
                    <c:set var="districtKey" value="binhthanh"/>
                    <c:set var="storeImg" value="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=700&q=80"/>
                </c:if>

                <div class="col-lg-4 col-md-6 store-card-col" data-district="${districtKey}">
                    <div class="card card-luxury h-100 product-hover-lift d-flex flex-column">
                        <div class="product-image-container position-relative overflow-hidden" style="aspect-ratio: 16/10;">
                            <img src="${storeImg}" 
                                 alt="${st.name}" 
                                 class="w-100 h-100 object-fit-cover"
                                 loading="lazy">
                            <span class="badge-luxury-tag position-absolute top-0 start-0 m-3">
                                <i class="fa-solid fa-circle text-success me-1"></i> <span data-i18n="stores.open_now">Đang Mở Cửa</span>
                            </span>
                            <span class="badge bg-espresso border border-gold text-gold position-absolute top-0 end-0 m-3 px-2 py-1 rounded-2 small">
                                <i class="fa-solid fa-star text-gold me-1"></i> <span data-i18n="stores.rating">4.9 (420+ Đánh giá)</span>
                            </span>
                        </div>

                        <div class="card-body p-4 d-flex flex-column flex-grow-1">
                            <h5 class="font-serif fw-bold mb-2 text-primary">${st.name}</h5>
                            <p class="text-secondary small mb-2"><i class="fa-solid fa-location-dot text-gold me-2"></i> ${st.address}</p>
                            <p class="text-secondary small mb-2"><i class="fa-regular fa-clock text-gold me-2"></i> ${st.openingTime} - ${st.closingTime} <span data-i18n="stores.everyday">(Mở cửa hàng ngày)</span></p>
                            <p class="text-secondary small mb-3"><i class="fa-solid fa-phone text-gold me-2"></i> ${st.phoneNumber}</p>
                            
                            <!-- Amenities -->
                            <div class="d-flex flex-wrap gap-1 mb-4">
                                <span class="badge bg-espresso text-secondary border border-gold-subtle small px-2 py-1"><i class="fa-solid fa-wifi text-gold me-1"></i> <span data-i18n="stores.wifi">WiFi Tốc Độ Cao</span></span>
                                <span class="badge bg-espresso text-secondary border border-gold-subtle small px-2 py-1"><i class="fa-solid fa-square-parking text-gold me-1"></i> <span data-i18n="stores.parking">Giữ Xe Miễn Phí</span></span>
                                <span class="badge bg-espresso text-secondary border border-gold-subtle small px-2 py-1"><i class="fa-solid fa-mug-hot text-gold me-1"></i> <span data-i18n="stores.slowbar">Slow Bar Pour-Over</span></span>
                            </div>

                            <div class="mt-auto d-flex gap-2">
                                <a href="https://maps.google.com/?q=${st.latitude},${st.longitude}" target="_blank" class="btn btn-outline-gold btn-sm flex-grow-1 rounded-2">
                                    <i class="fa-solid fa-diamond-turn-right me-1"></i> <span data-i18n="stores.directions">Chỉ Đường</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/reservation?storeId=${st.id}" class="btn btn-gold btn-sm flex-grow-1 rounded-2">
                                    <i class="fa-solid fa-calendar-check me-1"></i> <span data-i18n="stores.reserve">Đặt Bàn Trước</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Roastery Commitment Banner -->
        <div class="mt-5 pt-3">
            <div class="card-luxury p-4 p-md-5 text-center bg-espresso">
                <i class="fa-solid fa-mug-hot text-gold display-4 mb-3"></i>
                <h3 class="font-serif fw-bold text-primary mb-2" data-i18n="stores.cupping_title">Đặc Quyền Thử Cà Phê Miễn Phí (Cupping Session)</h3>
                <p class="text-secondary mx-auto mb-4" style="max-width: 650px;" data-i18n="stores.cupping_desc">
                    Mỗi sáng thứ Bảy từ 09:00 - 10:30, các Master Roaster của UTECoffe tổ chức buổi chia sẻ và thử nếm các mẻ hạt đặc sản mới hoàn toàn miễn phí cho thành viên UTEClub.
                </p>
                <a href="${pageContext.request.contextPath}/reservation" class="btn btn-gold px-4 py-2 rounded-2 font-accent fw-bold">
                    <i class="fa-solid fa-ticket me-1"></i> <span data-i18n="stores.cupping_btn">Đăng Ký Tham Gia Cupping Session</span>
                </a>
            </div>
        </div>
    </div>

    <!-- Store District Filter & Haversine Distance Client Script -->
    <script>
        function calculateGpsNearest() {
            const noticeEl = document.getElementById('gpsStatusNotice');
            const btn = document.getElementById('btnGpsNearest');

            if (!navigator.geolocation) {
                alert('Trình duyệt không hỗ trợ định vị GPS.');
                return;
            }

            if (noticeEl) {
                noticeEl.classList.remove('d-none');
                noticeEl.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-1"></i> Đang tìm cửa hàng UTECoffe gần vị trí của bạn nhất...';
            }

            navigator.geolocation.getCurrentPosition(function (position) {
                const lat = position.coords.latitude;
                const lng = position.coords.longitude;

                fetch('${pageContext.request.contextPath}/api/stores/nearest?lat=' + lat + '&lng=' + lng)
                    .then(res => res.json())
                    .then(data => {
                        if (data.success && data.data && data.data.length > 0) {
                            const nearest = data.data[0];
                            if (noticeEl) {
                                noticeEl.innerHTML = '<span class="badge bg-gold-gradient text-obsidian px-3 py-2 rounded-2 fw-bold"><i class="fa-solid fa-check me-1"></i> Chi nhánh gần nhất: ' + nearest.store.name + ' • Khoảng cách: ' + nearest.formattedDistance + ' • Thời gian giao: ~' + nearest.estimatedDeliveryMinutes + ' phút</span>';
                            }
                        }
                    })
                    .catch(() => {
                        if (noticeEl) noticeEl.textContent = 'Đã kết nối dữ liệu 3 chi nhánh thành công.';
                    });
            }, function (error) {
                if (noticeEl) {
                    noticeEl.textContent = 'Chưa thể truy cập GPS định vị. Quý khách có thể xem 3 chi nhánh theo danh sách bên dưới.';
                }
            }, { timeout: 10000 });
        }

        document.addEventListener('DOMContentLoaded', function () {
            const filterBtns = document.querySelectorAll('.store-filter-btn');
            const storeCols = document.querySelectorAll('.store-card-col');

            filterBtns.forEach(btn => {
                btn.addEventListener('click', function () {
                    filterBtns.forEach(b => {
                        b.classList.remove('btn-gold', 'active');
                        b.classList.add('btn-outline-gold');
                    });
                    this.classList.remove('btn-outline-gold');
                    this.classList.add('btn-gold', 'active');

                    const filter = this.getAttribute('data-filter');
                    storeCols.forEach(col => {
                        const district = col.getAttribute('data-district');
                        if (filter === 'all' || district === filter) {
                            col.style.display = '';
                        } else {
                            col.style.display = 'none';
                        }
                    });
                });
            });
        });
    </script>
</body>
