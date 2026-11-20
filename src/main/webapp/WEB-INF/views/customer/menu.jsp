<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Thực Đơn - UTECoffe</title>
</head>
<body>
    <div class="container py-5">
        <div class="text-center mb-5">
            <h2 class="fw-bold text-dark">THỰC ĐƠN ĐẶC SẢN</h2>
            <p class="text-muted">Tuyển chọn các thức uống cà phê, trà nghệ nhân và bánh ngọt tươi mới mỗi ngày</p>
            <div style="width: 50px; height: 3px; background: #D4AF37; margin: 10px auto;"></div>
        </div>

        <!-- Category Filters -->
        <div class="d-flex justify-content-center flex-wrap gap-2 mb-5">
            <a href="${pageContext.request.contextPath}/menu" 
               class="btn ${empty selectedCategoryId ? 'btn-gold' : 'btn-outline-secondary'}">
                Tất Cả Món
            </a>
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/menu?categoryId=${cat.id}" 
                   class="btn ${selectedCategoryId == cat.id ? 'btn-gold' : 'btn-outline-secondary'}">
                    ${cat.name}
                </a>
            </c:forEach>
        </div>

        <!-- Products Grid -->
        <div class="row g-4">
            <c:forEach var="prod" items="${products}">
                <div class="col-lg-3 col-md-6">
                    <div class="card h-100 border-0 shadow-sm rounded-3 overflow-hidden">
                        <img src="${prod.imageUrl}" class="card-img-top" alt="${prod.name}" style="height: 200px; object-fit: cover;">
                        <div class="card-body d-flex flex-column">
                            <span class="badge bg-light text-secondary mb-2 align-self-start">${prod.category.name}</span>
                            <h5 class="card-title fw-bold">
                                <a href="${pageContext.request.contextPath}/menu/${prod.slug}" class="text-decoration-none text-dark">
                                    ${prod.name}
                                </a>
                            </h5>
                            <p class="card-text text-muted small flex-grow-1">${prod.description}</p>
                            <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
                                <span class="fw-bold text-danger fs-5">
                                    <fmt:formatNumber value="${prod.basePrice}" type="currency" currencySymbol="₫"/>
                                </span>
                                <a href="${pageContext.request.contextPath}/menu/${prod.slug}" class="btn btn-sm btn-gold">
                                    Chi Tiết
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
