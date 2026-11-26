<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Quản Lý Chi Nhánh & Đặt Bàn - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="font-serif fw-bold text-primary mb-0">Hệ Thống 3 Chi Nhánh &amp; Sơ Đồ Bàn</h4>
            <small class="text-secondary">Quản trị vận hành thực tế cơ sở, quản lý bàn phục vụ và tiếp nhận đặt chỗ trực tuyến</small>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-dark-roast border border-gold text-gold px-3 py-2 font-accent">
                <i class="fa-solid fa-store me-1"></i> 3 Cơ Sở Đang Hoạt Động
            </span>
        </div>
    </div>

    <!-- 3 Store Cards -->
    <div class="row g-4 mb-5">
        <c:forEach var="store" items="${stores}">
            <div class="col-lg-4 col-md-6">
                <div class="card-luxury p-4 h-100 border-gold shadow-lg d-flex flex-column justify-content-between" style="min-height: 290px;">
                    <div>
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <h5 class="font-serif fw-bold text-primary mb-0 text-truncate" title="${store.name}">
                                ${store.name}
                            </h5>
                            <span class="badge ${store.isActive ? 'bg-success-subtle text-success border border-success' : 'bg-secondary text-light'} small font-accent flex-shrink-0 ms-2">
                                ${store.isActive ? 'Hoạt Động' : 'Tạm Đóng'}
                            </span>
                        </div>
                        <p class="small text-secondary mb-2 text-truncate" title="${store.address}">
                            <i class="fa-solid fa-location-dot me-2 text-gold"></i>${store.address}
                        </p>
                        <p class="small text-secondary mb-2">
                            <i class="fa-solid fa-phone me-2 text-gold"></i>${store.phoneNumber}
                        </p>
                        <p class="small text-secondary mb-3">
                            <i class="fa-regular fa-clock me-2 text-gold"></i>${store.openingTime} - ${store.closingTime}
                        </p>
                    </div>
                    <div class="pt-3 border-top border-gold-subtle mt-auto d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/barista/kds?storeId=${store.id}" target="_blank" class="btn btn-sm btn-outline-warning w-100 font-accent fw-bold rounded-pill">
                            <i class="fa-solid fa-mug-saucer me-1"></i> Mở KDS Quầy
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Table Management & Online Reservations Section -->
    <div class="card-luxury p-4 border-gold shadow-lg mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom border-gold">
            <div>
                <h5 class="font-serif fw-bold text-primary mb-0">
                    <i class="fa-solid fa-chair me-2"></i>Tiếp Nhận Đặt Bàn Trực Tuyến &amp; Điều Phối Chỗ Ngồi
                </h5>
                <small class="text-secondary">Khách hàng đặt bàn từ website theo từng khung giờ và khu vực ưa thích</small>
            </div>
            <div class="d-flex gap-2 mt-2 mt-md-0">
                <span class="badge bg-dark-roast border border-secondary text-light px-3 py-2 font-accent">
                    Tổng: <strong>${reservations.size()}</strong> lượt đặt
                </span>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty reservations}">
                <div class="table-responsive">
                    <table class="table table-luxury align-middle">
                        <thead>
                            <tr>
                                <th>Mã Đặt</th>
                                <th>Khách Hàng</th>
                                <th>Chi Nhánh</th>
                                <th>Số Khách</th>
                                <th>Thời Gian Hẹn</th>
                                <th>Ghi Chú / Khu Vực</th>
                                <th>Trạng Thái</th>
                                <th class="text-end">Xử Lý</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="res" items="${reservations}">
                                <tr id="res-row-${res.id}">
                                    <td class="font-accent fw-bold text-gold">#RES-${res.id}</td>
                                    <td>
                                        <div class="fw-bold text-light">${res.user != null ? res.user.fullName : 'Khách vãng lai'}</div>
                                        <small class="text-secondary">${res.user != null ? res.user.phoneNumber : ''}</small>
                                    </td>
                                    <td><span class="badge bg-dark-roast border border-secondary text-light">${res.store.name}</span></td>
                                    <td><span class="fw-bold text-gold">${res.guestCount} Khách</span></td>
                                    <td>
                                        <div class="small text-light">${res.reservationTime}</div>
                                    </td>
                                    <td>
                                        <small class="text-secondary">${not empty res.note ? res.note : 'Tiêu chuẩn quầy'}</small>
                                    </td>
                                    <td>
                                        <span class="badge ${res.status == 'CONFIRMED' ? 'bg-success' : (res.status == 'COMPLETED' ? 'bg-primary' : (res.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark'))} px-2 py-1" id="res-status-badge-${res.id}">
                                            <c:choose>
                                                <c:when test="${res.status == 'CONFIRMED'}">Đã Xác Nhận</c:when>
                                                <c:when test="${res.status == 'COMPLETED'}">Đã Phục Vụ</c:when>
                                                <c:when test="${res.status == 'CANCELLED'}">Đã Hủy</c:when>
                                                <c:otherwise>Chờ Duyệt</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <div class="btn-group btn-group-sm">
                                            <c:if test="${res.status != 'CONFIRMED' && res.status != 'COMPLETED' && res.status != 'CANCELLED'}">
                                                <button type="button" class="btn btn-outline-success btn-sm" title="Xác nhận giữ chỗ" onclick="updateResStatus(${res.id}, 'CONFIRMED')">
                                                    <i class="fa-solid fa-check"></i> Duyệt
                                                </button>
                                            </c:if>
                                            <c:if test="${res.status == 'CONFIRMED'}">
                                                <button type="button" class="btn btn-outline-primary btn-sm" title="Hoàn tất phục vụ" onclick="updateResStatus(${res.id}, 'COMPLETED')">
                                                    <i class="fa-solid fa-check-double"></i> Xong
                                                </button>
                                            </c:if>
                                            <c:if test="${res.status != 'CANCELLED' && res.status != 'COMPLETED'}">
                                                <button type="button" class="btn btn-outline-danger btn-sm" title="Hủy bàn" onclick="updateResStatus(${res.id}, 'CANCELLED')">
                                                    <i class="fa-solid fa-xmark"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-4">
                    <i class="fa-solid fa-calendar-check text-gold fs-2 mb-2 d-block opacity-50"></i>
                    <p class="text-secondary small mb-0">Chưa có lịch đặt bàn trực tuyến nào đang chờ xử lý.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Script for Updating Reservation Status -->
    <script>
        function updateResStatus(id, status) {
            fetch('${pageContext.request.contextPath}/admin/reservations/' + id + '/status?status=' + status, {
                method: 'POST'
            }).then(res => res.json()).then(data => {
                if (data.success) {
                    location.reload();
                }
            }).catch(err => console.error(err));
        }
    </script>
</body>
