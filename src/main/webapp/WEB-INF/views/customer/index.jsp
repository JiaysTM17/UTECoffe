<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Trang Chủ - UTECoffe Specialty Tea & Coffee Roastery</title>
    <style>
        .hero-banner {
            background: linear-gradient(rgba(18, 16, 14, 0.85), rgba(18, 16, 14, 0.9)), url('https://images.unsplash.com/photo-1447933601403-0c6688de566e?q=80&w=1600') center/cover;
            color: #FFFFFF;
            padding: 120px 0 100px;
        }
        .product-card {
            background: #FFFFFF;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 1px solid #EDE6D6;
        }
        .product-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
        }
        .product-img {
            height: 220px;
            object-fit: cover;
            width: 100%;
        }
    </style>
</head>
<body>
    <!-- Hero Section -->
    <section class="hero-banner text-center">
        <div class="container">
            <span class="badge bg-warning text-dark px-3 py-2 text-uppercase fw-bold letter-spacing-2 mb-3">
                Thế Hệ Thứ 3 Của Cà Phê & Trà Đặc Sản
            </span>
            <h1 class="display-4 fw-bold mb-3" style="letter-spacing: 2px;">
                TINH HOA TRÀ &amp; CÀ PHÊ VIỆT
            </h1>
            <p class="lead text-light opacity-75 max-w-700 mx-auto mb-4" style="font-size: 1.15rem;">
                Hạt Arabica Cầu Đất rang mộc thủ công, lá trà Ô Long Mộc Châu tuyển chọn kết hợp mô hình đặt món đa kênh OMO và quầy pha chế thời gian thực.
            </p>
            <div class="d-flex justify-content-center gap-3">
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold btn-lg px-4">
                    <i class="fa-solid fa-mug-hot me-2"></i> Khám Phá Thực Đơn
                </a>
                <a href="${pageContext.request.contextPath}/reservation" class="btn btn-outline-light btn-lg px-4">
                    <i class="fa-regular fa-calendar-check me-2"></i> Đặt Bàn Ngay
                </a>
            </div>
        </div>
    </section>

    <!-- Featured Products -->
    <section class="py-5">
        <div class="container py-4">
            <div class="text-center mb-5">
                <h6 class="text-warning text-uppercase fw-bold letter-spacing-2 mb-2">Thực Đơn Nổi Bật</h6>
                <h2 class="fw-bold text-dark">HƯƠNG VỊ ĐẶC SẮC NHẤT</h2>
                <div style="width: 60px; height: 3px; background: #D4AF37; margin: 12px auto;"></div>
            </div>

            <div class="row g-4">
                <c:forEach var="prod" items="${featuredProducts}">
                    <div class="col-lg-3 col-md-6">
                        <div class="product-card h-100 d-flex flex-column">
                            <img src="${prod.imageUrl}" alt="${prod.name}" class="product-img">
                            <div class="p-3 d-flex flex-column flex-grow-1">
                                <span class="badge bg-light text-secondary mb-2 align-self-start" style="font-size: 0.75rem;">
                                    ${prod.category.name}
                                </span>
                                <h5 class="fw-bold text-dark mb-2" style="font-size: 1.05rem;">
                                    <a href="${pageContext.request.contextPath}/menu/${prod.slug}" class="text-decoration-none text-dark">
                                        ${prod.name}
                                    </a>
                                </h5>
                                <p class="small text-muted mb-3 flex-grow-1 line-clamp-2">
                                    ${prod.description}
                                </p>
                                <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                    <span class="fw-bold text-danger fs-5">
                                        <fmt:formatNumber value="${prod.basePrice}" type="currency" currencySymbol="₫"/>
                                    </span>
                                    <a href="${pageContext.request.contextPath}/menu/${prod.slug}" class="btn btn-sm btn-gold">
                                        <i class="fa-solid fa-plus"></i> Đặt Món
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- OMO Value Proposition -->
    <section class="py-5 bg-white border-top border-bottom">
        <div class="container py-3">
            <div class="row g-4 text-center">
                <div class="col-md-4">
                    <div class="p-4">
                        <i class="fa-solid fa-truck-fast text-warning fs-1 mb-3"></i>
                        <h5 class="fw-bold">Giao Hàng Siêu Tốc 30 Phút</h5>
                        <p class="text-muted small">Thuật toán Haversine tự động điều phối đơn hàng đến chi nhánh gần nhất để giữ trọn vẹn hương vị thức uống.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4">
                        <i class="fa-solid fa-bell-concierge text-warning fs-1 mb-3"></i>
                        <h5 class="fw-bold">Pha Chế Thời Gian Thực KDS</h5>
                        <p class="text-muted small">Hệ thống màn hình quầy Barista hiển thị công thức chuẩn hóa, giảm thiểu tối đa thời gian chờ đợi của bạn.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4">
                        <i class="fa-solid fa-crown text-warning fs-1 mb-3"></i>
                        <h5 class="fw-bold">Đặc Quyền Thành Viên UTEClub</h5>
                        <p class="text-muted small">Tích lũy hạt vàng trên mỗi hóa đơn, thăng hạng thành viên và đổi lấy các món nước miễn phí cùng ưu đãi sinh nhật.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
</body>
