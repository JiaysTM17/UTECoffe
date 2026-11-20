<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>KDS Pha Chế - Chi Nhánh ${store.name}</title>
</head>
<body>
    <div class="container-fluid">
        <div class="row g-3" id="kdsOrdersContainer">
            <c:forEach var="ord" items="${activeOrders}">
                <div class="col-lg-3 col-md-6" id="order-card-${ord.id}">
                    <div class="card bg-dark text-white border-warning h-100 shadow">
                        <div class="card-header d-flex justify-content-between align-items-center bg-black border-warning">
                            <span class="fw-bold text-warning">#${ord.orderCode}</span>
                            <span class="badge ${ord.status == 'PREPARING' ? 'bg-danger' : 'bg-primary'}">${ord.status}</span>
                        </div>
                        <div class="card-body">
                            <p class="small text-muted mb-2">Loại đơn: <strong>${ord.orderType}</strong></p>
                            <p class="small text-muted mb-2">Ghi chú: ${ord.note}</p>
                            <hr class="border-secondary">
                            <div class="d-grid gap-2 mt-3">
                                <c:if test="${ord.status == 'CONFIRMED'}">
                                    <button class="btn btn-warning btn-sm fw-bold" onclick="updateStatus(${ord.id}, 'PREPARING')">
                                        <i class="fa-solid fa-fire me-1"></i> Bắt Đầu Pha Chế
                                    </button>
                                </c:if>
                                <c:if test="${ord.status == 'PREPARING'}">
                                    <button class="btn btn-success btn-sm fw-bold" onclick="updateStatus(${ord.id}, 'READY')">
                                        <i class="fa-solid fa-check me-1"></i> Hoàn Thành Món
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <script>
        const storeId = ${store.id};
        const socket = new SockJS('${pageContext.request.contextPath}/ws-utecoffe');
        const stompClient = Stomp.over(socket);

        stompClient.connect({}, function (frame) {
            console.log('Connected to KDS WebSocket: ' + frame);
            stompClient.subscribe('/topic/kds/' + storeId, function (message) {
                const payload = JSON.parse(message.body);
                // Reload on new order or status update
                window.location.reload();
            });
        });

        async function updateStatus(orderId, status) {
            try {
                let res = await fetch('${pageContext.request.contextPath}/api/kds/orders/' + orderId + '/status?status=' + status, {
                    method: 'POST'
                });
                let data = await res.json();
                if (data.success) {
                    window.location.reload();
                }
            } catch (err) {
                alert('Lỗi cập nhật: ' + err);
            }
        }
    </script>
</body>
