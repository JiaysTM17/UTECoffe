<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Thanh Toán Đơn Hàng - UTECoffe Specialty Roastery</title>
</head>
<body class="bg-obsidian">

    <!-- Header Banner: Compact & Balanced -->
    <div class="py-3 bg-espresso border-bottom border-gold text-center">
        <div class="container py-1">
            <span class="badge bg-gold-subtle text-gold px-2.5 py-0.5 rounded-pill small font-accent mb-1 text-uppercase" style="letter-spacing: 0.1em; font-size: 0.72rem;" data-i18n="checkout.badge">
                <i class="fa-solid fa-lock me-1"></i> BẢO MẬT &amp; CHÍNH XÁC
            </span>
            <h1 class="font-serif fs-4 fw-bold text-gold-gradient mb-1" data-i18n="checkout.title">
                Xác Nhận Đơn Hàng
            </h1>
            <p class="text-secondary mx-auto small mb-0" style="max-width: 540px; font-size: 0.82rem;" data-i18n="checkout.desc">
                Quý khách vui lòng kiểm tra kỹ thông tin nhận hàng và phương thức thanh toán trước khi hoàn tất.
            </p>
        </div>
    </div>

    <!-- Main Container: Centered & Bounded to Prevent Stretched/Drifting Layout on Wide Screens -->
    <div class="container py-4" style="max-width: 1140px; margin: 0 auto;">
        <form action="${pageContext.request.contextPath}/checkout/place-order" method="post" id="checkoutForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="row g-3">
                <!-- Left Column: Shipping Info & Payment Gateways -->
                <div class="col-lg-7">
                    <!-- Method Selector -->
                    <div class="card-luxury p-3 p-md-3.5 mb-3">
                        <h6 class="font-serif fw-bold text-gold-gradient mb-2.5 border-bottom border-gold pb-2" style="font-size: 0.98rem;">
                            <i class="fa-solid fa-truck-fast me-1.5"></i><span data-i18n="checkout.step1">1. Phương Thức Nhận Thức Uống</span>
                        </h6>

                        <div class="row g-2 mb-3">
                            <div class="col-sm-6">
                                <input type="radio" class="btn-check" name="orderType" id="typeDelivery" value="DELIVERY" checked>
                                <label class="delivery-option-btn py-2.5 px-2" for="typeDelivery">
                                    <i class="fa-solid fa-motorcycle fs-4 mb-1 text-gold"></i>
                                    <span class="fw-bold font-accent d-block text-gold" style="font-size: 0.88rem;" data-i18n="checkout.delivery">GIAO TẬN NƠI</span>
                                    <small class="text-secondary d-block mt-0.5" style="font-size: 0.72rem;" data-i18n="checkout.delivery_hint">Siêu tốc 20 - 35 phút</small>
                                </label>
                            </div>
                            <div class="col-sm-6">
                                <input type="radio" class="btn-check" name="orderType" id="typeTakeaway" value="TAKE_AWAY">
                                <label class="delivery-option-btn py-2.5 px-2" for="typeTakeaway">
                                    <i class="fa-solid fa-store fs-4 mb-1 text-gold"></i>
                                    <span class="fw-bold font-accent d-block text-gold" style="font-size: 0.88rem;" data-i18n="checkout.takeaway">LẤY TẠI QUÁN</span>
                                    <small class="text-secondary d-block mt-0.5" style="font-size: 0.72rem;" data-i18n="checkout.takeaway_hint">Chuẩn bị sẵn không chờ</small>
                                </label>
                            </div>
                        </div>

                        <!-- Store Branch Selection with Geolocation Detection -->
                        <div class="mb-2.5">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label class="form-label small text-gold fw-bold mb-0" style="font-size: 0.78rem;" data-i18n="checkout.store_label">Chi Nhánh Chế Biến Thức Uống:</label>
                                <button type="button" class="btn btn-outline-gold btn-sm py-0 px-2 rounded-pill font-accent" style="font-size: 0.7rem;" onclick="detectNearestStore()">
                                    <i class="fa-solid fa-location-crosshairs text-gold me-1"></i> <span data-i18n="checkout.gps_btn">Định Vị Gần Nhất</span>
                                </button>
                            </div>
                            <select class="form-select form-control-luxury text-truncate" name="storeId" id="storeSelect" style="font-size: 0.82rem;" required>
                                <option value="1">UTECoffe Flagship Thủ Đức - 01 Võ Văn Ngân, P. Linh Chiểu, TP. Thủ Đức</option>
                                <option value="2">UTECoffe Roastery Quận 1 - 68 Lê Lợi, P. Bến Nghé, Quận 1</option>
                                <option value="3">UTECoffe Garden Bình Thạnh - 180 Ung Văn Khiêm, Phường 25, Q. Bình Thạnh, TP.HCM</option>
                            </select>
                            <div id="nearestStoreNotice" class="small text-gold mt-1 d-none" style="font-size: 0.75rem;">
                                <i class="fa-solid fa-circle-check me-1 text-success"></i> <span id="nearestStoreText"></span>
                            </div>
                            <input type="hidden" name="idempotencyKey" id="idempotencyKeyInput" value="">
                        </div>

                        <!-- Recipient Name & Phone -->
                        <div class="row g-2 mb-2.5">
                            <div class="col-md-6">
                                <label class="form-label small text-gold fw-bold mb-1" style="font-size: 0.78rem;" data-i18n="checkout.name_label">Họ và Tên Quý Khách:</label>
                                <input type="text" class="form-control form-control-luxury" style="font-size: 0.82rem;" name="recipientName" placeholder="Ví dụ: Nguyễn Văn An" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small text-gold fw-bold mb-1" style="font-size: 0.78rem;" data-i18n="checkout.phone_label">Số Điện Thoại Nhận Hàng:</label>
                                <input type="tel" class="form-control form-control-luxury" style="font-size: 0.82rem;" name="recipientPhone" placeholder="Ví dụ: 0901234567" required>
                            </div>
                        </div>

                        <!-- Delivery Address Group -->
                        <div class="mb-2.5" id="deliveryAddressGroup">
                            <label class="form-label small text-gold fw-bold mb-1" style="font-size: 0.78rem;" data-i18n="checkout.addr_label">Địa Chỉ Giao Tận Tay:</label>
                            <input type="text" class="form-control form-control-luxury" style="font-size: 0.82rem;" name="deliveryAddress" placeholder="Số nhà, tên đường, phường/xã, quận/huyện...">
                            <small class="text-secondary" style="font-size: 0.72rem;">
                                <i class="fa-solid fa-circle-info text-gold me-1"></i> <span data-i18n="checkout.shipper_hint">Shipper sẽ gọi điện trước khi giao 5 - 10 phút.</span>
                            </small>
                        </div>

                        <!-- Notes for Barista -->
                        <div>
                            <label class="form-label small text-gold fw-bold mb-1" style="font-size: 0.78rem;" data-i18n="checkout.note_label">Ghi Chú Cho Barista / Shipper:</label>
                            <textarea class="form-control form-control-luxury" style="font-size: 0.82rem;" name="note" rows="2" placeholder="Ví dụ: Giao lên lầu 3, để đá riêng, ít ngọt..."></textarea>
                        </div>
                    </div>

                    <!-- Payment Gateways Selection -->
                    <div class="card-luxury p-3 p-md-3.5">
                        <h6 class="font-serif fw-bold text-gold-gradient mb-2.5 border-bottom border-gold pb-2" style="font-size: 0.98rem;">
                            <i class="fa-solid fa-credit-card me-1.5"></i><span data-i18n="checkout.step2">2. Cổng Thanh Toán An Toàn</span>
                        </h6>

                        <div class="d-flex flex-column gap-2">
                            <!-- VietQR Dynamic -->
                            <label class="p-2.5 rounded-3 d-flex align-items-center gap-2.5 cursor-pointer payment-option-card">
                                <input type="radio" name="paymentMethod" value="VIETQR" checked class="form-check-input flex-shrink-0 mt-0">
                                <div class="flex-grow-1">
                                    <div class="fw-bold d-flex align-items-center gap-2 flex-wrap" style="font-size: 0.85rem;">
                                        <i class="fa-solid fa-qrcode text-gold"></i>
                                        <span>Chuyển Khoản Ngân Hàng (VietQR Động Trực Tiếp)</span>
                                        <span class="badge bg-gold text-obsidian small px-2 py-0" style="font-size: 0.68rem;">Khuyên dùng</span>
                                    </div>
                                    <small class="text-secondary d-block mt-0.5" style="font-size: 0.74rem;">
                                        Hiển thị mã QR chứa sẵn số tiền và mã đơn ngay trên website. Tự động xác nhận sau khi quét.
                                    </small>
                                </div>
                            </label>

                            <!-- VNPay In-App QR -->
                            <label class="p-2.5 rounded-3 d-flex align-items-center gap-2.5 cursor-pointer payment-option-card">
                                <input type="radio" name="paymentMethod" value="VNPAY" class="form-check-input flex-shrink-0 mt-0">
                                <div class="flex-grow-1">
                                    <div class="fw-bold d-flex align-items-center gap-2 flex-wrap" style="font-size: 0.85rem;">
                                        <i class="fa-solid fa-wallet text-gold"></i>
                                        <span>Cổng VNPay-QR (Quét mã trực tiếp trên Web)</span>
                                        <span class="badge bg-espresso border border-gold text-gold small px-2 py-0" style="font-size: 0.68rem;">Không chuyển hướng</span>
                                    </div>
                                    <small class="text-secondary d-block mt-0.5" style="font-size: 0.74rem;">
                                        Tạo mã QR thanh toán an toàn trực tiếp trên giao diện website UTECoffe, hỗ trợ tất cả App ngân hàng.
                                    </small>
                                </div>
                            </label>

                            <!-- MoMo In-App QR -->
                            <label class="p-2.5 rounded-3 d-flex align-items-center gap-2.5 cursor-pointer payment-option-card">
                                <input type="radio" name="paymentMethod" value="MOMO" class="form-check-input flex-shrink-0 mt-0">
                                <div class="flex-grow-1">
                                    <div class="fw-bold d-flex align-items-center gap-2 flex-wrap" style="font-size: 0.85rem;">
                                        <i class="fa-solid fa-mobile-screen-button text-gold"></i>
                                        <span>Ví Điện Tử MoMo QR (Trực Tiếp Trên Web)</span>
                                    </div>
                                    <small class="text-secondary d-block mt-0.5" style="font-size: 0.74rem;">
                                        Mở app MoMo quét mã QR động được tạo ngay trên đơn hàng để hoàn tất thanh toán.
                                    </small>
                                </div>
                            </label>

                            <!-- COD -->
                            <label class="p-2.5 rounded-3 d-flex align-items-center gap-2.5 cursor-pointer payment-option-card">
                                <input type="radio" name="paymentMethod" value="COD" class="form-check-input flex-shrink-0 mt-0">
                                <div class="flex-grow-1">
                                    <div class="fw-bold d-flex align-items-center gap-2 flex-wrap" style="font-size: 0.85rem;">
                                        <i class="fa-solid fa-money-bill-wave text-gold"></i>
                                        <span>Tiền Mặt Khi Nhận Hàng (COD)</span>
                                    </div>
                                    <small class="text-secondary d-block mt-0.5" style="font-size: 0.74rem;">
                                        Thanh toán tiền mặt trực tiếp cho nhân viên giao hàng khi nhận thức uống tận tay.
                                    </small>
                                </div>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Order Review & Submit (Balanced Height & Content) -->
                <div class="col-lg-5">
                    <div class="card-luxury p-3 p-md-3.5 sticky-top" style="top: 85px;">
                        <h6 class="font-serif fw-bold text-gold-gradient mb-2.5 border-bottom border-gold pb-2" style="font-size: 0.98rem;">
                            <i class="fa-solid fa-bag-shopping me-1.5"></i>Đơn Hàng Thưởng Thức <c:if test="${not empty cart and not empty cart.items}">(${cart.items.size()} món)</c:if>
                        </h6>

                        <!-- Item Review List in Summary -->
                        <c:if test="${not empty cart and not empty cart.items}">
                            <div class="mb-3 pe-1 border-bottom border-secondary border-opacity-25" style="max-height: 240px; overflow-y: auto;">
                                <c:forEach var="item" items="${cart.items}">
                                    <div class="d-flex align-items-center justify-content-between py-2 border-bottom border-dark">
                                        <div class="d-flex align-items-center gap-2 overflow-hidden">
                                            <img src="${not empty item.product.imageUrl ? item.product.imageUrl : 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=200&q=80'}" 
                                                 class="rounded-2 border border-gold-subtle object-fit-cover flex-shrink-0" 
                                                 style="width: 44px; height: 44px;" 
                                                 alt="${item.product.name}">
                                            <div class="text-truncate">
                                                <div class="text-light fw-bold text-truncate" style="font-size: 0.86rem;">${item.product.name}</div>
                                                <small class="text-gold d-block" style="font-size: 0.72rem;">
                                                    Size: ${item.productSize.name} • SL: ${item.quantity}
                                                </small>
                                            </div>
                                        </div>
                                        <div class="price-gold font-monospace fw-bold text-end flex-shrink-0 ps-2" style="font-size: 0.84rem;">
                                            <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> VNĐ
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <!-- Cost Breakdown -->
                        <div class="mb-2.5">
                            <div class="d-flex justify-content-between small text-secondary mb-1.5" style="font-size: 0.82rem;">
                                <span>Tạm tính thức uống:</span>
                                <span class="text-light fw-bold font-monospace">
                                    <fmt:formatNumber value="${not empty cart ? cart.totalAmount : 125000}" pattern="#,##0"/> VNĐ
                                </span>
                            </div>
                            <div class="d-flex justify-content-between small text-secondary mb-1.5" style="font-size: 0.82rem;">
                                <span>Phí vận chuyển:</span>
                                <c:choose>
                                    <c:when test="${not empty cart and cart.shippingFee == 0}">
                                        <span class="text-success fw-bold">Miễn Phí</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-light fw-bold font-monospace">
                                            <fmt:formatNumber value="${not empty cart ? cart.shippingFee : 15000}" pattern="#,##0"/> VNĐ
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="d-flex justify-content-between small text-secondary mb-1.5" style="font-size: 0.82rem;">
                                <span>Ưu đãi áp dụng:</span>
                                <span class="text-gold font-monospace fw-bold">
                                    -<fmt:formatNumber value="${not empty cart ? cart.discountAmount : 0}" pattern="#,##0"/> VNĐ
                                </span>
                            </div>
                        </div>

                        <hr class="border-secondary opacity-25 my-2">

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="fw-bold" style="font-size: 0.92rem;">Tổng Thanh Toán:</span>
                            <span class="price-gold fs-4 fw-bold">
                                <fmt:formatNumber value="${not empty cart ? cart.finalAmount : 125000}" pattern="#,##0"/> VNĐ
                            </span>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn btn-gold w-100 py-2.5 fw-bold fs-6 rounded-pill shadow-gold" id="submitOrderBtn">
                            <i class="fa-solid fa-lock me-1.5"></i> Xác Nhận &amp; Đặt Hàng
                        </button>

                        <div class="text-center mt-2.5">
                            <small class="text-secondary" style="font-size: 0.72rem;">
                                Bằng việc bấm đặt hàng, quý khách đồng ý với <a href="${pageContext.request.contextPath}/policy/terms" target="_blank" class="text-gold text-decoration-none hover-gold">Điều khoản dịch vụ</a> của UTECoffe.
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- Toggle Delivery Address, Idempotency & Geolocation Script -->
    <script>
        // Generate UUID v4 for strict Idempotency Key
        function generateUUID() {
            return 'idemp-' + 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
                return v.toString(16);
            });
        }

        // Automatic Store Detection using Geolocation API
        function detectNearestStore() {
            const noticeEl = document.getElementById('nearestStoreNotice');
            const textEl = document.getElementById('nearestStoreText');
            const storeSelect = document.getElementById('storeSelect');

            if (!navigator.geolocation) {
                alert('Trình duyệt của bạn không hỗ trợ định vị địa lý.');
                return;
            }

            if (noticeEl) {
                noticeEl.classList.remove('d-none');
                textEl.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-1"></i> Đang tìm chi nhánh gần vị trí của bạn nhất...';
            }

            navigator.geolocation.getCurrentPosition(function (position) {
                const lat = position.coords.latitude;
                const lng = position.coords.longitude;

                fetch('${pageContext.request.contextPath}/api/stores/nearest?lat=' + lat + '&lng=' + lng)
                    .then(res => res.json())
                    .then(data => {
                        if (data.success && data.data && data.data.length > 0) {
                            const nearest = data.data[0];
                            if (storeSelect) {
                                storeSelect.value = nearest.store.id;
                            }
                            if (textEl) {
                                textEl.innerHTML = 'Đã chọn chi nhánh gần bạn nhất: <strong>' + nearest.store.name + '</strong> (Khoảng cách: <strong>' + nearest.formattedDistance + '</strong> • Dự kiến: <strong>' + nearest.estimatedDeliveryMinutes + ' phút</strong>)';
                            }
                        }
                    })
                    .catch(() => {
                        if (textEl) textEl.textContent = 'Mặc định chọn Flagship Thủ Đức.';
                    });
            }, function (error) {
                if (textEl) {
                    textEl.textContent = 'Chưa thể lấy vị trí GPS (vui lòng chọn chi nhánh thủ công).';
                }
            }, { timeout: 10000 });
        }

        document.addEventListener('DOMContentLoaded', function () {
            // Set Idempotency Key on load
            const keyInput = document.getElementById('idempotencyKeyInput');
            if (keyInput && !keyInput.value) {
                keyInput.value = generateUUID();
            }

            const typeDelivery = document.getElementById('typeDelivery');
            const typeTakeaway = document.getElementById('typeTakeaway');
            const addressGroup = document.getElementById('deliveryAddressGroup');
            const checkoutForm = document.getElementById('checkoutForm');
            const submitBtn = document.getElementById('submitOrderBtn');

            function toggleAddress() {
                if (typeTakeaway && typeTakeaway.checked) {
                    if (addressGroup) addressGroup.classList.add('d-none');
                } else {
                    if (addressGroup) addressGroup.classList.remove('d-none');
                }
            }

            if (typeDelivery) typeDelivery.addEventListener('change', toggleAddress);
            if (typeTakeaway) typeTakeaway.addEventListener('change', toggleAddress);

            // Double-Submit Protection (Idempotency UI Shield)
            let isSubmitting = false;
            if (checkoutForm) {
                checkoutForm.addEventListener('submit', function (e) {
                    if (isSubmitting) {
                        e.preventDefault();
                        return false;
                    }
                    isSubmitting = true;
                    if (submitBtn) {
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-2"></i> Đang Bảo Mật & Xác Nhận Đơn Hàng...';
                    }
                });
            }
        });
    </script>
</body>
