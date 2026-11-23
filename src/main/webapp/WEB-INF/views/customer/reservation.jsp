<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Đặt Bàn Thưởng Thức - UTECoffe Specialty Roastery</title>
</head>
<body class="bg-obsidian">

    <!-- Header Banner -->
    <div class="py-5 bg-espresso border-bottom border-gold text-center position-relative overflow-hidden">
        <div class="container py-3 position-relative" style="z-index: 2;">
            <span class="badge bg-gold-subtle text-gold px-3 py-1 rounded-pill small font-accent mb-3 text-uppercase" style="letter-spacing: 0.15em;">
                <i class="fa-solid fa-bell-concierge me-1"></i> DỊCH VỤ TIẾP ĐÓN CHU ĐÁO
            </span>
            <h1 class="font-serif display-4 fw-bold text-gold-gradient mb-3" data-i18n="nav.reservation">
                Đặt Bàn Thưởng Thức
            </h1>
            <p class="text-secondary mx-auto fs-6 mb-0" style="max-width: 680px; line-height: 1.7;">
                Giữ trước vị trí thưởng thức lý tưởng tại UTECoffe để những buổi gặp gỡ, trò chuyện hay làm việc của bạn trở nên trọn vẹn và thư thái nhất.
            </p>
        </div>
    </div>

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-9">
                <!-- Special Perk Alert -->
                <div class="card-luxury p-3 mb-4 bg-espresso border-gold-subtle d-flex flex-row align-items-center gap-3">
                    <div class="text-gold fs-3 ps-2">
                        <i class="fa-solid fa-gift"></i>
                    </div>
                    <div>
                        <div class="fw-bold text-gold small">ĐẶC QUYỀN ĐẶT BÀN TRỰC TUYẾN:</div>
                        <div class="small text-secondary">
                            Mỗi lượt đặt chỗ trực tuyến qua website được tặng kèm <strong>01 shot Cold Brew Cam Vàng Signature</strong> dùng thử trước khi bắt đầu thưởng thức.
                        </div>
                    </div>
                </div>

                <div class="card-luxury p-4 p-md-5 shadow-lg">
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success border-0 bg-success-subtle text-success py-3 px-4 rounded-3 mb-4 d-flex align-items-center gap-2">
                            <i class="fa-solid fa-circle-check fs-5"></i>
                            <div>${successMessage}</div>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/reservation/book" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        
                        <!-- 1. Store Selection -->
                        <div class="mb-4">
                            <label class="form-label text-gold small fw-bold">1. Chọn Chi Nhánh Thưởng Thức:</label>
                            <select class="form-select form-control-luxury" name="storeId" required>
                                <c:forEach var="store" items="${stores}">
                                    <option value="${store.id}" ${param.storeId == store.id ? 'selected' : ''}>
                                        ${store.name} - ${store.address}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- 2. Zone Atmosphere Selector -->
                        <div class="mb-4">
                            <label class="form-label text-gold small fw-bold">2. Khu Vực Không Gian Ưa Thích:</label>
                            <div class="row g-3">
                                <div class="col-md-3 col-6">
                                    <input type="radio" class="btn-check" name="zonePreference" id="zoneBar" value="BAR" checked>
                                    <label class="zone-option-card d-flex flex-column align-items-center justify-content-center p-3 text-center rounded-3 h-100" for="zoneBar">
                                        <i class="fa-solid fa-mug-saucer fs-3 mb-2 text-gold"></i>
                                        <span class="zone-name fw-bold text-light mb-1">Quầy Barista</span>
                                        <span class="zone-desc text-secondary">Trải nghiệm pha chế</span>
                                    </label>
                                </div>
                                <div class="col-md-3 col-6">
                                    <input type="radio" class="btn-check" name="zonePreference" id="zoneLounge" value="LOUNGE">
                                    <label class="zone-option-card d-flex flex-column align-items-center justify-content-center p-3 text-center rounded-3 h-100" for="zoneLounge">
                                        <i class="fa-solid fa-couch fs-3 mb-2 text-gold"></i>
                                        <span class="zone-name fw-bold text-light mb-1">Sofa VIP Lounge</span>
                                        <span class="zone-desc text-secondary">Yên tĩnh, sang trọng</span>
                                    </label>
                                </div>
                                <div class="col-md-3 col-6">
                                    <input type="radio" class="btn-check" name="zonePreference" id="zoneGarden" value="GARDEN">
                                    <label class="zone-option-card d-flex flex-column align-items-center justify-content-center p-3 text-center rounded-3 h-100" for="zoneGarden">
                                        <i class="fa-solid fa-tree fs-3 mb-2 text-gold"></i>
                                        <span class="zone-name fw-bold text-light mb-1">Sân Vườn Xanh</span>
                                        <span class="zone-desc text-secondary">Thoáng đãng tự nhiên</span>
                                    </label>
                                </div>
                                <div class="col-md-3 col-6">
                                    <input type="radio" class="btn-check" name="zonePreference" id="zoneWork" value="WORK">
                                    <label class="zone-option-card d-flex flex-column align-items-center justify-content-center p-3 text-center rounded-3 h-100" for="zoneWork">
                                        <i class="fa-solid fa-laptop fs-3 mb-2 text-gold"></i>
                                        <span class="zone-name fw-bold text-light mb-1">Bàn Co-Working</span>
                                        <span class="zone-desc text-secondary">Ổ điện &amp; WiFi mạnh</span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- 3. Customer Info -->
                        <div class="row g-4 mb-4">
                            <div class="col-md-6">
                                <label class="form-label text-gold small fw-bold">3. Số Lượng Khách:</label>
                                <select class="form-select form-control-luxury" name="numberOfGuests" required>
                                    <option value="1">1 Người (Bàn Độc Thoại / Bar Slow Bar)</option>
                                    <option value="2" selected>2 Người (Bàn Đôi Lãng Mạn)</option>
                                    <option value="4">3 - 4 Người (Bàn Tiêu Chuẩn)</option>
                                    <option value="6">5 - 6 Người (Bàn Họp / Nhóm Bạn)</option>
                                    <option value="10">Phòng Riêng Private (8 - 12 Người)</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-gold small fw-bold">Họ và Tên Quý Khách:</label>
                                <input type="text" class="form-control form-control-luxury" name="customerName" placeholder="Nguyễn Văn A" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-gold small fw-bold">Số Điện Thoại Xác Nhận:</label>
                                <input type="tel" class="form-control form-control-luxury" name="phoneNumber" placeholder="0901234567" required>
                            </div>

                            <div class="col-md-3 col-6">
                                <label class="form-label text-gold small fw-bold">Ngày Thưởng Thức:</label>
                                <input type="date" class="form-control form-control-luxury font-monospace" name="reservationDate" required id="reservationDateInput">
                            </div>
                            <div class="col-md-3 col-6">
                                <label class="form-label text-gold small fw-bold">Khung Giờ Hẹn:</label>
                                <input type="time" class="form-control form-control-luxury font-monospace" name="reservationTime" required value="14:30">
                            </div>

                            <div class="col-12">
                                <label class="form-label text-gold small fw-bold">Yêu Cầu Đặc Biệt (Trang trí hoa tươi, chuẩn bị cà phê Geisha, bánh kỷ niệm...):</label>
                                <textarea class="form-control form-control-luxury" name="specialRequest" rows="3" placeholder="Nhập yêu cầu để chúng tôi chuẩn bị tiếp đón chu đáo nhất..."></textarea>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-gold w-100 py-3 fw-bold fs-6 rounded-pill shadow-gold">
                            <i class="fa-solid fa-calendar-check me-2"></i> Xác Nhận Giữ Chỗ Trực Tuyến
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Default Date Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const dateInput = document.getElementById('reservationDateInput');
            if (dateInput && !dateInput.value) {
                const today = new Date().toISOString().split('T')[0];
                dateInput.value = today;
                dateInput.min = today;
            }
        });
    </script>
</body>
