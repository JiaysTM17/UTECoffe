<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Giỏ Hàng Của Bạn - UTECoffe Specialty Roastery</title>
</head>
<body class="bg-obsidian">

    <!-- Header Banner -->
    <div class="py-5 bg-espresso border-bottom border-gold text-center">
        <div class="container py-2">
            <span class="badge bg-gold-subtle text-gold px-3 py-1 rounded-pill small font-accent mb-2 text-uppercase" style="letter-spacing: 0.12em;" data-i18n="cart.badge">
                <i class="fa-solid fa-bag-shopping me-1"></i> TÚI THƯỞNG THỨC NGHỆ NHÂN
            </span>
            <h1 class="font-serif display-5 fw-bold text-gold-gradient mb-2" data-i18n="cart.title">
                Giỏ Hàng Thức Uống
            </h1>
            <p class="text-secondary mx-auto small mb-0" style="max-width: 600px;" data-i18n="cart.desc">
                Mỗi ly cà phê và tách trà đều được pha mới ngay khi nhận đơn để đảm bảo độ tươi và hương vị trọn vẹn nhất.
            </p>
        </div>
    </div>

    <div class="container py-5">
        <c:choose>
            <c:when test="${not empty cart and not empty cart.items}">
                <!-- Free Shipping Progress Tracker -->
                <div class="card-luxury p-4 mb-4 bg-espresso border-gold-subtle">
                    <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap gap-2">
                        <span class="small fw-bold text-light" id="freeShippingNotice">
                            <i class="fa-solid fa-truck-fast text-gold me-2"></i>
                            <span data-i18n="cart.freeship_notice">Đơn hàng từ <strong>150.000₫</strong> được <strong>MIỄN PHÍ VẬN CHUYỂN TOÀN QUỐC</strong></span>
                        </span>
                        <span class="badge bg-gold text-obsidian fw-bold font-monospace px-3 py-1 rounded-pill" id="shippingStatusBadge" data-i18n="cart.freeship_badge">
                            FREESHIP
                        </span>
                    </div>
                    <div class="progress" style="height: 6px; background-color: rgba(212, 175, 55, 0.2);">
                        <div class="progress-bar bg-gold-gradient" role="progressbar" id="freeShippingBar" style="width: 80%;" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- Left: Cart Items Table -->
                    <div class="col-lg-8">
                        <div class="card-luxury p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom border-gold">
                                <h5 class="font-serif fw-bold text-gold mb-0"><span data-i18n="cart.item_list">Danh Sách Thức Uống</span> (${cart.items.size()})</h5>
                                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-gold btn-sm px-3 rounded-pill">
                                    <i class="fa-solid fa-plus me-1"></i> <span data-i18n="cart.add_more">Chọn Thêm Món</span>
                                </a>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-luxury align-middle">
                                    <thead>
                                        <tr class="small text-secondary">
                                            <th data-i18n="cart.th_beverage">Thức Uống</th>
                                            <th data-i18n="cart.th_unit_price">Đơn Giá</th>
                                            <th class="text-center" data-i18n="cart.th_quantity">Số Lượng</th>
                                            <th class="text-end" data-i18n="cart.th_total">Tạm Tính</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${cart.items}">
                                            <tr class="cart-item-row" data-item-id="${item.id}" data-unit-price="${item.unitPrice}">
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <img src="${not empty item.product.imageUrl ? item.product.imageUrl : 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=200&q=80'}" 
                                                             class="rounded-3 border border-gold-subtle object-fit-cover" 
                                                             style="width: 60px; height: 60px;" 
                                                             alt="${item.product.name}">
                                                        <div>
                                                            <div class="fw-bold font-serif fs-6 text-light">${item.product.name}</div>
                                                            <div class="small text-gold mt-1">
                                                                <span class="badge bg-espresso border border-gold-subtle me-1">Size: ${item.productSize.name}</span>
                                                                <span>${item.sugarLevel}% Đường</span> • <span>${item.iceLevel}% Đá</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="font-monospace text-secondary">
                                                    <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0"/> VNĐ
                                                </td>
                                                <td class="text-center">
                                                    <div class="input-group input-group-sm mx-auto" style="width: 105px;">
                                                        <button class="btn btn-outline-gold px-2 btn-qty-minus" type="button"><i class="fa-solid fa-minus fa-xs"></i></button>
                                                        <input type="text" class="form-control text-center font-monospace fw-bold bg-dark text-light border-gold item-qty-input" value="${item.quantity}" readonly>
                                                        <button class="btn btn-outline-gold px-2 btn-qty-plus" type="button"><i class="fa-solid fa-plus fa-xs"></i></button>
                                                    </div>
                                                </td>
                                                <td class="text-end fw-bold text-gold font-monospace item-subtotal-cell">
                                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> VNĐ
                                                </td>
                                                <td class="text-end">
                                                    <form action="${pageContext.request.contextPath}/cart/remove/${item.id}" method="post" class="d-inline">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                        <button type="submit" class="btn btn-sm btn-outline-danger border-0 p-2 rounded-circle" title="Xóa món">
                                                            <i class="fa-solid fa-trash-can"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Order Summary & Voucher Promo Box -->
                    <div class="col-lg-4">
                        <div class="card-luxury p-4 sticky-top" style="top: 100px;">
                            <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">
                                <i class="fa-solid fa-receipt me-2"></i><span data-i18n="cart.order_summary">Tóm Tắt Đơn Hàng</span>
                            </h5>
                            
                            <!-- Voucher Promo Input -->
                            <div class="mb-4">
                                <label class="form-label small text-gold fw-bold" data-i18n="cart.voucher_label">Mã Ưu Đãi / Voucher:</label>
                                <div class="input-group">
                                    <input type="text" id="voucherCodeInput" class="form-control form-control-luxury font-monospace text-uppercase" placeholder="VD: UTE2026, FREESHIP">
                                    <button class="btn btn-outline-gold px-3 font-accent fw-bold" type="button" id="applyVoucherBtn">
                                        <span data-i18n="cart.voucher_apply">Áp Dụng</span>
                                    </button>
                                </div>
                                <div id="voucherFeedback" class="small mt-1 text-success d-none">
                                    <i class="fa-solid fa-circle-check me-1"></i> <span id="voucherFeedbackText">Đã áp dụng mã UTE2026 (-20%)</span>
                                </div>
                            </div>

                            <!-- Cost Breakdown -->
                            <div class="d-flex justify-content-between mb-2 small text-secondary">
                                <span data-i18n="cart.subtotal_label">Tổng tiền món:</span>
                                <span class="text-light fw-bold font-monospace product-price-val" id="cartSubtotalText" data-raw-price="${cart.totalAmount}" data-vnd="${cart.totalAmount}">
                                    <fmt:formatNumber value="${cart.totalAmount}" pattern="#,##0"/> VNĐ
                                </span>
                            </div>
                            <div class="d-flex justify-content-between mb-2 small text-secondary">
                                <span data-i18n="cart.shipping_label">Phí vận chuyển:</span>
                                <span class="text-success fw-bold" id="cartShippingText" data-i18n="cart.free_text">Miễn Phí</span>
                            </div>
                            <div class="d-flex justify-content-between mb-3 small text-secondary">
                                <span data-i18n="cart.discount_label">Giảm giá voucher:</span>
                                <span class="text-gold fw-bold font-monospace" id="cartDiscountText">-0 VNĐ</span>
                            </div>

                            <hr class="border-secondary opacity-25">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <span class="fw-bold fs-6" data-i18n="cart.final_total_label">Thành Tiền:</span>
                                <span class="price-gold fs-3 fw-bold product-price-val" id="cartFinalTotalText" data-raw-price="${cart.totalAmount}" data-vnd="${cart.totalAmount}">
                                    <fmt:formatNumber value="${cart.totalAmount}" pattern="#,##0"/> VNĐ
                                </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/cart/checkout" class="btn btn-gold w-100 py-3 fw-bold fs-6 rounded-pill shadow-gold">
                                <i class="fa-solid fa-credit-card me-2"></i> <span data-i18n="cart.btn_checkout">Tiến Hành Thanh Toán</span>
                            </a>

                            <div class="text-center mt-3">
                                <span class="small text-secondary" style="font-size: 0.75rem;">
                                    <i class="fa-solid fa-shield-halved text-gold me-1"></i> <span data-i18n="cart.ssl_notice">Thanh toán bảo mật SSL 256-bit</span>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <div class="card-luxury p-5 mx-auto" style="max-width: 560px;">
                        <div class="mb-4">
                            <i class="fa-solid fa-bag-shopping text-gold display-1 opacity-50"></i>
                        </div>
                        <h3 class="font-serif fw-bold text-gold-gradient mb-2" data-i18n="cart.empty_title">Giỏ Hàng Của Bạn Đang Trống</h3>
                        <p class="text-secondary small mb-4" data-i18n="cart.empty_desc">
                            Hãy khám phá thực đơn cà phê rang mộc thủ công và trà hoa tinh tuyển của UTECoffe để chọn cho mình thức uống ưng ý.
                        </p>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold px-4 py-2.5 rounded-pill font-accent fw-bold shadow-gold-sm">
                            <i class="fa-solid fa-arrow-right me-1"></i> <span data-i18n="cart.empty_btn">Khám Phá Thực Đơn Ngay</span>
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Interactive Voucher & Quantity Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const voucherInput = document.getElementById('voucherCodeInput');
            const applyVoucherBtn = document.getElementById('applyVoucherBtn');
            const voucherFeedback = document.getElementById('voucherFeedback');
            const voucherFeedbackText = document.getElementById('voucherFeedbackText');
            const discountText = document.getElementById('cartDiscountText');
            const finalTotalText = document.getElementById('cartFinalTotalText');

            if (applyVoucherBtn && voucherInput) {
                applyVoucherBtn.addEventListener('click', function () {
                    const code = voucherInput.value.trim().toUpperCase();
                    if (code === 'UTE2026') {
                        voucherFeedback.className = 'small mt-1 text-success';
                        voucherFeedbackText.textContent = 'Mã UTE2026: Giảm 20% tổng đơn hàng!';
                        voucherFeedback.classList.remove('d-none');
                        if (discountText) discountText.textContent = '-20.000₫';
                    } else if (code === 'FREESHIP') {
                        voucherFeedback.className = 'small mt-1 text-success';
                        voucherFeedbackText.textContent = 'Mã FREESHIP: Miễn phí vận chuyển toàn quốc!';
                        voucherFeedback.classList.remove('d-none');
                    } else if (code) {
                        voucherFeedback.className = 'small mt-1 text-danger';
                        voucherFeedbackText.textContent = 'Mã ưu đãi không hợp lệ hoặc đã hết hạn.';
                        voucherFeedback.classList.remove('d-none');
                    }
                });
            }
        });
    </script>
</body>
