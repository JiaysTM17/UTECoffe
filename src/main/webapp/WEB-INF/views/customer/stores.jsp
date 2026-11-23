<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Hệ Thống Cửa Hàng - UTECoffe Flagship Roasteries</title>
</head>
<body class="bg-obsidian">
    <div class="py-5 bg-espresso border-bottom border-gold text-center">
        <div class="container">
            <span class="section-subtitle">Không Gian Thưởng Thức Tinh Hoa</span>
            <h1 class="font-serif display-4 fw-bold text-gold-gradient mb-2">Hệ Thống 10 Cửa Hàng</h1>
            <p class="text-secondary mx-auto" style="max-width: 650px;">
                Mỗi chi nhánh UTECoffe mang một phong cách kiến trúc bản địa hòa quyện cùng mùi thơm rang mộc đặc trưng.
            </p>
        </div>
    </div>

    <div class="container py-5">
        <div class="row g-4">
            <c:forEach var="st" items="${stores}">
                <div class="col-lg-4 col-md-6">
                    <div class="card card-luxury h-100">
                        <div class="product-image-container" style="aspect-ratio: 16/10;">
                            <img src="https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=600&q=80" alt="${st.name}">
                            <span class="badge-luxury-tag"><i class="fa-solid fa-circle text-success me-1"></i> Đang Mở Cửa</span>
                        </div>
                        <div class="card-body p-4 d-flex flex-column">
                            <h5 class="font-serif fw-bold mb-2 text-gold-gradient">${st.name}</h5>
                            <p class="text-secondary small mb-2"><i class="fa-solid fa-location-dot text-gold me-2"></i> ${st.address}</p>
                            <p class="text-secondary small mb-2"><i class="fa-solid fa-clock text-gold me-2"></i> ${st.openingTime} - ${st.closingTime}</p>
                            <p class="text-secondary small mb-4"><i class="fa-solid fa-phone text-gold me-2"></i> ${st.phoneNumber}</p>
                            
                            <div class="mt-auto d-flex gap-2">
                                <a href="https://maps.google.com/?q=${st.latitude},${st.longitude}" target="_blank" class="btn btn-outline-gold btn-sm flex-grow-1">
                                    <i class="fa-solid fa-diamond-turn-right me-1"></i> Chỉ Đường
                                </a>
                                <a href="${pageContext.request.contextPath}/reservation?storeId=${st.id}" class="btn btn-gold btn-sm flex-grow-1">
                                    <i class="fa-solid fa-chair me-1"></i> Đặt Bàn
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
