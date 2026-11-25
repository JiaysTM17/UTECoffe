<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <title>500 - Sự Cố Hệ Thống - UTECoffe</title>
</head>
<body>
    <div class="container py-5 text-center my-5">
        <h1 class="display-1 fw-bold text-secondary mb-2">500</h1>
        <h3 class="fw-bold text-dark mb-3">HỆ THỐNG ĐANG BẢO TRÌ NÂNG CẤP</h3>
        <p class="text-muted max-w-700 mx-auto mb-4" style="max-width: 520px;">
            ${errorMessage != null ? errorMessage : 'Hệ thống đang được cân chỉnh để phục vụ trải nghiệm tốt nhất. Vui lòng thử lại sau.'}
        </p>
        <p class="small text-muted mb-4">Hỗ trợ khẩn cấp: <strong>1900 2026</strong> (07:00 - 22:30 hàng ngày)</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-gold px-4">
            <i class="fa-solid fa-arrow-rotate-right me-2"></i> Tải Lại Trang
        </a>
    </div>
</body>
