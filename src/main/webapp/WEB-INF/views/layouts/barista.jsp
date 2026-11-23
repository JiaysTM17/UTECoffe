<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - UTECoffe Barista Cockpit</title>
    
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Plus+Jakarta+Sans:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxury.css">
    
    <!-- Instant Theme Detection Script -->
    <script>
        (function() {
            var savedTheme = localStorage.getItem('utecoffe_theme') || 'dark';
            document.documentElement.setAttribute('data-theme', savedTheme);
        })();
    </script>
    
    <sitemesh:write property='head'/>
</head>
<body class="bg-obsidian text-light min-vh-100 d-flex flex-column">
    <!-- Barista KDS Top Header -->
    <header class="py-2 px-4 border-bottom border-gold bg-espresso d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/assets/images/logo_dark.svg" alt="UTECOFFE" height="38">
            </a>
            <span class="badge bg-gold text-dark font-accent fw-bold px-2 py-1">KDS BARISTA COCKPIT</span>
        </div>
        <div class="d-flex align-items-center gap-4">
            <div id="liveClock" class="font-accent fw-bold text-gold fs-5">--:--:--</div>
            <span id="stompStatus" class="badge bg-success-subtle border border-success text-success px-3 py-2"><i class="fa-solid fa-satellite-dish me-1"></i> STOMP Realtime: Đã Kết Nối</span>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-gold btn-sm"><i class="fa-solid fa-sliders me-1"></i> Admin</a>
        </div>
    </header>

    <!-- Main KDS Board -->
    <main class="flex-grow-1 p-3">
        <sitemesh:write property='body'/>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateClock() {
            const now = new Date();
            const timeStr = now.toLocaleTimeString('vi-VN');
            const el = document.getElementById('liveClock');
            if (el) el.innerText = timeStr;
        }
        setInterval(updateClock, 1000);
        updateClock();
    </script>
</body>
</html>
