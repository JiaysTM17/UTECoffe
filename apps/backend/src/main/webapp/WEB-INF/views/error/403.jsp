<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <title>403 - Quyền Truy Cập Bị Từ Chối - UTECoffe</title>
</head>
<body>
    <div class="container py-5 text-center my-5">
        <h1 class="display-1 fw-bold text-danger mb-2"><i class="fa-solid fa-lock"></i> 403</h1>
        <h3 class="fw-bold text-dark mb-3">TRUY CẬP BỊ GIỚI HẠN</h3>
        <p class="text-muted max-w-700 mx-auto mb-4" style="max-width: 500px;">
            ${errorMessage != null ? errorMessage : 'Tài khoản của bạn không có đủ đặc quyền truy cập vào phân hệ này.'}
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-gold px-4">
            <i class="fa-solid fa-house me-2"></i> Quay Lại Trang Chủ
        </a>
    </div>
</body>
