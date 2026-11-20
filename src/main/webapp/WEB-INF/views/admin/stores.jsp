<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Quản Lý Chi Nhánh & Bàn - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0">Danh Sách Chi Nhánh Cửa Hàng UTECoffe</h4>
        <button class="btn btn-warning btn-sm fw-bold"><i class="fa-solid fa-store me-1"></i> Thêm Chi Nhánh Mới</button>
    </div>

    <div class="row g-4">
        <c:forEach var="store" items="${stores}">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm h-100 p-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <h5 class="fw-bold text-dark mb-0">${store.name}</h5>
                        <span class="badge ${store.isActive ? 'bg-success' : 'bg-secondary'}">
                            ${store.isActive ? 'Hoạt Động' : 'Tạm Đóng'}
                        </span>
                    </div>
                    <p class="small text-muted mb-2"><i class="fa-solid fa-location-dot me-2 text-warning"></i>${store.address}</p>
                    <p class="small text-muted mb-2"><i class="fa-solid fa-phone me-2 text-warning"></i>${store.phoneNumber}</p>
                    <p class="small text-muted mb-3"><i class="fa-regular fa-clock me-2 text-warning"></i>${store.openingTime} - ${store.closingTime}</p>
                    <div class="pt-3 border-top mt-auto d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/barista/kds?storeId=${store.id}" target="_blank" class="btn btn-sm btn-outline-warning w-100">
                            Mở KDS Quầy
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</body>
