<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Kho Nguyên Liệu BOM - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="font-serif fw-bold text-gold-gradient mb-0">Quản Lý Tồn Kho &amp; Định Lượng BOM</h4>
            <small class="text-muted">Tự động trừ kho nguyên liệu theo định lượng công thức pha chế</small>
        </div>
    </div>

    <div class="card-luxury p-4 mb-4">
        <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">Tồn Kho Nguyên Liệu Theo Chi Nhánh</h5>
        <div class="table-responsive">
            <table class="table table-luxury align-middle">
                <thead>
                    <tr>
                        <th>Chi Nhánh</th>
                        <th>Tên Nguyên Liệu</th>
                        <th>Tồn Kho Khả Dụng</th>
                        <th>Mức Cảnh Báo</th>
                        <th>Trạng Thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="inv" items="${inventories}">
                        <tr>
                            <td class="fw-bold">${inv.store.name}</td>
                            <td>${inv.ingredient.name}</td>
                            <td class="text-gold fw-bold">${inv.currentStock} ${inv.ingredient.unit}</td>
                            <td class="text-muted">${inv.reorderLevel} ${inv.ingredient.unit}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${inv.currentStock <= inv.reorderLevel}">
                                        <span class="badge bg-danger text-light px-2 py-1"><i class="fa-solid fa-triangle-exclamation me-1"></i> Cần Nhập Hàng</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success text-light px-2 py-1"><i class="fa-solid fa-circle-check me-1"></i> Đầy Đủ</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
