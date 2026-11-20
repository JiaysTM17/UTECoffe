<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Hồ Sơ Thành Viên - UTECoffe</title>
</head>
<body>
    <div class="container py-5">
        <div class="row g-4">
            <!-- Loyalty Card Banner -->
            <div class="col-lg-4">
                <div class="card border-0 shadow text-white p-4 mb-4" style="background: linear-gradient(135deg, #1A1715, #2D2824); border-radius: 16px; border: 1px solid #D4AF37 !important;">
                    <div class="d-flex justify-content-between align-items-start mb-4">
                        <div>
                            <span class="badge bg-warning text-dark px-2 py-1 mb-2">UTEClub Member</span>
                            <h5 class="fw-bold mb-0">THẺ THÀNH VIÊN</h5>
                        </div>
                        <i class="fa-solid fa-mug-saucer text-warning fs-3"></i>
                    </div>
                    <h3 class="fw-bold letter-spacing-2 mb-3">${loyaltyCard != null ? loyaltyCard.cardNumber : 'UTE-MEMBER'}</h3>
                    <div class="d-flex justify-content-between align-items-end mt-4 pt-3 border-top border-secondary">
                        <div>
                            <small class="text-muted d-block">HẠNG THẺ</small>
                            <span class="fw-bold text-warning fs-5">${loyaltyCard != null ? loyaltyCard.tier : 'BRONZE'}</span>
                        </div>
                        <div class="text-end">
                            <small class="text-muted d-block">ĐIỂM HẠT VÀNG</small>
                            <span class="fw-bold text-warning fs-4">${loyaltyCard != null ? loyaltyCard.pointsBalance : 0} pts</span>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm p-4">
                    <h6 class="fw-bold mb-3">Thông Tin Cá Nhân</h6>
                    <p class="small mb-2"><strong>Họ tên:</strong> ${user.fullName}</p>
                    <p class="small mb-2"><strong>Email:</strong> ${user.email}</p>
                    <p class="small mb-3"><strong>Số điện thoại:</strong> ${user.phoneNumber}</p>
                    <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline-danger btn-sm w-100">Đăng Xuất</a>
                </div>
            </div>

            <!-- Orders History & Points Logs -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm p-4 mb-4">
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-receipt me-2 text-warning"></i> Lịch Sử Đơn Hàng Gần Đây</h5>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Mã Đơn</th>
                                    <th>Chi Nhánh</th>
                                    <th>Tổng Tiền</th>
                                    <th>Trạng Thái</th>
                                    <th>Ngày Đặt</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ord" items="${orders}">
                                    <tr>
                                        <td class="fw-bold"><a href="${pageContext.request.contextPath}/orders/tracking/${ord.orderCode}">#${ord.orderCode}</a></td>
                                        <td>${ord.store.name}</td>
                                        <td class="text-danger fw-bold"><fmt:formatNumber value="${ord.finalAmount}" type="currency" currencySymbol="₫"/></td>
                                        <td><span class="badge bg-warning text-dark">${ord.status}</span></td>
                                        <td class="small text-muted">${ord.createdAt}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
