<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Theo Dõi Đơn Hàng #${order.orderCode} - UTECoffe Specialty Roastery</title>
</head>
<body class="bg-obsidian">

    <!-- Header Section -->
    <div class="py-5 bg-espresso border-bottom border-gold text-center">
        <div class="container py-2">
            <span class="badge bg-gold-subtle text-gold px-3 py-1 rounded-pill small font-accent mb-2 text-uppercase" style="letter-spacing: 0.12em;">
                <i class="fa-solid fa-satellite-dish me-1 fa-fade"></i> TRUYỀN DỮ LIỆU THỜI GIAN THỰC (WEBSOCKET)
            </span>
            <h1 class="font-serif display-5 fw-bold text-gold-gradient mb-2">
                Hành Trình Tách Cà Phê Của Bạn
            </h1>
            <p class="text-secondary mx-auto small mb-0" style="max-width: 600px;">
                Mã Đơn Hàng: <span class="text-gold fw-bold font-monospace fs-6">#${order.orderCode}</span> • Đặt lúc: <span class="text-light"><fmt:formatDate value="${order.createdAt}" pattern="HH:mm - dd/MM/yyyy"/></span>
            </p>
        </div>
    </div>

    <!-- Main Order Tracker Container -->
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">

                <!-- 4-Stage Luxury Status Stepper Card -->
                <div class="card-luxury p-4 p-md-5 mb-4 shadow-lg">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom border-gold flex-wrap gap-2">
                        <div>
                            <span class="small text-secondary text-uppercase font-accent" style="letter-spacing: 0.08em;">Trạng Thái Hiện Tại</span>
                            <h4 class="font-serif fw-bold text-gold mb-0 mt-1 d-flex align-items-center gap-2">
                                <span class="spinner-grow spinner-grow-sm text-gold" role="status"></span>
                                <span id="currentStatusText">${order.status}</span>
                            </h4>
                        </div>
                        <div class="text-md-end">
                            <span class="small text-secondary d-block">Dự kiến hoàn tất trong:</span>
                            <span class="badge bg-espresso border border-gold text-gold fs-6 px-3 py-2 rounded-pill font-monospace" id="estimatedTimeBadge">
                                <i class="fa-regular fa-clock me-1"></i> ~15 - 25 Phút
                            </span>
                        </div>
                    </div>

                    <!-- Visual Timeline Stepper -->
                    <div class="order-stepper-wrap py-4">
                        <div class="stepper-track-bg"></div>
                        <div class="stepper-track-progress" id="stepperProgressBar" style="width: 25%;"></div>

                        <div class="row text-center position-relative g-0" style="z-index: 2;">
                            <!-- Step 1: Order Placed -->
                            <div class="col-3 stepper-step" id="step-PENDING">
                                <div class="step-circle active mx-auto mb-2">
                                    <i class="fa-solid fa-clipboard-check"></i>
                                </div>
                                <div class="step-label fw-bold font-accent text-gold small">Tiếp Nhận</div>
                                <div class="step-sub text-secondary small d-none d-md-block" style="font-size: 0.75rem;">Hệ thống xác nhận</div>
                            </div>

                            <!-- Step 2: Barista Crafting -->
                            <div class="col-3 stepper-step" id="step-PREPARING">
                                <div class="step-circle mx-auto mb-2">
                                    <i class="fa-solid fa-mug-hot"></i>
                                </div>
                                <div class="step-label fw-bold font-accent small text-secondary">Pha Chế</div>
                                <div class="step-sub text-secondary small d-none d-md-block" style="font-size: 0.75rem;">Barista chiết xuất</div>
                            </div>

                            <!-- Step 3: Shipping / Ready -->
                            <div class="col-3 stepper-step" id="step-SHIPPING">
                                <div class="step-circle mx-auto mb-2">
                                    <i class="fa-solid fa-motorcycle"></i>
                                </div>
                                <div class="step-label fw-bold font-accent small text-secondary">Giao Hàng</div>
                                <div class="step-sub text-secondary small d-none d-md-block" style="font-size: 0.75rem;">Đang trên đường tới</div>
                            </div>

                            <!-- Step 4: Delivered -->
                            <div class="col-3 stepper-step" id="step-COMPLETED">
                                <div class="step-circle mx-auto mb-2">
                                    <i class="fa-solid fa-champagne-glasses"></i>
                                </div>
                                <div class="step-label fw-bold font-accent small text-secondary">Thưởng Thức</div>
                                <div class="step-sub text-secondary small d-none d-md-block" style="font-size: 0.75rem;">Giao thành công</div>
                            </div>
                        </div>
                    </div>

                    <!-- Real-Time Activity Log Card -->
                    <div class="p-3 bg-espresso rounded-3 border border-gold-subtle d-flex align-items-center gap-3 mt-3">
                        <div class="text-gold fs-3 ps-2">
                            <i class="fa-solid fa-circle-info"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-bold text-light small" id="statusMessageHeader">Thông điệp từ quầy Barista:</div>
                            <div class="text-secondary small" id="statusDescText">
                                Đơn hàng #${order.orderCode} đã được chuyển tới máy in hóa đơn quầy Barista chi nhánh ${order.store.name}.
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order Details & Shipping Info Row -->
                <div class="row g-4">
                    <!-- Left: Items Ordered -->
                    <div class="col-lg-7">
                        <div class="card-luxury p-4 h-100">
                            <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">
                                <i class="fa-solid fa-receipt me-2"></i>Chi Tiết Thức Uống Đã Đặt
                            </h5>

                            <div class="table-responsive">
                                <table class="table table-luxury align-middle mb-0">
                                    <thead>
                                        <tr class="small text-secondary">
                                            <th>Thức Uống</th>
                                            <th class="text-center">Số Lượng</th>
                                            <th class="text-end">Thành Tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${order.items}">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold font-serif text-light">${item.product.name}</div>
                                                    <small class="text-gold d-block">
                                                        Size: ${item.productSize.name} • ${item.sugarLevel}% Đường • ${item.iceLevel}% Đá
                                                    </small>
                                                </td>
                                                <td class="text-center font-monospace fw-bold">${item.quantity}</td>
                                                <td class="text-end fw-bold text-gold">
                                                    <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <hr class="border-secondary opacity-25 my-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-bold">Tổng Thanh Toán:</span>
                                <span class="price-gold fs-4">
                                    <fmt:formatNumber value="${order.finalAmount}" type="currency" currencySymbol="₫"/>
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Delivery Details & Store Info -->
                    <div class="col-lg-5">
                        <div class="card-luxury p-4 h-100 d-flex flex-column justify-content-between">
                            <div>
                                <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">
                                    <i class="fa-solid fa-location-crosshairs me-2"></i>Thông Tin Giao Nhận
                                </h5>

                                <div class="mb-3">
                                    <span class="small text-secondary d-block mb-1">Người nhận:</span>
                                    <div class="fw-bold text-light">${order.recipientName}</div>
                                    <div class="small text-gold font-monospace"><i class="fa-solid fa-phone me-1"></i>${order.recipientPhone}</div>
                                </div>

                                <div class="mb-3">
                                    <span class="small text-secondary d-block mb-1">Địa chỉ giao:</span>
                                    <div class="small text-light">
                                        <i class="fa-solid fa-house-chimney text-gold me-1"></i>
                                        ${not empty order.deliveryAddress ? order.deliveryAddress : 'Nhận trực tiếp tại quầy UTECoffe Roastery'}
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <span class="small text-secondary d-block mb-1">Chi nhánh chế biến:</span>
                                    <div class="small text-light fw-bold">${order.store.name}</div>
                                    <div class="small text-secondary">${order.store.address}</div>
                                </div>

                                <div class="mb-3">
                                    <span class="small text-secondary d-block mb-1">Phương thức thanh toán:</span>
                                    <span class="badge bg-gold-subtle text-gold border border-gold-subtle px-2 py-1 rounded-pill">
                                        <i class="fa-solid fa-credit-card me-1"></i> ${order.paymentMethod}
                                    </span>
                                </div>
                            </div>

                            <div class="pt-3 border-top border-gold mt-4 d-flex gap-2">
                                <a href="tel:19002026" class="btn btn-outline-gold btn-sm flex-grow-1">
                                    <i class="fa-solid fa-headset me-1"></i> Gọi Hotline CSKH
                                </a>
                                <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold btn-sm flex-grow-1">
                                    <i class="fa-solid fa-mug-saucer me-1"></i> Đặt Thêm Món
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Embedded CSS for Stepper -->
    <style>
        .order-stepper-wrap {
            position: relative;
            margin: 1.5rem 0;
        }
        .stepper-track-bg {
            position: absolute;
            top: 25px;
            left: 12.5%;
            right: 12.5%;
            height: 4px;
            background: rgba(212, 175, 55, 0.2);
            z-index: 1;
            border-radius: 4px;
        }
        .stepper-track-progress {
            position: absolute;
            top: 25px;
            left: 12.5%;
            height: 4px;
            background: var(--gold-gradient);
            z-index: 1;
            border-radius: 4px;
            transition: width 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .step-circle {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--bg-card);
            border: 2px solid rgba(212, 175, 55, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.15rem;
            color: var(--text-secondary);
            transition: all 0.4s ease;
            position: relative;
        }
        .step-circle.active {
            border-color: var(--text-gold);
            background: var(--gold-gradient);
            color: #0b0908 !important;
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.45);
            transform: scale(1.1);
        }
        .step-circle.completed {
            border-color: #28a745;
            background: #28a745;
            color: #ffffff;
        }
    </style>

    <!-- SockJS and STOMP WebSocket Live Connection -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const orderCode = '${order.orderCode}';
            const initialStatus = '${order.status}';

            function updateStepperUI(status) {
                const stepPending = document.getElementById('step-PENDING');
                const stepPreparing = document.getElementById('step-PREPARING');
                const stepShipping = document.getElementById('step-SHIPPING');
                const stepCompleted = document.getElementById('step-COMPLETED');
                const progressBar = document.getElementById('stepperProgressBar');
                const statusBadge = document.getElementById('currentStatusText');

                if (statusBadge) statusBadge.innerText = status;

                // Reset all
                [stepPending, stepPreparing, stepShipping, stepCompleted].forEach(step => {
                    if (!step) return;
                    const circle = step.querySelector('.step-circle');
                    const label = step.querySelector('.step-label');
                    if (circle) circle.className = 'step-circle mx-auto mb-2';
                    if (label) label.className = 'step-label fw-bold font-accent small text-secondary';
                });

                let progressWidth = '12.5%';
                if (status === 'PENDING' || status === 'CONFIRMED' || status === 'PAID') {
                    progressWidth = '12.5%';
                    setStepState(stepPending, 'active');
                } else if (status === 'PREPARING' || status === 'PROCESSING') {
                    progressWidth = '37.5%';
                    setStepState(stepPending, 'completed');
                    setStepState(stepPreparing, 'active');
                } else if (status === 'SHIPPING' || status === 'READY') {
                    progressWidth = '62.5%';
                    setStepState(stepPending, 'completed');
                    setStepState(stepPreparing, 'completed');
                    setStepState(stepShipping, 'active');
                } else if (status === 'COMPLETED' || status === 'DELIVERED') {
                    progressWidth = '75%';
                    setStepState(stepPending, 'completed');
                    setStepState(stepPreparing, 'completed');
                    setStepState(stepShipping, 'completed');
                    setStepState(stepCompleted, 'active');
                }

                if (progressBar) progressBar.style.width = progressWidth;
            }

            function setStepState(stepEl, state) {
                if (!stepEl) return;
                const circle = stepEl.querySelector('.step-circle');
                const label = stepEl.querySelector('.step-label');
                if (circle) {
                    circle.classList.add(state);
                }
                if (label) {
                    label.classList.remove('text-secondary');
                    label.classList.add('text-gold');
                }
            }

            // Init stepper
            updateStepperUI(initialStatus);

            // Connect to WebSocket STOMP
            try {
                const socket = new SockJS('${pageContext.request.contextPath}/ws-utecoffe');
                const stompClient = Stomp.over(socket);
                stompClient.debug = null; // Suppress noisy logs

                stompClient.connect({}, function (frame) {
                    stompClient.subscribe('/topic/order/' + orderCode, function (message) {
                        try {
                            const payload = JSON.parse(message.body);
                            if (payload.status) {
                                updateStepperUI(payload.status);
                            }
                            if (payload.message) {
                                const descEl = document.getElementById('statusDescText');
                                if (descEl) descEl.innerText = payload.message;
                            }
                        } catch (e) {
                            console.error('Error parsing STOMP message:', e);
                        }
                    });
                }, function (error) {
                    console.warn('STOMP connection failed, continuing in fallback mode:', error);
                });
            } catch (err) {
                console.warn('WebSocket init exception:', err);
            }
        });
    </script>
</body>
