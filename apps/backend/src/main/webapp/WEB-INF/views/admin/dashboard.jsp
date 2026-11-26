<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Bảng Điều Khiển Quản Trị - UTECoffe Executive Suite</title>
</head>
<body>
    <!-- Top Stat Metric Cards -->
    <div class="row g-4 mb-4">
        <!-- Metric 1: Total Revenue -->
        <div class="col-xl-3 col-sm-6">
            <div class="card-luxury p-4 h-100 border-gold shadow-lg" style="background: linear-gradient(145deg, rgba(30,25,20,0.95) 0%, rgba(15,13,10,0.98) 100%);">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-gold font-accent fw-bold text-uppercase small" style="letter-spacing: 0.1em;">Tổng Doanh Thu</span>
                    <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-coins fs-5"></i></div>
                </div>
                <h3 class="font-serif fw-bold text-primary mb-1">
                    <fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/> VNĐ
                </h3>
                <small class="text-success"><i class="fa-solid fa-arrow-trend-up me-1"></i> ${completedOrdersCount} đơn hoàn tất trọn vẹn</small>
            </div>
        </div>

        <!-- Metric 2: Total Orders -->
        <div class="col-xl-3 col-sm-6">
            <div class="card-luxury p-4 h-100 border-gold shadow-lg">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-gold font-accent fw-bold text-uppercase small" style="letter-spacing: 0.1em;">Tổng Đơn Hàng</span>
                    <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-receipt fs-5"></i></div>
                </div>
                <h3 class="font-serif fw-bold text-primary mb-1">${totalOrders} Đơn</h3>
                <small class="text-warning"><i class="fa-solid fa-clock me-1"></i> ${pendingOrdersCount} đơn đang xử lý / pha chế</small>
            </div>
        </div>

        <!-- Metric 3: Active Products -->
        <div class="col-xl-3 col-sm-6">
            <div class="card-luxury p-4 h-100 border-gold shadow-lg">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-gold font-accent fw-bold text-uppercase small" style="letter-spacing: 0.1em;">Thực Đơn Đặc Sản</span>
                    <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-mug-hot fs-5"></i></div>
                </div>
                <h3 class="font-serif fw-bold text-primary mb-1">${totalProducts} Sản Phẩm</h3>
                <small class="text-secondary font-accent">5 danh mục: Cà phê, Trà, Bánh &amp; Đá xay</small>
            </div>
        </div>

        <!-- Metric 4: Members -->
        <div class="col-xl-3 col-sm-6">
            <div class="card-luxury p-4 h-100 border-gold shadow-lg">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-gold font-accent fw-bold text-uppercase small" style="letter-spacing: 0.1em;">Thành Viên UTEClub</span>
                    <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-award fs-5"></i></div>
                </div>
                <h3 class="font-serif fw-bold text-primary mb-1">${totalUsers} Tài Khoản</h3>
                <small class="text-success"><i class="fa-solid fa-crown me-1"></i> Đồng, Bạc, Vàng, Kim Cương</small>
            </div>
        </div>
    </div>

    <!-- Store Performance Row: 3 Branches -->
    <div class="row g-4 mb-4">
        <div class="col-12">
            <div class="card-luxury p-4 border-gold shadow-lg">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom border-gold-subtle">
                    <div>
                        <h5 class="font-serif fw-bold text-primary mb-0">
                            <i class="fa-solid fa-store me-2"></i>Hiệu Suất Vận Hành 3 Chi Nhánh
                        </h5>
                        <small class="text-secondary">Thống kê đơn hàng và doanh thu theo từng cơ sở</small>
                    </div>
                    <span class="badge bg-dark-roast border border-gold text-gold px-3 py-1 font-accent">
                        3 Chi Nhánh Đang Hoạt Động
                    </span>
                </div>

                <div class="row g-3">
                    <c:forEach var="st" items="${stores}">
                        <div class="col-md-4">
                            <div class="p-3 rounded-3 bg-dark-roast border border-secondary border-opacity-50 h-100 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div class="fw-bold text-gold font-accent text-truncate" title="${st.name}">${st.name}</div>
                                        <span class="badge bg-success-subtle text-success small">Hoạt Động</span>
                                    </div>
                                    <div class="text-secondary small mb-3 text-truncate" title="${st.address}">
                                        <i class="fa-solid fa-location-dot me-1 text-gold"></i> ${st.address}
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-2 border-top border-secondary border-opacity-25">
                                    <span class="text-primary small">
                                        Đơn hàng: <strong>${storeOrderCounts[st.id] != null ? storeOrderCounts[st.id] : 0}</strong>
                                    </span>
                                    <span class="text-gold fw-bold small">
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
    <div class="row g-4 mb-4">
        <!-- Channel Breakdown -->
        <div class="col-lg-6">
            <div class="card-luxury p-4 border-gold shadow-lg h-100">
                <h5 class="font-serif fw-bold text-primary mb-3 border-bottom border-gold-subtle pb-2">
                    <i class="fa-solid fa-chart-pie me-2"></i>Phân Bổ Kênh Phục Vụ
                </h5>
                <div class="d-flex flex-column gap-3">
                    <div>
                        <div class="d-flex justify-content-between small mb-1">
                            <span class="text-primary"><i class="fa-solid fa-chair text-gold me-2"></i>Tại Quán (Dine-in)</span>
                            <span class="text-gold fw-bold">${dineInCount} đơn</span>
                        </div>
                        <div class="progress bg-dark" style="height: 8px;">
                            <div class="progress-bar bg-warning" style="width: ${totalOrders > 0 ? (dineInCount * 100 / totalOrders) : 0}%;"></div>
                        </div>
                    </div>
                    <div>
                        <div class="d-flex justify-content-between small mb-1">
                            <span class="text-primary"><i class="fa-solid fa-mug-saucer text-warning me-2"></i>Mang Đi (Take-away)</span>
                            <span class="text-warning fw-bold">${takeAwayCount} đơn</span>
                        </div>
                        <div class="progress bg-dark" style="height: 8px;">
                            <div class="progress-bar bg-warning" style="width: ${totalOrders > 0 ? (takeAwayCount * 100 / totalOrders) : 0}%;"></div>
                        </div>
                    </div>
                    <div>
                        <div class="d-flex justify-content-between small mb-1">
                            <span class="text-primary"><i class="fa-solid fa-motorcycle text-info me-2"></i>Giao Hàng (Delivery)</span>
                            <span class="text-info fw-bold">${deliveryCount} đơn</span>
                        </div>
                        <div class="progress bg-dark" style="height: 8px;">
                            <div class="progress-bar bg-info" style="width: ${totalOrders > 0 ? (deliveryCount * 100 / totalOrders) : 0}%;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top Selling Products -->
        <div class="col-lg-6">
            <div class="card-luxury p-4 border-gold shadow-lg h-100">
                <h5 class="font-serif fw-bold text-primary mb-3 border-bottom border-gold-subtle pb-2">
                    <i class="fa-solid fa-fire-flame-curved me-2"></i>Top 5 Thức Uống Bán Chạy Nhất
                </h5>
                <c:choose>
                    <c:when test="${not empty topProducts}">
                        <ul class="list-unstyled mb-0 d-flex flex-column gap-2">
                            <c:forEach var="tp" items="${topProducts}" varStatus="status">
                                <li class="p-2 rounded-3 bg-dark-roast border border-secondary border-opacity-25 d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="badge ${status.index == 0 ? 'bg-warning text-dark' : 'bg-dark text-gold'} font-accent">${status.index + 1}</span>
                                        <span class="text-primary small fw-bold">${tp.key}</span>
                                    </div>
                                    <span class="badge bg-espresso border border-gold-subtle text-gold small">${tp.value} phần</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <p class="text-secondary small mb-0">Đang cập nhật số liệu sản phẩm bán chạy theo đơn hàng thực tế...</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Quick Actions Panel -->
    <div class="row g-4 mb-4">
        <div class="col-12">
            <div class="card-luxury p-3 border-gold shadow-sm bg-espresso">
                <div class="d-flex flex-wrap gap-2 align-items-center justify-content-between">
                    <span class="text-gold font-accent fw-bold small text-uppercase">
                        <i class="fa-solid fa-bolt me-1"></i> Thao Tác Quản Trị Nhanh:
                    </span>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-gold btn-sm rounded-pill px-3 font-accent">
                            <i class="fa-solid fa-plus me-1"></i> Quản Lý Thực Đơn
                        </a>
                        <a href="${pageContext.request.contextPath}/barista/kds" class="btn btn-outline-warning btn-sm rounded-pill px-3 font-accent">
                            <i class="fa-solid fa-display me-1"></i> Màn Hình KDS Pha Chế
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/stores" class="btn btn-outline-info btn-sm rounded-pill px-3 font-accent">
                            <i class="fa-solid fa-chair me-1"></i> Quản Lý Đặt Bàn
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/inventory" class="btn btn-outline-gold btn-sm rounded-pill px-3 font-accent">
                            <i class="fa-solid fa-warehouse me-1"></i> Kiểm Kho Nguyên Liệu
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/orders/export" class="btn btn-outline-success btn-sm rounded-pill px-3 font-accent">
                            <i class="fa-solid fa-file-excel me-1"></i> Xuất Excel Đơn Hàng
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Orders Table -->
    <div class="card-luxury p-4 border-gold shadow-lg">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-gold">
            <div>
                <h5 class="font-serif fw-bold text-primary mb-0">Đơn Hàng Mới Nhất Toàn Chuỗi</h5>
                <small class="text-secondary">Cập nhật thời gian thực qua hệ thống điều phối OMO</small>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/orders/export" class="btn btn-gold btn-sm rounded-pill px-3 font-accent">
                    <i class="fa-solid fa-file-excel me-1"></i> Xuất Excel
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-gold btn-sm rounded-pill px-3 font-accent">
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
                            <td class="fw-bold font-accent">
                                <a href="${pageContext.request.contextPath}/orders/tracking/${ord.orderCode}" class="text-gold text-decoration-none">
                                    #${ord.orderCode}
                                </a>
                            </td>
                            <td>
                                <div class="fw-bold text-primary">${ord.recipientName}</div>
                                <small class="text-secondary">${ord.recipientPhone}</small>
                            </td>
                            <td><span class="text-primary">${ord.store.name}</span></td>
                            <td>
                                <span class="badge bg-espresso border border-secondary text-primary">
                                    <c:choose>
                                        <c:when test="${ord.orderType == 'DINE_IN'}">🍽️ Tại Quán</c:when>
                                        <c:when test="${ord.orderType == 'TAKE_AWAY'}">🥤 Mang Đi</c:when>
                                        <c:otherwise>🛵 Giao Hàng</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td class="text-gold fw-bold">
                                <fmt:formatNumber value="${ord.finalAmount}" pattern="#,##0"/> VNĐ
                            </td>
                            <td>
                                <span class="badge ${ord.status == 'COMPLETED' ? 'bg-success' : (ord.status == 'CANCELLED' ? 'bg-danger' : (ord.status == 'PREPARING' ? 'bg-warning text-dark' : 'bg-secondary text-primary'))} px-2 py-1">
                                    <c:choose>
                                        <c:when test="${ord.status == 'COMPLETED'}">Hoàn Tất</c:when>
                                        <c:when test="${ord.status == 'PREPARING'}">Đang Pha</c:when>
                                        <c:when test="${ord.status == 'PENDING'}">Chờ Xử Lý</c:when>
                                        <c:when test="${ord.status == 'CANCELLED'}">Đã Hủy</c:when>
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
