<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Nhật Ký Hệ Thống - UTECoffe Admin</title>
</head>
<body>
    <div class="mb-4">
        <h4 class="fw-bold mb-1">Nhật Ký Truy Vết Hệ Thống (Audit Logs)</h4>
        <p class="text-muted small mb-0">Theo dõi các thay đổi dữ liệu, hành động bảo mật và thao tác quan trọng</p>
    </div>

    <div class="card border-0 shadow-sm p-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
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
                            <td class="small text-muted">${l.timestamp}</td>
                            <td><span class="badge bg-info text-dark">${l.action}</span></td>
                            <td>${l.entityName} #${l.entityId}</td>
                            <td class="fw-bold">${l.user != null ? l.user.fullName : 'Hệ thống tự động'}</td>
                            <td><code>${l.ipAddress}</code></td>
                            <td class="small text-muted">${l.details}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
