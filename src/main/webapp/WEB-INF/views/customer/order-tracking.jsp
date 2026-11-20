<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Theo Dõi Đơn Hàng #${order.orderCode} - UTECoffe</title>
</head>
<body>
    <div class="container py-5">
        <div class="card border-0 shadow-sm p-4 max-w-700 mx-auto">
            <div class="text-center mb-4">
                <span class="badge bg-warning text-dark px-3 py-2 text-uppercase mb-2">Trực Tuyến Thời Gian Thực</span>
                <h3 class="fw-bold">ĐƠN HÀNG #${order.orderCode}</h3>
                <p class="text-muted small">Cập nhật tự động qua kết nối WebSocket STOMP</p>
            </div>

            <!-- Current Status Alert -->
            <div class="alert alert-info d-flex align-items-center mb-4" role="alert">
                <i class="fa-solid fa-spinner fa-spin fs-4 me-3"></i>
                <div>
                    <h6 class="mb-0 fw-bold">Trạng Thái Đơn Hàng: <span id="orderStatusBadge" class="text-primary">${order.status}</span></h6>
                    <small id="statusDescText">Hệ thống đang truyền thông tin trực tiếp tới quầy Barista chi nhánh.</small>
                </div>
            </div>

            <div class="border p-3 rounded-3 mb-4">
                <h6 class="fw-bold mb-3">Chi Tiết Đơn Hàng:</h6>
                <div class="d-flex justify-content-between small mb-2">
                    <span class="text-muted">Chi nhánh:</span>
                    <span class="fw-bold">${order.store.name}</span>
                </div>
                <div class="d-flex justify-content-between small mb-2">
                    <span class="text-muted">Người nhận:</span>
                    <span>${order.recipientName} (${order.recipientPhone})</span>
                </div>
                <div class="d-flex justify-content-between small mb-2">
                    <span class="text-muted">Tổng thanh toán:</span>
                    <span class="text-danger fw-bold fs-6">
                        <fmt:formatNumber value="${order.finalAmount}" type="currency" currencySymbol="₫"/>
                    </span>
                </div>
            </div>

            <div class="text-center">
                <a href="${pageContext.request.contextPath}/" class="btn btn-gold btn-sm px-4">Về Trang Chủ</a>
            </div>
        </div>
    </div>

    <!-- SockJS and STOMP -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script>
        const orderCode = '${order.orderCode}';
        const socket = new SockJS('${pageContext.request.contextPath}/ws-utecoffe');
        const stompClient = Stomp.over(socket);

        stompClient.connect({}, function (frame) {
            console.log('Connected to Order Tracking WebSocket: ' + frame);
            stompClient.subscribe('/topic/order/' + orderCode, function (message) {
                const payload = JSON.parse(message.body);
                document.getElementById('orderStatusBadge').innerText = payload.status;
                document.getElementById('statusDescText').innerText = payload.message || 'Trạng thái đã được cập nhật.';
            });
        });
    </script>
</body>
