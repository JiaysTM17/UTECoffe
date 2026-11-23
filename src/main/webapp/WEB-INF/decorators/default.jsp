<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - UTECoffe Specialty Tea & Coffee</title>
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/static/images/logo_icon.png">

    <style>
        :root {
            --color-obsidian: #12100E;
            --color-espresso: #221D1A;
            --color-gold-primary: #D4AF37;
            --color-gold-light: #EED59B;
            --color-cream: #F8F5EE;
            --color-sand: #EDE6D6;
            --color-text-dark: #1F1D1B;
            --color-text-muted: #7A7268;
        }
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: var(--color-cream);
            color: var(--color-text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .navbar-utecoffe {
            background-color: var(--color-obsidian);
            border-bottom: 2px solid var(--color-gold-primary);
            padding: 12px 0;
        }
        .navbar-brand-text {
            color: #FFFFFF !important;
            font-weight: 700;
            letter-spacing: 3px;
            font-size: 1.35rem;
        }
        .navbar-brand-text span {
            color: var(--color-gold-primary);
        }
        .nav-link-custom {
            color: #D6CEC5 !important;
            font-weight: 500;
            font-size: 0.92rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 8px 16px !important;
            transition: all 0.3s ease;
        }
        .nav-link-custom:hover, .nav-link-custom.active {
            color: var(--color-gold-primary) !important;
        }
        .btn-gold {
            background: linear-gradient(135deg, #DEB76A, #B88E44);
            color: #12100E;
            font-weight: 600;
            border: none;
            padding: 8px 22px;
            border-radius: 4px;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }
        .btn-gold:hover {
            background: linear-gradient(135deg, #EED59B, #DEB76A);
            color: #000000;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
        }
        .footer-utecoffe {
            background-color: var(--color-obsidian);
            color: #A89F94;
            border-top: 1px solid #2B2520;
            margin-top: auto;
            padding: 45px 0 20px;
        }
        .footer-utecoffe h5 {
            color: var(--color-gold-primary);
            font-size: 1rem;
            font-weight: 700;
            letter-spacing: 2px;
            margin-bottom: 20px;
        }
        .footer-utecoffe a {
            color: #A89F94;
            text-decoration: none;
            transition: color 0.2s;
        }
        .footer-utecoffe a:hover {
            color: var(--color-gold-primary);
        }
    </style>
    <sitemesh:write property='head'/>
</head>
<body>

    <!-- Header Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-utecoffe sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand navbar-brand-text d-flex align-items-center" href="${pageContext.request.contextPath}/">
                <i class="fa-solid fa-mug-hot text-warning me-2"></i>
                UTE<span>COFFE</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/">Trang Chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/menu">Thực Đơn</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/stores">Chi Nhánh</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/reservation">Đặt Bàn</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/story">Câu Chuyện</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center gap-3">
                    <a href="${pageContext.request.contextPath}/cart" class="position-relative text-light fs-5 me-2">
                        <i class="fa-solid fa-bag-shopping"></i>
                        <span id="cartCountBadge" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.65rem;">
                            0
                        </span>
                    </a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <div class="dropdown">
                                <button class="btn btn-sm btn-outline-warning dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    <i class="fa-regular fa-user me-1"></i> ${sessionScope.currentUser.fullName}
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Tài Khoản</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders/history">Lịch Sử Đơn Hàng</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth/logout">Đăng Xuất</a></li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-gold btn-sm">Đăng Nhập</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Dynamic Body Content -->
    <main class="flex-grow-1">
        <sitemesh:write property='body'/>
    </main>

    <!-- Footer -->
    <footer class="footer-utecoffe">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <h5 class="text-uppercase"><i class="fa-solid fa-leaf me-2"></i>UTECOFFE</h5>
                    <p class="small text-muted mb-3">
                        Hệ thống chuỗi bán lẻ Trà & Cà Phê đặc sản cao cấp kết hợp mô hình OMO hiện đại. Nghệ thuật rang xay thủ công và tinh hoa trà Việt.
                    </p>
                    <p class="small mb-1"><i class="fa-solid fa-location-dot me-2 text-warning"></i>1 Võ Văn Ngân, TP. Thủ Đức, TP. Hồ Chí Minh</p>
                    <p class="small mb-1"><i class="fa-solid fa-phone me-2 text-warning"></i>Hotline: 1900 2026</p>
                    <p class="small"><i class="fa-solid fa-envelope me-2 text-warning"></i>contact@utecoffe.vn</p>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h5 class="text-uppercase">Khám Phá</h5>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/menu?cat=coffee">Cà Phê Đặc Sản</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/menu?cat=tea">Trà Thượng Hạng</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/menu?cat=pastry">Bánh Thủ Công</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/menu?cat=beans">Hạt Rang Mộc</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h5 class="text-uppercase">Chính Sách</h5>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/policy/delivery">Chính Sách Giao Hàng OMO</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/policy/loyalty">Chương Trình Thành Viên UTEClub</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/policy/terms">Điều Khoản Sử Dụng</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/policy/privacy">Bảo Mật Thông Tin</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h5 class="text-uppercase">Kết Nối Với Chúng Tôi</h5>
                    <div class="d-flex gap-2 mb-3">
                        <a href="#" class="btn btn-outline-secondary btn-sm"><i class="fa-brands fa-facebook-f"></i></a>
                        <a href="#" class="btn btn-outline-secondary btn-sm"><i class="fa-brands fa-instagram"></i></a>
                        <a href="#" class="btn btn-outline-secondary btn-sm"><i class="fa-brands fa-tiktok"></i></a>
                    </div>
                    <p class="small text-muted">Đăng ký nhận ưu đãi đặc biệt từ UTECoffe:</p>
                    <div class="input-group input-group-sm">
                        <input type="email" class="form-control" placeholder="Email của bạn...">
                        <button class="btn btn-gold" type="button">Gửi</button>
                    </div>
                </div>
            </div>
            <hr class="border-secondary my-4">
            <div class="text-center small text-muted">
                &copy; 2026 UTECoffe Specialty Tea & Coffee Roastery. All rights reserved.
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery 3.7.1 -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</body>
</html>
