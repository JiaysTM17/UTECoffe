<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Đặt Bàn Thưởng Thức - UTECoffe Specialty Roastery</title>
</head>
<body class="bg-obsidian">

    <!-- Header Banner -->
    <div class="py-5 bg-espresso border-bottom border-gold text-center position-relative overflow-hidden">
        <div class="container py-3 position-relative" style="z-index: 2;">
            <span class="badge bg-gold-subtle text-gold px-3 py-1 rounded-2 small mb-3 fw-medium" data-i18n="res.badge">
                <i class="fa-solid fa-bell-concierge me-1"></i> Dịch Vụ Tiếp Đón Chu Đáo
            </span>
            <h1 class="font-serif display-4 fw-bold text-primary mb-3" data-i18n="nav.reservation">
                Đặt Bàn Thưởng Thức
            </h1>
            <p class="text-secondary mx-auto fs-6 mb-0" style="max-width: 680px; line-height: 1.7;" data-i18n="res.desc">
                Giữ trước vị trí thưởng thức lý tưởng tại UTECoffe để những buổi gặp gỡ, trò chuyện hay làm việc của bạn trở nên trọn vẹn và thư thái nhất.
            </p>
        </div>
    </div>

    <div class="container py-4" style="max-width: 960px; margin: 0 auto;">
        <c:choose>
            <c:when test="${param.success == 'true' or not empty confirmedReservation}">
                <!-- VIP Digital Reservation Boarding Pass -->
                <div class="card-luxury p-4 p-md-5 shadow-lg border-gold text-center animate-fade-in mb-4" style="background: radial-gradient(circle at 50% 20%, rgba(212, 175, 55, 0.12), rgba(11, 9, 8, 0.98));">
                    <div class="d-inline-flex p-3 rounded-circle bg-gold bg-opacity-20 border border-gold mb-3 shadow-gold-sm">
                        <i class="fa-solid fa-champagne-glasses text-gold fs-2"></i>
                    </div>

                    <span class="badge bg-gold text-dark px-3 py-1 rounded-2 small mb-2 fw-semibold" style="font-size: 0.76rem;">
                        <i class="fa-solid fa-circle-check me-1"></i> Xác Nhận Giữ Chỗ Thành Công
                    </span>
                    <h2 class="font-serif fs-3 fw-bold text-primary mb-2">
                        Chào Mừng ${not empty customerName ? customerName : 'Quý Khách'} Đến Với UTECoffe
                    </h2>
                    <p class="text-secondary small mx-auto mb-4" style="max-width: 580px; font-size: 0.85rem;">
                        Vị trí của bạn đã được hệ thống phân bổ tối ưu theo thời gian thực. Barista UTECoffe hân hạnh được đón tiếp bạn.
                    </p>

                    <!-- Pass Metadata Slate -->
                    <div class="transfer-slate p-3.5 mx-auto mb-4 text-start" style="max-width: 580px;">
                        <div class="d-flex justify-content-between align-items-center py-2 transfer-line">
                            <span class="text-secondary small">Mã Giữ Chỗ (Booking Pass):</span>
                            <span class="badge bg-espresso border border-gold text-gold font-monospace px-2.5 py-1" style="font-size: 0.88rem;">
                                #${not empty reservationCode ? reservationCode : (not empty confirmedReservation.reservationCode ? confirmedReservation.reservationCode : 'UTE-RES-2026')}
                            </span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2 transfer-line">
                            <span class="text-secondary small">Vị Trí Phân Bổ:</span>
                            <strong class="text-primary" style="font-size: 0.92rem;">
                                <c:choose>
                                    <c:when test="${not empty tableNumber}">
                                        Bàn ${tableNumber} • ${not empty assignedZoneName ? assignedZoneName : 'Khu Vực Quán'}
                                    </c:when>
                                    <c:when test="${not empty confirmedReservation.storeTable}">
                                        Bàn ${confirmedReservation.storeTable.tableNumber} • ${confirmedReservation.assignedZoneName}
                                    </c:when>
                                    <c:otherwise>
                                        Bàn VIP Ưu Tiên • Khu Vực Tiếp Đón
                                    </c:otherwise>
                                </c:choose>
                            </strong>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2 transfer-line">
                            <span class="text-secondary small">Thời Gian Hẹn:</span>
                            <strong class="text-gold font-monospace" style="font-size: 0.95rem;">
                                ${not empty formattedTime ? formattedTime : (not empty confirmedReservation.formattedReservationTime ? confirmedReservation.formattedReservationTime : '14:30')}
                            </strong>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2 transfer-line">
                            <span class="text-secondary small">Chi Nhánh:</span>
                            <strong class="text-primary text-end" style="font-size: 0.86rem;">
                                ${not empty storeName ? storeName : (not empty confirmedReservation.store ? confirmedReservation.store.name : 'UTECoffe Flagship Thủ Đức')}
                            </strong>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2">
                            <span class="text-secondary small">Đặc Quyền Tặng Kèm:</span>
                            <span class="badge bg-gold-subtle text-gold small px-2 py-0.5 rounded-pill font-accent">
                                <i class="fa-solid fa-gift me-1"></i> 01 Shot Cold Brew Cam Vàng Signature
                            </span>
                        </div>
                    </div>

                    <!-- Digital Check-In QR -->
                    <div class="qr-token-card mx-auto mb-4 p-3 d-inline-block position-relative">
                        <img src="https://api.qrserver.com/v1/create-qr-code/?size=160x160&data=UTECOFFE-RESERVATION-${not empty reservationCode ? reservationCode : (not empty confirmedReservation.reservationCode ? confirmedReservation.reservationCode : '2026')}" 
                             class="img-fluid rounded-2 d-block mx-auto" 
                             style="width: 140px; height: 140px;" 
                             alt="Check-in QR Code">
                        <small class="text-dark d-block mt-1 font-monospace fw-bold" style="font-size: 0.72rem;">ĐƯA CHO BARISTA KHI ĐẾN QUÁN</small>
                    </div>

                    <!-- Actions -->
                    <div class="d-flex justify-content-center gap-3 flex-wrap">
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold px-4 py-2 fw-semibold">
                            <i class="fa-solid fa-mug-saucer me-1.5"></i> Khám Phá Menu &amp; Đặt Món Trước
                        </a>
                        <a href="${pageContext.request.contextPath}/reservation" class="btn btn-outline-gold px-4 py-2">
                            <i class="fa-solid fa-plus me-1.5"></i> Đặt Thêm Lượt Khác
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row justify-content-center">
                    <div class="col-12">
                        <!-- Special Perk Alert -->
                        <div class="card-luxury p-3 mb-4 bg-espresso border-gold-subtle d-flex flex-row align-items-center gap-3">
                            <div class="text-gold fs-3 ps-2">
                                <i class="fa-solid fa-gift"></i>
                            </div>
                            <div>
                                <div class="fw-bold text-gold small" data-i18n="res.perk_title">ĐẶC QUYỀN ĐẶT BÀN TRỰC TUYẾN:</div>
                                <div class="small text-secondary" data-i18n="res.perk_desc">
                                    Mỗi lượt đặt chỗ trực tuyến qua website được tặng kèm <strong>01 shot Cold Brew Cam Vàng Signature</strong> dùng thử trước khi bắt đầu thưởng thức.
                                </div>
                            </div>
                        </div>

                        <div class="card-luxury p-4 p-md-5 shadow-lg">
                            <form action="${pageContext.request.contextPath}/reservation/book" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                
                                <!-- 1. Store Selection -->
                                <div class="mb-4">
                                    <label class="form-label text-gold small fw-bold" data-i18n="res.store_label">1. Chọn Chi Nhánh Thưởng Thức:</label>
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
                                    <label class="form-label text-gold small fw-bold" data-i18n="res.zone_label">2. Khu Vực Không Gian Ưa Thích:</label>
                                    <div class="row g-3">
                                        <div class="col-md-3 col-6">
                                            <input type="radio" class="btn-check" name="zonePreference" id="zoneBar" value="BAR" checked>
                                            <label class="zone-option-card d-flex flex-column align-items-center justify-content-center p-3 text-center rounded-3 h-100" for="zoneBar">
                                                <i class="fa-solid fa-mug-saucer fs-3 mb-2 text-gold"></i>
                                                <span class="zone-name fw-bold text-primary mb-1" data-i18n="res.zone_bar_title">Quầy Barista</span>
                                                <span class="zone-desc text-secondary" data-i18n="res.zone_bar_desc">Trải nghiệm pha chế</span>
                                            </label>
                                        </div>
                                        <div class="col-md-3 col-6">
                                            <input type="radio" class="btn-check" name="zonePreference" id="zoneLounge" value="LOUNGE">
                                            <label class="zone-option-card d-flex flex-column align-items-center justify-content-center p-3 text-center rounded-3 h-100" for="zoneLounge">
                                                <i class="fa-solid fa-couch fs-3 mb-2 text-gold"></i>
                                                <span class="zone-name fw-bold text-primary mb-1" data-i18n="res.zone_lounge_title">Sofa VIP Lounge</span>
                                                <span class="zone-desc text-secondary" data-i18n="res.zone_lounge_desc">Yên tĩnh, sang trọng</span>
                                            </label>
                                        </div>
                                        <div class="col-md-3 col-6">
                                            <input type="radio" class="btn-check" name="zonePreference" id="zoneGarden" value="GARDEN">
                                            <label class="zone-option-card d-flex flex-column align-items-center justify-content-center p-3 text-center rounded-3 h-100" for="zoneGarden">
                                                <i class="fa-solid fa-tree fs-3 mb-2 text-gold"></i>
                                                <span class="zone-name fw-bold text-primary mb-1" data-i18n="res.zone_garden_title">Sân Vườn Xanh</span>
                                                <span class="zone-desc text-secondary" data-i18n="res.zone_garden_desc">Thoáng đãng tự nhiên</span>
                                            </label>
                                        </div>
                                        <div class="col-md-3 col-6">
                                            <input type="radio" class="btn-check" name="zonePreference" id="zoneWork" value="WORK">
                                            <label class="zone-option-card d-flex flex-column align-items-center justify-content-center p-3 text-center rounded-3 h-100" for="zoneWork">
                                                <i class="fa-solid fa-laptop fs-3 mb-2 text-gold"></i>
                                                <span class="zone-name fw-bold text-primary mb-1" data-i18n="res.zone_work_title">Bàn Co-Working</span>
                                                <span class="zone-desc text-secondary" data-i18n="res.zone_work_desc">Ổ điện &amp; WiFi mạnh</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <!-- 3. Customer Info -->
                                <div class="row g-3 mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label text-gold small fw-bold" data-i18n="res.guests_label">3. Số Lượng Khách:</label>
                                        <select class="form-select form-control-luxury" name="numberOfGuests" required>
                                            <option value="1" data-i18n="res.opt_guest1">1 Người (Bàn Độc Thoại / Bar Slow Bar)</option>
                                            <option value="2" selected data-i18n="res.opt_guest2">2 Người (Bàn Đôi Lãng Mạn)</option>
                                            <option value="4" data-i18n="res.opt_guest4">3 - 4 Người (Bàn Tiêu Chuẩn)</option>
                                            <option value="6" data-i18n="res.opt_guest6">5 - 6 Người (Bàn Họp / Nhóm Bạn)</option>
                                            <option value="10" data-i18n="res.opt_guest10">Phòng Riêng Private (8 - 12 Người)</option>
                                        </select>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label text-gold small fw-bold" data-i18n="res.name_label">Họ và Tên Quý Khách:</label>
                                        <input type="text" class="form-control form-control-luxury" name="customerName" placeholder="Nguyễn Văn A" data-i18n-placeholder="res.placeholder_name" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label text-gold small fw-bold" data-i18n="res.phone_label">Số Điện Thoại Xác Nhận:</label>
                                        <input type="tel" class="form-control form-control-luxury" name="phoneNumber" placeholder="0901234567" data-i18n-placeholder="res.placeholder_phone" required>
                                    </div>

                                    <div class="col-md-3 col-6">
                                        <label class="form-label text-gold small fw-bold" data-i18n="res.date_label">Ngày Thưởng Thức:</label>
                                        <input type="date" class="form-control form-control-luxury font-monospace" name="reservationDate" required id="reservationDateInput">
                                    </div>
                                    <div class="col-md-3 col-6">
                                        <label class="form-label text-gold small fw-bold" data-i18n="res.time_label">Khung Giờ Hẹn:</label>
                                        <input type="time" class="form-control form-control-luxury font-monospace" name="reservationTime" required value="14:30">
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label text-gold small fw-bold" data-i18n="res.special_label">Yêu Cầu Đặc Biệt (Trang trí hoa tươi, chuẩn bị cà phê Geisha, bánh kỷ niệm...):</label>
                                        <textarea class="form-control form-control-luxury" name="specialRequest" rows="2" placeholder="Nhập yêu cầu để chúng tôi chuẩn bị tiếp đón chu đáo nhất..." data-i18n-placeholder="res.placeholder_special"></textarea>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-gold w-100 py-2.5 fw-semibold fs-6">
                                    <i class="fa-solid fa-calendar-check me-2"></i> <span data-i18n="res.submit_btn">Xác Nhận Giữ Chỗ Trực Tuyến</span>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
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
