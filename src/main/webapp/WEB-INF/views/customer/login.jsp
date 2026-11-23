<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Đăng Nhập Thành Viên - UTECoffe</title>
</head>
<body class="bg-obsidian">
    <div class="container py-5 min-vh-75 d-flex align-items-center justify-content-center">
        <div class="card card-luxury border-gold p-4 p-md-5 shadow-lg w-100" style="max-width: 460px;">
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
                        <a href="#" class="small text-muted text-decoration-none hover-gold">Quên mật khẩu?</a>
                    </div>
                    <input type="password" id="passwordInput" name="password" class="form-control form-control-luxury" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn btn-gold w-100 py-3 fw-bold mb-3 shadow-gold-sm">
                    <i class="fa-solid fa-arrow-right-to-bracket me-1"></i> Đăng Nhập
                </button>
            </form>

            <!-- Quick Demo Role Switcher -->
            <div class="pt-3 border-top border-gold-subtle mt-2">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-gold font-accent small fw-bold text-uppercase" style="letter-spacing: 0.08em;">
                        <i class="fa-solid fa-users me-1"></i> Tài Khoản Thử Nghiệm (1-Click)
                    </span>
                    <small class="text-secondary" style="font-size: 0.7rem;">Pass: Admin@2026</small>
                </div>

                <div class="d-flex flex-column gap-2 mb-3">
                    <!-- Customer 1: Bronze -->
                    <button type="button" class="btn btn-dark-roast border text-start p-2 rounded-3 demo-role-btn d-flex align-items-center justify-content-between" 
                            style="border-color: #cd7f32 !important;"
                            onclick="fillDemoAccount('phuong.bronze@utecoffe.vn', 'Admin@2026')">
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge text-white px-2 py-1 small fw-bold" style="background: #cd7f32;">ĐỒNG</span>
                            <div>
                                <div class="text-light small fw-bold mb-0">Nguyễn Thị Mai Phương</div>
                                <div class="text-secondary" style="font-size: 0.72rem;">Khách Mới • 120 điểm • Voucher 20%</div>
                            </div>
                        </div>
                        <i class="fa-solid fa-arrow-right text-secondary small"></i>
                    </button>

                    <!-- Customer 2: Silver -->
                    <button type="button" class="btn btn-dark-roast border text-start p-2 rounded-3 demo-role-btn d-flex align-items-center justify-content-between" 
                            style="border-color: #c0c0c0 !important;"
                            onclick="fillDemoAccount('bao.silver@utecoffe.vn', 'Admin@2026')">
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge text-dark px-2 py-1 small fw-bold" style="background: #c0c0c0;">BẠC</span>
                            <div>
                                <div class="text-light small fw-bold mb-0">Trần Quốc Bảo</div>
                                <div class="text-secondary" style="font-size: 0.72rem;">Thân Thiết • 850 điểm • Free Up-size T5</div>
                            </div>
                        </div>
                        <i class="fa-solid fa-arrow-right text-secondary small"></i>
                    </button>

                    <!-- Customer 3: Diamond -->
                    <button type="button" class="btn btn-dark-roast border text-start p-2 rounded-3 demo-role-btn d-flex align-items-center justify-content-between" 
                            style="border-color: #b9f2ff !important; background: linear-gradient(90deg, rgba(185,242,255,0.06) 0%, rgba(20,20,20,0.8) 100%);"
                            onclick="fillDemoAccount('vy.diamond@utecoffe.vn', 'Admin@2026')">
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge text-dark px-2 py-1 small fw-bold" style="background: #b9f2ff;"><i class="fa-solid fa-crown me-1"></i>KIM CƯƠNG</span>
                            <div>
                                <div class="text-gold small fw-bold mb-0">Lê Hoàng Yến Vy</div>
                                <div class="text-secondary" style="font-size: 0.72rem;">Thượng Khách VIP • 3.650 điểm • Giảm 15%</div>
                            </div>
                        </div>
                        <i class="fa-solid fa-arrow-right text-gold small"></i>
                    </button>

                    <!-- Staff Roles: Barista & Admin -->
                    <div class="d-flex gap-2 pt-1">
                        <button type="button" class="btn btn-outline-warning btn-sm flex-grow-1 rounded-pill py-1 text-nowrap" 
                                style="font-size: 0.75rem;"
                                onclick="fillDemoAccount('barista.thuduc@utecoffe.vn', 'Admin@2026')">
                            <i class="fa-solid fa-mug-hot me-1"></i> Barista KDS
                        </button>
                        <button type="button" class="btn btn-outline-danger btn-sm flex-grow-1 rounded-pill py-1 text-nowrap" 
                                style="font-size: 0.75rem;"
                                onclick="fillDemoAccount('admin@utecoffe.vn', 'Admin@2026')">
                            <i class="fa-solid fa-shield-halved me-1"></i> Admin Portal
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
