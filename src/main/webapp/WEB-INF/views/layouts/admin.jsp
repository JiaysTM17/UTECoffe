<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - UTECoffe Admin Executive Suite</title>
    
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Playfair+Display:wght@600;700&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxury.css">
    
    <style>
        .admin-sidebar {
            width: 270px;
            background-color: #0E0D0B;
            border-right: 1px solid var(--border-gold);
            min-height: 100vh;
        }
        .admin-nav-link {
            display: flex;
            align-items: center;
            gap: 0.85rem;
            padding: 0.85rem 1.4rem;
            color: var(--text-secondary);
            font-family: var(--font-accent);
            font-size: 0.82rem;
            font-weight: 600;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            text-decoration: none;
            border-left: 3px solid transparent;
            transition: var(--transition-fast);
        }
        .admin-nav-link:hover, .admin-nav-link.active {
            color: var(--gold-200);
            background: rgba(222, 183, 106, 0.08);
            border-left-color: var(--gold-300);
        }
    </style>
    <sitemesh:write property='head'/>
</head>
<body class="bg-obsidian text-light">
    <div class="d-flex">
        <!-- Sidebar -->
        <aside class="admin-sidebar d-flex flex-column p-0 sticky-top" style="height: 100vh;">
            <div class="p-4 border-bottom border-secondary opacity-75 text-center">
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <img src="${pageContext.request.contextPath}/assets/images/logo_dark.svg" alt="UTECOFFE Admin" height="42">
                </a>
                <div class="badge bg-dark-roast border border-gold text-gold mt-2 py-1 px-2 small">EXECUTIVE PORTAL</div>
            </div>

            <nav class="flex-grow-1 overflow-auto py-3">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-nav-link"><i class="fa-solid fa-chart-line text-gold"></i> Tổng Quan</a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="admin-nav-link"><i class="fa-solid fa-receipt text-gold"></i> Quản Lý Đơn Hàng</a>
                <a href="${pageContext.request.contextPath}/admin/inventory" class="admin-nav-link"><i class="fa-solid fa-warehouse text-gold"></i> Kho Nguyên Liệu BOM</a>
                <a href="${pageContext.request.contextPath}/admin/products" class="admin-nav-link"><i class="fa-solid fa-mug-saucer text-gold"></i> Danh Mục &amp; Món</a>
                <a href="${pageContext.request.contextPath}/admin/stores" class="admin-nav-link"><i class="fa-solid fa-store text-gold"></i> Chuỗi Cửa Hàng</a>
                <a href="${pageContext.request.contextPath}/admin/coupons" class="admin-nav-link"><i class="fa-solid fa-tags text-gold"></i> Mã Khuyến Mãi</a>
                <a href="${pageContext.request.contextPath}/admin/users" class="admin-nav-link"><i class="fa-solid fa-users-gear text-gold"></i> Người Dùng &amp; Quyền</a>
                <a href="${pageContext.request.contextPath}/admin/audit-logs" class="admin-nav-link"><i class="fa-solid fa-shield-halved text-gold"></i> Nhật Ký Kiểm Toán AOP</a>
                <div class="border-top border-secondary opacity-25 my-2"></div>
                <a href="${pageContext.request.contextPath}/swagger-ui.html" target="_blank" class="admin-nav-link text-info"><i class="fa-solid fa-code text-info"></i> OpenAPI Swagger UI</a>
                <a href="${pageContext.request.contextPath}/actuator/health" target="_blank" class="admin-nav-link text-success"><i class="fa-solid fa-heart-pulse text-success"></i> Health Probes</a>
                <a href="${pageContext.request.contextPath}/barista/kds" class="admin-nav-link text-warning"><i class="fa-solid fa-display text-warning"></i> Chuyển Sang KDS</a>
            </nav>

            <div class="p-3 border-top border-secondary opacity-75">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-gold btn-sm w-100 mb-2"><i class="fa-solid fa-store me-1"></i> Về Cửa Hàng</a>
                <form action="${pageContext.request.contextPath}/auth/logout" method="post" class="m-0">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-outline-danger btn-sm w-100"><i class="fa-solid fa-right-from-bracket me-1"></i> Đăng Xuất</button>
                </form>
            </div>
        </aside>

        <!-- Main Workspace -->
        <div class="flex-grow-1 d-flex flex-column min-vh-100">
            <!-- Top Header -->
            <header class="py-3 px-4 border-bottom border-gold d-flex justify-content-between align-items-center bg-espresso">
                <div>
                    <h5 class="mb-0 font-serif text-gold-gradient fw-bold"><sitemesh:write property='title'/></h5>
                    <small class="text-muted">Hệ Thống Quản Trị Chuỗi Cà Phê Đặc Sản UTECoffe</small>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="badge bg-dark-roast border border-gold text-gold py-2 px-3"><i class="fa-solid fa-signal me-1 text-success"></i> Hệ Thống Trực Tuyến</span>
                    <span class="text-secondary small"><i class="fa-solid fa-user-shield text-gold me-1"></i> <sec:authentication property="name"/></span>
                </div>
            </header>

            <!-- Admin Page Content -->
            <main class="p-4 flex-grow-1 bg-obsidian">
                <sitemesh:write property='body'/>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
