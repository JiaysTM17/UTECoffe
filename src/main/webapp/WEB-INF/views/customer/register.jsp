<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Đăng Ký Thành Viên UTEClub - UTECoffe</title>
</head>
<body class="bg-obsidian">
    <div class="container py-5 min-vh-75 d-flex align-items-center justify-content-center">
        <div class="card card-luxury border-gold p-4 p-md-5 shadow-lg w-100" style="max-width: 480px;">
            <div class="text-center mb-4">
                <img src="${pageContext.request.contextPath}/assets/images/logo_icon.svg" alt="UTECOFFE" height="48" class="mb-3">
                <h3 class="font-serif fw-bold text-gold-gradient mb-1">Đăng Ký UTEClub</h3>
                <p class="text-secondary small">Gia nhập cộng đồng người yêu trà &amp; cà phê đặc sản</p>
            </div>

            <form action="${pageContext.request.contextPath}/api/auth/register" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="mb-3">
                    <label class="form-label text-gold small fw-bold">Họ và Tên:</label>
                    <input type="text" name="fullName" class="form-control form-control-luxury" placeholder="Nguyễn Văn A" required>
                </div>

                <div class="mb-3">
                    <label class="form-label text-gold small fw-bold">Địa Chỉ Email:</label>
                    <input type="email" name="email" class="form-control form-control-luxury" placeholder="email@gmail.com" required>
                </div>

                <div class="mb-3">
                    <label class="form-label text-gold small fw-bold">Số Điện Thoại:</label>
                    <input type="tel" name="phoneNumber" class="form-control form-control-luxury" placeholder="0901234567" required>
                </div>

                <div class="mb-4">
                    <label class="form-label text-gold small fw-bold">Mật Khẩu:</label>
                    <input type="password" name="password" class="form-control form-control-luxury" placeholder="Ít nhất 6 ký tự" required>
                </div>

                <button type="submit" class="btn btn-gold w-100 py-3 fw-bold mb-3">
                    <i class="fa-solid fa-user-plus me-1"></i> Tạo Tài Khoản Thành Viên
                </button>
            </form>

            <div class="text-center small text-secondary">
                Đã có tài khoản? 
                <a href="${pageContext.request.contextPath}/auth/login" class="text-gold fw-bold text-decoration-none">Đăng nhập</a>
            </div>
        </div>
    </div>
</body>
