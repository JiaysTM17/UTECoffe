<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - UTECoffe Specialty Tea &amp; Coffee Roastery</title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,400&family=Montserrat:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,400&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5.3.3 & FontAwesome 6.5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <!-- UTECoffe Luxury Design System -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxury.css">
    
    <!-- Instant Theme Detection Script (Prevents Flickering) -->
    <script>
        (function() {
            window.UTECOFFE_CONTEXT_PATH = '${pageContext.request.contextPath}';
            var savedTheme = localStorage.getItem('utecoffe_theme') || 'dark';
            document.documentElement.setAttribute('data-theme', savedTheme);
        })();
    </script>
    
    <sitemesh:write property='head'/>
</head>
<body class="bg-obsidian d-flex flex-column min-vh-100">

    <!-- Top Luxury Announcement Banner (High Contrast) -->
    <div class="top-announcement-bar">
        <div class="container-fluid px-3 px-xl-5 d-flex justify-content-between align-items-center flex-nowrap" style="max-width: 1720px; margin: 0 auto;">
            <div class="d-none d-lg-flex align-items-center gap-2 top-bar-info flex-shrink-0 text-nowrap">
                <i class="fa-solid fa-location-dot text-gold"></i>
                <span data-i18n="topbar.location">Flagship: 01 Võ Văn Ngân, TP. Thủ Đức, TP.HCM</span>
            </div>
            <div class="mx-auto text-center top-bar-promo text-nowrap px-2">
                <i class="fa-solid fa-gem text-gold me-1"></i>
                <span class="top-bar-promo-text" data-i18n="topbar.promo">ƯU ĐÃI 20% ĐƠN ĐẦU TIÊN • FREESHIP TOÀN QUỐC TỪ 150.000₫</span>
            </div>
            <div class="d-none d-md-flex align-items-center gap-3 top-bar-right flex-shrink-0 text-nowrap">
                <span class="text-secondary"><i class="fa-regular fa-clock text-gold me-1"></i><span data-i18n="topbar.hours">07:00 - 22:30</span></span>
                <span class="opacity-50">|</span>
                <a href="tel:19002026" class="top-bar-hotline"><i class="fa-solid fa-phone text-gold me-1"></i>1900 2026</a>
            </div>
        </div>
    </div>

    <!-- Glassmorphism Sticky Navbar -->
    <nav class="navbar navbar-expand-xl navbar-luxury sticky-top">
        <div class="container-fluid px-3 px-xl-5 d-flex align-items-center justify-content-between flex-nowrap" style="max-width: 1720px; margin: 0 auto;">
            <!-- Brand Logo (Official Vector SVG Transparent) -->
            <a class="navbar-brand py-0 me-3 me-xxl-4 flex-shrink-0" href="${pageContext.request.contextPath}/">
                <img id="navbarLogo" src="${pageContext.request.contextPath}/assets/images/logo_dark.svg" alt="UTECOFFE Specialty Roastery" height="48" class="brand-logo-img d-inline-block align-text-top">
            </a>

            <!-- Mobile Toggle -->
            <button class="navbar-toggler border-gold text-gold p-2" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-label="Toggle navigation">
                <i class="fa-solid fa-bars-staggered fa-lg"></i>
            </button>

            <!-- Nav Items -->
            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav me-auto mb-2 mb-xl-0 flex-row flex-nowrap align-items-center gap-1 gap-xxl-2">
                    <li class="nav-item">
                        <a class="nav-link nav-link-luxury text-nowrap" data-i18n="nav.home" href="${pageContext.request.contextPath}/">Trang Chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-luxury text-nowrap" data-i18n="nav.menu" href="${pageContext.request.contextPath}/menu">Thực Đơn</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-luxury text-nowrap" data-i18n="nav.story" href="${pageContext.request.contextPath}/story">Câu Chuyện</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-luxury text-nowrap" data-i18n="nav.reservation" href="${pageContext.request.contextPath}/reservation">Đặt Bàn</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-luxury text-nowrap" data-i18n="nav.stores" href="${pageContext.request.contextPath}/stores">Chi Nhánh</a>
                    </li>
                </ul>

                <!-- Right Actions: Language + Theme Switcher + Cart + User -->
                <div class="d-flex align-items-center gap-2 gap-xl-3 flex-nowrap ms-auto header-actions-group">
                    <!-- Bilingual Language Toggle -->
                    <div class="lang-switcher flex-shrink-0" role="group" aria-label="Bilingual selector">
                        <button type="button" class="btn-lang-toggle active" data-lang="vi" title="Tiếng Việt">VN</button>
                        <button type="button" class="btn-lang-toggle" data-lang="en" title="English">EN</button>
                    </div>

                    <!-- Theme Switcher (Dark / Light) -->
                    <button id="themeToggleBtn" class="btn btn-theme-toggle flex-shrink-0" type="button" title="Chuyển đổi giao diện Sáng / Tối" aria-label="Toggle theme">
                        <i class="fa-solid fa-sun icon-sun text-gold"></i>
                        <i class="fa-solid fa-moon icon-moon text-gold"></i>
                    </button>

                    <!-- Cart Button -->
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-gold btn-sm px-3 flex-shrink-0 text-nowrap position-relative">
                        <i class="fa-solid fa-bag-shopping me-1"></i> <span data-i18n="nav.cart">Giỏ Hàng</span>
                    </a>

                    <!-- User Account Dropdown -->
                    <sec:authorize access="isAuthenticated()">
                        <div class="dropdown">
                            <button class="btn btn-dark-roast btn-sm border-gold text-gold dropdown-toggle d-flex align-items-center gap-2" type="button" data-bs-toggle="dropdown">
                                <c:choose>
                                    <c:when test="${currentUser != null && currentUser.role.name == 'ROLE_ADMIN'}">
                                        <span class="badge bg-danger text-white px-2 py-0.5 rounded-pill small fw-bold font-accent">ADMIN</span>
                                    </c:when>
                                    <c:when test="${currentUser != null && currentUser.role.name == 'ROLE_BARISTA'}">
                                        <span class="badge bg-warning text-dark px-2 py-0.5 rounded-pill small fw-bold font-accent">BARISTA</span>
                                    </c:when>
                                    <c:when test="${currentLoyaltyCard != null && currentLoyaltyCard.tier == 'DIAMOND'}">
                                        <span class="badge px-2 py-0.5 rounded-pill small fw-bold font-accent text-dark" style="background: #b9f2ff;"><i class="fa-solid fa-crown me-1"></i>KIM CƯƠNG</span>
                                    </c:when>
                                    <c:when test="${currentLoyaltyCard != null && currentLoyaltyCard.tier == 'GOLD'}">
                                        <span class="badge px-2 py-0.5 rounded-pill small fw-bold font-accent text-dark" style="background: #ffd700;"><i class="fa-solid fa-gem me-1"></i>VÀNG</span>
                                    </c:when>
                                    <c:when test="${currentLoyaltyCard != null && currentLoyaltyCard.tier == 'SILVER'}">
                                        <span class="badge px-2 py-0.5 rounded-pill small fw-bold font-accent text-dark" style="background: #c0c0c0;"><i class="fa-solid fa-medal me-1"></i>BẠC</span>
                                    </c:when>
                                    <c:when test="${currentLoyaltyCard != null && currentLoyaltyCard.tier == 'BRONZE'}">
                                        <span class="badge px-2 py-0.5 rounded-pill small fw-bold font-accent text-white" style="background: #cd7f32;"><i class="fa-solid fa-award me-1"></i>ĐỒNG</span>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fa-solid fa-circle-user fa-lg"></i>
                                    </c:otherwise>
                                </c:choose>
                                <span class="d-none d-sm-inline fw-semibold">${currentUser != null ? currentUser.fullName : pageContext.request.userPrincipal.name}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end bg-espresso border-gold shadow-lg">
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-award me-2 text-gold"></i><span data-i18n="nav.profile">Hồ sơ &amp; Điểm UTEClub</span></a></li>
                                <sec:authorize access="hasRole('ADMIN')">
                                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-chart-pie me-2 text-gold"></i><span data-i18n="nav.admin">Trang Quản Trị Admin</span></a></li>
                                </sec:authorize>
                                <sec:authorize access="hasAnyRole('BARISTA', 'STORE_MANAGER', 'ADMIN')">
                                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/barista/kds"><i class="fa-solid fa-mug-hot me-2 text-gold"></i><span data-i18n="nav.kds">Màn Hình Pha Chế KDS</span></a></li>
                                </sec:authorize>
                                <li><hr class="dropdown-divider border-secondary opacity-25"></li>
                                <li>
                                    <form action="${pageContext.request.contextPath}/auth/logout" method="post" class="m-0 p-0">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button type="submit" class="dropdown-item text-danger py-2"><i class="fa-solid fa-right-from-bracket me-2"></i><span data-i18n="nav.logout">Đăng Xuất</span></button>
                                    </form>
                                </li>
                            </ul>
                        </div>
                    </sec:authorize>

                    <sec:authorize access="!isAuthenticated()">
                        <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-gold btn-sm px-3 flex-shrink-0 text-nowrap">
                            <i class="fa-solid fa-arrow-right-to-bracket me-1"></i> <span data-i18n="nav.login">Đăng Nhập</span>
                        </a>
                    </sec:authorize>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content Body -->
    <main class="flex-grow-1">
        <sitemesh:write property='body'/>
    </main>

    <!-- Luxury Footer -->
    <footer class="footer-luxury">
        <div class="container">
            <div class="row g-4 mb-5">
                <!-- Col 1: Brand Info -->
                <div class="col-lg-4 col-md-6">
                    <img src="${pageContext.request.contextPath}/assets/images/logo_dark.svg" alt="UTECOFFE" height="50" class="brand-logo-img mb-3">
                    <p class="text-secondary small pe-lg-4" data-i18n="footer.desc">
                        UTECOFFE là thương hiệu chuỗi cà phê &amp; trà đặc sản thượng hạng. Chúng tôi tận tâm tuyển chọn từng mẻ quả chín mọng từ độ cao 1.600m Cầu Đất, kết hợp kỹ thuật rang mộc thủ công để mang đến trải nghiệm hương vị đỉnh cao.
                    </p>
                    <div class="d-flex gap-2 mt-3">
                        <a href="javascript:void(0)" onclick="showUnderDevelopment('Kênh Facebook Official')" class="btn btn-outline-gold btn-sm rounded-circle p-2" style="width: 36px; height: 36px;" title="Facebook UTECoffe"><i class="fa-brands fa-facebook-f"></i></a>
                        <a href="javascript:void(0)" onclick="showUnderDevelopment('Kênh Instagram Official')" class="btn btn-outline-gold btn-sm rounded-circle p-2" style="width: 36px; height: 36px;" title="Instagram UTECoffe"><i class="fa-brands fa-instagram"></i></a>
                        <a href="javascript:void(0)" onclick="showUnderDevelopment('Kênh TikTok Official')" class="btn btn-outline-gold btn-sm rounded-circle p-2" style="width: 36px; height: 36px;" title="TikTok UTECoffe"><i class="fa-brands fa-tiktok"></i></a>
                        <a href="javascript:void(0)" onclick="showUnderDevelopment('Kênh YouTube Roastery')" class="btn btn-outline-gold btn-sm rounded-circle p-2" style="width: 36px; height: 36px;" title="YouTube UTECoffe"><i class="fa-brands fa-youtube"></i></a>
                    </div>
                </div>

                <!-- Col 2: Navigation -->
                <div class="col-lg-2 col-md-6 col-6">
                    <h6 class="text-gold font-accent fw-bold text-uppercase mb-3" style="letter-spacing: 0.12em;" data-i18n="footer.explore">Khám Phá</h6>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/menu" class="footer-link">Cà Phê Đặc Sản</a></li>
                        <li><a href="${pageContext.request.contextPath}/menu" class="footer-link">Trà Thủ Công</a></li>
                        <li><a href="${pageContext.request.contextPath}/menu" class="footer-link">Cold Brew Ủ Lạnh</a></li>
                        <li><a href="${pageContext.request.contextPath}/story" class="footer-link">Nghệ Thuật Rang Mộc</a></li>
                        <li><a href="${pageContext.request.contextPath}/reservation" class="footer-link">Đặt Bàn Thưởng Thức</a></li>
                    </ul>
                </div>

                <!-- Col 3: Customer Care -->
                <div class="col-lg-2 col-md-6 col-6">
                    <h6 class="text-gold font-accent fw-bold text-uppercase mb-3" style="letter-spacing: 0.12em;" data-i18n="footer.policy">Dịch Vụ</h6>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/uteclub" class="footer-link">Đặc Quyền UTEClub</a></li>
                        <li><a href="${pageContext.request.contextPath}/stores" class="footer-link">Tìm Cửa Hàng Gần Nhất</a></li>
                        <li><a href="${pageContext.request.contextPath}/cart" class="footer-link">Giao Hàng Siêu Tốc 30'</a></li>
                        <li><a href="${pageContext.request.contextPath}/policy/refund" class="footer-link">Chính Sách Hoàn Tiền</a></li>
                        <li><a href="${pageContext.request.contextPath}/policy/terms" class="footer-link">Điều Khoản &amp; Bảo Mật</a></li>
                    </ul>
                </div>

                <!-- Col 4: Roastery Contact -->
                <div class="col-lg-4 col-md-6">
                    <h6 class="text-gold font-accent fw-bold text-uppercase mb-3" style="letter-spacing: 0.12em;">Xưởng Rang &amp; Trụ Sở</h6>
                    <p class="text-secondary small mb-2"><i class="fa-solid fa-location-dot text-gold me-2"></i> 01 Võ Văn Ngân, P. Linh Chiểu, TP. Thủ Đức, TP. Hồ Chí Minh</p>
                    <p class="text-secondary small mb-2"><i class="fa-solid fa-clock text-gold me-2"></i> Giờ hoạt động: 06:30 - 23:00 (Thứ 2 - Chủ Nhật)</p>
                    <p class="text-secondary small mb-2"><i class="fa-solid fa-envelope text-gold me-2"></i> contact@utecoffe.vn | cskh@utecoffe.vn</p>
                    <p class="text-secondary small mb-3"><i class="fa-solid fa-phone text-gold me-2"></i> Tổng đài đặt món: 1900 2026</p>
                    
                    <div class="pt-2">
                        <span class="text-muted small d-block mb-1">Đối tác thanh toán bảo mật:</span>
                        <div class="d-flex gap-2 align-items-center flex-wrap">
                            <span class="badge bg-secondary text-light px-2 py-1"><i class="fa-solid fa-qrcode me-1 text-gold"></i> VietQR</span>
                            <span class="badge bg-secondary text-light px-2 py-1"><i class="fa-regular fa-credit-card me-1 text-gold"></i> VNPay</span>
                            <span class="badge bg-secondary text-light px-2 py-1"><i class="fa-solid fa-wallet me-1 text-gold"></i> MoMo</span>
                            <span class="badge bg-secondary text-light px-2 py-1"><i class="fa-solid fa-money-bill-1 me-1 text-gold"></i> Tiền mặt</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom Copyright -->
            <div class="border-top border-secondary opacity-25 pt-4 d-flex flex-column flex-md-row justify-content-between align-items-center small text-muted">
                <p class="mb-0" data-i18n="footer.rights">© 2026 UTECoffe Specialty Tea &amp; Coffee Roastery. Bản quyền thuộc về Trương Gia Kiệt (@JiaysTM17).</p>
                <p class="mb-0">Spring Boot 3.3.5 • PostgreSQL 16 • WebSocket STOMP • SiteMesh 3.2.1</p>
            </div>
        </div>
    </footer>

    <!-- Luxury In-Development Modal -->
    <div class="modal fade" id="inDevelopmentModal" tabindex="-1" aria-labelledby="inDevelopmentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content card-luxury border-gold shadow-lg bg-espresso text-light p-3" style="border-radius: 24px;">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge bg-gold-gradient text-obsidian rounded-circle p-2 d-inline-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                            <i class="fa-solid fa-sparkles"></i>
                        </span>
                        <h5 class="modal-title font-serif text-gold-gradient fw-bold mb-0" id="inDevelopmentModalLabel" data-i18n="in_dev.title">Thông Báo Trải Nghiệm</h5>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body py-4 text-center">
                    <div class="mb-3">
                        <div class="d-inline-flex align-items-center justify-content-center rounded-circle border border-gold p-4" style="background: radial-gradient(circle, rgba(222,183,106,0.18) 0%, rgba(14,13,11,0) 70%); width: 85px; height: 85px;">
                            <i class="fa-solid fa-compass-drafting text-gold fs-2"></i>
                        </div>
                    </div>
                    <h5 class="font-serif fw-bold text-light mb-2" id="inDevFeatureTitle" data-i18n="in_dev.default_feature">Kênh Truyền Thông Đang Nâng Cấp</h5>
                    <p class="text-secondary small px-3 mb-0" id="inDevFeatureDesc" style="line-height: 1.8;" data-i18n="in_dev.desc">
                        UTECOFFE Official đang trong quá trình hoàn thiện nội dung và chuẩn bị ra mắt độc quyền trên nền tảng này nhằm mang đến trải nghiệm tinh tế và trọn vẹn nhất cho bạn. Xin vui lòng đón chờ trong thời gian sớm nhất!
                    </p>
                </div>
                <div class="modal-footer border-0 pt-0 justify-content-center gap-2">
                    <button type="button" class="btn btn-gold btn-sm px-4 rounded-pill font-accent" data-bs-dismiss="modal">
                        <i class="fa-solid fa-check me-1"></i> <span data-i18n="in_dev.btn_understand">Đã Hiểu &amp; Đón Chờ</span>
                    </button>
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-gold btn-sm px-3 rounded-pill font-accent" data-i18n="in_dev.btn_explore">
                        Khám Phá Menu
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS Bundle & UTECoffe Luxury Interaction Engine -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/luxury.js"></script>
    <script>
        function showUnderDevelopment(featureName, customMessage) {
            const isEn = (localStorage.getItem('utecoffe_lang') === 'en');
            const titleEl = document.getElementById('inDevFeatureTitle');
            const descEl = document.getElementById('inDevFeatureDesc');
            if (titleEl && featureName) {
                titleEl.textContent = featureName + (isEn ? ' - Under Active Development' : ' - Đang Nâng Cấp');
            }
            if (descEl && customMessage) {
                descEl.textContent = customMessage;
            } else if (descEl) {
                if (isEn) {
                    descEl.innerHTML = 'This official communication channel & feature of <strong>UTECOFFE Artisanal Roasters</strong> is currently under active curation and will debut exclusively soon. We are committed to delivering the highest standard of elegance for you. Thank you for your continued patronage!';
                } else {
                    descEl.innerHTML = 'Kênh truyền thông & tính năng này của <strong>UTECOFFE Artisanal Roasters</strong> đang trong quá trình hoàn thiện nội dung và chuẩn bị ra mắt độc quyền. Chúng tôi cam kết mang tới tiêu chuẩn phục vụ tinh tế và trọn vẹn nhất cho bạn. Xin chân thành cảm ơn sự đồng hành của quý khách!';
                }
            }
            const modalEl = document.getElementById('inDevelopmentModal');
            if (modalEl && typeof bootstrap !== 'undefined') {
                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                modal.show();
            } else {
                alert(featureName + (isEn ? ': Feature is under development. Please stay tuned!' : ': Tính năng đang được hoàn thiện. Vui lòng đón chờ!'));
            }
        }
    </script>
</body>
</html>
