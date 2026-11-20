<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Quản Lý Khuyến Mãi & Voucher - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0">Chương Trình Khuyến Mãi &amp; Mã Ưu Đãi</h4>
        <button class="btn btn-warning btn-sm fw-bold"><i class="fa-solid fa-tags me-1"></i> Tạo Mã Mới</button>
    </div>

    <div class="card border-0 shadow-sm p-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Mã Voucher</th>
                        <th>Tiêu Đề</th>
                        <th>Loại Giảm</th>
                        <th>Mức Giảm</th>
                        <th>Đơn Tối Thiểu</th>
                        <th>Lượt Đã Dùng</th>
                        <th>Thời Hạn</th>
                        <th>Trạng Thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${coupons}">
                        <tr>
                            <td><span class="badge bg-dark fs-6">${c.code}</span></td>
                            <td class="fw-bold">${c.title}</td>
                            <td>${c.discountType}</td>
                            <td class="text-danger fw-bold">
                                <c:choose>
                                    <c:when test="${c.discountType == 'PERCENTAGE'}">${c.discountValue}%</c:when>
                                    <c:otherwise><fmt:formatNumber value="${c.discountValue}" type="currency" currencySymbol="₫"/></c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatNumber value="${c.minOrderValue}" type="currency" currencySymbol="₫"/></td>
                            <td>${c.usedCount} / ${c.usageLimit}</td>
                            <td class="small text-muted">${c.startDate} đến ${c.endDate}</td>
                            <td>
                                <span class="badge ${c.isActive ? 'bg-success' : 'bg-secondary'}">
                                    ${c.isActive ? 'Đang Chạy' : 'Hết Hạn'}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
