<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Thực Đơn Cà Phê &amp; Trà Đặc Sản - UTECoffe</title>
</head>
<body class="bg-obsidian">
    <!-- Header Banner -->
    <div class="py-5 bg-espresso border-bottom border-gold text-center">
        <div class="container">
            <span class="section-subtitle">Bộ Sưu Tập Hương Vị 2026</span>
            <h1 class="font-serif display-4 fw-bold text-gold-gradient mb-2">Thực Đơn Đặc Sản</h1>
            <p class="text-secondary mx-auto" style="max-width: 650px;">
                Tất cả thức uống được chế biến từ hạt cà phê đặc sản tuyển chọn và búp trà hoa tự nhiên, pha chế tươi mới theo yêu cầu riêng của bạn.
            </p>
        </div>
    </div>

    <!-- Menu Content -->
    <div class="container py-5">
        <!-- Category Filter Tabs -->
        <div class="d-flex justify-content-center flex-wrap gap-2 mb-5">
            <a href="${pageContext.request.contextPath}/menu" class="btn ${empty selectedCategoryId ? 'btn-gold' : 'btn-outline-gold'} btn-sm px-4 py-2">
                Tất Cả Món
            </a>
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/menu?categoryId=${cat.id}" 
                   class="btn ${selectedCategoryId == cat.id ? 'btn-gold' : 'btn-outline-gold'} btn-sm px-4 py-2">
                    ${cat.name}
                </a>
            </c:forEach>
        </div>

        <!-- Product Cards Grid -->
        <div class="row g-4">
            <c:forEach var="prod" items="${products}">
                <div class="col-lg-3 col-md-6">
                    <div class="card card-luxury h-100 d-flex flex-column">
                        <div class="product-image-container">
                            <img src="${not empty prod.imageUrl ? prod.imageUrl : 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=500&q=80'}" 
                                 alt="${prod.name}">
                            <span class="badge-luxury-tag">${prod.category.name}</span>
                        </div>
                        <div class="card-body p-4 d-flex flex-column flex-grow-1">
                            <h5 class="font-serif fw-bold mb-2">
                                <a href="${pageContext.request.contextPath}/menu/detail/${prod.id}" class="text-light text-decoration-none hover-gold">${prod.name}</a>
                            </h5>
                            <p class="text-secondary small flex-grow-1 mb-3 text-truncate-2">
                                ${not empty prod.description ? prod.description : 'Hương vị cao cấp chế biến thủ công từ nguyên liệu hảo hạng.'}
                            </p>
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top border-secondary opacity-75">
                                <span class="price-gold"><fmt:formatNumber value="${prod.basePrice}" type="currency" currencySymbol="₫"/></span>
                                <a href="${pageContext.request.contextPath}/menu/detail/${prod.id}" class="btn btn-gold btn-sm px-3">
                                    <i class="fa-solid fa-mug-hot me-1"></i> Tùy Chỉnh
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
