<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>${product.name} - UTECoffe</title>
</head>
<body>
    <div class="container py-5">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu">Thực Đơn</a></li>
                <li class="breadcrumb-item active">${product.name}</li>
            </ol>
        </nav>

        <div class="row g-5">
            <div class="col-md-6">
                <img src="${product.imageUrl}" alt="${product.name}" class="img-fluid rounded-4 shadow-sm w-100" style="max-height: 480px; object-fit: cover;">
            </div>
            <div class="col-md-6">
                <span class="badge bg-warning text-dark text-uppercase mb-2">${product.category.name}</span>
                <h2 class="fw-bold mb-3">${product.name}</h2>
                <h3 class="text-danger fw-bold mb-4">
                    <fmt:formatNumber value="${product.basePrice}" type="currency" currencySymbol="₫"/>
                </h3>
                <p class="text-muted mb-4 lead" style="font-size: 1rem;">${product.description}</p>

                <hr class="my-4">

                <div class="mb-4">
                    <label class="form-label fw-bold">Số Lượng:</label>
                    <div class="input-group" style="width: 140px;">
                        <button class="btn btn-outline-secondary" type="button" onclick="decrementQty()">-</button>
                        <input type="text" id="productQty" class="form-control text-center" value="1" readonly>
                        <button class="btn btn-outline-secondary" type="button" onclick="incrementQty()">+</button>
                    </div>
                </div>

                <div class="d-flex gap-3">
                    <button class="btn btn-gold btn-lg px-4" onclick="addToCart('${product.id}', '${product.name}', ${product.basePrice})">
                        <i class="fa-solid fa-cart-plus me-2"></i> Thêm Vào Giỏ Hàng
                    </button>
                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-dark btn-lg px-4">
                        Mua Ngay
                    </a>
                </div>
            </div>
        </div>
    </div>
    <script>
        function incrementQty() {
            let el = document.getElementById('productQty');
            el.value = parseInt(el.value) + 1;
        }
        function decrementQty() {
            let el = document.getElementById('productQty');
            if (parseInt(el.value) > 1) el.value = parseInt(el.value) - 1;
        }
        function addToCart(id, name, price) {
            let qty = parseInt(document.getElementById('productQty').value);
            let cart = JSON.parse(localStorage.getItem('utecoffe_cart') || '[]');
            let existing = cart.find(i => i.productId == id);
            if (existing) {
                existing.quantity += qty;
            } else {
                cart.push({ productId: id, name: name, unitPrice: price, quantity: qty });
            }
            localStorage.setItem('utecoffe_cart', JSON.stringify(cart));
            alert('Đã thêm món vào giỏ hàng thành công!');
            window.location.href = '${pageContext.request.contextPath}/cart';
        }
    </script>
</body>
