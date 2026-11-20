<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Quản Lý Thực Đơn & Món - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0">Thực Đơn Trà &amp; Cà Phê Đặc Sản</h4>
        <button class="btn btn-warning btn-sm fw-bold"><i class="fa-solid fa-plus me-1"></i> Thêm Món Mới</button>
    </div>

    <div class="card border-0 shadow-sm p-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Ảnh</th>
                        <th>Tên Món</th>
                        <th>Danh Mục</th>
                        <th>Đơn Giá</th>
                        <th>Món Nổi Bật</th>
                        <th>Đang Bán</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td><img src="${p.imageUrl}" alt="${p.name}" style="width: 50px; height: 50px; object-fit: cover;" class="rounded"></td>
                            <td class="fw-bold">${p.name}</td>
                            <td>${p.category.name}</td>
                            <td class="text-danger fw-bold"><fmt:formatNumber value="${p.basePrice}" type="currency" currencySymbol="₫"/></td>
                            <td><span class="badge ${p.isFeatured ? 'bg-warning text-dark' : 'bg-light text-muted'}">${p.isFeatured ? 'Nổi Bật' : 'Thường'}</span></td>
                            <td><span class="badge ${p.isAvailable ? 'bg-success' : 'bg-danger'}">${p.isAvailable ? 'Sẵn Sàng' : 'Tạm Hết'}</span></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
