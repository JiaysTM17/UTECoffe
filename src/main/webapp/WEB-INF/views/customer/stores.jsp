<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Hệ Thống Chi Nhánh - UTECoffe</title>
</head>
<body>
    <div class="container py-5">
        <div class="text-center mb-5">
            <span class="badge bg-warning text-dark px-3 py-1 text-uppercase fw-bold mb-2">Không Gian Trải Nghiệm</span>
            <h2 class="fw-bold text-dark">HỆ THỐNG CHI NHÁNH UTECOFFE</h2>
            <p class="text-muted">Các không gian thưởng thức trà và cà phê đặc sản cao cấp tại TP. Hồ Chí Minh</p>
            <div style="width: 50px; height: 3px; background: #D4AF37; margin: 10px auto;"></div>
        </div>

        <div class="row g-4">
            <c:forEach var="st" items="${stores}">
                <div class="col-lg-4 col-md-6">
                    <div class="card border-0 shadow-sm rounded-4 h-100 overflow-hidden d-flex flex-column">
                        <img src="https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=600" class="card-img-top" alt="${st.name}" style="height: 200px; object-fit: cover;">
                        <div class="card-body p-4 d-flex flex-column flex-grow-1">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="fw-bold text-dark mb-0">${st.name}</h5>
                                <span class="badge bg-success">Mở Cửa</span>
                            </div>
                            <p class="small text-muted mb-2"><i class="fa-solid fa-location-dot me-2 text-warning"></i>${st.address}</p>
                            <p class="small text-muted mb-2"><i class="fa-solid fa-phone me-2 text-warning"></i>Hotline: ${st.phoneNumber}</p>
                            <p class="small text-muted mb-4"><i class="fa-regular fa-clock me-2 text-warning"></i>Giờ mở cửa: ${st.openingTime} - ${st.closingTime}</p>
                            
                            <div class="mt-auto pt-3 border-top d-flex gap-2">
                                <a href="https://maps.google.com/?q=${st.latitude},${st.longitude}" target="_blank" class="btn btn-outline-secondary btn-sm flex-grow-1">
                                    <i class="fa-solid fa-diamond-turn-right me-1"></i> Chỉ Đường
                                </a>
                                <a href="${pageContext.request.contextPath}/reservation?storeId=${st.id}" class="btn btn-gold btn-sm flex-grow-1 fw-bold">
                                    <i class="fa-regular fa-calendar-check me-1"></i> Đặt Bàn
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
