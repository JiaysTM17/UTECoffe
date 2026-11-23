<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - KDS Barista Realtime</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { font-family: 'Montserrat', sans-serif; background-color: #0E0D0C; color: #F5F2EB; }
        .kds-header { background: #1A1715; border-bottom: 2px solid #D4AF37; padding: 12px 24px; }
    </style>
    <sitemesh:write property='head'/>
</head>
<body>
    <header class="kds-header d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center gap-3">
            <h4 class="mb-0 fw-bold text-warning"><i class="fa-solid fa-mug-saucer me-2"></i>KDS BARISTA DISPLAY</h4>
            <span class="badge bg-success" id="connectionStatus"><i class="fa-solid fa-circle-dot me-1"></i> Trực Tuyến (STOMP)</span>
        </div>
        <div class="d-flex align-items-center gap-3">
            <span id="currentTime" class="fw-bold text-light"></span>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-outline-light"><i class="fa-solid fa-arrow-left me-1"></i> Về Quản Trị</a>
        </div>
    </header>
    <main class="p-3">
        <sitemesh:write property='body'/>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script>
        setInterval(() => {
            document.getElementById('currentTime').innerText = new Date().toLocaleTimeString('vi-VN');
        }, 1000);
    </script>
</body>
</html>
