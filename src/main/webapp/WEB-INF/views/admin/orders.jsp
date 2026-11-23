<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Sổ Cái Đơn Hàng - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="font-serif fw-bold text-gold-gradient mb-0">Quản Lý Đơn Hàng Toàn Hệ Thống</h4>
            <small class="text-muted">Theo dõi, điều phối và đối soát giao dịch thời gian thực</small>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/orders/export" class="btn btn-gold btn-sm">
                <i class="fa-solid fa-file-excel me-1"></i> Xuất File Excel (.xlsx)
            </a>
        </div>
    </div>

    <div class="card-luxury p-4">
        <div class="table-responsive">
            <table class="table table-luxury align-middle">
                <thead>
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
                            <td class="fw-bold font-accent"><a href="${pageContext.request.contextPath}/orders/tracking/${ord.orderCode}" class="text-gold text-decoration-none">#${ord.orderCode}</a></td>
                            <td>
                                <div class="fw-bold">${ord.recipientName}</div>
                                <small class="text-muted">${ord.recipientPhone}</small>
                            </td>
                            <td>${ord.store.name}</td>
                            <td><span class="badge bg-espresso border border-secondary text-light">${ord.orderType}</span></td>
                            <td class="text-gold fw-bold"><fmt:formatNumber value="${ord.finalAmount}" type="currency" currencySymbol="₫"/></td>
                            <td>
                                <span class="badge ${ord.status == 'COMPLETED' ? 'bg-success' : (ord.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark')} px-2 py-1">
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
