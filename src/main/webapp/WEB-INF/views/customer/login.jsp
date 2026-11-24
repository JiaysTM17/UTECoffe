<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Đăng Nhập Thành Viên - UTECoffe</title>
</head>
<body class="bg-obsidian">
    <div class="container py-5 min-vh-75 d-flex align-items-center justify-content-center">
        <div class="card card-luxury border-gold p-4 shadow-lg w-100" style="max-width: 480px;">
            <div class="text-center mb-4">
                <img src="${pageContext.request.contextPath}/assets/images/logo_icon.svg" alt="UTECOFFE" height="48" class="mb-3">
                <h3 class="font-serif fw-bold text-gold-gradient mb-1">Chào Mừng Trở Lại</h3>
                <p class="text-secondary small">Đăng nhập để nhận ưu đãi tích điểm UTEClub</p>
            </div>

            <c:if test="${param.error != null}">
                <div class="alert alert-danger small py-2 px-3 rounded-3 mb-3 border-0 bg-danger-subtle text-danger">
                    <i class="fa-solid fa-circle-exclamation me-1"></i> Email hoặc mật khẩu không chính xác!
                </div>
            </c:if>

            <c:if test="${param.logout != null}">
                <div class="alert alert-success small py-2 px-3 rounded-3 mb-3 border-0 bg-success-subtle text-success">
                    <i class="fa-solid fa-circle-check me-1"></i> Bạn đã đăng xuất an toàn.
                </div>
            </c:if>

            <form id="loginForm" action="${pageContext.request.contextPath}/auth/login-process" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="mb-3">
                    <label class="form-label text-gold small fw-bold">Email hoặc Số Điện Thoại:</label>
                    <input type="text" id="usernameInput" name="username" class="form-control form-control-luxury" placeholder="admin@utecoffe.vn" required autofocus>
                </div>

                <div class="mb-4">
                    <div class="d-flex justify-content-between">
                        <label class="form-label text-gold small fw-bold">Mật Khẩu:</label>
                        <a href="javascript:void(0)" onclick="showUnderDevelopment('Khôi Phục Mật Khẩu', 'Tính năng đặt lại mật khẩu trực tuyến qua Email OTP đang được nâng cấp. Để được hỗ trợ cấp lại mật khẩu ngay lập tức, quý khách vui lòng liên hệ hotline tổng đài 1900 2026 hoặc quản trị viên chi nhánh.')" class="small text-muted text-decoration-none hover-gold">Quên mật khẩu?</a>
                    </div>
                    <input type="password" id="passwordInput" name="password" class="form-control form-control-luxury" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn btn-gold w-100 py-3 fw-bold mb-3 shadow-gold-sm">
                    <i class="fa-solid fa-arrow-right-to-bracket me-1"></i> Đăng Nhập
                </button>
            </form>

            <!-- Quick Demo Role Switcher -->
            <div class="pt-3 border-top border-gold-subtle mt-2">
                <div class="d-flex align-items-center justify-content-between mb-2 pb-1 border-bottom border-gold-subtle">
                    <span class="text-gold font-accent small fw-bold text-uppercase d-flex align-items-center gap-1 text-nowrap">
                        <i class="fa-solid fa-bolt text-gold"></i> Đăng Nhập Nhanh (Demo)
                    </span>
                    <span class="badge bg-espresso border border-gold-subtle text-secondary font-monospace text-nowrap" style="font-size: 0.72rem;">
                        Pass: Admin@2026
                    </span>
                </div>

                <div class="d-flex flex-column gap-2 mb-3">
                    <!-- Customer 1: Bronze -->
                    <button type="button" class="btn btn-dark-roast border text-start p-2 rounded-3 demo-role-btn d-flex align-items-center justify-content-between" 
                            style="border-color: #cd7f32 !important;"
                            onclick="fillDemoAccount('phuong.bronze@utecoffe.vn', 'Admin@2026')">
                        <div class="d-flex align-items-center gap-2 overflow-hidden">
                            <span class="badge text-white px-2 py-1 small fw-bold text-nowrap" style="background: #cd7f32; min-width: 80px; text-align: center;">ĐỒNG</span>
                            <div class="text-truncate">
                                <div class="text-light small fw-bold text-truncate mb-0">Nguyễn Thị Mai Phương</div>
                                <div class="text-secondary text-truncate" style="font-size: 0.72rem;">120 điểm • Khách Mới (Voucher 20%)</div>
                            </div>
                        </div>
                        <i class="fa-solid fa-arrow-right text-secondary small ms-2 flex-shrink-0"></i>
                    </button>

                    <!-- Customer 2: Silver -->
                    <button type="button" class="btn btn-dark-roast border text-start p-2 rounded-3 demo-role-btn d-flex align-items-center justify-content-between" 
                            style="border-color: #c0c0c0 !important;"
                            onclick="fillDemoAccount('bao.silver@utecoffe.vn', 'Admin@2026')">
                        <div class="d-flex align-items-center gap-2 overflow-hidden">
                            <span class="badge text-dark px-2 py-1 small fw-bold text-nowrap" style="background: #c0c0c0; min-width: 80px; text-align: center;">BẠC</span>
                            <div class="text-truncate">
                                <div class="text-light small fw-bold text-truncate mb-0">Trần Quốc Bảo</div>
                                <div class="text-secondary text-truncate" style="font-size: 0.72rem;">850 điểm • Thân Thiết (Free Up-size T5)</div>
                            </div>
                        </div>
                        <i class="fa-solid fa-arrow-right text-secondary small ms-2 flex-shrink-0"></i>
                    </button>

                    <!-- Customer 3: Diamond -->
                    <button type="button" class="btn btn-dark-roast border text-start p-2 rounded-3 demo-role-btn d-flex align-items-center justify-content-between" 
                            style="border-color: #b9f2ff !important; background: linear-gradient(90deg, rgba(185,242,255,0.08) 0%, rgba(20,20,20,0.85) 100%);"
                            onclick="fillDemoAccount('vy.diamond@utecoffe.vn', 'Admin@2026')">
                        <div class="d-flex align-items-center gap-2 overflow-hidden">
                            <span class="badge text-dark px-2 py-1 small fw-bold text-nowrap" style="background: #b9f2ff; min-width: 80px; text-align: center;"><i class="fa-solid fa-crown me-1 text-warning"></i>KIM CƯƠNG</span>
                            <div class="text-truncate">
                                <div class="text-gold small fw-bold text-truncate mb-0">Lê Hoàng Yến Vy</div>
                                <div class="text-secondary text-truncate" style="font-size: 0.72rem;">3.650 điểm • VIP (Giảm trực tiếp 15%)</div>
                            </div>
                        </div>
                        <i class="fa-solid fa-arrow-right text-gold small ms-2 flex-shrink-0"></i>
                    </button>

                    <!-- Staff Roles: Barista & Admin -->
                    <div class="d-flex gap-2 pt-1">
                        <button type="button" class="btn btn-outline-warning btn-sm flex-grow-1 rounded-pill py-2 text-nowrap d-flex align-items-center justify-content-center gap-1 shadow-sm" 
                                style="font-size: 0.75rem;"
                                onclick="fillDemoAccount('barista.thuduc@utecoffe.vn', 'Admin@2026')">
                            <i class="fa-solid fa-mug-hot"></i> Barista KDS
                        </button>
                        <button type="button" class="btn btn-outline-danger btn-sm flex-grow-1 rounded-pill py-2 text-nowrap d-flex align-items-center justify-content-center gap-1 shadow-sm" 
                                style="font-size: 0.75rem;"
                                onclick="fillDemoAccount('admin@utecoffe.vn', 'Admin@2026')">
                            <i class="fa-solid fa-shield-halved"></i> Quản Trị Admin
                        </button>
                    </div>
                </div>
            </div>

            <div class="text-center small text-secondary">
                Chưa có tài khoản thành viên? 
                <a href="${pageContext.request.contextPath}/auth/register" class="text-gold fw-bold text-decoration-none">Đăng ký ngay</a>
            </div>
        </div>
    </div>

    <!-- Quick Demo Account Script -->
    <script>
        function fillDemoAccount(email, password) {
            const uInput = document.getElementById('usernameInput');
            const pInput = document.getElementById('passwordInput');
            if (uInput && pInput) {
                uInput.value = email;
                pInput.value = password;
                uInput.focus();
                
                // Visual feedback
                uInput.classList.add('border-gold');
                pInput.classList.add('border-gold');
                setTimeout(() => {
                    uInput.classList.remove('border-gold');
                    pInput.classList.remove('border-gold');
                }, 1000);
            }
        }
    </script>
</body>
