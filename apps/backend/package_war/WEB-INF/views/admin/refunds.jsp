<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Xử Lý Khiếu Nại & Hoàn Tiền - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="font-serif fw-bold text-primary mb-0">Xử Lý Khiếu Nại, Đơn Lỗi &amp; Hoàn Tiền (Disputes &amp; Refunds)</h4>
            <small class="text-secondary">Chính sách bảo vệ quyền lợi khách hàng, giải quyết sự cố giao hàng đổ vỡ hoặc chậm trễ</small>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-dark-roast border border-gold text-gold px-3 py-2 font-accent">
                Tổng: <strong>${refunds.size()}</strong> Hồ Sơ Đền Bù
            </span>
        </div>
    </div>

    <!-- Quick Stats Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Hồ Sơ Đã Xử Lý</span>
                    <h4 class="font-serif fw-bold text-success mb-0">100% Hoàn Tất</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-success text-success"><i class="fa-solid fa-circle-check"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Tỷ Lệ Giữ Chân Khách</span>
                    <h4 class="font-serif fw-bold text-gold mb-0">96.8% Hài Lòng</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-hand-holding-heart"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Thời Gian Xử Lý Trung Bình</span>
                    <h4 class="font-serif fw-bold text-primary mb-0">&lt; 15 Phút</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-secondary text-secondary"><i class="fa-solid fa-bolt"></i></div>
            </div>
        </div>
    </div>

    <!-- Refunds Table -->
    <div class="card-luxury p-4 border-gold shadow-lg mb-4">
        <div class="table-responsive">
            <table class="table table-luxury align-middle">
                <thead>
                    <tr>
                        <th>Mã Khiếu Nại</th>
                        <th>Giao Dịch Gốc</th>
                        <th>Số Tiền Đền Bù</th>
                        <th>Lý Do Sự Cố</th>
                        <th>Trạng Thái</th>
                        <th class="text-end">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ref" items="${refunds}">
                        <tr id="refund-row-${ref.id}">
                            <td class="font-accent fw-bold text-gold">${ref.refundCode}</td>
                            <td>
                                <div class="text-primary small font-monospace">${ref.payment != null ? ref.payment.transactionId : 'TXN-DIRECT'}</div>
                                <small class="text-secondary">Phương thức: ${ref.payment != null ? ref.payment.paymentMethod : 'VIETQR'}</small>
                            </td>
                            <td>
                                <span class="text-danger fw-bold fs-6">
                                    <fmt:formatNumber value="${ref.amount}" pattern="#,##0"/> VNĐ
                                </span>
                            </td>
                            <td>
                                <div class="text-primary small" style="max-width: 400px;">${ref.reason}</div>
                            </td>
                            <td>
                                <span class="badge ${ref.status == 'REFUNDED' ? 'bg-success-subtle text-success border border-success' : 'bg-warning-subtle text-warning border border-warning'} px-2 py-1">
                                    ${ref.status == 'REFUNDED' ? '✅ Đã Hoàn Tiền' : '⏳ Đang Xác Minh'}
                                </span>
                            </td>
                            <td class="text-end">
                                <c:if test="${ref.status != 'REFUNDED'}">
                                    <button type="button" class="btn btn-outline-success btn-sm rounded-pill px-3 font-accent" onclick="updateRefundStatus(${ref.id}, 'REFUNDED')">
                                        <i class="fa-solid fa-check me-1"></i> Duyệt Hoàn Tiền
                                    </button>
                                </c:if>
                                <c:if test="${ref.status == 'REFUNDED'}">
                                    <span class="text-secondary small font-accent"><i class="fa-solid fa-circle-check text-success me-1"></i> Đã đền bù điểm</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function updateRefundStatus(id, status) {
            if (!confirm('Xác nhận duyệt hoàn tiền cho khách hàng?')) return;
            fetch('${pageContext.request.contextPath}/admin/refunds/' + id + '/status?status=' + status, {
                method: 'POST'
            }).then(res => res.json()).then(data => {
                if (data.success) {
                    location.reload();
                }
            }).catch(err => console.error(err));
        }
    </script>
</body>
