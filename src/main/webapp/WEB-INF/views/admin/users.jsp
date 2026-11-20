<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Quản Lý Khách Hàng & Phân Quyền - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0">Danh Sách Người Dùng &amp; Phân Quyền RBAC</h4>
        <button class="btn btn-warning btn-sm fw-bold"><i class="fa-solid fa-user-plus me-1"></i> Thêm Tài Khoản</button>
    </div>

    <div class="card border-0 shadow-sm p-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Họ và Tên</th>
                        <th>Email</th>
                        <th>Số Điện Thoại</th>
                        <th>Vai Trò (Role)</th>
                        <th>Trạng Thái</th>
                        <th>Ngày Tham Gia</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td>#${u.id}</td>
                            <td class="fw-bold">${u.fullName}</td>
                            <td>${u.email}</td>
                            <td>${u.phoneNumber}</td>
                            <td>
                                <span class="badge bg-primary">${u.role.name}</span>
                            </td>
                            <td>
                                <span class="badge ${u.status ? 'bg-success' : 'bg-danger'}">
                                    ${u.status ? 'Hoạt Động' : 'Khóa'}
                                </span>
                            </td>
                            <td class="small text-muted">${u.createdAt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
