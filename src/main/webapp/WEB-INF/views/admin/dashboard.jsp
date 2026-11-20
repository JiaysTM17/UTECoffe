<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Tổng Quan Hệ Thống - UTECoffe</title>
</head>
<body>
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm p-3 border-start border-primary border-4">
                <span class="text-muted small">Tổng Đơn Hàng</span>
                <h3 class="fw-bold mb-0">${totalOrders}</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm p-3 border-start border-success border-4">
                <span class="text-muted small">Thực Đơn Sản Phẩm</span>
                <h3 class="fw-bold mb-0">${totalProducts}</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm p-3 border-start border-warning border-4">
                <span class="text-muted small">Chi Nhánh Hoạt Động</span>
                <h3 class="fw-bold mb-0">${totalStores}</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm p-3 border-start border-danger border-4">
                <span class="text-muted small">Khách Hàng Thành Viên</span>
                <h3 class="fw-bold mb-0">${totalUsers}</h3>
            </div>
        </div>
    </div>
    <div class="card border-0 shadow-sm p-4">
        <h5 class="fw-bold mb-3">Lối Tắt Quản Trị Nhanh</h5>
        <div class="d-flex gap-3">
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-primary">Quản Lý Đơn Hàng</a>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-success">Quản Lý Món & BOM</a>
            <a href="${pageContext.request.contextPath}/barista/kds" target="_blank" class="btn btn-outline-warning">Mở Màn Hình KDS</a>
        </div>
    </div>
</body>
