<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Màn Hình Pha Chế KDS - ${store.name}</title>
</head>
<body>
    <!-- Top Filter & Controls Strip -->
    <div class="d-flex justify-content-between align-items-center mb-3 p-3 bg-espresso border border-gold rounded-3">
        <div>
            <h5 class="font-serif fw-bold text-gold-gradient mb-0"><i class="fa-solid fa-mug-saucer me-2"></i>Hàng Đợi Chế Biến: ${store.name}</h5>
            <small class="text-muted">Đơn hàng tự động đồng bộ qua WebSocket STOMP</small>
        </div>
        <div class="d-flex gap-3 align-items-center">
            <span class="badge bg-dark-roast border border-gold text-gold fs-6 px-3 py-2">
                Đang chờ: <strong class="text-light">${not empty activeOrders ? activeOrders.size() : 0}</strong> vé
            </span>
        </div>
    </div>

    <!-- KDS Ticket Grid -->
    <div class="row g-3" id="kdsTicketGrid">
        <c:choose>
            <c:when test="${not empty activeOrders}">
                <c:forEach var="ord" items="${activeOrders}">
                    <div class="col-xxl-3 col-xl-4 col-md-6" id="ticket-${ord.id}">
                        <div class="card card-luxury h-100 border-gold shadow-lg">
                            <div class="card-header bg-dark-roast border-bottom border-gold d-flex justify-content-between align-items-center py-2 px-3">
                                <span class="font-accent fw-bold text-gold fs-5">#${ord.orderCode}</span>
                                <span class="badge bg-warning text-dark font-accent fw-bold">${ord.orderType}</span>
                            </div>
                            <div class="card-body p-3">
                                <div class="small text-muted mb-2">Khách: <strong>${ord.recipientName}</strong> (${ord.recipientPhone})</div>
                                <c:if test="${not empty ord.note}">
                                    <div class="alert alert-warning py-1 px-2 small mb-2 border-0 bg-warning-subtle text-dark">
                                        <i class="fa-solid fa-note-sticky me-1"></i> Ghi chú: ${ord.note}
                                    </div>
                                </c:if>
                                <div class="border-top border-secondary opacity-50 my-2"></div>
                                
                                <ul class="list-unstyled mb-0">
                                    <c:forEach var="item" items="${ord.items}">
                                        <li class="py-2 border-bottom border-secondary border-opacity-25 d-flex justify-content-between align-items-start">
                                            <div>
                                                <div class="fw-bold text-light">${item.quantity}x ${item.product.name}</div>
                                                <small class="text-gold">${item.productSize.name} • ${item.sugarLevel}% Đường • ${item.iceLevel}% Đá</small>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                            <div class="card-footer bg-dark-roast border-top border-gold p-2 d-flex gap-2">
                                <button class="btn btn-gold btn-sm flex-grow-1" onclick="updateOrderStatus(${ord.id}, 'COMPLETED')">
                                    <i class="fa-solid fa-check-double me-1"></i> Pha Xong
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12 text-center py-5">
                    <i class="fa-solid fa-champagne-glasses text-gold fs-1 mb-3 d-block opacity-50"></i>
                    <h4 class="font-serif text-secondary">Hàng Đợi Trống</h4>
                    <p class="text-muted small">Hiện tại không có đơn hàng nào cần pha chế tại chi nhánh này.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- STOMP Client Script for Real-time Ticket Addition -->
    <script src="https://cdn.jsdelivr.net/npm/@stomp/stompjs@7.0.0/bundles/stomp.umd.min.js"></script>
    <script>
        function updateOrderStatus(orderId, status) {
            fetch('${pageContext.request.contextPath}/api/barista/orders/' + orderId + '/status?status=' + status, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' }
            }).then(() => {
                const el = document.getElementById('ticket-' + orderId);
                if (el) el.remove();
            }).catch(err => console.error(err));
        }
    </script>
</body>
