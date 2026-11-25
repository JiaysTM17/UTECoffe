<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Thanh Toán Đơn Hàng - UTECoffe Specialty Roastery</title>
</head>
<body class="bg-obsidian">

    <!-- Header Banner -->
    <div class="py-5 bg-espresso border-bottom border-gold text-center">
        <div class="container py-2">
            <span class="badge bg-gold-subtle text-gold px-3 py-1 rounded-pill small font-accent mb-2 text-uppercase" style="letter-spacing: 0.12em;" data-i18n="checkout.badge">
                <i class="fa-solid fa-lock me-1"></i> BẢO MẬT &amp; CHÍNH XÁC
            </span>
            <h1 class="font-serif display-5 fw-bold text-gold-gradient mb-2" data-i18n="checkout.title">
                Xác Nhận Đơn Hàng
            </h1>
            <p class="text-secondary mx-auto small mb-0" style="max-width: 600px;" data-i18n="checkout.desc">
                Quý khách vui lòng kiểm tra kỹ thông tin nhận hàng và phương thức thanh toán trước khi hoàn tất.
            </p>
        </div>
    </div>

    <div class="container py-5">
        <form action="${pageContext.request.contextPath}/api/orders" method="post" id="checkoutForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="row g-4">
                <!-- Left Column: Shipping Info & Payment Gateways -->
                <div class="col-lg-7">
                    <!-- Method Selector -->
                    <div class="card-luxury p-4 mb-4">
                        <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">
                            <i class="fa-solid fa-truck-fast me-2"></i><span data-i18n="checkout.step1">1. Phương Thức Nhận Thức Uống</span>
                        </h5>

                        <div class="row g-3 mb-4">
                            <div class="col-6">
                                <input type="radio" class="btn-check" name="orderType" id="typeDelivery" value="DELIVERY" checked>
                                <label class="btn btn-outline-gold w-100 py-3 text-center rounded-3 cursor-pointer" for="typeDelivery">
                                    <i class="fa-solid fa-motorcycle fs-3 d-block mb-1 text-gold"></i>
                                    <span class="fw-bold font-accent" data-i18n="checkout.delivery">Giao Tận Nơi</span>
                                    <small class="d-block text-secondary" style="font-size: 0.75rem;" data-i18n="checkout.delivery_hint">Siêu tốc 20 - 35 phút</small>
                                </label>
                            </div>
                            <div class="col-6">
                                <input type="radio" class="btn-check" name="orderType" id="typeTakeaway" value="TAKE_AWAY">
                                <label class="btn btn-outline-gold w-100 py-3 text-center rounded-3 cursor-pointer" for="typeTakeaway">
                                    <i class="fa-solid fa-store fs-3 d-block mb-1 text-gold"></i>
                                    <span class="fw-bold font-accent" data-i18n="checkout.takeaway">Lấy Tại Quán</span>
                                    <small class="d-block text-secondary" style="font-size: 0.75rem;" data-i18n="checkout.takeaway_hint">Chuẩn bị sẵn không chờ</small>
                                </label>
                            </div>
                        </div>

                        <!-- Store Branch Selection with Haversine Geolocation Detection -->
                        <div class="mb-3">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label class="form-label small text-gold fw-bold mb-0" data-i18n="checkout.store_label">Chi Nhánh Chế Biến Thức Uống:</label>
                                <button type="button" class="btn btn-outline-gold btn-sm py-0 px-2 rounded-pill font-accent" style="font-size: 0.72rem;" onclick="detectNearestStore()">
                                    <i class="fa-solid fa-location-crosshairs text-gold me-1"></i> <span data-i18n="checkout.gps_btn">Định Vị Gần Nhất</span>
                                </button>
                            </div>
                            <select class="form-select form-control-luxury" name="storeId" id="storeSelect" required>
                                <option value="1">UTECoffe Flagship Thủ Đức - 01 Võ Văn Ngân, P. Linh Chiểu, TP. Thủ Đức</option>
                                <option value="2">UTECoffe Roastery Quận 1 - 68 Lê Lợi, P. Bến Nghé, Quận 1</option>
                                <option value="3">UTECoffe Garden Bình Thạnh - 180 Ung Văn Khiêm, Phường 25, Q. Bình Thạnh, TP.HCM</option>
                            </select>
                            <div id="nearestStoreNotice" class="small text-gold mt-1 d-none">
                                <i class="fa-solid fa-circle-check me-1 text-success"></i> <span id="nearestStoreText"></span>
                            </div>
                            <input type="hidden" name="idempotencyKey" id="idempotencyKeyInput" value="">
                        </div>

                        <!-- Recipient Name & Phone -->
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small text-gold fw-bold" data-i18n="checkout.name_label">Họ và Tên Quý Khách:</label>
                                <input type="text" class="form-control form-control-luxury" name="recipientName" placeholder="Ví dụ: Nguyễn Văn An" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small text-gold fw-bold" data-i18n="checkout.phone_label">Số Điện Thoại Nhận Hàng:</label>
                                <input type="tel" class="form-control form-control-luxury" name="recipientPhone" placeholder="Ví dụ: 0901234567" required>
                            </div>
                        </div>

                        <!-- Delivery Address Group -->
                        <div class="mb-3" id="deliveryAddressGroup">
                            <label class="form-label small text-gold fw-bold" data-i18n="checkout.addr_label">Địa Chỉ Giao Tận Tay:</label>
                            <input type="text" class="form-control form-control-luxury" name="deliveryAddress" placeholder="Số nhà, tên đường, phường/xã, quận/huyện...">
                            <small class="text-secondary" style="font-size: 0.75rem;">
                                <i class="fa-solid fa-circle-info text-gold me-1"></i> <span data-i18n="checkout.shipper_hint">Shipper sẽ gọi điện trước khi giao 5 - 10 phút.</span>
                            </small>
                        </div>

                        <!-- Notes for Barista -->
                        <div>
                            <label class="form-label small text-gold fw-bold" data-i18n="checkout.note_label">Ghi Chú Cho Barista / Shipper:</label>
                            <textarea class="form-control form-control-luxury" name="note" rows="2" placeholder="Ví dụ: Giao lên lầu 3, để đá riêng, ít ngọt..."></textarea>
                        </div>
                    </div>

                    <!-- Payment Gateways Selection -->
                    <div class="card-luxury p-4">
                        <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">
                            <i class="fa-solid fa-credit-card me-2"></i><span data-i18n="checkout.step2">2. Cổng Thanh Toán An Toàn</span>
                        </h5>

                        <div class="d-flex flex-column gap-3">
                            <!-- VietQR Dynamic -->
                            <label class="p-3 border border-gold rounded-3 bg-espresso d-flex align-items-center gap-3 cursor-pointer payment-option-card">
                                <input type="radio" name="paymentMethod" value="VIETQR" checked class="form-check-input flex-shrink-0">
                                <div class="flex-grow-1">
                                    <div class="fw-bold d-flex align-items-center gap-2">
                                        <i class="fa-solid fa-qrcode text-gold fs-5"></i>
                                        <span>Chuyển Khoản Ngân Hàng Tự Động (VietQR Động)</span>
                                        <span class="badge bg-gold text-obsidian small px-2 py-0">Khuyên dùng</span>
                                    </div>
                                    <small class="text-secondary d-block mt-1">
                                        Mã QR chứa sẵn số tiền và mã đơn. Hệ thống tự động xác nhận sau 3 giây và chuyển lệnh pha chế.
                                    </small>
                                </div>
                            </label>

                            <!-- VNPay Sandbox -->
                            <label class="p-3 border border-secondary rounded-3 bg-espresso d-flex align-items-center gap-3 cursor-pointer payment-option-card">
                                <input type="radio" name="paymentMethod" value="VNPAY" class="form-check-input flex-shrink-0">
                                <div class="flex-grow-1">
                                    <div class="fw-bold d-flex align-items-center gap-2">
                                        <i class="fa-regular fa-credit-card text-gold fs-5"></i>
                                        <span>Cổng VNPay (Thẻ ATM, Visa, MasterCard, QR Pay)</span>
                                    </div>
                                    <small class="text-secondary d-block mt-1">
                                        Hỗ trợ 40+ ngân hàng Việt Nam và thẻ thanh toán quốc tế qua cổng VNPay.
                                    </small>
                                </div>
                            </label>

                            <!-- MoMo Sandbox -->
                            <label class="p-3 border border-secondary rounded-3 bg-espresso d-flex align-items-center gap-3 cursor-pointer payment-option-card">
                                <input type="radio" name="paymentMethod" value="MOMO" class="form-check-input flex-shrink-0">
                                <div class="flex-grow-1">
                                    <div class="fw-bold d-flex align-items-center gap-2">
                                        <i class="fa-solid fa-wallet text-gold fs-5"></i>
                                        <span>Ví Điện Tử MoMo</span>
                                    </div>
                                    <small class="text-secondary d-block mt-1">
                                        Quét mã thanh toán tức thì qua ứng dụng MoMo trên điện thoại.
                                    </small>
                                </div>
                            </label>

                            <!-- COD -->
                            <label class="p-3 border border-secondary rounded-3 bg-espresso d-flex align-items-center gap-3 cursor-pointer payment-option-card">
                                <input type="radio" name="paymentMethod" value="COD" class="form-check-input flex-shrink-0">
                                <div class="flex-grow-1">
                                    <div class="fw-bold d-flex align-items-center gap-2">
                                        <i class="fa-solid fa-money-bill-wave text-gold fs-5"></i>
                                        <span>Tiền Mặt Khi Nhận Hàng (COD)</span>
                                    </div>
                                    <small class="text-secondary d-block mt-1">
                                        Thanh toán tiền mặt trực tiếp cho nhân viên giao hàng khi nhận thức uống.
                                    </small>
                                </div>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Order Review & Submit -->
                <div class="col-lg-5">
                    <div class="card-luxury p-4 sticky-top" style="top: 100px;">
                        <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">
                            <i class="fa-solid fa-bag-shopping me-2"></i>Đơn Hàng Thưởng Thức
                        </h5>

                        <div class="mb-3">
                            <div class="d-flex justify-content-between small text-secondary mb-2">
                                <span>Tạm tính thức uống:</span>
                                <span class="text-light fw-bold font-monospace">125.000 VNĐ</span>
                            </div>
                            <div class="d-flex justify-content-between small text-secondary mb-2">
                                <span>Phí vận chuyển:</span>
                                <span class="text-success fw-bold">Miễn Phí</span>
                            </div>
                            <div class="d-flex justify-content-between small text-secondary mb-2">
                                <span>Ưu đãi thành viên:</span>
                                <span class="text-gold font-monospace fw-bold">-20.000 VNĐ</span>
                            </div>
                        </div>

                        <hr class="border-secondary opacity-25">

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="fw-bold fs-6">Tổng Thanh Toán:</span>
                            <span class="price-gold fs-3 fw-bold">105.000 VNĐ</span>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn btn-gold w-100 py-3 fw-bold fs-6 rounded-pill shadow-gold" id="submitOrderBtn">
                            <i class="fa-solid fa-lock me-2"></i> Xác Nhận &amp; Đặt Hàng
                        </button>

                        <div class="text-center mt-3">
                            <small class="text-secondary" style="font-size: 0.75rem;">
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

        // Automatic Store Detection using Haversine Geolocation API
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
                textEl.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-1"></i> Đang tính toán chi nhánh gần nhất theo thuật toán Haversine...';
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
