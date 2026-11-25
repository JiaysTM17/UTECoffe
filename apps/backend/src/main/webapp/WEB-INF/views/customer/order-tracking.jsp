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
            <span class="badge bg-gold-subtle text-gold px-3 py-1 rounded-pill small font-accent mb-2 text-uppercase" style="letter-spacing: 0.12em;" data-i18n="track.badge">
                <i class="fa-solid fa-satellite-dish me-1 fa-fade"></i> TRUYỀN DỮ LIỆU THỜI GIAN THỰC (WEBSOCKET)
            </span>
            <h1 class="font-serif display-5 fw-bold text-gold-gradient mb-2" data-i18n="track.title">
                Hành Trình Tách Cà Phê Của Bạn
            </h1>
            <p class="text-secondary mx-auto small mb-0" style="max-width: 600px;">
                <span data-i18n="track.code_label">Mã Đơn Hàng:</span> <span class="text-gold fw-bold font-monospace fs-6">#${order.orderCode}</span> • <span data-i18n="track.time_label">Đặt lúc:</span> <span class="text-light">${not empty order.formattedCreatedAt ? order.formattedCreatedAt : order.createdAt}</span>
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
                            <span class="small text-secondary text-uppercase font-accent" style="letter-spacing: 0.08em;" data-i18n="track.status_label">Trạng Thái Hiện Tại</span>
                            <h4 class="font-serif fw-bold text-gold mb-0 mt-1 d-flex align-items-center gap-2">
                                <span class="spinner-grow spinner-grow-sm text-gold" role="status"></span>
                                <span id="currentStatusText">${order.status}</span>
                            </h4>
                        </div>
                        <div class="text-md-end">
                            <span class="small text-secondary d-block" data-i18n="track.eta_label">Dự kiến hoàn tất trong:</span>
                            <span class="badge bg-espresso border border-gold text-gold fs-6 px-3 py-2 rounded-pill font-monospace" id="estimatedTimeBadge">
                                <i class="fa-regular fa-clock me-1"></i> <span data-i18n="track.eta_val">~15 - 25 Phút</span>
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
                                <div class="step-label fw-bold font-accent text-gold small" data-i18n="track.step1">Tiếp Nhận</div>
                                <div class="step-sub text-secondary small d-none d-md-block" style="font-size: 0.75rem;" data-i18n="track.step1_sub">Hệ thống xác nhận</div>
                            </div>

                            <!-- Step 2: Barista Crafting -->
                            <div class="col-3 stepper-step" id="step-PREPARING">
                                <div class="step-circle mx-auto mb-2">
                                    <i class="fa-solid fa-mug-hot"></i>
                                </div>
                                <div class="step-label fw-bold font-accent small text-secondary" data-i18n="track.step2">Pha Chế</div>
                                <div class="step-sub text-secondary small d-none d-md-block" style="font-size: 0.75rem;" data-i18n="track.step2_sub">Barista chiết xuất</div>
                            </div>

                            <!-- Step 3: Shipping / Ready -->
                            <div class="col-3 stepper-step" id="step-SHIPPING">
                                <div class="step-circle mx-auto mb-2">
                                    <i class="fa-solid fa-motorcycle"></i>
                                </div>
                                <div class="step-label fw-bold font-accent small text-secondary" data-i18n="track.step3">Giao Hàng</div>
                                <div class="step-sub text-secondary small d-none d-md-block" style="font-size: 0.75rem;" data-i18n="track.step3_sub">Đang trên đường tới</div>
                            </div>

                            <!-- Step 4: Delivered -->
                            <div class="col-3 stepper-step" id="step-COMPLETED">
                                <div class="step-circle mx-auto mb-2">
                                    <i class="fa-solid fa-champagne-glasses"></i>
                                </div>
                                <div class="step-label fw-bold font-accent small text-secondary" data-i18n="track.step4">Thưởng Thức</div>
                                <div class="step-sub text-secondary small d-none d-md-block" style="font-size: 0.75rem;" data-i18n="track.step4_sub">Giao thành công</div>
                            </div>
                        </div>
                    </div>

                    <!-- Real-Time Activity Log Card -->
                    <div class="p-3 bg-espresso rounded-3 border border-gold-subtle d-flex align-items-center gap-3 mt-3">
                        <div class="text-gold fs-3 ps-2">
                            <i class="fa-solid fa-circle-info"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-bold text-light small" id="statusMessageHeader" data-i18n="track.barista_note">Thông điệp từ quầy Barista:</div>
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
                                <i class="fa-solid fa-receipt me-2"></i><span data-i18n="track.items_title">Chi Tiết Thức Uống Đã Đặt</span>
                            </h5>

                            <div class="table-responsive">
                                <table class="table table-luxury align-middle mb-0">
                                    <thead>
                                        <tr class="small text-secondary">
                                            <th data-i18n="track.col_item">Thức Uống</th>
                                            <th class="text-center" data-i18n="track.col_qty">Số Lượng</th>
                                            <th class="text-end" data-i18n="track.col_total">Thành Tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${order.items}">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold font-serif text-light">${item.product.name}</div>
                                                    <small class="text-gold d-block">
                                                        Size: ${not empty item.productSize ? item.productSize.name : 'M'} • ${not empty item.sugarLevel ? item.sugarLevel : 100}% Đường • ${not empty item.iceLevel ? item.iceLevel : 100}% Đá
                                                    </small>
                                                </td>
                                                <td class="text-center font-monospace fw-bold">${item.quantity}</td>
                                                <td class="text-end fw-bold text-gold">
                                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> VNĐ
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <hr class="border-secondary opacity-25 my-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-bold" data-i18n="track.total_paid">Tổng Thanh Toán:</span>
                                <span class="price-gold fs-4">
                                    <fmt:formatNumber value="${order.finalAmount}" pattern="#,##0"/> VNĐ
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Delivery Details & Store Info -->
                    <div class="col-lg-5">
                        <div class="card-luxury p-4 h-100 d-flex flex-column justify-content-between">
                            <div>
                                <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">
                                    <i class="fa-solid fa-location-crosshairs me-2"></i><span data-i18n="track.shipping_title">Thông Tin Giao Nhận</span>
                                </h5>

                                <div class="mb-3">
                                    <span class="small text-secondary d-block mb-1" data-i18n="track.recipient">Người nhận:</span>
                                    <div class="fw-bold text-light">${order.recipientName}</div>
                                    <div class="small text-gold font-monospace"><i class="fa-solid fa-phone me-1"></i>${order.recipientPhone}</div>
                                </div>

                                <div class="mb-3">
                                    <span class="small text-secondary d-block mb-1" data-i18n="track.address">Địa chỉ giao:</span>
                                    <div class="small text-light">
                                        <i class="fa-solid fa-house-chimney text-gold me-1"></i>
                                        ${not empty order.deliveryAddress ? order.deliveryAddress : 'Nhận trực tiếp tại quầy UTECoffe Roastery'}
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <span class="small text-secondary d-block mb-1" data-i18n="track.store">Chi nhánh chế biến:</span>
                                    <div class="small text-light fw-bold">${order.store.name}</div>
                                    <div class="small text-secondary">${order.store.address}</div>
                                </div>

                                <div class="mb-3">
                                    <span class="small text-secondary d-block mb-1" data-i18n="track.payment_method">Phương thức thanh toán:</span>
                                    <span class="badge bg-gold-subtle text-gold border border-gold-subtle px-2 py-1 rounded-pill">
                                        <i class="fa-solid fa-credit-card me-1"></i> ${order.paymentMethod}
                                    </span>
                                </div>

                                <!-- In-App Simulated Universal QR Payment Center -->
                                <c:choose>
                                    <c:when test="${order.paymentMethod != 'COD' and (order.status == 'PENDING' or param.showQr == 'true' or showQr == true)}">
                                        <div class="card-luxury p-3 p-md-4 text-center border-gold bg-espresso mt-3 shadow-lg" id="vietQrPaymentBox">
                                            <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom border-gold flex-wrap gap-1">
                                                <span class="badge bg-gold text-obsidian small font-accent fw-bold px-2 py-1 rounded-pill">
                                                    <i class="fa-solid fa-qrcode me-1"></i> THANH TOÁN QR TRỰC TIẾP
                                                </span>
                                                <span class="small text-secondary font-monospace" style="font-size: 0.75rem;">
                                                    <i class="fa-regular fa-clock me-1 text-gold"></i> Hết hạn: <strong class="text-gold" id="qrCountdown">14:59</strong>
                                                </span>
                                            </div>

                                            <!-- Bank / Wallet Tab Selector -->
                                            <div class="d-flex justify-content-center gap-1 mb-3">
                                                <button type="button" class="btn btn-outline-gold btn-sm py-1 px-2.5 active font-accent qr-tab-btn" onclick="selectQrTab('ICB', 'VietinBank', '108820269999', this)">
                                                    VietinBank
                                                </button>
                                                <button type="button" class="btn btn-outline-gold btn-sm py-1 px-2.5 font-accent qr-tab-btn" onclick="selectQrTab('TCB', 'Techcombank', '190368202699', this)">
                                                    Techcombank
                                                </button>
                                                <button type="button" class="btn btn-outline-gold btn-sm py-1 px-2.5 font-accent qr-tab-btn" onclick="selectQrTab('970415', 'Ví MoMo / VNPay-QR', '108820269999', this)">
                                                    MoMo / VNPay
                                                </button>
                                            </div>

                                            <!-- Dynamic High-Resolution Universal QR Code -->
                                            <div class="position-relative d-inline-block mx-auto mb-3 p-2 bg-white rounded-3 shadow-gold-sm">
                                                <img id="dynamicQrImage" 
                                                     src="https://img.vietqr.io/image/ICB-108820269999-compact2.png?amount=${order.finalAmount}&addInfo=THANH+TOAN+DON+${order.orderCode}&accountName=CONG+TY+CP+CA+PHE+UTE+COFFE"
                                                     class="img-fluid rounded-2 d-block mx-auto"
                                                     style="max-width: 210px; height: auto;"
                                                     alt="Mã QR Thanh Toán UTECoffe">
                                            </div>

                                            <!-- Transfer Details with 1-Click Copy -->
                                            <div class="text-start bg-obsidian p-3 rounded-3 border border-gold-subtle mb-3 small">
                                                <div class="d-flex justify-content-between align-items-center mb-1.5 pb-1 border-bottom border-dark">
                                                    <span class="text-secondary">Ngân Hàng:</span>
                                                    <strong class="text-light" id="qrBankName">VietinBank (Chi nhánh Thủ Đức)</strong>
                                                </div>
                                                <div class="d-flex justify-content-between align-items-center mb-1.5 pb-1 border-bottom border-dark">
                                                    <span class="text-secondary">Số Tài Khoản:</span>
                                                    <div class="d-flex align-items-center gap-1.5">
                                                        <strong class="text-gold font-monospace fs-6" id="qrAccNo">108820269999</strong>
                                                        <button type="button" class="btn btn-outline-gold btn-sm py-0 px-2 rounded-pill" style="font-size: 0.7rem;" onclick="copyToClipboard('108820269999', this)">
                                                            <i class="fa-regular fa-copy"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="d-flex justify-content-between align-items-center mb-1.5 pb-1 border-bottom border-dark">
                                                    <span class="text-secondary">Chủ Tài Khoản:</span>
                                                    <strong class="text-light text-uppercase">CONG TY CP CA PHE UTE COFFE</strong>
                                                </div>
                                                <div class="d-flex justify-content-between align-items-center mb-1.5 pb-1 border-bottom border-dark">
                                                    <span class="text-secondary">Số Tiền:</span>
                                                    <strong class="price-gold fs-6">
                                                        <fmt:formatNumber value="${order.finalAmount}" pattern="#,##0"/> VNĐ
                                                    </strong>
                                                </div>
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="text-secondary">Nội Dung:</span>
                                                    <div class="d-flex align-items-center gap-1.5">
                                                        <strong class="text-gold font-monospace" id="qrMemoText">THANH TOAN DON ${order.orderCode}</strong>
                                                        <button type="button" class="btn btn-outline-gold btn-sm py-0 px-2 rounded-pill" style="font-size: 0.7rem;" onclick="copyToClipboard('THANH TOAN DON ${order.orderCode}', this)">
                                                            <i class="fa-regular fa-copy"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- User Action Buttons -->
                                            <button type="button" class="btn btn-gold w-100 py-2.5 rounded-pill fw-bold shadow-gold mb-2 font-accent" id="btnConfirmPaid" onclick="executePaymentVerification()">
                                                <i class="fa-solid fa-circle-check me-1.5"></i> Tôi Đã Chuyển Khoản Thành Công
                                            </button>

                                            <button type="button" class="btn btn-outline-gold w-100 py-1.5 rounded-pill small font-accent text-gold" id="btnSimulateScan" onclick="simulateDemoFastPayment()">
                                                <i class="fa-solid fa-bolt text-warning me-1.5"></i> Giả Lập Quét QR Thành Công (Thử Nghiệm Demo)
                                            </button>
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
                                        <div class="p-3 bg-espresso rounded-3 border border-gold-subtle mt-3 text-center">
                                            <i class="fa-solid fa-circle-check text-success fs-3 mb-2 d-block"></i>
                                            <div class="small fw-bold text-light">Đơn Hàng Đang Được Xử Lý An Toàn</div>
                                            <div class="small text-secondary mt-1">Phương thức: <strong>${order.paymentMethod}</strong></div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="pt-3 border-top border-gold mt-4 d-flex gap-2">
                                <a href="tel:19002026" class="btn btn-outline-gold btn-sm flex-grow-1">
                                    <i class="fa-solid fa-headset me-1"></i> <span data-i18n="track.btn_support">Gọi Hotline CSKH</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold btn-sm flex-grow-1">
                                    <i class="fa-solid fa-mug-saucer me-1"></i> <span data-i18n="track.btn_order_more">Đặt Thêm Món</span>
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
