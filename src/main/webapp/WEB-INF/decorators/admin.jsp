<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - UTECoffe Admin Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { font-family: 'Montserrat', sans-serif; background-color: #F4F6F9; }
        .sidebar { min-height: 100vh; background-color: #1A1715; color: #FFF; width: 250px; }
        .sidebar .nav-link { color: #A89F94; padding: 12px 20px; font-weight: 500; font-size: 0.9rem; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { color: #D4AF37; background: rgba(212, 175, 55, 0.1); }
        .admin-header { background: #FFF; border-bottom: 1px solid #E5E7EB; padding: 14px 24px; }
    </style>
    <sitemesh:write property='head'/>
</head>
<body>
<div class="d-flex">
    <!-- Admin Sidebar -->
    <aside class="sidebar p-3 d-flex flex-column">
        <div class="mb-4 text-center">
            <h4 class="text-white fw-bold mb-0">UTE<span class="text-warning">COFFE</span></h4>
            <span class="badge bg-warning text-dark mt-1">Management Portal</span>
        </div>
        <ul class="nav flex-column mb-auto">
            <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="fa-solid fa-chart-line me-2"></i> Tổng Quan</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/orders" class="nav-link"><i class="fa-solid fa-receipt me-2"></i> Đơn Hàng</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/products" class="nav-link"><i class="fa-solid fa-mug-hot me-2"></i> Thực Đơn & Món</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/inventory" class="nav-link"><i class="fa-solid fa-boxes-stacked me-2"></i> Kho & Nguyên Liệu</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/stores" class="nav-link"><i class="fa-solid fa-store me-2"></i> Chi Nhánh & Bàn</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/coupons" class="nav-link"><i class="fa-solid fa-tags me-2"></i> Khuyến Mãi</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/users" class="nav-link"><i class="fa-solid fa-users me-2"></i> Khách Hàng & Phân Quyền</a></li>
            <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/audit-logs" class="nav-link"><i class="fa-solid fa-shield-halved me-2"></i> Nhật Ký Hệ Thống</a></li>
        </ul>
        <div class="pt-3 border-top border-secondary">
            <a href="${pageContext.request.contextPath}/auth/logout" class="nav-link text-danger"><i class="fa-solid fa-right-from-bracket me-2"></i> Đăng Xuất</a>
        </div>
    </aside>

    <!-- Main Content Area -->
    <div class="flex-grow-1 d-flex flex-column">
        <header class="admin-header d-flex justify-content-between align-items-center shadow-sm">
            <h5 class="mb-0 text-dark fw-bold"><sitemesh:write property='title'/></h5>
            <div class="d-flex align-items-center gap-3">
                <span class="text-muted small"><i class="fa-solid fa-user-shield text-warning me-1"></i> Quản Trị Viên</span>
                <a href="${pageContext.request.contextPath}/" target="_blank" class="btn btn-sm btn-outline-secondary"><i class="fa-solid fa-external-link me-1"></i> Xem Cửa Hàng</a>
            </div>
        </header>
        <main class="p-4 flex-grow-1">
            <sitemesh:write property='body'/>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</body>
</html>
