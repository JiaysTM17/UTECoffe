<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Quản Lý Đơn Hàng - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0">Danh Sách Đơn Hàng Toàn Hệ Thống</h4>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-file-export me-1"></i> Xuất Excel</button>
        </div>
    </div>

    <div class="card border-0 shadow-sm p-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Mã Đơn</th>
                        <th>Khách Hàng</th>
                        <th>Chi Nhánh</th>
                        <th>Hình Thức</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th>Thời Gian</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ord" items="${orders}">
                        <tr>
                            <td class="fw-bold"><a href="${pageContext.request.contextPath}/orders/tracking/${ord.orderCode}">#${ord.orderCode}</a></td>
                            <td>${ord.recipientName}<br><small class="text-muted">${ord.recipientPhone}</small></td>
                            <td>${ord.store.name}</td>
                            <td><span class="badge bg-light text-dark">${ord.orderType}</span></td>
                            <td class="text-danger fw-bold"><fmt:formatNumber value="${ord.finalAmount}" type="currency" currencySymbol="₫"/></td>
                            <td>
                                <span class="badge ${ord.status == 'COMPLETED' ? 'bg-success' : (ord.status == 'CANCELLED' ? 'bg-secondary' : 'bg-warning text-dark')}">
                                    ${ord.status}
                                </span>
                            </td>
                            <td class="small text-muted">${ord.createdAt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
