<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Thanh Toán Đơn Hàng - UTECoffe</title>
</head>
<body>
    <div class="container py-5">
        <h3 class="fw-bold mb-4"><i class="fa-solid fa-credit-card me-2 text-warning"></i> Thông Tin Thanh Toán</h3>
        <div class="row g-4">
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm p-4 mb-4">
                    <h5 class="fw-bold mb-3">1. Hình Thức Đặt Món</h5>
                    <div class="row g-3 mb-4">
                        <div class="col-4">
                            <input type="radio" class="btn-check" name="orderType" id="takeaway" value="TAKE_AWAY" checked>
                            <label class="btn btn-outline-secondary w-100 py-3" for="takeaway">
                                <i class="fa-solid fa-bag-shopping d-block mb-1 fs-5"></i> Mang Đi
                            </label>
                        </div>
                        <div class="col-4">
                            <input type="radio" class="btn-check" name="orderType" id="delivery" value="DELIVERY">
                            <label class="btn btn-outline-secondary w-100 py-3" for="delivery">
                                <i class="fa-solid fa-motorcycle d-block mb-1 fs-5"></i> Giao Hàng
                            </label>
                        </div>
                        <div class="col-4">
                            <input type="radio" class="btn-check" name="orderType" id="dinein" value="DINE_IN">
                            <label class="btn btn-outline-secondary w-100 py-3" for="dinein">
                                <i class="fa-solid fa-utensils d-block mb-1 fs-5"></i> Dùng Tại Bàn
                            </label>
                        </div>
                    </div>

                    <h5 class="fw-bold mb-3">2. Chi Nhánh Phục Vụ</h5>
                    <select class="form-select mb-4" id="storeSelect">
                        <c:forEach var="store" items="${stores}">
                            <option value="${store.id}">${store.name} - ${store.address}</option>
                        </c:forEach>
                    </select>

                    <h5 class="fw-bold mb-3">3. Thông Tin Người Nhận</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="recipientName" placeholder="Họ và tên..." required>
                        </div>
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="recipientPhone" placeholder="Số điện thoại..." required>
                        </div>
                        <div class="col-12">
                            <input type="text" class="form-control" id="deliveryAddress" placeholder="Địa chỉ giao hàng (nếu chọn giao tận nơi)...">
                        </div>
                        <div class="col-12">
                            <textarea class="form-control" id="orderNote" rows="2" placeholder="Ghi chú đơn hàng (ít ngọt, không đá, số bàn, v.v.)..."></textarea>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm p-4">
                    <h5 class="fw-bold mb-3">4. Phương Thức Thanh Toán</h5>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="paymentMethod" id="pmVietQr" value="VIETQR" checked>
                        <label class="form-check-label fw-bold" for="pmVietQr">
                            <i class="fa-solid fa-qrcode text-primary me-2"></i> VietQR Chuyển Khoản Nhanh 24/7 (Khuyên dùng)
                        </label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="radio" name="paymentMethod" id="pmCod" value="COD">
                        <label class="form-check-label fw-bold" for="pmCod">
                            <i class="fa-solid fa-money-bill-wave text-success me-2"></i> Thanh toán tiền mặt khi nhận hàng (COD)
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="paymentMethod" id="pmVnpay" value="VNPAY">
                        <label class="form-check-label fw-bold" for="pmVnpay">
                            <i class="fa-regular fa-credit-card text-danger me-2"></i> Cổng thanh toán VNPAY / Ví MoMo
                        </label>
                    </div>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="card border-0 shadow-sm p-4 sticky-top" style="top: 100px;">
                    <h5 class="fw-bold mb-3">Đơn Hàng Của Bạn</h5>
                    <div id="checkoutItemsList" class="mb-3"></div>
                    <hr>
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" id="couponInput" placeholder="Mã giảm giá (UTECOFFEWELCOME)...">
                        <button class="btn btn-outline-secondary" type="button">Áp Dụng</button>
                    </div>
                    <div class="d-flex justify-content-between mb-4">
                        <span class="fw-bold fs-5">Tổng Thanh Toán:</span>
                        <span id="checkoutTotal" class="fw-bold text-danger fs-5">0 ₫</span>
                    </div>
                    <button class="btn btn-gold w-100 py-3 fw-bold" onclick="submitOrder()">
                        Xác Nhận Đặt Đơn Hàng
                    </button>
                </div>
            </div>
        </div>
    </div>
    <script>
        function loadCheckout() {
            let cart = JSON.parse(localStorage.getItem('utecoffe_cart') || '[]');
            let list = document.getElementById('checkoutItemsList');
            let total = 0;
            list.innerHTML = '';
            cart.forEach(i => {
                let itemTotal = i.unitPrice * i.quantity;
                total += itemTotal;
                list.innerHTML += `<div class="d-flex justify-content-between small mb-1">
                    <span>${i.name} x ${i.quantity}</span>
                    <span class="fw-bold">${itemTotal.toLocaleString('vi-VN')} ₫</span>
                </div>`;
            });
            document.getElementById('checkoutTotal').innerText = total.toLocaleString('vi-VN') + ' ₫';
        }

        async function submitOrder() {
            let cart = JSON.parse(localStorage.getItem('utecoffe_cart') || '[]');
            if (cart.length === 0) {
                alert('Giỏ hàng trống!');
                return;
            }

            let orderType = document.querySelector('input[name="orderType"]:checked').value;
            let paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
            let storeId = document.getElementById('storeSelect').value;
            let name = document.getElementById('recipientName').value;
            let phone = document.getElementById('recipientPhone').value;
            let addr = document.getElementById('deliveryAddress').value;
            let note = document.getElementById('orderNote').value;
            let coupon = document.getElementById('couponInput').value;

            if (!name || !phone) {
                alert('Vui lòng nhập tên và số điện thoại nhận hàng!');
                return;
            }

            let payload = {
                storeId: parseInt(storeId),
                orderType: orderType,
                paymentMethod: paymentMethod,
                recipientName: name,
                recipientPhone: phone,
                deliveryAddress: addr,
                note: note,
                couponCode: coupon,
                items: cart.map(i => ({
                    productId: parseInt(i.productId),
                    quantity: parseInt(i.quantity)
                }))
            };

            try {
                let res = await fetch('${pageContext.request.contextPath}/api/orders', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });
                let data = await res.json();
                if (data.success) {
                    localStorage.removeItem('utecoffe_cart');
                    window.location.href = '${pageContext.request.contextPath}/orders/tracking/' + data.data.orderCode;
                } else {
                    alert('Lỗi đặt hàng: ' + data.message);
                }
            } catch (err) {
                alert('Không thể kết nối đến máy chủ: ' + err);
            }
        }

        document.addEventListener('DOMContentLoaded', loadCheckout);
    </script>
</body>
