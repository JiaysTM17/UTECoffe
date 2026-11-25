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

    <!-- Tier Variables Calculation -->
    <c:set var="tierName" value="${loyaltyCard != null ? loyaltyCard.tier.name() : 'BRONZE'}"/>
    <c:set var="pts" value="${loyaltyCard != null ? loyaltyCard.pointsBalance : 0}"/>
    <c:set var="progressPct" value="20"/>
    <c:set var="nextTierText" value="Tích thêm 380 điểm để lên Hạng Bạc"/>
    <c:set var="badgeStyle" value="background: #cd7f32; color: #ffffff;"/>
    <c:set var="badgeIcon" value="fa-award"/>
    <c:set var="badgeLabel" value="HẠNG ĐỒNG (BRONZE)"/>

    <c:if test="${tierName == 'SILVER'}">
        <c:set var="badgeStyle" value="background: #c0c0c0; color: #12100E;"/>
        <c:set var="badgeIcon" value="fa-medal"/>
        <c:set var="badgeLabel" value="HẠNG BẠC (SILVER)"/>
        <c:set var="progressPct" value="${((pts - 500) * 100) / 1000}"/>
        <c:set var="nextTierText" value="Tích thêm ${1500 - pts > 0 ? 1500 - pts : 0} điểm để lên Hạng Vàng VIP"/>
    </c:if>

    <c:if test="${tierName == 'GOLD'}">
        <c:set var="badgeStyle" value="background: #ffd700; color: #12100E;"/>
        <c:set var="badgeIcon" value="fa-gem"/>
        <c:set var="badgeLabel" value="HẠNG VÀNG (GOLD VIP)"/>
        <c:set var="progressPct" value="${((pts - 1500) * 100) / 1500}"/>
        <c:set var="nextTierText" value="Tích thêm ${3000 - pts > 0 ? 3000 - pts : 0} điểm để lên Kim Cương"/>
    </c:if>

    <c:if test="${tierName == 'DIAMOND'}">
        <c:set var="badgeStyle" value="background: #b9f2ff; color: #12100E;"/>
        <c:set var="badgeIcon" value="fa-crown"/>
        <c:set var="badgeLabel" value="KIM CƯƠNG (DIAMOND ELITE)"/>
        <c:set var="progressPct" value="100"/>
        <c:set var="nextTierText" value="Đẳng Cấp Tối Cao - Thượng Khách Danh Dự Trọn Đời"/>
    </c:if>

    <c:if test="${tierName == 'BRONZE'}">
        <c:set var="progressPct" value="${(pts * 100) / 500}"/>
        <c:set var="nextTierText" value="Tích thêm ${500 - pts > 0 ? 500 - pts : 0} điểm để lên Hạng Bạc"/>
    </c:if>

    <div class="container py-5">
        <div class="row g-4">
            <!-- Left: Member Digital Card & Perks -->
            <div class="col-lg-4">
                <!-- Virtual VIP Card -->
                <div class="card-luxury p-4 text-center mb-4 position-relative overflow-hidden" 
                     style="background: linear-gradient(135deg, rgba(26,20,18,0.98), rgba(44,30,22,0.95)); border: 1.5px solid var(--border-gold);">
                    
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="badge px-3 py-1.5 rounded-pill small font-accent fw-bold" style="${badgeStyle}">
                            <i class="fa-solid ${badgeIcon} me-1"></i> ${badgeLabel}
                        </span>
                        <span class="text-gold font-monospace small">${loyaltyCard != null ? loyaltyCard.cardNumber : '#UTE-2026'}</span>
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
                            <span class="price-gold fs-4 fw-bold"><fmt:formatNumber value="${pts}" pattern="#,##0"/> Điểm</span>
                        </div>
                        <div class="progress mb-2" style="height: 6px; background-color: rgba(212,175,55,0.2);">
                            <div class="progress-bar bg-gold-gradient" role="progressbar" style="width: ${progressPct > 100 ? 100 : (progressPct < 5 ? 5 : progressPct)}%;" aria-valuenow="${progressPct}" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                        <small class="text-secondary d-block" style="font-size: 0.75rem;">
                            <strong>${nextTierText}</strong>
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

                <!-- Member Perks Breakdown (Dynamic based on Tier) -->
                <div class="card-luxury p-4">
                    <h6 class="font-serif fw-bold text-gold mb-3 border-bottom border-gold pb-2">
                        <i class="fa-solid fa-gift me-2"></i>Đặc Quyền Của Bạn (${badgeLabel})
                    </h6>
                    <ul class="list-unstyled small text-secondary mb-0 d-flex flex-column gap-2">
                        <c:choose>
                            <c:when test="${tierName == 'DIAMOND'}">
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> <strong>Giảm 15% trọn đời</strong> trên toàn bộ thực đơn</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Miễn phí 01 phần bánh sừng bò thủ công mỗi tuần</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Vé mời tham dự Private Cupping Tour &amp; Roastery Workshop</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Ưu tiên số 1 khi đặt bàn Sofa VIP Lounge tại 3 chi nhánh</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Đường dây hỗ trợ &amp; trợ lý đặt món riêng 24/7</li>
                            </c:when>
                            <c:when test="${tierName == 'GOLD'}">
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> <strong>Giảm 10% trực tiếp</strong> trên toàn bộ thực đơn</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> 01 Ly cà phê Signature miễn phí ngày Sinh Nhật</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Ưu tiên giữ bàn đẹp tại khu vực VIP Lounge</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Toàn bộ đặc quyền của Hạng Bạc &amp; Đồng</li>
                            </c:when>
                            <c:when test="${tierName == 'SILVER'}">
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> <strong>Free Up-size</strong> (Size M lên Size L) mỗi thứ Năm hàng tuần</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Voucher giảm 10% tặng vào ví đầu mỗi tháng</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Tặng 01 phần Topping tự chọn hàng tháng</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Toàn bộ đặc quyền tích lũy của Hạng Đồng</li>
                            </c:when>
                            <c:otherwise>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Tích lũy <strong>10% điểm</strong> cho mọi đơn hàng tại quán &amp; online</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Voucher <strong>giảm 20%</strong> cho đơn hàng đầu tiên</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Nhận tin mẻ rang specialty mới sớm nhất</li>
                                <li><i class="fa-solid fa-circle-check text-gold me-2"></i> Đặt bàn trực tuyến nhanh chóng tại 3 chi nhánh Flagship</li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>

            <!-- Right: Order History, Vouchers & Points Transactions -->
            <div class="col-lg-8">
                <!-- Voucher Wallet (Dynamic) -->
                <div class="card-luxury p-4 mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-3 border-bottom border-gold pb-2">
                        <h5 class="font-serif fw-bold text-gold-gradient mb-0">
                            <i class="fa-solid fa-ticket me-2"></i>Ví Voucher Ưu Đãi Của Bạn
                        </h5>
                        <span class="badge bg-gold text-obsidian small font-accent">${userCoupons != null ? userCoupons.size() : 0} Voucher Khả Dụng</span>
                    </div>

                    <div class="row g-3">
                        <c:choose>
                            <c:when test="${not empty userCoupons}">
                                <c:forEach var="uc" items="${userCoupons}">
                                    <div class="col-md-6">
                                        <div class="p-3 bg-espresso rounded-3 border border-gold-subtle d-flex align-items-center justify-content-between h-100">
                                            <div class="pe-2">
                                                <span class="badge bg-gold text-obsidian fw-bold font-monospace mb-1">${uc.coupon.code}</span>
                                                <div class="fw-bold text-light small mb-1">${uc.coupon.title}</div>
                                                <small class="text-secondary d-block" style="font-size: 0.75rem;">${uc.coupon.description}</small>
                                                <small class="text-muted d-block mt-1" style="font-size: 0.7rem;">HSD: 31/12/2026</small>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-gold btn-sm rounded-pill px-3 flex-shrink-0">
                                                Dùng
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="col-12 text-center py-4 text-secondary small">
                                    <i class="fa-solid fa-ticket text-gold fs-2 mb-2 d-block opacity-50"></i>
                                    Bạn chưa có voucher nào trong ví. Hãy tham gia các sự kiện của UTEClub nhé!
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Tabs for Orders and Points History -->
                <div class="card-luxury p-4">
                    <ul class="nav nav-pills mb-3 border-bottom border-gold-subtle pb-3 gap-2" id="profileTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="btn btn-gold btn-sm rounded-pill active px-4 fw-semibold" id="orders-tab" data-bs-toggle="pill" data-bs-target="#orders-pane" type="button" role="tab">
                                <i class="fa-solid fa-clock-rotate-left me-1"></i> Lịch Sử Đơn Hàng (${orders != null ? orders.size() : 0})
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="btn btn-outline-gold btn-sm rounded-pill px-4 fw-semibold" id="points-tab" data-bs-toggle="pill" data-bs-target="#points-pane" type="button" role="tab">
                                <i class="fa-solid fa-coins me-1"></i> Lịch Sử Tích Điểm UTEClub (${pointsHistory != null ? pointsHistory.size() : 0})
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="profileTabContent">
                        <!-- Pane 1: Orders -->
                        <div class="tab-pane fade show active" id="orders-pane" role="tabpanel">
                            <div class="table-responsive">
                                <table class="table table-luxury align-middle mb-0">
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
                                                            <fmt:formatNumber value="${ord.finalAmount}" pattern="#,##0"/> VNĐ
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

                        <!-- Pane 2: Points History -->
                        <div class="tab-pane fade" id="points-pane" role="tabpanel">
                            <div class="table-responsive">
                                <table class="table table-luxury align-middle mb-0">
                                    <thead>
                                        <tr class="small text-secondary">
                                            <th>Thời Gian</th>
                                            <th>Mô Tả Giao Dịch</th>
                                            <th>Loại</th>
                                            <th class="text-end">Điểm Biến Động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty pointsHistory}">
                                                <c:forEach var="tx" items="${pointsHistory}">
                                                    <tr>
                                                        <td class="small text-muted font-monospace">${tx.createdAt}</td>
                                                        <td class="small text-light">${tx.description}</td>
                                                        <td>
                                                            <span class="badge bg-espresso border border-gold-subtle text-gold small">${tx.transactionType}</span>
                                                        </td>
                                                        <td class="text-end fw-bold font-monospace ${tx.pointsChange >= 0 ? 'text-success' : 'text-danger'}">
                                                            ${tx.pointsChange >= 0 ? '+' : ''}${tx.pointsChange} Điểm
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="4" class="text-center py-5 text-secondary">
                                                        <i class="fa-solid fa-coins text-gold fs-1 mb-2 d-block opacity-50"></i>
                                                        Chưa có giao dịch tích điểm nào được ghi nhận.
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
        </div>
    </div>
</body>
