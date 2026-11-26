<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Nhật Ký Truy Vết AOP - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="font-serif fw-bold text-primary mb-0">Nhật Ký Truy Vết Hệ Thống AOP (Audit Logs)</h4>
            <small class="text-secondary">Giám sát bảo mật, ghi nhận mọi hành vi thay đổi dữ liệu theo thời gian thực</small>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-dark-roast border border-gold text-gold px-3 py-2 font-accent">
                <i class="fa-solid fa-shield-halved me-1"></i> AOP Audit Interceptor Active
            </span>
        </div>
    </div>

    <div class="card-luxury p-4 border-gold shadow-lg">
        <div class="table-responsive">
            <table class="table table-luxury align-middle">
                <thead>
                    <tr>
                        <th>Thời Gian</th>
                        <th>Hành Động</th>
                        <th>Đối Tượng</th>
                        <th>Người Thực Hiện</th>
                        <th>Địa Chỉ IP</th>
                        <th>Chi Tiết</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="l" items="${logs}">
                        <tr>
                            <td class="small text-secondary font-monospace">${l.timestamp}</td>
                            <td><span class="badge bg-espresso border border-gold text-gold font-accent">${l.action}</span></td>
                            <td class="text-primary">${l.entityName} #${l.entityId}</td>
                            <td class="fw-bold text-primary">${l.user != null ? l.user.fullName : 'Hệ thống tự động'}</td>
                            <td><code class="text-warning">${l.ipAddress}</code></td>
                            <td class="small text-secondary">${l.details}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
