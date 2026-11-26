<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Giỏ Hàng Của Bạn - UTECoffe Specialty Roastery</title>
</head>
<body class="bg-obsidian">

    <!-- Header Banner: Compact & Elegant -->
    <div class="py-3 bg-espresso border-bottom border-gold text-center">
        <div class="container py-1">
            <span class="badge bg-gold-subtle text-gold px-2.5 py-0.5 rounded-2 small mb-1 fw-medium" style="font-size: 0.72rem;" data-i18n="cart.badge">
                <i class="fa-solid fa-bag-shopping me-1"></i> Túi Thưởng Thức Nghệ Nhân
            </span>
            <h1 class="font-serif fs-4 fw-bold text-primary mb-1" data-i18n="cart.title">
                Giỏ Hàng Thức Uống
            </h1>
            <p class="text-secondary mx-auto small mb-0" style="max-width: 540px; font-size: 0.82rem;" data-i18n="cart.desc">
                Mỗi thức uống được pha chế thủ công ngay khi nhận đơn để đảm bảo hương vị trọn vẹn nhất.
            </p>
        </div>
    </div>

    <!-- Main Content Container: Tightly Bounded to Prevent Stretched Elements -->
    <div class="container py-4 cart-container-compact">
        <c:choose>
            <c:when test="${not empty cart and not empty cart.items}">
                <!-- Free Shipping Progress Tracker: Compact & Neat -->
                <div class="card-luxury p-3 mb-3 bg-espresso border-gold-subtle">
                    <div class="d-flex justify-content-between align-items-center mb-1.5 flex-wrap gap-2">
                        <span class="small fw-bold text-primary" id="freeShippingNotice" style="font-size: 0.82rem;">
                            <i class="fa-solid fa-truck-fast text-gold me-2"></i>
                            <span data-i18n="cart.freeship_notice">Đơn hàng từ <strong>150.000₫</strong> được <strong>MIỄN PHÍ VẬN CHUYỂN TOÀN QUỐC</strong></span>
                        </span>
                        <span class="badge bg-gold text-dark fw-semibold px-2.5 py-0.5 rounded-2" id="shippingStatusBadge" style="font-size: 0.72rem;" data-i18n="cart.freeship_badge">
                            FREESHIP
                        </span>
                    </div>
                    <div class="progress" style="height: 5px; background-color: rgba(212, 175, 55, 0.15);">
                        <div class="progress-bar bg-gold" role="progressbar" id="freeShippingBar" style="width: 80%;" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                </div>

                <div class="row g-3">
                    <!-- Left: Cart Items & Smart Pairing Suggestions -->
                    <div class="col-lg-8">
                        <div class="card-luxury p-3 p-md-3.5 mb-3">
                            <div class="d-flex justify-content-between align-items-center mb-2.5 pb-2 border-bottom border-gold">
                                <h6 class="font-serif fw-bold text-gold mb-0" style="font-size: 0.95rem;">
                                    <span data-i18n="cart.item_list">Danh Sách Thức Uống</span> (${cart.items.size()})
                                </h6>
                                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-gold btn-sm px-2.5 py-1 rounded-2" style="font-size: 0.78rem;">
                                    <i class="fa-solid fa-plus me-1"></i> <span data-i18n="cart.add_more">Chọn Thêm Món</span>
                                </a>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-luxury table-cart-compact align-middle mb-0">
                                    <thead>
                                        <tr class="small text-secondary">
                                            <th data-i18n="cart.th_beverage">Thức Uống</th>
                                            <th data-i18n="cart.th_unit_price">Đơn Giá</th>
                                            <th class="text-center" data-i18n="cart.th_quantity">Số Lượng</th>
                                            <th class="text-end" data-i18n="cart.th_total">Tạm Tính</th>
                                            <th style="width: 36px;"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${cart.items}">
                                            <tr class="cart-item-row" data-item-id="${item.id}" data-unit-price="${item.unitPrice}">
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-shrink-0 me-3 position-relative" style="width: 56px; height: 56px;">
                                                            <img src="${not empty item.product.imageUrl ? item.product.imageUrl : 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=200&q=80'}" 
                                                                 class="rounded-3 border border-gold-subtle object-fit-cover shadow-sm w-100 h-100" 
                                                                 alt="${item.product.name}">
                                                        </div>
                                                        <div class="flex-grow-1 min-w-0">
                                                            <div class="cart-product-title font-serif fw-bold text-primary mb-1" style="font-size: 1.05rem; letter-spacing: -0.01em; word-break: break-word;">${item.product.name}</div>
                                                            <div class="cart-product-meta d-flex align-items-center flex-wrap gap-1">
                                                                <span class="badge bg-espresso border border-gold-subtle px-2 py-0.5 text-gold" style="font-size: 0.72rem; letter-spacing: 0.04em;">
                                                                    <c:choose>
                                                                        <c:when test="${not empty item.productSize and not empty item.productSize.name and item.productSize.name.toLowerCase().startsWith('size')}">
                                                                            ${item.productSize.name}
                                                                        </c:when>
                                                                        <c:when test="${not empty item.productSize and not empty item.productSize.name}">
                                                                            Size ${item.productSize.name}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Size M
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                                <span class="text-secondary small font-monospace">${item.sugarLevel}% Đường</span>
                                                                <span class="text-gold opacity-50">•</span>
                                                                <span class="text-secondary small font-monospace">${item.iceLevel}% Đá</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="font-monospace text-secondary text-nowrap" style="font-size: 0.88rem; white-space: nowrap !important;">
                                                    <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0"/> VNĐ
                                                </td>
                                                <td class="text-center">
                                                    <div class="input-group input-group-sm mx-auto" style="width: 96px;">
                                                        <button class="btn btn-outline-gold px-1.5 btn-qty-minus" type="button"><i class="fa-solid fa-minus fa-2xs"></i></button>
                                                        <input type="text" class="form-control form-control-luxury text-center font-monospace fw-bold item-qty-input px-1" style="font-size: 0.85rem;" value="${item.quantity}" readonly>
                                                        <button class="btn btn-outline-gold px-1.5 btn-qty-plus" type="button"><i class="fa-solid fa-plus fa-2xs"></i></button>
                                                    </div>
                                                </td>
                                                <td class="text-end fw-bold text-gold font-monospace item-subtotal-cell text-nowrap" style="font-size: 0.95rem; white-space: nowrap !important;">
                                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> VNĐ
                                                </td>
                                                <td class="text-end">
                                                    <form action="${pageContext.request.contextPath}/cart/remove/${item.id}" method="post" class="d-inline">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                        <button type="submit" class="btn btn-sm btn-outline-danger border-0 rounded-circle p-2 text-secondary hover-danger" title="Xóa món">
                                                            <i class="fa-regular fa-trash-can fa-sm"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Recommendations: Compact Shelf -->
                        <c:if test="${not empty cart.pairingRecommendations}">
                            <div class="cart-rec-shelf p-3 mb-3">
                                <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap gap-2">
                                    <h6 class="font-serif fw-bold text-gold mb-0" style="font-size: 0.88rem;">
                                        <i class="fa-solid fa-wand-magic-sparkles me-1 text-gold"></i> Gợi Ý Món Dùng Kèm Hoàn Hảo
                                    </h6>
                                    <span class="badge bg-gold-subtle text-gold font-accent" style="font-size: 0.68rem;">
                                        Phổ biến cùng đơn hàng
                                    </span>
                                </div>
                                <div class="row g-2.5">
                                    <c:forEach var="rec" items="${cart.pairingRecommendations}">
                                        <div class="col-sm-4">
                                            <div class="cart-rec-item p-2.5 h-100 d-flex flex-column justify-content-between">
                                                <div class="d-flex align-items-center gap-2 mb-2">
                                                    <img src="${not empty rec.targetImageUrl ? rec.targetImageUrl : 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=200&q=80'}" 
                                                         class="rounded-2 border border-gold-subtle object-fit-cover flex-shrink-0" 
                                                         style="width: 44px; height: 44px;" 
                                                         alt="${rec.targetProductName}">
                                                    <div class="min-w-0 flex-grow-1">
                                                        <div class="text-primary fw-bold lh-sm" title="${rec.targetProductName}" style="font-size: 0.84rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; min-height: 2.1em;">
                                                            ${rec.targetProductName}
                                                        </div>
                                                        <div class="price-gold font-monospace fw-bold mt-1" style="font-size: 0.8rem;">
                                                            <fmt:formatNumber value="${rec.targetPrice}" pattern="#,##0"/> VNĐ
                                                        </div>
                                                    </div>
                                                </div>
                                                <button type="button" class="btn btn-outline-gold btn-sm w-100 py-1 rounded-pill font-accent d-flex align-items-center justify-content-center gap-1" style="font-size: 0.75rem;" onclick="quickAddPairing(${rec.targetProductId})">
                                                    <i class="fa-solid fa-plus fa-xs"></i> <span>Thêm Nhanh</span>
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Right: Order Summary & Voucher Promo Box (Compact & Balanced) -->
                    <div class="col-lg-4">
                        <div class="card-luxury p-3 p-md-3.5 sticky-top" style="top: 85px;">
                            <h6 class="font-serif fw-bold text-primary mb-2.5 border-bottom border-gold pb-2" style="font-size: 0.98rem;">
                                <i class="fa-solid fa-receipt me-1.5"></i><span data-i18n="cart.order_summary">Tóm Tắt Đơn Hàng</span>
                            </h6>
                            
                            <!-- Voucher Promo Input -->
                            <div class="mb-3">
                                <label class="form-label small text-gold fw-bold mb-1" style="font-size: 0.78rem;" data-i18n="cart.voucher_label">Mã Ưu Đãi / Voucher:</label>
                                <div class="input-group input-group-sm">
                                    <input type="text" id="voucherCodeInput" class="form-control form-control-luxury font-monospace text-uppercase" placeholder="VD: UTE2026, FREESHIP" style="font-size: 0.82rem;">
                                    <button class="btn btn-outline-gold px-2.5 font-accent fw-bold" type="button" id="applyVoucherBtn" style="font-size: 0.8rem;">
                                        <span data-i18n="cart.voucher_apply">Áp Dụng</span>
                                    </button>
                                </div>
                                <div class="d-flex flex-wrap gap-1 mt-1.5">
                                    <button type="button" class="badge bg-espresso border border-gold-subtle text-gold py-1 px-2 cursor-pointer voucher-quick-pill" style="font-size: 0.7rem;" onclick="quickApplyVoucher('UTE2026')">
                                        <i class="fa-solid fa-tag me-1"></i> UTE2026 (-20%)
                                    </button>
                                    <button type="button" class="badge bg-espresso border border-gold-subtle text-gold py-1 px-2 cursor-pointer voucher-quick-pill" style="font-size: 0.7rem;" onclick="quickApplyVoucher('FREESHIP')">
                                        <i class="fa-solid fa-truck-fast me-1"></i> FREESHIP
                                    </button>
                                </div>
                                <div id="voucherFeedback" class="small mt-1 text-success d-none" style="font-size: 0.78rem;">
                                    <i class="fa-solid fa-circle-check me-1"></i> <span id="voucherFeedbackText">Đã áp dụng mã UTE2026 (-20%)</span>
                                </div>
                            </div>

                            <!-- Cost Breakdown -->
                            <div class="d-flex justify-content-between mb-1.5 small text-secondary" style="font-size: 0.82rem;">
                                <span data-i18n="cart.subtotal_label">Tổng tiền món:</span>
                                <span class="text-primary fw-bold font-monospace product-price-val" id="cartSubtotalText" data-raw-price="${cart.totalAmount}" data-vnd="${cart.totalAmount}">
                                    <fmt:formatNumber value="${cart.totalAmount}" pattern="#,##0"/> VNĐ
                                </span>
                            </div>
                            <div class="d-flex justify-content-between mb-1.5 small text-secondary" style="font-size: 0.82rem;">
                                <span data-i18n="cart.shipping_label">Phí vận chuyển:</span>
                                <span class="text-success fw-bold" id="cartShippingText" data-i18n="cart.free_text">Miễn Phí</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2 small text-secondary" style="font-size: 0.82rem;">
                                <span data-i18n="cart.discount_label">Giảm giá voucher:</span>
                                <span class="text-gold fw-bold font-monospace" id="cartDiscountText">-0 VNĐ</span>
                            </div>

                            <hr class="border-secondary opacity-25 my-2">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="fw-bold" style="font-size: 0.92rem;" data-i18n="cart.final_total_label">Thành Tiền:</span>
                                <span class="price-gold fs-4 fw-bold product-price-val" id="cartFinalTotalText" data-raw-price="${cart.totalAmount}" data-vnd="${cart.totalAmount}">
                                    <fmt:formatNumber value="${cart.totalAmount}" pattern="#,##0"/> VNĐ
                                </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/cart/checkout" class="btn btn-gold w-100 py-2.5 fw-semibold fs-6">
                                <i class="fa-solid fa-credit-card me-1.5"></i> <span data-i18n="cart.btn_checkout">Tiến Hành Thanh Toán</span>
                            </a>

                            <div class="text-center mt-2.5">
                                <span class="text-secondary" style="font-size: 0.72rem;">
                                    <i class="fa-solid fa-shield-halved text-gold me-1"></i> <span data-i18n="cart.ssl_notice">Thanh toán bảo mật SSL 256-bit</span>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-4">
                    <div class="card-luxury p-4 mx-auto" style="max-width: 480px;">
                        <div class="mb-3">
                            <i class="fa-solid fa-bag-shopping text-gold display-3 opacity-50"></i>
                        </div>
                        <h4 class="font-serif fw-bold text-primary mb-2" data-i18n="cart.empty_title">Giỏ Hàng Của Bạn Đang Trống</h4>
                        <p class="text-secondary small mb-3" style="font-size: 0.82rem;" data-i18n="cart.empty_desc">
                            Hãy khám phá thực đơn cà phê rang mộc thủ công và trà hoa tinh tuyển của UTECoffe để chọn cho mình thức uống ưng ý.
                        </p>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold px-4 py-2 fw-semibold" style="font-size: 0.85rem;">
                            <i class="fa-solid fa-arrow-right me-1"></i> <span data-i18n="cart.empty_btn">Khám Phá Thực Đơn Ngay</span>
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Interactive Dynamic Cart Engine with Algorithmic Voucher & Free Shipping Progress -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const voucherInput = document.getElementById('voucherCodeInput');
            const applyVoucherBtn = document.getElementById('applyVoucherBtn');
            const voucherFeedback = document.getElementById('voucherFeedback');
            const voucherFeedbackText = document.getElementById('voucherFeedbackText');
            const discountText = document.getElementById('cartDiscountText');
            const subtotalText = document.getElementById('cartSubtotalText');
            const shippingText = document.getElementById('cartShippingText');
            const finalTotalText = document.getElementById('cartFinalTotalText');
            const freeShippingBar = document.getElementById('freeShippingBar');
            const freeShippingNotice = document.getElementById('freeShippingNotice');
            const shippingStatusBadge = document.getElementById('shippingStatusBadge');

            function formatCurrency(val) {
                return Math.round(val).toLocaleString('vi-VN') + ' VNĐ';
            }

            function updateFreeShippingProgress(subtotal) {
                const threshold = 150000;
                const percent = Math.min(100, Math.round((subtotal / threshold) * 100));
                if (freeShippingBar) {
                    freeShippingBar.style.width = percent + '%';
                    freeShippingBar.setAttribute('aria-valuenow', percent);
                }
                if (freeShippingNotice) {
                    if (subtotal >= threshold) {
                        freeShippingNotice.innerHTML = '<i class="fa-solid fa-circle-check text-success me-2"></i>Đơn hàng đã đủ điều kiện <strong>MIỄN PHÍ VẬN CHUYỂN TOÀN QUỐC!</strong>';
                        if (shippingStatusBadge) {
                            shippingStatusBadge.className = 'badge bg-success text-primary fw-bold font-monospace px-2.5 py-0.5 rounded-pill';
                            shippingStatusBadge.textContent = 'FREESHIP ĐẠT';
                        }
                        if (shippingText) shippingText.textContent = 'Miễn Phí';
                    } else {
                        const remaining = threshold - subtotal;
                        freeShippingNotice.innerHTML = '<i class="fa-solid fa-truck-fast text-gold me-2"></i>Mua thêm <strong>' + formatCurrency(remaining) + '</strong> để được <strong>MIỄN PHÍ VẬN CHUYỂN!</strong>';
                        if (shippingStatusBadge) {
                            shippingStatusBadge.className = 'badge bg-gold text-obsidian fw-bold font-monospace px-2.5 py-0.5 rounded-pill';
                            shippingStatusBadge.textContent = 'CẦN THÊM ' + percent + '%';
                        }
                    }
                }
            }

            // Initial calculation
            const rawSubtotal = parseFloat(subtotalText ? subtotalText.getAttribute('data-raw-price') : 0) || 0;
            updateFreeShippingProgress(rawSubtotal);

            // Quantity increment & decrement handlers
            document.querySelectorAll('.cart-item-row').forEach(row => {
                const itemId = row.getAttribute('data-item-id');
                const unitPrice = parseFloat(row.getAttribute('data-unit-price')) || 0;
                const qtyInput = row.querySelector('.item-qty-input');
                const subtotalCell = row.querySelector('.item-subtotal-cell');
                const btnPlus = row.querySelector('.btn-qty-plus');
                const btnMinus = row.querySelector('.btn-qty-minus');

                function updateItemQuantity(newQty) {
                    const formData = new URLSearchParams();
                    formData.append('itemId', itemId);
                    formData.append('quantity', newQty);

                    fetch('${pageContext.request.contextPath}/cart/update', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'X-CSRF-TOKEN': '${_csrf.token}'
                        },
                        body: formData.toString()
                    })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            if (newQty <= 0) {
                                row.remove();
                                if (document.querySelectorAll('.cart-item-row').length === 0) {
                                    window.location.reload();
                                }
                            } else {
                                if (qtyInput) qtyInput.value = newQty;
                                if (subtotalCell) subtotalCell.textContent = formatCurrency(unitPrice * newQty);
                            }
                            if (subtotalText) {
                                subtotalText.textContent = formatCurrency(data.totalAmount);
                                subtotalText.setAttribute('data-raw-price', data.totalAmount);
                            }
                            if (finalTotalText) finalTotalText.textContent = formatCurrency(data.finalAmount);
                            updateFreeShippingProgress(data.totalAmount);
                        }
                    })
                    .catch(e => console.warn('Quantity update error:', e));
                }

                if (btnPlus) {
                    btnPlus.addEventListener('click', function () {
                        const curQty = parseInt(qtyInput ? qtyInput.value : 1) || 1;
                        updateItemQuantity(curQty + 1);
                    });
                }

                if (btnMinus) {
                    btnMinus.addEventListener('click', function () {
                        const curQty = parseInt(qtyInput ? qtyInput.value : 1) || 1;
                        if (curQty > 1) {
                            updateItemQuantity(curQty - 1);
                        } else if (confirm('Bạn có muốn xóa thức uống này khỏi giỏ hàng?')) {
                            updateItemQuantity(0);
                        }
                    });
                }
            });

            // Voucher Application with Knapsack Optimization Feedback
            if (applyVoucherBtn && voucherInput) {
                applyVoucherBtn.addEventListener('click', function () {
                    const code = voucherInput.value.trim().toUpperCase();
                    if (!code) return;

                    const formData = new URLSearchParams();
                    formData.append('code', code);

                    fetch('${pageContext.request.contextPath}/cart/apply-voucher', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'X-CSRF-TOKEN': '${_csrf.token}'
                        },
                        body: formData.toString()
                    })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            voucherFeedback.className = 'small mt-1 text-success';
                            if (code === 'UTE2026') {
                                voucherFeedbackText.textContent = 'Mã UTE2026: Giảm 20% (Tiết kiệm ' + formatCurrency(data.discountAmount) + ')!';
                            } else if (code === 'FREESHIP') {
                                voucherFeedbackText.textContent = 'Mã FREESHIP: Miễn phí vận chuyển toàn quốc!';
                            } else {
                                voucherFeedbackText.textContent = data.message || 'Đã áp dụng mã ' + code;
                            }
                            voucherFeedback.classList.remove('d-none');

                            if (discountText) discountText.textContent = '-' + formatCurrency(data.discountAmount);
                            if (finalTotalText) finalTotalText.textContent = formatCurrency(data.finalAmount);
                            if (data.shippingFee === 0 && shippingText) shippingText.textContent = 'Miễn Phí';
                        } else {
                            voucherFeedback.className = 'small mt-1 text-danger';
                            voucherFeedbackText.textContent = data.message || 'Mã ưu đãi không hợp lệ.';
                            voucherFeedback.classList.remove('d-none');
                        }
                    })
                    .catch(() => {
                        voucherFeedback.className = 'small mt-1 text-danger';
                        voucherFeedbackText.textContent = 'Không thể kết nối máy chủ để kiểm tra voucher.';
                        voucherFeedback.classList.remove('d-none');
                    });
                });
            }
        });

        function quickApplyVoucher(code) {
            const input = document.getElementById('voucherCodeInput');
            if (input) {
                input.value = code;
                const btn = document.getElementById('applyVoucherBtn');
                if (btn) btn.click();
            }
        }

        function quickAddPairing(productId) {
            const formData = new URLSearchParams();
            formData.append('productId', productId);
            formData.append('size', 'M');
            formData.append('sugar', '100');
            formData.append('ice', '100');
            formData.append('quantity', '1');

            fetch('${pageContext.request.contextPath}/cart/add', {
                method: 'POST',
                keepalive: true,
                credentials: 'include',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-CSRF-TOKEN': '${_csrf.token}'
                },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    window.location.reload();
                }
            })
            .catch(e => console.warn('Quick add error:', e));
        }
    </script>
</body>
