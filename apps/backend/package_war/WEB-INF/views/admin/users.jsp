<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Quản Lý Người Dùng & Phân Quyền - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h5 class="fw-semibold text-primary mb-0" style="font-family: var(--font-sans); font-size: 1.05rem;">Quản lý người dùng &amp; phân quyền RBAC</h5>
            <small class="text-secondary" style="font-size: 0.75rem;">Quản trị danh sách khách hàng UTEClub, Barista chi nhánh và Ban điều hành</small>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-dark-roast border border-gold-subtle text-gold px-2.5 py-1.5 font-sans rounded-2" style="font-size: 0.75rem;">
                Tổng: <strong>${users.size()}</strong> tài khoản
            </span>
        </div>
    </div>

    <div class="card-luxury p-3 p-md-3.5 border-gold shadow-sm">
        <div class="table-responsive">
            <table class="table table-luxury table-sm align-middle">
                <thead>
                    <tr style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.03em; color: var(--text-secondary);">
                        <th class="py-2">ID</th>
                        <th class="py-2">Họ và Tên</th>
                        <th class="py-2">Email Đăng Nhập</th>
                        <th class="py-2">Số Điện Thoại</th>
                        <th class="py-2">Vai Trò (Role)</th>
                        <th class="py-2">Trạng Thái</th>
                        <th class="py-2">Ngày Tham Gia</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td class="font-monospace text-secondary">#${u.id}</td>
                            <td>
                                <div class="fw-bold text-primary">${u.fullName}</div>
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
