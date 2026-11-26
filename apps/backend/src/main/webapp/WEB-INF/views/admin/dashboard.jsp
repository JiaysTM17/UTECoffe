<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Bảng Điều Khiển Quản Trị - UTECoffe Executive Suite</title>
</head>
<body>
    <!-- Top Stat Metric Cards -->
    <div class="row g-3 mb-3">
        <!-- Metric 1: Total Revenue -->
        <div class="col-xl-3 col-sm-6">
            <div class="card-luxury p-3 p-md-3.5 h-100 shadow-sm">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="text-secondary fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.03em; text-transform: uppercase;">Tổng doanh thu</span>
                    <div class="d-flex align-items-center justify-content-center rounded-2" style="width: 32px; height: 32px; background: rgba(222, 183, 106, 0.12); color: var(--gold-primary);">
                        <i class="fa-solid fa-coins" style="font-size: 0.88rem;"></i>
                    </div>
                </div>
                <div class="fw-bold text-primary my-1" style="font-family: var(--font-sans); font-size: 1.45rem; letter-spacing: -0.02em; font-variant-numeric: tabular-nums; line-height: 1.25;">
                    <fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/> VNĐ
                </div>
                <div class="text-success small d-flex align-items-center gap-1" style="font-size: 0.75rem;">
                    <i class="fa-solid fa-arrow-trend-up"></i>
                    <span>${completedOrdersCount} đơn hoàn tất</span>
                </div>
            </div>
        </div>

        <!-- Metric 2: Total Orders -->
        <div class="col-xl-3 col-sm-6">
            <div class="card-luxury p-3 p-md-3.5 h-100 shadow-sm">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="text-secondary fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.03em; text-transform: uppercase;">Tổng đơn hàng</span>
                    <div class="d-flex align-items-center justify-content-center rounded-2" style="width: 32px; height: 32px; background: rgba(222, 183, 106, 0.12); color: var(--gold-primary);">
                        <i class="fa-solid fa-receipt" style="font-size: 0.88rem;"></i>
                    </div>
                </div>
                <div class="fw-bold text-primary my-1" style="font-family: var(--font-sans); font-size: 1.45rem; letter-spacing: -0.02em; font-variant-numeric: tabular-nums; line-height: 1.25;">
                    ${totalOrders} đơn
                </div>
                <div class="text-warning small d-flex align-items-center gap-1" style="font-size: 0.75rem;">
                    <i class="fa-regular fa-clock"></i>
                    <span>${pendingOrdersCount} đơn đang xử lý</span>
                </div>
            </div>
        </div>

        <!-- Metric 3: Active Products -->
        <div class="col-xl-3 col-sm-6">
            <div class="card-luxury p-3 p-md-3.5 h-100 shadow-sm">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="text-secondary fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.03em; text-transform: uppercase;">Thực đơn đặc sản</span>
                    <div class="d-flex align-items-center justify-content-center rounded-2" style="width: 32px; height: 32px; background: rgba(222, 183, 106, 0.12); color: var(--gold-primary);">
                        <i class="fa-solid fa-mug-hot" style="font-size: 0.88rem;"></i>
                    </div>
                </div>
                <div class="fw-bold text-primary my-1" style="font-family: var(--font-sans); font-size: 1.45rem; letter-spacing: -0.02em; font-variant-numeric: tabular-nums; line-height: 1.25;">
                    ${totalProducts} sản phẩm
                </div>
                <div class="text-secondary small" style="font-size: 0.75rem;">
                    5 danh mục đang phục vụ
                </div>
            </div>
        </div>

        <!-- Metric 4: Members -->
        <div class="col-xl-3 col-sm-6">
            <div class="card-luxury p-3 p-md-3.5 h-100 shadow-sm">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="text-secondary fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.03em; text-transform: uppercase;">Thành viên UTEClub</span>
                    <div class="d-flex align-items-center justify-content-center rounded-2" style="width: 32px; height: 32px; background: rgba(222, 183, 106, 0.12); color: var(--gold-primary);">
                        <i class="fa-solid fa-award" style="font-size: 0.88rem;"></i>
                    </div>
                </div>
                <div class="fw-bold text-primary my-1" style="font-family: var(--font-sans); font-size: 1.45rem; letter-spacing: -0.02em; font-variant-numeric: tabular-nums; line-height: 1.25;">
                    ${totalUsers} tài khoản
                </div>
                <div class="text-success small d-flex align-items-center gap-1" style="font-size: 0.75rem;">
                    <i class="fa-solid fa-crown"></i>
                    <span>Hội viên 4 hạng thẻ</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Store Performance Row: 3 Branches -->
    <div class="row g-3 mb-3">
        <div class="col-12">
            <div class="card-luxury p-3 p-md-3.5 shadow-sm">
                <div class="d-flex justify-content-between align-items-center mb-2.5 pb-2 border-bottom border-gold-subtle">
                    <div class="d-flex align-items-center gap-2">
                        <i class="fa-solid fa-store text-gold" style="font-size: 0.92rem;"></i>
                        <span class="fw-semibold text-primary" style="font-size: 0.92rem;">Hiệu suất vận hành 3 chi nhánh</span>
                    </div>
                    <span class="badge bg-dark-roast border border-gold-subtle text-gold py-1 px-2.5 font-sans" style="font-size: 0.72rem; border-radius: 9999px;">
                        3 chi nhánh đang hoạt động
                    </span>
                </div>

                <div class="row g-2.5">
                    <c:forEach var="st" items="${stores}">
                        <div class="col-md-4">
                            <div class="p-2.5 rounded-2 h-100 d-flex flex-column justify-content-between" style="background: var(--bg-secondary); border: 1px solid var(--border-gold-subtle);">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start mb-1">
                                        <div class="fw-semibold text-primary text-truncate" style="font-size: 0.85rem;" title="${st.name}">${st.name}</div>
                                        <span class="badge bg-success-subtle text-success" style="font-size: 0.68rem; padding: 2px 6px;">Hoạt động</span>
                                    </div>
                                    <div class="text-secondary small mb-2 text-truncate" style="font-size: 0.75rem;" title="${st.address}">
                                        <i class="fa-solid fa-location-dot me-1 text-gold"></i> ${st.address}
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-2 border-top border-secondary border-opacity-25" style="font-size: 0.78rem;">
                                    <span class="text-secondary">
                                        Đơn hàng: <strong class="text-primary">${storeOrderCounts[st.id] != null ? storeOrderCounts[st.id] : 0}</strong>
                                    </span>
                                    <span class="text-gold fw-bold" style="font-variant-numeric: tabular-nums;">
                                        <fmt:formatNumber value="${storeRevenues[st.id] != null ? storeRevenues[st.id] : 0}" pattern="#,##0"/> VNĐ
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- Sales Analytics & Channel Distribution -->
    <div class="row g-3 mb-3">
        <!-- Channel Breakdown -->
        <div class="col-lg-6">
            <div class="card-luxury p-3 p-md-3.5 shadow-sm h-100">
                <div class="d-flex align-items-center gap-2 mb-3 pb-2 border-bottom border-gold-subtle">
                    <i class="fa-solid fa-chart-pie text-gold" style="font-size: 0.9rem;"></i>
                    <span class="fw-semibold text-primary" style="font-size: 0.92rem;">Phân bổ kênh phục vụ</span>
                </div>
                <div class="d-flex flex-column gap-2.5">
                    <div>
                        <div class="d-flex justify-content-between small mb-1" style="font-size: 0.8rem;">
                            <span class="text-primary"><i class="fa-solid fa-utensils text-gold me-2"></i>Tại quán (Dine-in)</span>
                            <span class="text-gold fw-bold" style="font-variant-numeric: tabular-nums;">${dineInCount} đơn</span>
                        </div>
                        <div class="progress" style="height: 6px; background: rgba(0,0,0,0.08); border-radius: 9999px;">
                            <div class="progress-bar bg-warning" style="width: ${totalOrders > 0 ? (dineInCount * 100 / totalOrders) : 0}%; border-radius: 9999px;"></div>
                        </div>
                    </div>
                    <div>
                        <div class="d-flex justify-content-between small mb-1" style="font-size: 0.8rem;">
                            <span class="text-primary"><i class="fa-solid fa-cup-straw text-warning me-2"></i>Mang đi (Take-away)</span>
                            <span class="text-warning fw-bold" style="font-variant-numeric: tabular-nums;">${takeAwayCount} đơn</span>
                        </div>
                        <div class="progress" style="height: 6px; background: rgba(0,0,0,0.08); border-radius: 9999px;">
                            <div class="progress-bar bg-warning" style="width: ${totalOrders > 0 ? (takeAwayCount * 100 / totalOrders) : 0}%; border-radius: 9999px;"></div>
                        </div>
                    </div>
                    <div>
                        <div class="d-flex justify-content-between small mb-1" style="font-size: 0.8rem;">
                            <span class="text-primary"><i class="fa-solid fa-motorcycle text-info me-2"></i>Giao hàng (Delivery)</span>
                            <span class="text-info fw-bold" style="font-variant-numeric: tabular-nums;">${deliveryCount} đơn</span>
                        </div>
                        <div class="progress" style="height: 6px; background: rgba(0,0,0,0.08); border-radius: 9999px;">
                            <div class="progress-bar bg-info" style="width: ${totalOrders > 0 ? (deliveryCount * 100 / totalOrders) : 0}%; border-radius: 9999px;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top Selling Products -->
        <div class="col-lg-6">
            <div class="card-luxury p-3 p-md-3.5 shadow-sm h-100">
                <div class="d-flex align-items-center gap-2 mb-3 pb-2 border-bottom border-gold-subtle">
                    <i class="fa-solid fa-fire text-gold" style="font-size: 0.9rem;"></i>
                    <span class="fw-semibold text-primary" style="font-size: 0.92rem;">Top 5 thức uống bán chạy nhất</span>
                </div>
                <c:choose>
                    <c:when test="${not empty topProducts}">
                        <ul class="list-unstyled mb-0 d-flex flex-column gap-2">
                            <c:forEach var="tp" items="${topProducts}" varStatus="status">
                                <li class="py-1.5 px-2.5 rounded-2 d-flex justify-content-between align-items-center" style="background: var(--bg-secondary); border: 1px solid var(--border-gold-subtle);">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge ${status.index == 0 ? 'bg-warning text-dark' : 'bg-dark-roast text-gold'} font-sans rounded-circle p-0 d-inline-flex align-items-center justify-content-center" style="width: 20px; height: 20px; font-size: 0.7rem;">${status.index + 1}</span>
                                        <span class="text-primary small fw-medium" style="font-size: 0.82rem;">${tp.key}</span>
                                    </div>
                                    <span class="badge font-sans" style="font-size: 0.75rem; background: var(--bg-card); border: 1px solid var(--border-gold-subtle); color: var(--text-gold); font-variant-numeric: tabular-nums;">${tp.value} phần</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <p class="text-secondary small mb-0" style="font-size: 0.8rem;">Đang cập nhật số liệu sản phẩm bán chạy theo đơn hàng thực tế...</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Quick Actions Panel -->
    <div class="card-luxury p-2.5 p-md-3 mb-3 shadow-sm">
        <div class="d-flex flex-wrap gap-2 align-items-center justify-content-between">
            <span class="text-secondary fw-semibold small" style="font-size: 0.8rem;">
                <i class="fa-solid fa-bolt text-gold me-1"></i> Thao tác quản trị nhanh:
            </span>
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-gold btn-sm rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;">
                    <i class="fa-solid fa-plus me-1"></i> Quản lý thực đơn
                </a>
                <a href="${pageContext.request.contextPath}/barista/kds" class="btn btn-outline-warning btn-sm rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;">
                    <i class="fa-solid fa-display me-1"></i> KDS pha chế
                </a>
                <a href="${pageContext.request.contextPath}/admin/stores" class="btn btn-outline-info btn-sm rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;">
                    <i class="fa-solid fa-chair me-1"></i> Quản lý đặt bàn
                </a>
                <a href="${pageContext.request.contextPath}/admin/inventory" class="btn btn-outline-gold btn-sm rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;">
                    <i class="fa-solid fa-warehouse me-1"></i> Kiểm kho BOM
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders/export" class="btn btn-outline-success btn-sm rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;">
                    <i class="fa-solid fa-file-excel me-1"></i> Xuất Excel đơn
                </a>
            </div>
        </div>
    </div>

    <!-- Recent Orders Table -->
    <div class="card-luxury p-3 p-md-3.5 shadow-sm">
        <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom border-gold-subtle">
            <div class="d-flex align-items-center gap-2">
                <i class="fa-solid fa-receipt text-gold" style="font-size: 0.9rem;"></i>
                <span class="fw-semibold text-primary" style="font-size: 0.92rem;">Đơn hàng mới nhất toàn chuỗi</span>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/orders/export" class="btn btn-outline-gold btn-sm rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;">
                    <i class="fa-solid fa-file-excel me-1"></i> Xuất Excel
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-gold btn-sm rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;">
                    Xem tất cả
                </a>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-luxury table-sm align-middle mb-0">
                <thead>
                    <tr style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.03em; color: var(--text-secondary);">
                        <th class="py-2">Mã đơn</th>
                        <th class="py-2">Khách hàng</th>
                        <th class="py-2">Chi nhánh</th>
                        <th class="py-2">Hình thức</th>
                        <th class="py-2">Tổng tiền</th>
                        <th class="py-2">Trạng thái</th>
                    </tr>
                </thead>
                <tbody style="font-size: 0.82rem;">
                    <c:forEach var="ord" items="${recentOrders}">
                        <tr>
                            <td class="fw-semibold">
                                <a href="${pageContext.request.contextPath}/orders/tracking/${ord.orderCode}" class="text-gold text-decoration-none">
                                    #${ord.orderCode}
                                </a>
                            </td>
                            <td>
                                <div class="fw-medium text-primary">${ord.recipientName}</div>
                                <small class="text-secondary" style="font-size: 0.75rem;">${ord.recipientPhone}</small>
                            </td>
                            <td><span class="text-primary">${ord.store.name}</span></td>
                            <td>
                                <span class="badge font-sans" style="font-size: 0.75rem; background: var(--bg-secondary); border: 1px solid var(--border-gold-subtle); color: var(--text-primary);">
                                    <c:choose>
                                        <c:when test="${ord.orderType == 'DINE_IN'}"><i class="fa-solid fa-utensils text-gold me-1"></i>Tại quán</c:when>
                                        <c:when test="${ord.orderType == 'TAKE_AWAY'}"><i class="fa-solid fa-cup-straw text-warning me-1"></i>Mang đi</c:when>
                                        <c:otherwise><i class="fa-solid fa-motorcycle text-info me-1"></i>Giao hàng</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td class="text-gold fw-bold" style="font-variant-numeric: tabular-nums;">
                                <fmt:formatNumber value="${ord.finalAmount}" pattern="#,##0"/> VNĐ
                            </td>
                            <td>
                                <span class="badge ${ord.status == 'COMPLETED' ? 'bg-success-subtle text-success border border-success-subtle' : (ord.status == 'CANCELLED' ? 'bg-danger-subtle text-danger border border-danger-subtle' : (ord.status == 'PREPARING' ? 'bg-warning-subtle text-warning border border-warning-subtle' : 'bg-secondary text-primary'))} px-2 py-1" style="font-size: 0.75rem;">
                                    <c:choose>
                                        <c:when test="${ord.status == 'COMPLETED'}">Hoàn tất</c:when>
                                        <c:when test="${ord.status == 'PREPARING'}">Đang pha</c:when>
                                        <c:when test="${ord.status == 'PENDING'}">Chờ xử lý</c:when>
                                        <c:when test="${ord.status == 'CANCELLED'}">Đã hủy</c:when>
                                        <c:otherwise>${ord.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</body>
