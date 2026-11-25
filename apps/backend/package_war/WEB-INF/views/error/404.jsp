<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <title>404 - Không Tìm Thấy Trang - UTECoffe</title>
</head>
<body>
    <div class="container py-5 text-center my-5">
        <h1 class="display-1 fw-bold text-warning mb-2">404</h1>
        <h3 class="fw-bold text-dark mb-3">RẤT TIẾC, TRANG NÀY ĐÃ BỊ LẠC TRÔI</h3>
        <p class="text-muted max-w-700 mx-auto mb-4" style="max-width: 500px;">
            ${errorMessage != null ? errorMessage : 'Trang bạn đang tìm kiếm có thể đã bị xóa hoặc đường dẫn không chính xác.'}
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/" class="btn btn-gold px-4">
                <i class="fa-solid fa-house me-2"></i> Về Trang Chủ
            </a>
            <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-dark px-4">
                <i class="fa-solid fa-mug-hot me-2"></i> Khám Phá Thực Đơn
            </a>
        </div>
    </div>
</body>
