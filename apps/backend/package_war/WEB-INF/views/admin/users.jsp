<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Quản Lý Người Dùng & Phân Quyền - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="font-serif fw-bold text-gold-gradient mb-0">Quản Lý Người Dùng &amp; Phân Quyền RBAC</h4>
            <small class="text-secondary">Quản trị danh sách khách hàng UTEClub, Barista chi nhánh và Ban điều hành</small>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-dark-roast border border-gold text-gold px-3 py-2 font-accent">
                Tổng: <strong>${users.size()}</strong> tài khoản
            </span>
        </div>
    </div>

    <div class="card-luxury p-4 border-gold shadow-lg">
        <div class="table-responsive">
            <table class="table table-luxury align-middle">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ và Tên</th>
                        <th>Email Đăng Nhập</th>
                        <th>Số Điện Thoại</th>
                        <th>Vai Trò (Role)</th>
                        <th>Trạng Thái</th>
                        <th>Ngày Tham Gia</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td class="font-monospace text-secondary">#${u.id}</td>
                            <td>
                                <div class="fw-bold text-light">${u.fullName}</div>
                            </td>
                            <td>
                                <span class="font-monospace text-gold small">${u.email}</span>
                            </td>
                            <td>
                                <span class="text-secondary small">${u.phoneNumber != null ? u.phoneNumber : '---'}</span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.role.name == 'ROLE_ADMIN'}">
                                        <span class="badge bg-danger-subtle text-danger border border-danger font-accent">
                                            <i class="fa-solid fa-shield-halved me-1"></i> ADMIN
                                        </span>
                                    </c:when>
                                    <c:when test="${u.role.name == 'ROLE_BARISTA'}">
                                        <span class="badge bg-warning-subtle text-warning border border-warning font-accent">
                                            <i class="fa-solid fa-mug-hot me-1"></i> BARISTA
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-espresso border border-gold text-gold font-accent">
                                            <i class="fa-solid fa-user me-1"></i> CUSTOMER
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="badge ${u.status ? 'bg-success-subtle text-success border border-success' : 'bg-danger-subtle text-danger'} px-2 py-1">
                                    ${u.status ? 'Hoạt Động' : 'Khóa'}
                                </span>
                            </td>
                            <td class="small text-secondary">${u.createdAt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>