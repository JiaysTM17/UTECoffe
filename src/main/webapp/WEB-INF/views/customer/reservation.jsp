<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Đặt Bàn Thưởng Thức - UTECoffe Roastery</title>
</head>
<body class="bg-obsidian">
    <div class="container py-5">
        <div class="section-title-wrap mb-4">
            <span class="section-subtitle">Dịch Vụ Tiếp Đón Chu Đáo</span>
            <h2 class="section-title">Đặt Bàn Thưởng Thức Không Gian</h2>
            <div class="gold-divider"></div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card-luxury p-4 p-md-5">
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success border-0 bg-success-subtle text-success py-3 px-4 rounded-3 mb-4">
                            <i class="fa-solid fa-circle-check me-2"></i> ${successMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/reservation/book" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        
                        <div class="row g-4 mb-4">
                            <div class="col-md-6">
                                <label class="form-label text-gold small fw-bold">Chi Nhánh Thưởng Thức:</label>
                                <select class="form-select form-control-luxury" name="storeId" required>
                                    <c:forEach var="store" items="${stores}">
                                        <option value="${store.id}">${store.name} - ${store.address}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-gold small fw-bold">Số Lượng Khách:</label>
                                <select class="form-select form-control-luxury" name="numberOfGuests" required>
                                    <option value="1">1 Người (Bàn Độc Thoại / Bar Counter)</option>
                                    <option value="2" selected>2 Người (Bàn Đôi Lãng Mạn)</option>
                                    <option value="4">3 - 4 Người (Bàn Nhóm Tiêu Chuẩn)</option>
                                    <option value="6">5 - 6 Người (Bàn Họp / Gia Đình)</option>
                                    <option value="10">Phòng VIP Riêng Tư (8 - 12 Người)</option>
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

                            <div class="col-md-6">
                                <label class="form-label text-gold small fw-bold">Ngày Đặt Bàn:</label>
                                <input type="date" class="form-control form-control-luxury" name="reservationDate" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-gold small fw-bold">Khung Giờ Hẹn:</label>
                                <input type="time" class="form-control form-control-luxury" name="reservationTime" required>
                            </div>

                            <div class="col-12">
                                <label class="form-label text-gold small fw-bold">Yêu Cầu Đặc Biệt (Khu vực, trang trí hoa, chuẩn bị cà phê specialty...):</label>
                                <textarea class="form-control form-control-luxury" name="specialRequest" rows="3" placeholder="Nhập yêu cầu để chúng tôi chuẩn bị tiếp đón chu đáo nhất..."></textarea>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-gold w-100 py-3 fw-bold fs-6">
                            <i class="fa-solid fa-calendar-check me-2"></i> Xác Nhận Giữ Chỗ Trực Tuyến
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
