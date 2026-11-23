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

            <form action="${pageContext.request.contextPath}/auth/login-process" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="mb-3">
                    <label class="form-label text-gold small fw-bold">Email hoặc Số Điện Thoại:</label>
                    <input type="text" name="username" class="form-control form-control-luxury" placeholder="admin@utecoffe.vn" required autofocus>
                </div>

                <div class="mb-4">
                    <div class="d-flex justify-content-between">
                        <label class="form-label text-gold small fw-bold">Mật Khẩu:</label>
                        <a href="#" class="small text-muted text-decoration-none hover-gold">Quên mật khẩu?</a>
                    </div>
                    <input type="password" name="password" class="form-control form-control-luxury" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn btn-gold w-100 py-3 fw-bold mb-3">
                    <i class="fa-solid fa-arrow-right-to-bracket me-1"></i> Đăng Nhập
                </button>
            </form>

            <div class="text-center small text-secondary">
                Chưa có tài khoản thành viên? 
                <a href="${pageContext.request.contextPath}/auth/register" class="text-gold fw-bold text-decoration-none">Đăng ký ngay</a>
            </div>
        </div>
    </div>
</body>
