<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Hồ Sơ Thành Viên UTEClub - UTECoffe Specialty Roastery</title>
</head>
<body class="bg-obsidian">

    <!-- Header Section -->
    <div class="py-5 bg-espresso border-bottom border-gold text-center position-relative overflow-hidden">
        <div class="container py-2 position-relative" style="z-index: 2;">
            <span class="badge bg-gold-subtle text-gold px-3 py-1 rounded-pill small font-accent mb-2 text-uppercase" style="letter-spacing: 0.15em;">
                <i class="fa-solid fa-crown me-1"></i> ĐẶC QUYỀN HỘI VIÊN CAO CẤP
            </span>
            <h1 class="font-serif display-5 fw-bold text-gold-gradient mb-2">
                Hồ Sơ UTEClub &amp; Tích Điểm
            </h1>
            <p class="text-secondary mx-auto small mb-0" style="max-width: 600px;">
                Tận hưởng những ưu đãi độc quyền, nâng hạng thẻ và đổi quà thưởng thức từ điểm tích lũy của bạn.
            </p>
        </div>
    </div>

    <div class="container py-5">
        <div class="row g-4">
            <!-- Left: Member Digital Card & Perks -->
            <div class="col-lg-4">
                <!-- Virtual VIP Card -->
                <div class="card-luxury p-4 text-center mb-4 position-relative overflow-hidden" style="background: linear-gradient(135deg, rgba(26,20,18,0.95), rgba(44,30,22,0.95)); border: 1.5px solid var(--border-gold);">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="badge bg-gold text-obsidian fw-bold font-accent px-3 py-1 rounded-pill small">
                            <i class="fa-solid fa-gem me-1"></i> HẠNG VÀNG (GOLD)
                        </span>
                        <span class="text-gold font-monospace small">#UTE-${user.id != null ? user.id : '2026'}</span>
                    </div>

                    <div class="my-3">
                        <div class="d-inline-flex p-1 rounded-circle border border-gold mb-2 shadow-sm">
                            <i class="fa-solid fa-circle-user text-gold display-3"></i>
                        </div>
                        <h4 class="font-serif fw-bold text-gold-gradient mb-1">${user.fullName != null ? user.fullName : 'Thành Viên Danh Dự'}</h4>
                        <p class="text-secondary small mb-0 font-monospace">${user.email}</p>
                    </div>

                    <!-- Points Meter -->
                    <div class="p-3 rounded-3 bg-espresso border border-gold-subtle mb-3 text-start">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="small text-secondary font-accent text-uppercase">Điểm Tích Lũy:</span>
                            <span class="price-gold fs-4 fw-bold">1.250 Điểm</span>
                        </div>
                        <div class="progress mb-2" style="height: 6px; background-color: rgba(212,175,55,0.2);">
                            <div class="progress-bar bg-gold-gradient" role="progressbar" style="width: 75%;" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                        <small class="text-secondary d-block" style="font-size: 0.75rem;">
                            Tích thêm <strong>250 điểm</strong> để thăng hạng <strong>Kim Cương (Diamond)</strong>
                        </small>
                    </div>

                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold btn-sm flex-grow-1 rounded-pill font-accent fw-bold">
                            <i class="fa-solid fa-mug-hot me-1"></i> Đổi Thức Uống
                        </a>
                        <a href="${pageContext.request.contextPath}/reservation" class="btn btn-outline-gold btn-sm flex-grow-1 rounded-pill font-accent">
                            <i class="fa-solid fa-chair me-1"></i> Đặt Bàn VIP
                        </a>
                    </div>
                </div>

                <!-- Member Perks Breakdown -->
                <div class="card-luxury p-4">
                    <h6 class="font-serif fw-bold text-gold mb-3 border-bottom border-gold pb-2">
                        <i class="fa-solid fa-gift me-2"></i>Đặc Quyền Của Bạn
                    </h6>
                    <ul class="list-unstyled small text-secondary mb-0 d-flex flex-column gap-2">
                        <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Giảm 10% trực tiếp trên toàn bộ thực đơn</li>
                        <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Miễn phí nâng size (Size M lên Size L) mỗi thứ Hai</li>
                        <li><i class="fa-solid fa-circle-check text-gold me-2"></i> 01 Ly cà phê Signature miễn phí nhân dịp Sinh Nhật</li>
                        <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Ưu tiên giữ chỗ tại không gian VIP Lounge</li>
                    </ul>
                </div>
            </div>

            <!-- Right: Order History & Vouchers -->
            <div class="col-lg-8">
                <!-- Voucher Wallet -->
                <div class="card-luxury p-4 mb-4">
                    <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">
                        <i class="fa-solid fa-ticket me-2"></i>Ví Voucher Ưu Đãi Của Bạn
                    </h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="p-3 bg-espresso rounded-3 border border-gold-subtle d-flex align-items-center justify-content-between">
                                <div>
                                    <span class="badge bg-gold text-obsidian fw-bold font-monospace mb-1">UTE2026</span>
                                    <div class="fw-bold text-light small">Giảm 20% Đơn Hàng Đầu Tiên</div>
                                    <small class="text-secondary" style="font-size: 0.75rem;">HSD: 31/12/2026</small>
                                </div>
                                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-gold btn-sm rounded-pill px-3">Dùng</a>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="p-3 bg-espresso rounded-3 border border-gold-subtle d-flex align-items-center justify-content-between">
                                <div>
                                    <span class="badge bg-gold text-obsidian fw-bold font-monospace mb-1">FREESHIP</span>
                                    <div class="fw-bold text-light small">Miễn Phí Giao Hàng Toàn Quốc</div>
                                    <small class="text-secondary" style="font-size: 0.75rem;">Đơn từ 150k</small>
                                </div>
                                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-gold btn-sm rounded-pill px-3">Dùng</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order History -->
                <div class="card-luxury p-4">
                    <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">
                        <i class="fa-solid fa-clock-rotate-left me-2"></i>Lịch Sử Đơn Hàng
                    </h5>
                    <div class="table-responsive">
                        <table class="table table-luxury align-middle">
                            <thead>
                                <tr class="small text-secondary">
                                    <th>Mã Đơn</th>
                                    <th>Chi Nhánh</th>
                                    <th>Hình Thức</th>
                                    <th>Tổng Tiền</th>
                                    <th>Trạng Thái</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty orders}">
                                        <c:forEach var="ord" items="${orders}">
                                            <tr>
                                                <td class="fw-bold">
                                                    <a href="${pageContext.request.contextPath}/orders/tracking/${ord.orderCode}" class="text-gold text-decoration-none font-monospace">
                                                        #${ord.orderCode}
                                                    </a>
                                                </td>
                                                <td class="small text-light">${ord.store.name}</td>
                                                <td><span class="badge bg-espresso border border-secondary text-light small">${ord.orderType}</span></td>
                                                <td class="text-gold fw-bold font-monospace">
                                                    <fmt:formatNumber value="${ord.finalAmount}" type="currency" currencySymbol="₫"/>
                                                </td>
                                                <td>
                                                    <span class="badge bg-gold-subtle text-gold border border-gold-subtle small">${ord.status}</span>
                                                </td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/orders/tracking/${ord.orderCode}" class="btn btn-outline-gold btn-sm py-1 px-2 rounded-pill small" title="Theo dõi đơn">
                                                        <i class="fa-solid fa-eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center py-5 text-secondary">
                                                <i class="fa-solid fa-receipt text-gold fs-1 mb-2 d-block opacity-50"></i>
                                                Bạn chưa có đơn hàng nào tại UTECoffe.
                                                <div class="mt-3">
                                                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold btn-sm px-4 rounded-pill">
                                                        <i class="fa-solid fa-mug-hot me-1"></i> Khám Phá Menu Ngay
                                                    </a>
                                                </div>
                                            </td>
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
