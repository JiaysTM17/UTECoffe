<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Hồ Sơ Thành Viên UTEClub - UTECoffe</title>
</head>
<body class="bg-obsidian">
    <div class="container py-5">
        <div class="section-title-wrap mb-4">
            <span class="section-subtitle">Đặc Quyền Hội Viên</span>
            <h2 class="section-title">Hồ Sơ Cá Nhân &amp; Điểm UTEClub</h2>
            <div class="gold-divider"></div>
        </div>

        <div class="row g-4">
            <!-- Left: Member Card -->
            <div class="col-lg-4">
                <div class="card-luxury p-4 text-center">
                    <div class="d-inline-block p-1 rounded-circle border border-gold mb-3">
                        <i class="fa-solid fa-circle-user text-gold display-4"></i>
                    </div>
                    <h4 class="font-serif fw-bold text-gold-gradient mb-1">${user.fullName}</h4>
                    <p class="text-secondary small mb-3">${user.email} • ${user.phoneNumber}</p>
                    
                    <div class="p-3 rounded-3 bg-espresso border border-gold mb-3 text-start">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="small text-muted font-accent text-uppercase">Hạng Thẻ:</span>
                            <span class="badge bg-gold text-dark font-accent fw-bold">THÀNH VIÊN VÀNG</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="small text-muted font-accent text-uppercase">Điểm Tích Lũy:</span>
                            <span class="price-gold fs-5">1.250 Điểm</span>
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold btn-sm w-100">
                        <i class="fa-solid fa-mug-hot me-1"></i> Đặt Món Dùng Điểm
                    </a>
                </div>
            </div>

            <!-- Right: Order History & Points History -->
            <div class="col-lg-8">
                <div class="card-luxury p-4">
                    <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">Lịch Sử Đơn Hàng Gần Đây</h5>
                    <div class="table-responsive">
                        <table class="table table-luxury align-middle">
                            <thead>
                                <tr>
                                    <th>Mã Đơn</th>
                                    <th>Chi Nhánh</th>
                                    <th>Hình Thức</th>
                                    <th>Tổng Tiền</th>
                                    <th>Trạng Thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty orders}">
                                        <c:forEach var="ord" items="${orders}">
                                            <tr>
                                                <td class="fw-bold"><a href="${pageContext.request.contextPath}/orders/tracking/${ord.orderCode}" class="text-gold text-decoration-none">#${ord.orderCode}</a></td>
                                                <td>${ord.store.name}</td>
                                                <td><span class="badge bg-espresso border border-secondary text-light">${ord.orderType}</span></td>
                                                <td class="text-gold fw-bold"><fmt:formatNumber value="${ord.finalAmount}" type="currency" currencySymbol="₫"/></td>
                                                <td><span class="badge bg-success text-light">${ord.status}</span></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">Chưa có đơn hàng nào.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
