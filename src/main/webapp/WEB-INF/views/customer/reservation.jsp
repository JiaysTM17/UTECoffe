<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Đặt Bàn Thưởng Trà & Cà Phê - UTECoffe</title>
</head>
<body>
    <div class="container py-5">
        <div class="card border-0 shadow-sm max-w-700 mx-auto p-4 p-md-5" style="max-width: 650px;">
            <div class="text-center mb-4">
                <span class="badge bg-warning text-dark px-3 py-1 text-uppercase fw-bold mb-2">Trải Nghiệm Không Gian</span>
                <h3 class="fw-bold text-dark">ĐẶT BÀN TRƯỚC TẠI CHI NHÁNH</h3>
                <p class="text-muted small">Thưởng thức nghệ thuật pha chế thủ công trong không gian sang trọng và ấm cúng</p>
                <div style="width: 50px; height: 3px; background: #D4AF37; margin: 10px auto;"></div>
            </div>

            <c:if test="${param.success == 'true'}">
                <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
                    <i class="fa-solid fa-circle-check fs-4 text-success me-3"></i>
                    <div>
                        <h6 class="mb-0 fw-bold">Yêu Cầu Đặt Bàn Đã Được Ghi Nhận Thành Công!</h6>
                        <small>Nhân viên chi nhánh UTECoffe sẽ liên hệ số điện thoại của bạn trong vòng 10 phút để xác nhận vị trí bàn tốt nhất.</small>
                    </div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/reservation" method="post">
                <div class="mb-3">
                    <label class="form-label small fw-bold">Chi Nhánh Cửa Hàng:</label>
                    <select class="form-select" name="storeId" required>
                        <c:forEach var="st" items="${stores}">
                            <option value="${st.id}">${st.name} - ${st.address}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Ngày Đến:</label>
                        <input type="date" name="reservationDate" class="form-control" id="resDateInput" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Giờ Đến:</label>
                        <input type="time" name="reservationTime" class="form-control" value="09:00" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-bold">Số Lượng Khách:</label>
                    <select class="form-select" name="guestCount" required>
                        <option value="1">1 người</option>
                        <option value="2" selected>2 người (Hẹn hò / Đôi bạn)</option>
                        <option value="4">3 - 4 người (Nhóm nhỏ)</option>
                        <option value="6">5 - 6 người (Họp nhóm / Gia đình)</option>
                        <option value="10">Phòng VIP (> 8 người)</option>
                    </select>
                </div>

                <div class="mb-4">
                    <label class="form-label small fw-bold">Yêu Cầu Đặc Biệt / Ghi Chú:</label>
                    <textarea class="form-control" name="note" rows="3" placeholder="Gần cửa sổ, khu vực yên tĩnh làm việc, chuẩn bị trước ghế trẻ em, v.v."></textarea>
                </div>

                <button type="submit" class="btn btn-gold w-100 py-3 fw-bold">
                    <i class="fa-regular fa-calendar-check me-2"></i> Xác Nhận Đặt Bàn
                </button>
            </form>
        </div>
    </div>
    <script>
        // Set minimum reservation date to today
        document.getElementById('resDateInput').min = new Date().toISOString().split('T')[0];
        document.getElementById('resDateInput').value = new Date().toISOString().split('T')[0];
    </script>
</body>
