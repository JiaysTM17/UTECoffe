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

        <div class="row g-5 mb-5">
            <div class="col-md-6">
                <img src="${product.imageUrl}" alt="${product.name}" class="img-fluid rounded-4 shadow-sm w-100" style="max-height: 480px; object-fit: cover;">
            </div>
            <div class="col-md-6">
                <span class="badge bg-warning text-dark text-uppercase mb-2">${product.category.name}</span>
                <h2 class="fw-bold mb-2">${product.name}</h2>
                <div class="d-flex align-items-center gap-2 mb-3">
                    <span class="text-warning fs-5">
                        <i class="fa-solid fa-star"></i>
                        <span class="fw-bold text-dark fs-6">${avgRating} / 5.0</span>
                    </span>
                    <span class="text-muted small">(${reviews.size()} đánh giá)</span>
                </div>
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

        <!-- Reviews & Ratings Section -->
        <div class="card border-0 shadow-sm p-4">
            <h4 class="fw-bold mb-4"><i class="fa-regular fa-comments text-warning me-2"></i> Đánh Giá Từ Khách Hàng</h4>
            
            <div class="row g-4 mb-4">
                <div class="col-md-4 text-center border-end">
                    <h1 class="display-3 fw-bold text-warning mb-0">${avgRating}</h1>
                    <div class="text-warning mb-2">
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <p class="text-muted small">Dựa trên ${reviews.size()} đánh giá thực tế</p>
                </div>
                <div class="col-md-8">
                    <h6 class="fw-bold mb-3">Gửi Cảm Nhận Của Bạn</h6>
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <form id="reviewForm" onsubmit="submitReview(event)">
                                <div class="mb-3">
                                    <label class="form-label small fw-bold">Điểm đánh giá:</label>
                                    <select class="form-select form-select-sm" id="reviewRating" style="width: 160px;">
                                        <option value="5">⭐⭐⭐⭐⭐ (5/5)</option>
                                        <option value="4">⭐⭐⭐⭐ (4/5)</option>
                                        <option value="3">⭐⭐⭐ (3/5)</option>
                                        <option value="2">⭐⭐ (2/5)</option>
                                        <option value="1">⭐ (1/5)</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <textarea class="form-control" id="reviewComment" rows="3" placeholder="Chia sẻ cảm nhận về hương vị, độ đậm đà, bao bì của thức uống..." required></textarea>
                                </div>
                                <button type="submit" class="btn btn-gold btn-sm px-4 fw-bold">Gửi Đánh Giá</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-light border small">
                                Vui lòng <a href="${pageContext.request.contextPath}/auth/login" class="fw-bold text-warning">Đăng nhập</a> để chia sẻ cảm nhận hương vị của bạn.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <hr>

            <!-- Reviews List -->
            <div class="reviews-list mt-3">
                <c:choose>
                    <c:when test="${empty reviews}">
                        <p class="text-muted text-center py-4">Chưa có đánh giá nào cho sản phẩm này. Hãy là người đầu tiên trải nghiệm và chia sẻ!</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="rev" items="${reviews}">
                            <div class="py-3 border-bottom">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="fw-bold text-dark">${rev.user.fullName}</span>
                                    <span class="small text-muted">${rev.createdAt}</span>
                                </div>
                                <div class="text-warning small mb-2">
                                    <c:forEach begin="1" end="${rev.rating}">
                                        <i class="fa-solid fa-star"></i>
                                    </c:forEach>
                                </div>
                                <p class="small text-secondary mb-0">${rev.comment}</p>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
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

        async function submitReview(e) {
            e.preventDefault();
            let rating = document.getElementById('reviewRating').value;
            let comment = document.getElementById('reviewComment').value;
            try {
                let res = await fetch('${pageContext.request.contextPath}/api/reviews', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        productId: ${product.id},
                        rating: parseInt(rating),
                        comment: comment
                    })
                });
                let data = await res.json();
                if (data.success) {
                    alert('Cảm ơn bạn đã gửi đánh giá!');
                    window.location.reload();
                } else {
                    alert('Lỗi: ' + data.message);
                }
            } catch (err) {
                alert('Không thể kết nối: ' + err);
            }
        }
    </script>
</body>
