<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Nhật Ký Truy Vết AOP - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h5 class="fw-semibold text-primary mb-0" style="font-family: var(--font-sans); font-size: 1.05rem;">Nhật ký truy vết hệ thống AOP (Audit Logs)</h5>
            <small class="text-secondary" style="font-size: 0.75rem;">Giám sát bảo mật, ghi nhận mọi hành vi thay đổi dữ liệu theo thời gian thực</small>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-dark-roast border border-gold-subtle text-gold px-2.5 py-1.5 font-sans rounded-2" style="font-size: 0.75rem;">
                <i class="fa-solid fa-shield-halved me-1"></i> AOP Audit Interceptor Active
            </span>
        </div>
    </div>

    <div class="card-luxury p-3 p-md-3.5 border-gold shadow-sm">
        <div class="table-responsive">
            <table class="table table-luxury table-sm align-middle">
                <thead>
                    <tr style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.03em; color: var(--text-secondary);">
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
