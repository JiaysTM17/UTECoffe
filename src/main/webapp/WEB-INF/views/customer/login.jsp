<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Đăng Nhập - UTECoffe</title>
</head>
<body>
    <div class="container py-5">
        <div class="card border-0 shadow-sm max-w-700 mx-auto p-4" style="max-width: 450px;">
            <div class="text-center mb-4">
                <h4 class="fw-bold">ĐĂNG NHẬP</h4>
                <p class="text-muted small">Chào mừng bạn quay lại với UTECoffe</p>
            </div>
            <c:if test="${param.error != null}">
                <div class="alert alert-danger small py-2">Sai email hoặc mật khẩu!</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/auth/login-process" method="post">
                <div class="mb-3">
                    <label class="form-label small fw-bold">Email hoặc Số điện thoại:</label>
                    <input type="text" name="username" class="form-control" placeholder="admin@utecoffe.vn" required>
                </div>
                <div class="mb-4">
                    <label class="form-label small fw-bold">Mật khẩu:</label>
                    <input type="password" name="password" class="form-control" placeholder="******" required>
                </div>
                <button type="submit" class="btn btn-gold w-100 py-2 fw-bold">Đăng Nhập</button>
            </form>
            <div class="text-center mt-3 small">
                <span>Chưa có tài khoản? </span><a href="${pageContext.request.contextPath}/auth/register">Đăng ký thành viên</a>
            </div>
        </div>
    </div>
</body>
