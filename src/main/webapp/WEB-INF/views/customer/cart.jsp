<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Giỏ Hàng Của Bạn - UTECoffe</title>
</head>
<body>
    <div class="container py-5">
        <h3 class="fw-bold mb-4"><i class="fa-solid fa-bag-shopping me-2 text-warning"></i> Giỏ Hàng Của Bạn</h3>
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm p-3">
                    <table class="table align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Món</th>
                                <th>Đơn Giá</th>
                                <th>Số Lượng</th>
                                <th>Thành Tiền</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody id="cartTableBody">
                            <!-- Populated dynamically via JS -->
                        </tbody>
                    </table>
                    <div id="emptyCartMsg" class="text-center py-5 d-none">
                        <i class="fa-solid fa-basket-shopping fs-1 text-muted mb-3"></i>
                        <p class="text-muted">Giỏ hàng của bạn đang trống.</p>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold btn-sm">Xem Thực Đơn</a>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm p-4">
                    <h5 class="fw-bold mb-3">Tóm Tắt Đơn Hàng</h5>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Tạm tính:</span>
                        <span id="subtotalText" class="fw-bold">0 ₫</span>
                    </div>
                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted">Giảm giá:</span>
                        <span class="text-success fw-bold">-0 ₫</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between mb-4">
                        <span class="fw-bold fs-5">Tổng cộng:</span>
                        <span id="totalText" class="fw-bold text-danger fs-5">0 ₫</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-gold w-100 py-2 fw-bold">
                        Tiến Hành Thanh Toán
                    </a>
                </div>
            </div>
        </div>
    </div>
    <script>
        function renderCart() {
            let cart = JSON.parse(localStorage.getItem('utecoffe_cart') || '[]');
            let tbody = document.getElementById('cartTableBody');
            let emptyMsg = document.getElementById('emptyCartMsg');
            tbody.innerHTML = '';

            if (cart.length === 0) {
                emptyMsg.classList.remove('d-none');
                document.getElementById('subtotalText').innerText = '0 ₫';
                document.getElementById('totalText').innerText = '0 ₫';
                return;
            }
            emptyMsg.classList.add('d-none');

            let subtotal = 0;
            cart.forEach((item, index) => {
                let itemTotal = item.unitPrice * item.quantity;
                subtotal += itemTotal;
                tbody.innerHTML += `
                    <tr>
                        <td class="fw-bold">${item.name}</td>
                        <td>${item.unitPrice.toLocaleString('vi-VN')} ₫</td>
                        <td>${item.quantity}</td>
                        <td class="text-danger fw-bold">${itemTotal.toLocaleString('vi-VN')} ₫</td>
                        <td>
                            <button class="btn btn-sm btn-outline-danger" onclick="removeItem(${index})">
                                <i class="fa-solid fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
            });

            document.getElementById('subtotalText').innerText = subtotal.toLocaleString('vi-VN') + ' ₫';
            document.getElementById('totalText').innerText = subtotal.toLocaleString('vi-VN') + ' ₫';
        }

        function removeItem(index) {
            let cart = JSON.parse(localStorage.getItem('utecoffe_cart') || '[]');
            cart.splice(index, 1);
            localStorage.setItem('utecoffe_cart', JSON.stringify(cart));
            renderCart();
        }

        document.addEventListener('DOMContentLoaded', renderCart);
    </script>
</body>
