<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Bảng Điều Khiển Quản Trị - UTECoffe Executive Suite</title>
</head>
<body>
    <!-- Top Stat Metric Cards -->
    <div class="row g-4 mb-4">
        <div class="col-xl-3 col-sm-6">
            <div class="card-luxury p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-gold font-accent fw-bold text-uppercase small" style="letter-spacing: 0.1em;">Tổng Đơn Hàng</span>
                    <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-receipt fs-5"></i></div>
                </div>
                <h2 class="font-serif fw-bold text-light mb-1">${totalOrders}</h2>
                <small class="text-success"><i class="fa-solid fa-arrow-trend-up me-1"></i> +18.5% so với tuần trước</small>
            </div>
        </div>

        <div class="col-xl-3 col-sm-6">
            <div class="card-luxury p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-gold font-accent fw-bold text-uppercase small" style="letter-spacing: 0.1em;">Thực Đơn Đang Bán</span>
                    <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-mug-hot fs-5"></i></div>
                </div>
                <h2 class="font-serif fw-bold text-light mb-1">${totalProducts}</h2>
                <small class="text-muted font-accent">100% Cà phê &amp; Trà đặc sản</small>
            </div>
        </div>

        <div class="col-xl-3 col-sm-6">
            <div class="card-luxury p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-gold font-accent fw-bold text-uppercase small" style="letter-spacing: 0.1em;">Chuỗi Chi Nhánh</span>
                    <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-store fs-5"></i></div>
                </div>
                <h2 class="font-serif fw-bold text-light mb-1">${totalStores}</h2>
                <small class="text-gold font-accent">100% Hoạt động ổn định</small>
            </div>
        </div>

        <div class="col-xl-3 col-sm-6">
            <div class="card-luxury p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-gold font-accent fw-bold text-uppercase small" style="letter-spacing: 0.1em;">Thành Viên UTEClub</span>
                    <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-award fs-5"></i></div>
                </div>
                <h2 class="font-serif fw-bold text-light mb-1">${totalUsers}</h2>
                <small class="text-success"><i class="fa-solid fa-user-plus me-1"></i> Tích điểm tự động</small>
            </div>
        </div>
    </div>

    <!-- Recent Orders Table -->
    <div class="card-luxury p-4">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-gold">
            <div>
                <h5 class="font-serif fw-bold text-gold-gradient mb-0">Đơn Hàng Mới Nhất Toàn Chuỗi</h5>
                <small class="text-muted">Cập nhật thời gian thực qua hệ thống điều phối OMO</small>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/orders/export" class="btn btn-gold btn-sm">
                    <i class="fa-solid fa-file-excel me-1"></i> Xuất Báo Cáo Excel
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-gold btn-sm">
                    Xem Tất Cả
                </a>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-luxury align-middle">
                <thead>
                    <tr>
                        <th>Mã Đơn</th>
                        <th>Khách Hàng</th>
                        <th>Chi Nhánh</th>
                        <th>Hình Thức</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ord" items="${recentOrders}">
                        <tr>
                            <td class="fw-bold font-accent"><a href="${pageContext.request.contextPath}/orders/tracking/${ord.orderCode}" class="text-gold text-decoration-none">#${ord.orderCode}</a></td>
                            <td>
                                <div class="fw-bold">${ord.recipientName}</div>
                                <small class="text-muted">${ord.recipientPhone}</small>
                            </td>
                            <td>${ord.store.name}</td>
                            <td><span class="badge bg-espresso border border-secondary text-light">${ord.orderType}</span></td>
                            <td class="text-gold fw-bold"><fmt:formatNumber value="${ord.finalAmount}" type="currency" currencySymbol="₫"/></td>
                            <td>
                                <span class="badge ${ord.status == 'COMPLETED' ? 'bg-success' : (ord.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark')} px-2 py-1">
                                    ${ord.status}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
