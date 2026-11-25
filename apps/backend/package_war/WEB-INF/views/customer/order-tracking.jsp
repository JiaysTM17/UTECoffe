<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Theo Dõi Đơn Hàng #${order.orderCode} - UTECoffe Specialty Roastery</title>
</head>
<body class="bg-obsidian">

    <!-- Header Section: Compact & Refined -->
    <div class="py-3 bg-espresso border-bottom border-gold text-center">
        <div class="container py-1">
            <span class="badge bg-gold-subtle text-gold px-2.5 py-0.5 rounded-pill small font-accent mb-1 text-uppercase" style="letter-spacing: 0.1em; font-size: 0.72rem;" data-i18n="track.badge">
                <i class="fa-solid fa-satellite-dish me-1 fa-fade text-gold"></i> CẬP NHẬT TRẠNG THÁI TRỰC TIẾP TỪ BARISTA
            </span>
            <h1 class="font-serif fs-4 fw-bold text-gold-gradient mb-1" data-i18n="track.title">
                Hành Trình Tách Cà Phê Của Bạn
            </h1>
            <div class="d-flex justify-content-center align-items-center gap-2 flex-wrap text-secondary" style="font-size: 0.82rem;">
                <span><span data-i18n="track.code_label">Mã Đơn Hàng:</span> <strong class="text-gold font-monospace">#${order.orderCode}</strong></span>
                <span>•</span>
                <span><span data-i18n="track.time_label">Đặt lúc:</span> <strong class="text-light">${not empty order.formattedCreatedAt ? order.formattedCreatedAt : order.createdAt}</strong></span>
            </div>
        </div>
    </div>

    <!-- Main Order Tracker Container: Centered & Bounded -->
    <div class="container py-4" style="max-width: 1140px; margin: 0 auto;">
        
        <!-- 4-Stage Luxury Status Stepper Card: Compact & Sleek -->
        <div class="card-luxury p-3 p-md-3.5 mb-3 shadow-lg">
            <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom border-gold flex-wrap gap-2">
                <div>
                    <span class="small text-secondary text-uppercase font-accent" style="letter-spacing: 0.08em; font-size: 0.72rem;" data-i18n="track.status_label">Trạng Thái Hiện Tại</span>
                    <h5 class="font-serif fw-bold text-gold mb-0 mt-0.5 d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                        <span class="spinner-grow spinner-grow-sm text-gold" role="status"></span>
                        <span id="currentStatusText">${order.status}</span>
                    </h5>
                </div>
                <div class="text-md-end">
                    <span class="text-secondary d-block" style="font-size: 0.75rem;" data-i18n="track.eta_label">Dự kiến hoàn tất trong:</span>
                    <span class="badge bg-espresso border border-gold text-gold px-2.5 py-1 rounded-pill font-monospace" style="font-size: 0.82rem;" id="estimatedTimeBadge">
                        <i class="fa-regular fa-clock me-1"></i> <span data-i18n="track.eta_val">~15 - 25 Phút</span>
                    </span>
                </div>
            </div>

            <!-- Visual Timeline Stepper -->
            <div class="order-stepper-wrap py-2">
                <div class="stepper-track-bg"></div>
                <div class="stepper-track-progress" id="stepperProgressBar" style="width: 25%;"></div>

                <div class="row text-center position-relative g-0" style="z-index: 2;">
                    <!-- Step 1: Order Placed -->
                    <div class="col-3 stepper-step" id="step-PENDING">
                        <div class="step-circle active mx-auto mb-1.5">
                            <i class="fa-solid fa-clipboard-check"></i>
                        </div>
                        <div class="step-label fw-bold font-accent text-gold" style="font-size: 0.82rem;" data-i18n="track.step1">Tiếp Nhận</div>
                        <div class="step-sub text-secondary d-none d-md-block" style="font-size: 0.72rem;" data-i18n="track.step1_sub">Hệ thống xác nhận</div>
                    </div>

                    <!-- Step 2: Barista Crafting -->
                    <div class="col-3 stepper-step" id="step-PREPARING">
                        <div class="step-circle mx-auto mb-1.5">
                            <i class="fa-solid fa-mug-hot"></i>
                        </div>
                        <div class="step-label fw-bold font-accent text-secondary" style="font-size: 0.82rem;" data-i18n="track.step2">Pha Chế</div>
                        <div class="step-sub text-secondary d-none d-md-block" style="font-size: 0.72rem;" data-i18n="track.step2_sub">Barista chiết xuất</div>
                    </div>

                    <!-- Step 3: Shipping / Ready -->
                    <div class="col-3 stepper-step" id="step-SHIPPING">
                        <div class="step-circle mx-auto mb-1.5">
                            <i class="fa-solid fa-motorcycle"></i>
                        </div>
                        <div class="step-label fw-bold font-accent text-secondary" style="font-size: 0.82rem;" data-i18n="track.step3">Giao Hàng</div>
                        <div class="step-sub text-secondary d-none d-md-block" style="font-size: 0.72rem;" data-i18n="track.step3_sub">Đang trên đường tới</div>
                    </div>

                    <!-- Step 4: Delivered -->
                    <div class="col-3 stepper-step" id="step-COMPLETED">
                        <div class="step-circle mx-auto mb-1.5">
                            <i class="fa-solid fa-champagne-glasses"></i>
                        </div>
                        <div class="step-label fw-bold font-accent text-secondary" style="font-size: 0.82rem;" data-i18n="track.step4">Thưởng Thức</div>
                        <div class="step-sub text-secondary d-none d-md-block" style="font-size: 0.72rem;" data-i18n="track.step4_sub">Giao thành công</div>
                    </div>
                </div>
            </div>

            <!-- Real-Time Activity Log Card -->
            <div class="p-2.5 bg-espresso rounded-3 border border-gold-subtle d-flex align-items-center gap-2.5 mt-2">
                <div class="text-gold fs-4 ps-1">
                    <i class="fa-solid fa-circle-info"></i>
                </div>
                <div class="flex-grow-1">
                    <div class="fw-bold text-light" style="font-size: 0.82rem;" id="statusMessageHeader" data-i18n="track.barista_note">Thông điệp từ quầy Barista:</div>
                    <div class="text-secondary" style="font-size: 0.78rem;" id="statusDescText">
                        Đơn hàng #${order.orderCode} đã được chuyển tới máy in hóa đơn quầy Barista chi nhánh ${order.store.name}.
                    </div>
                </div>
            </div>
        </div>

        <!-- Balanced 2-Column Section: Left (Order Items & Delivery Info) vs Right (Interactive QR Payment Box) -->
        <div class="row g-3">
            <!-- Left Column: Items & Delivery Details -->
            <div class="col-lg-5">
                <!-- Card 1: Items Ordered -->
                <div class="card-luxury p-3 mb-3">
                    <h6 class="font-serif fw-bold text-gold-gradient mb-2 pb-2 border-bottom border-gold" style="font-size: 0.95rem;">
                        <i class="fa-solid fa-receipt me-1.5"></i><span data-i18n="track.items_title">Chi Tiết Thức Uống Đã Đặt</span>
                    </h6>

                    <div class="table-responsive mb-2" style="max-height: 240px; overflow-y: auto;">
                        <table class="table table-luxury table-cart-compact align-middle mb-0">
                            <thead>
                                <tr class="text-secondary" style="font-size: 0.72rem;">
                                    <th data-i18n="track.col_item">Thức Uống</th>
                                    <th class="text-center" data-i18n="track.col_qty">SL</th>
                                    <th class="text-end" data-i18n="track.col_total">Thành Tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${order.items}">
                                    <tr>
                                        <td>
                                            <div class="fw-bold font-serif text-light" style="font-size: 0.88rem;">${item.product.name}</div>
                                            <small class="text-gold d-block" style="font-size: 0.72rem;">
                                                Size: ${not empty item.productSize ? item.productSize.name : 'M'} • ${not empty item.sugarLevel ? item.sugarLevel : 100}% Đường • ${not empty item.iceLevel ? item.iceLevel : 100}% Đá
                                            </small>
                                        </td>
                                        <td class="text-center font-monospace fw-bold" style="font-size: 0.85rem;">${item.quantity}</td>
                                        <td class="text-end fw-bold text-gold font-monospace" style="font-size: 0.85rem;">
                                            <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> VNĐ
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex justify-content-between align-items-center pt-2 border-top border-secondary border-opacity-25">
                        <span class="fw-bold" style="font-size: 0.9rem;" data-i18n="track.total_paid">Tổng Thanh Toán:</span>
                        <span class="price-gold fs-5 fw-bold font-monospace">
                            <fmt:formatNumber value="${order.finalAmount}" pattern="#,##0"/> VNĐ
                        </span>
                    </div>
                </div>

                <!-- Card 2: Delivery & Store Info -->
                <div class="card-luxury p-3">
                    <h6 class="font-serif fw-bold text-gold-gradient mb-2.5 pb-2 border-bottom border-gold" style="font-size: 0.95rem;">
                        <i class="fa-solid fa-location-crosshairs me-1.5"></i><span data-i18n="track.shipping_title">Thông Tin Giao Nhận</span>
                    </h6>

                    <div class="mb-2">
                        <span class="text-secondary d-block" style="font-size: 0.75rem;" data-i18n="track.recipient">Người nhận:</span>
                        <div class="fw-bold text-light" style="font-size: 0.86rem;">${order.recipientName}</div>
                        <div class="text-gold font-monospace" style="font-size: 0.82rem;"><i class="fa-solid fa-phone me-1"></i>${order.recipientPhone}</div>
                    </div>

                    <div class="mb-2">
                        <span class="text-secondary d-block" style="font-size: 0.75rem;" data-i18n="track.address">Địa chỉ giao:</span>
                        <div class="text-light" style="font-size: 0.82rem;">
                            <i class="fa-solid fa-house-chimney text-gold me-1"></i>
                            ${not empty order.deliveryAddress ? order.deliveryAddress : 'Nhận trực tiếp tại quầy UTECoffe Roastery'}
                        </div>
                    </div>

                    <div class="mb-2">
                        <span class="text-secondary d-block" style="font-size: 0.75rem;" data-i18n="track.store">Chi nhánh chế biến:</span>
                        <div class="text-light fw-bold" style="font-size: 0.84rem;">${order.store.name}</div>
                        <div class="text-secondary" style="font-size: 0.76rem;">${order.store.address}</div>
                    </div>

                    <div>
                        <span class="text-secondary d-block mb-1" style="font-size: 0.75rem;" data-i18n="track.payment_method">Phương thức thanh toán:</span>
                        <span class="badge bg-gold-subtle text-gold border border-gold-subtle px-2 py-0.5 rounded-pill" style="font-size: 0.75rem;">
                            <i class="fa-solid fa-credit-card me-1"></i> ${order.paymentMethod}
                        </span>
                    </div>
                </div>
            </div>

            <!-- Right Column: Interactive Universal QR Payment Center -->
            <div class="col-lg-7">
                <c:choose>
                    <c:when test="${order.paymentMethod != 'COD' and (order.status == 'PENDING' or param.showQr == 'true' or showQr == true)}">
                        <div class="card-luxury p-3.5 p-md-4 text-center border-gold bg-espresso shadow-lg h-100 d-flex flex-column justify-content-between" id="vietQrPaymentBox">
                            <div>
                                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom border-gold flex-wrap gap-2">
                                    <span class="badge bg-gold text-obsidian small font-accent fw-bold px-2.5 py-1 rounded-pill" style="font-size: 0.75rem;">
                                        <i class="fa-solid fa-qrcode me-1"></i> THANH TOÁN QR TRỰC TIẾP
                                    </span>
                                    <span class="text-secondary font-monospace" style="font-size: 0.78rem;">
                                        <i class="fa-regular fa-clock me-1 text-gold"></i> Hết hạn sau: <strong class="text-gold" id="qrCountdown">14:59</strong>
                                    </span>
                                </div>

                                <!-- Bank / Wallet Segmented Control -->
                                <div class="text-center mb-3">
                                    <div class="bank-segment-wrap">
                                        <button type="button" class="bank-segment-btn active qr-tab-btn" onclick="selectQrTab('ICB', 'VietinBank', '108820269999', this)">
                                            VietinBank
                                        </button>
                                        <button type="button" class="bank-segment-btn qr-tab-btn" onclick="selectQrTab('TCB', 'Techcombank', '190368202699', this)">
                                            Techcombank
                                        </button>
                                        <button type="button" class="bank-segment-btn qr-tab-btn" onclick="selectQrTab('970415', 'Ví MoMo / VNPay-QR', '108820269999', this)">
                                            MoMo / VNPay
                                        </button>
                                    </div>
                                </div>

                                <!-- Dynamic High-Resolution Universal QR Code Frame -->
                                <div class="qr-token-card mx-auto mb-3 p-3 position-relative d-inline-block">
                                    <img id="dynamicQrImage" 
                                         src="https://img.vietqr.io/image/ICB-108820269999-compact2.png?amount=${order.finalAmount}&addInfo=THANH+TOAN+DON+${order.orderCode}&accountName=CONG+TY+CP+CA+PHE+UTE+COFFE"
                                         class="img-fluid rounded-2 d-block mx-auto"
                                         style="max-width: 195px; height: auto;"
                                         alt="Mã QR Thanh Toán UTECoffe">
                                    <div class="mt-2 text-center">
                                        <span class="badge bg-espresso text-gold border border-gold-subtle px-2.5 py-1 rounded-pill" style="font-size: 0.72rem; letter-spacing: 0.05em;">
                                            <i class="fa-solid fa-qrcode me-1 text-gold"></i> Quét Bằng Mọi App Ngân Hàng
                                        </span>
                                    </div>
                                </div>

                                <!-- Transfer Details: Luxury Invoice Slate -->
                                <div class="transfer-slate p-3 mb-3 text-start">
                                    <div class="d-flex justify-content-between align-items-center py-1.5 transfer-line">
                                        <span class="text-secondary small">Ngân Hàng Thụ Hưởng:</span>
                                        <strong class="text-light" id="qrBankName" style="font-size: 0.88rem;">VietinBank (Chi nhánh Thủ Đức)</strong>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center py-2 transfer-line">
                                        <span class="text-secondary small">Số Tài Khoản:</span>
                                        <div class="d-flex align-items-center gap-2">
                                            <strong class="text-gold font-monospace fs-5" id="qrAccNo">108820269999</strong>
                                            <button type="button" class="btn btn-outline-gold btn-sm py-0.5 px-2 rounded-pill font-accent d-flex align-items-center gap-1" style="font-size: 0.72rem;" onclick="copyToClipboard('108820269999', this)">
                                                <i class="fa-regular fa-copy"></i> <span>Sao Chép</span>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center py-1.5 transfer-line">
                                        <span class="text-secondary small">Chủ Tài Khoản:</span>
                                        <strong class="text-light text-uppercase font-serif" style="font-size: 0.85rem; letter-spacing: 0.03em;">CONG TY CP CA PHE UTE COFFE</strong>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center py-2 transfer-line">
                                        <span class="text-secondary small">Số Tiền Cần Chuyển:</span>
                                        <strong class="price-gold fs-5 font-monospace">
                                            <fmt:formatNumber value="${order.finalAmount}" pattern="#,##0"/> VNĐ
                                        </strong>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center py-2">
                                        <span class="text-secondary small">Nội Dung Chuyển Khoản:</span>
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="badge bg-espresso border border-gold text-gold font-monospace px-2.5 py-1.5" style="font-size: 0.86rem; letter-spacing: 0.05em;" id="qrMemoText">THANH TOAN DON ${order.orderCode}</span>
                                            <button type="button" class="btn btn-outline-gold btn-sm py-0.5 px-2 rounded-pill font-accent d-flex align-items-center gap-1" style="font-size: 0.72rem;" onclick="copyToClipboard('THANH TOAN DON ${order.orderCode}', this)">
                                                <i class="fa-regular fa-copy"></i> <span>Sao Chép</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- User Action Buttons -->
                            <div>
                                <button type="button" class="btn btn-gold w-100 py-3 rounded-pill fw-bold shadow-gold mb-1 font-accent fs-6" id="btnConfirmPaid" onclick="executePaymentVerification()">
                                    <i class="fa-solid fa-circle-check me-2"></i> Xác Nhận Đã Chuyển Khoản
                                </button>

                                <button type="button" class="btn btn-link text-gold text-decoration-none small mx-auto d-block opacity-75 hover-opacity-100" style="font-size: 0.78rem;" id="btnSimulateScan" onclick="simulateDemoFastPayment()">
                                    <i class="fa-solid fa-wand-magic-sparkles me-1 text-warning"></i> Thử nghiệm: Giả lập quét QR thành công
                                </button>
                            </div>
                        </div>

                        <script>
                            function copyToClipboard(text, btnElement) {
                                navigator.clipboard.writeText(text).then(() => {
                                    const originalHtml = btnElement.innerHTML;
                                    btnElement.innerHTML = '<i class="fa-solid fa-check text-success"></i>';
                                    setTimeout(() => { btnElement.innerHTML = originalHtml; }, 2000);
                                });
                            }

                            function selectQrTab(bankCode, bankName, accNo, btn) {
                                document.querySelectorAll('.qr-tab-btn').forEach(b => b.classList.remove('active'));
                                if (btn) btn.classList.add('active');

                                const qrImg = document.getElementById('dynamicQrImage');
                                const bankNameEl = document.getElementById('qrBankName');
                                const accNoEl = document.getElementById('qrAccNo');

                                if (bankNameEl) bankNameEl.textContent = bankName;
                                if (accNoEl) accNoEl.textContent = accNo;

                                if (qrImg) {
                                    const amount = '${order.finalAmount}';
                                    const memo = 'THANH+TOAN+DON+${order.orderCode}';
                                    const accountName = 'CONG+TY+CP+CA+PHE+UTE+COFFE';
                                    qrImg.src = 'https://img.vietqr.io/image/' + bankCode + '-' + accNo + '-compact2.png?amount=' + amount + '&addInfo=' + memo + '&accountName=' + accountName;
                                }
                            }

                            (function initQrTimer() {
                                let totalSeconds = 15 * 60;
                                const timerEl = document.getElementById('qrCountdown');
                                if (!timerEl) return;

                                const interval = setInterval(() => {
                                    totalSeconds--;
                                    if (totalSeconds <= 0) {
                                        clearInterval(interval);
                                        timerEl.textContent = 'Đã hết hạn';
                                        return;
                                    }
                                    const minutes = Math.floor(totalSeconds / 60);
                                    const seconds = totalSeconds % 60;
                                    timerEl.textContent = (minutes < 10 ? '0' : '') + minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
                                }, 1000);
                            })();

                            function executePaymentVerification() {
                                const btn = document.getElementById('btnConfirmPaid');
                                const btnDemo = document.getElementById('btnSimulateScan');
                                if (btn) {
                                    btn.disabled = true;
                                    btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-1.5"></i> Đang xác thực với cổng Napas 247...';
                                }
                                if (btnDemo) btnDemo.disabled = true;

                                fetch('${pageContext.request.contextPath}/api/payments/vietqr/verify/${order.orderCode}', {
                                    method: 'POST',
                                    headers: {
                                        'X-CSRF-TOKEN': '${_csrf.token}'
                                    }
                                })
                                .then(res => res.json())
                                .then(data => {
                                    showPaymentSuccessUI(data.message || 'Xác nhận thanh toán thành công!');
                                })
                                .catch(() => {
                                    if (btn) {
                                        btn.disabled = false;
                                        btn.innerHTML = '<i class="fa-solid fa-circle-check me-1.5"></i> Tôi Đã Chuyển Khoản Thành Công';
                                    }
                                    if (btnDemo) btnDemo.disabled = false;
                                });
                            }

                            function simulateDemoFastPayment() {
                                const btnDemo = document.getElementById('btnSimulateScan');
                                if (btnDemo) {
                                    btnDemo.disabled = true;
                                    btnDemo.innerHTML = '<i class="fa-solid fa-bolt fa-fade text-warning me-1.5"></i> Đang giả lập quét mã QR...';
                                }
                                setTimeout(() => {
                                    executePaymentVerification();
                                }, 800);
                            }

                            function showPaymentSuccessUI(msg) {
                                const paymentBox = document.getElementById('vietQrPaymentBox');
                                if (paymentBox) {
                                    paymentBox.innerHTML = `
                                        <div class="py-4 text-center animate-fade-in">
                                            <div class="d-inline-flex p-3 rounded-circle bg-success bg-opacity-25 border border-success mb-3 shadow-lg">
                                                <i class="fa-solid fa-circle-check text-success display-4"></i>
                                            </div>
                                            <h5 class="font-serif fw-bold text-gold mb-2">Thanh Toán Thành Công!</h5>
                                            <p class="small text-light mb-3">Khoản thanh toán đã được ghi nhận. Lệnh pha chế đã được chuyển tới quầy Barista.</p>
                                            <span class="badge bg-espresso border border-gold text-gold font-monospace px-3 py-1.5 rounded-pill">
                                                <i class="fa-solid fa-mug-hot me-1.5 text-warning fa-bounce"></i> Barista đang bắt đầu pha chế
                                            </span>
                                        </div>
                                    `;
                                }

                                const statusText = document.getElementById('currentStatusText');
                                if (statusText) statusText.textContent = 'PREPARING (Đang Pha Chế)';

                                const progressBar = document.getElementById('stepperProgressBar');
                                if (progressBar) progressBar.style.width = '50%';

                                const step2 = document.getElementById('step-PREPARING');
                                if (step2) {
                                    const circle = step2.querySelector('.step-circle');
                                    if (circle) circle.classList.add('active');
                                    const label = step2.querySelector('.step-label');
                                    if (label) {
                                        label.classList.remove('text-secondary');
                                        label.classList.add('text-gold');
                                    }
                                }

                                const statusDesc = document.getElementById('statusDescText');
                                if (statusDesc) {
                                    statusDesc.textContent = 'Đã nhận thanh toán. Barista tại ${order.store.name} đang tiến hành định lượng và chiết xuất thức uống.';
                                }
                            }
                        </script>
                    </c:when>
                    <c:otherwise>
                        <div class="card-luxury p-4 bg-espresso border-gold-subtle text-center h-100 d-flex flex-column justify-content-center">
                            <div class="mb-3">
                                <i class="fa-solid fa-circle-check text-success display-4"></i>
                            </div>
                            <h5 class="font-serif fw-bold text-gold mb-2">Đơn Hàng Đang Được Xử Lý</h5>
                            <p class="text-secondary small mb-3">Phương thức thanh toán: <strong class="text-light">${order.paymentMethod}</strong></p>
                            <p class="text-light small mx-auto" style="max-width: 420px;">
                                Nhân viên sẽ gọi điện xác nhận và giao hàng tận tay cho quý khách trong thời gian sớm nhất.
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Embedded CSS for Stepper -->
    <style>
        .order-stepper-wrap {
            position: relative;
            margin: 1rem 0;
        }
        .stepper-track-bg {
            position: absolute;
            top: 22px;
            left: 12.5%;
            right: 12.5%;
            height: 4px;
            background: rgba(212, 175, 55, 0.2);
            z-index: 1;
            border-radius: 4px;
        }
        .stepper-track-progress {
            position: absolute;
            top: 22px;
            left: 12.5%;
            height: 4px;
            background: var(--gold-gradient);
            z-index: 1;
            border-radius: 4px;
            transition: width 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .step-circle {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: var(--bg-card);
            border: 2px solid rgba(212, 175, 55, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.05rem;
            color: var(--text-secondary);
            transition: all 0.4s ease;
            position: relative;
        }
        .step-circle.active {
            border-color: var(--text-gold);
            background: var(--gold-gradient);
            color: #0b0908 !important;
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.45);
            transform: scale(1.08);
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

                function setStepState(stepEl, state) {
                    if (!stepEl) return;
                    const circle = stepEl.querySelector('.step-circle');
                    const label = stepEl.querySelector('.step-label');
                    if (!circle) return;

                    circle.classList.remove('active', 'completed');
                    if (label) {
                        label.classList.remove('text-gold', 'text-success');
                        label.classList.add('text-secondary');
                    }

                    if (state === 'active') {
                        circle.classList.add('active');
                        if (label) {
                            label.classList.remove('text-secondary');
                            label.classList.add('text-gold');
                        }
                    } else if (state === 'completed') {
                        circle.classList.add('completed');
                        if (label) {
                            label.classList.remove('text-secondary');
                            label.classList.add('text-success');
                        }
                    }
                }

                if (status === 'PENDING') {
                    if (progressBar) progressBar.style.width = '25%';
                    setStepState(stepPending, 'active');
                    setStepState(stepPreparing, 'inactive');
                    setStepState(stepShipping, 'inactive');
                    setStepState(stepCompleted, 'inactive');
                } else if (status === 'PREPARING') {
                    if (progressBar) progressBar.style.width = '50%';
                    setStepState(stepPending, 'completed');
                    setStepState(stepPreparing, 'active');
                    setStepState(stepShipping, 'inactive');
                    setStepState(stepCompleted, 'inactive');
                } else if (status === 'SHIPPING' || status === 'READY') {
                    if (progressBar) progressBar.style.width = '75%';
                    setStepState(stepPending, 'completed');
                    setStepState(stepPreparing, 'completed');
                    setStepState(stepShipping, 'active');
                    setStepState(stepCompleted, 'inactive');
                } else if (status === 'COMPLETED') {
                    if (progressBar) progressBar.style.width = '100%';
                    setStepState(stepPending, 'completed');
                    setStepState(stepPreparing, 'completed');
                    setStepState(stepShipping, 'completed');
                    setStepState(stepCompleted, 'completed');
                }
            }

            updateStepperUI(initialStatus);

            try {
                const socket = new SockJS('${pageContext.request.contextPath}/ws-kds');
                const stompClient = Stomp.over(socket);
                stompClient.debug = null;

                stompClient.connect({}, function () {
                    stompClient.subscribe('/topic/orders/' + orderCode, function (msg) {
                        try {
                            const data = JSON.parse(msg.body);
                            if (data && data.status) {
                                updateStepperUI(data.status);
                            }
                        } catch (e) {
                            console.error('WebSocket parse error:', e);
                        }
                    });
                }, function (err) {
                    console.warn('WebSocket connection fallback:', err);
                });
            } catch (err) {
                console.warn('Live WebSocket init deferred:', err);
            }
        });
    </script>
</body>
