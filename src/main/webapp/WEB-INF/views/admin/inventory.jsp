<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Quản Lý Kho & Định Lượng BOM - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">Tồn Kho &amp; Định Lượng Nguyên Liệu (BOM)</h4>
            <p class="text-muted small mb-0">Theo dõi định mức tồn kho an toàn và lịch sử hao hụt tự động</p>
        </div>
        <button class="btn btn-warning btn-sm fw-bold">
            <i class="fa-solid fa-plus me-1"></i> Tạo Phiếu Nhập Kho
        </button>
    </div>

    <div class="card border-0 shadow-sm p-4 mb-4">
        <h6 class="fw-bold mb-3">Danh Sách Tồn Kho Tại Các Chi Nhánh</h6>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Chi Nhánh</th>
                        <th>Nguyên Liệu</th>
                        <th>Đơn Vị</th>
                        <th>Tồn Hiện Tại</th>
                        <th>Mức An Toàn</th>
                        <th>Trạng Thái</th>
                        <th>Lần Nhập Cuối</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="inv" items="${inventories}">
                        <tr>
                            <td class="fw-bold">${inv.store.name}</td>
                            <td>${inv.ingredient.name}</td>
                            <td><span class="badge bg-light text-dark">${inv.ingredient.unit}</span></td>
                            <td class="fw-bold fs-6">${inv.currentStock}</td>
                            <td class="text-muted">${inv.safetyStock}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${inv.currentStock <= inv.safetyStock}">
                                        <span class="badge bg-danger"><i class="fa-solid fa-triangle-exclamation me-1"></i> Cảnh Báo Tồn Thấp</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success">Đủ Định Mức</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="small text-muted">${inv.lastRestockedAt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
