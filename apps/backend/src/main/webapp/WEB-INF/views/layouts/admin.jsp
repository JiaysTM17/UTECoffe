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
    
    <!-- Instant Theme Detection Script -->
    <script>
        (function() {
            var savedTheme = localStorage.getItem('utecoffe_theme') || 'dark';
            document.documentElement.setAttribute('data-theme', savedTheme);
        })();
    </script>
    
    <style>
        .admin-sidebar {
            width: 270px;
            min-width: 270px;
            max-width: 270px;
            flex-shrink: 0;
            background-color: #0E0D0B;
            border-right: 1px solid var(--border-gold);
            height: 100vh;
            position: sticky;
            top: 0;
            z-index: 1030;
        }
        .admin-nav-link {
            position: relative;
            display: flex;
            align-items: center;
            gap: 0.85rem;
            padding: 0.85rem 1.4rem;
            color: #9e9a91;
            font-family: var(--font-accent);
            font-size: 0.82rem;
            font-weight: 600;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            text-decoration: none;
            border-left: 4px solid transparent;
            transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .admin-nav-link i {
            width: 18px;
            text-align: center;
            transition: transform 0.2s ease, filter 0.2s ease;
        }
        .admin-nav-link:hover {
            color: #DEB76A;
            background: rgba(222, 183, 106, 0.06);
            border-left-color: rgba(222, 183, 106, 0.5);
        }
        .admin-nav-link.active {
            color: #DEB76A !important;
            font-weight: 700 !important;
            background: linear-gradient(90deg, rgba(222, 183, 106, 0.16) 0%, rgba(222, 183, 106, 0.02) 100%) !important;
            border-left: 4px solid #DEB76A !important;
        }
        .admin-nav-link.active i {
            color: #DEB76A !important;
            filter: drop-shadow(0 0 6px rgba(222, 183, 106, 0.7));
            transform: scale(1.12);
        }
        .admin-nav-link.active::after {
            content: '';
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: #DEB76A;
            box-shadow: 0 0 8px #DEB76A;
        }
    </style>
    <sitemesh:write property='head'/>
</head>
<body class="bg-obsidian text-light">
    <div class="d-flex">
        <!-- Sidebar -->
        <aside class="admin-sidebar d-flex flex-column p-0">
            <div class="p-4 border-bottom border-secondary opacity-75 text-center">
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <img src="${pageContext.request.contextPath}/assets/images/logo_dark.svg" alt="UTECOFFE Admin" height="42">
                </a>
                <div class="badge bg-dark-roast border border-gold text-gold mt-2 py-1 px-2 small font-accent">EXECUTIVE SUITE</div>
            </div>

            <nav class="flex-grow-1 overflow-auto py-2" id="adminSidebarNav">
                <!-- Group 1: BÁO CÁO & ĐIỀU HÀNH -->
                <div class="px-3 pt-2 pb-1 text-gold-subtle text-uppercase font-accent fw-bold" style="font-size: 0.68rem; letter-spacing: 0.1em; opacity: 0.85;">
                    Báo Cáo &amp; Điều Hành
                </div>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-nav-link ${pageContext.request.requestURI.endsWith('/admin/dashboard') ? 'active' : ''}">
                    <i class="fa-solid fa-chart-line text-gold"></i> Tổng Quan
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/orders') ? 'active' : ''}">
                    <i class="fa-solid fa-receipt text-gold"></i> Quản Lý Đơn Hàng
                </a>
                <a href="${pageContext.request.contextPath}/admin/refunds" class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/refunds') ? 'active' : ''}">
                    <i class="fa-solid fa-hand-holding-dollar text-gold"></i> Khiếu Nại &amp; Hoàn Tiền
                </a>
                <a href="${pageContext.request.contextPath}/barista/kds" class="admin-nav-link text-warning">
                    <i class="fa-solid fa-display text-warning"></i> Điều Phối KDS Barista
                </a>

                <!-- Group 2: THỰC ĐƠN & KHÁCH HÀNG -->
                <div class="px-3 pt-3 pb-1 text-gold-subtle text-uppercase font-accent fw-bold border-top border-secondary border-opacity-25 mt-2" style="font-size: 0.68rem; letter-spacing: 0.1em; opacity: 0.85;">
                    Thực Đơn &amp; Khách Hàng
                </div>
                <a href="${pageContext.request.contextPath}/admin/products" class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/products') ? 'active' : ''}">
                    <i class="fa-solid fa-mug-saucer text-gold"></i> Danh Mục &amp; Món
                </a>
                <a href="${pageContext.request.contextPath}/admin/recipes" class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/recipes') ? 'active' : ''}">
                    <i class="fa-solid fa-flask text-gold"></i> Công Thức Chuẩn SOP
                </a>
                <a href="${pageContext.request.contextPath}/admin/coupons" class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/coupons') ? 'active' : ''}">
                    <i class="fa-solid fa-tags text-gold"></i> Khuyến Mãi &amp; Voucher
                </a>
                <a href="${pageContext.request.contextPath}/admin/reviews" class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/reviews') ? 'active' : ''}">
                    <i class="fa-solid fa-star text-gold"></i> Đánh Giá &amp; CSKH
                </a>

                <!-- Group 3: CƠ SỞ & CUNG ỨNG -->
                <div class="px-3 pt-3 pb-1 text-gold-subtle text-uppercase font-accent fw-bold border-top border-secondary border-opacity-25 mt-2" style="font-size: 0.68rem; letter-spacing: 0.1em; opacity: 0.85;">
                    Cơ Sở &amp; Cung Ứng
                </div>
                <a href="${pageContext.request.contextPath}/admin/stores" class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/stores') ? 'active' : ''}">
                    <i class="fa-solid fa-store text-gold"></i> 3 Chi Nhánh &amp; Đặt Bàn
                </a>
                <a href="${pageContext.request.contextPath}/admin/inventory" class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/inventory') ? 'active' : ''}">
                    <i class="fa-solid fa-warehouse text-gold"></i> Kho Nguyên Liệu BOM
                </a>
                <a href="${pageContext.request.contextPath}/admin/suppliers" class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/suppliers') ? 'active' : ''}">
                    <i class="fa-solid fa-truck-ramp-box text-gold"></i> Nhà Cung Cấp &amp; PO
                </a>

                <!-- Group 4: HỆ THỐNG & NHÂN SỰ -->
                <div class="px-3 pt-3 pb-1 text-gold-subtle text-uppercase font-accent fw-bold border-top border-secondary border-opacity-25 mt-2" style="font-size: 0.68rem; letter-spacing: 0.1em; opacity: 0.85;">
                    Hệ Thống &amp; Nhân Sự
                </div>
                <a href="${pageContext.request.contextPath}/admin/users" class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/users') ? 'active' : ''}">
                    <i class="fa-solid fa-users-gear text-gold"></i> Người Dùng &amp; Quyền
                </a>
                <a href="${pageContext.request.contextPath}/admin/audit-logs" class="admin-nav-link ${pageContext.request.requestURI.contains('/admin/audit-logs') ? 'active' : ''}">
                    <i class="fa-solid fa-shield-halved text-gold"></i> Nhật Ký Kiểm Toán AOP
                </a>
                <div class="border-top border-secondary opacity-25 my-2"></div>
                <a href="${pageContext.request.contextPath}/swagger-ui.html" target="_blank" class="admin-nav-link text-info">
                    <i class="fa-solid fa-code text-info"></i> OpenAPI Swagger UI
                </a>
                <a href="${pageContext.request.contextPath}/actuator/health" target="_blank" class="admin-nav-link text-success">
                    <i class="fa-solid fa-heart-pulse text-success"></i> Health Probes
                </a>
                <a href="${pageContext.request.contextPath}/barista/kds" target="_blank" class="admin-nav-link text-warning">
                    <i class="fa-solid fa-display text-warning"></i> Chuyển Sang KDS
                </a>
            </nav>

            <div class="p-3 border-top border-secondary opacity-75">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-gold btn-sm w-100 mb-2 font-accent">
                    <i class="fa-solid fa-store me-1"></i> Về Cửa Hàng
                </a>
                <form action="${pageContext.request.contextPath}/auth/logout" method="post" class="m-0">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-outline-danger btn-sm w-100 font-accent">
                        <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng Xuất
                    </button>
                </form>
            </div>
        </aside>

        <!-- Main Workspace -->
        <div class="flex-grow-1 d-flex flex-column min-vh-100" style="min-width: 0; max-width: 100%; overflow-x: hidden;">
            <!-- Top Sticky Header -->
            <header class="py-3 px-4 border-bottom border-gold d-flex justify-content-between align-items-center bg-espresso sticky-top" style="z-index: 1020;">
                <div>
                    <h5 class="mb-0 font-serif text-gold-gradient fw-bold"><sitemesh:write property='title'/></h5>
                    <small class="text-secondary">Hệ Thống Quản Trị Chuỗi Cà Phê Đặc Sản UTECoffe</small>
                </div>
                <div class="d-flex align-items-center gap-3 flex-shrink-0">
                    <span class="badge bg-dark-roast border border-gold text-gold py-2 px-3 text-nowrap font-accent">
                        <i class="fa-solid fa-circle-dot me-1 text-success"></i> Hệ Thống Trực Tuyến
                    </span>
                    <span class="text-secondary small text-nowrap">
                        <i class="fa-solid fa-user-shield text-gold me-1"></i> <sec:authentication property="name"/>
                    </span>
                </div>
            </header>

            <!-- Admin Page Content -->
            <main class="p-4 p-xl-5 flex-grow-1 bg-obsidian">
                <sitemesh:write property='body'/>
            </main>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Dynamic Active Navigation Link Highlighter & Scroll Position Retainer
        document.addEventListener('DOMContentLoaded', function() {
            const sidebarNav = document.getElementById('adminSidebarNav');
            const currentPath = window.location.pathname.replace(/\/$/, '');
            const links = document.querySelectorAll('#adminSidebarNav .admin-nav-link');
            let matched = false;
            let activeLink = null;
            
            links.forEach(link => {
                const href = link.getAttribute('href');
                if (href) {
                    const cleanHref = href.replace(/\/$/, '');
                    if (cleanHref === currentPath) {
                        link.classList.add('active');
                        matched = true;
                        activeLink = link;
                    } else if (cleanHref.includes('/admin/') && currentPath.startsWith(cleanHref) && cleanHref !== '${pageContext.request.contextPath}/admin') {
                        link.classList.add('active');
                        matched = true;
                        activeLink = link;
                    } else {
                        link.classList.remove('active');
                    }
                }
            });
            // Default to dashboard if root admin
            if (!matched && currentPath.endsWith('/admin')) {
                const dash = document.querySelector('a[href$="/admin/dashboard"]');
                if (dash) {
                    dash.classList.add('active');
                    activeLink = dash;
                }
            }

            // Restore Scroll Position so selecting lower items does NOT jump back to top
            if (sidebarNav) {
                const savedScroll = sessionStorage.getItem('admin_sidebar_scroll_top');
                if (savedScroll !== null) {
                    sidebarNav.scrollTop = parseInt(savedScroll, 10);
                } else if (activeLink) {
                    activeLink.scrollIntoView({ block: 'nearest', behavior: 'instant' });
                }

                // If active link is outside visible range, smoothly keep it in view
                if (activeLink) {
                    setTimeout(function() {
                        const rect = activeLink.getBoundingClientRect();
                        const navRect = sidebarNav.getBoundingClientRect();
                        if (rect.top < navRect.top || rect.bottom > navRect.bottom) {
                            activeLink.scrollIntoView({ block: 'nearest', behavior: 'instant' });
                        }
                    }, 50);
                }

                // Save scroll on click or navigation
                links.forEach(link => {
                    link.addEventListener('click', function() {
                        sessionStorage.setItem('admin_sidebar_scroll_top', sidebarNav.scrollTop);
                    });
                });
                sidebarNav.addEventListener('scroll', function() {
                    sessionStorage.setItem('admin_sidebar_scroll_top', sidebarNav.scrollTop);
                }, { passive: true });
            }
        });
    </script>
</body>
</html>