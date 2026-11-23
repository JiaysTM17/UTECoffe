<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Giỏ Hàng Của Bạn - UTECoffe</title>
</head>
<body class="bg-obsidian">
    <div class="container py-5">
        <div class="section-title-wrap mb-4">
            <span class="section-subtitle">Đơn Hàng Trực Tuyến</span>
            <h2 class="section-title">Giỏ Hàng Thưởng Thức</h2>
            <div class="gold-divider"></div>
        </div>

        <div class="row g-4">
            <!-- Left: Cart Table -->
            <div class="col-lg-8">
                <div class="card-luxury p-4">
                    <div class="table-responsive">
                        <table class="table table-luxury align-middle">
                            <thead>
                                <tr>
                                    <th>Sản Phẩm</th>
                                    <th>Đơn Giá</th>
                                    <th class="text-center">Số Lượng</th>
                                    <th class="text-end">Tạm Tính</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty cart and not empty cart.items}">
                                        <c:forEach var="item" items="${cart.items}">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <img src="${item.product.imageUrl}" class="rounded-3" style="width: 55px; height: 55px; object-fit: cover;">
                                                        <div>
                                                            <div class="fw-bold font-serif">${item.product.name}</div>
                                                            <small class="text-gold">${item.productSize.name} • ${item.sugarLevel}% Đường • ${item.iceLevel}% Đá</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                                <td class="text-center font-accent fw-bold">${item.quantity}</td>
                                                <td class="text-end fw-bold text-gold"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫"/></td>
                                                <td class="text-end">
                                                    <button class="btn btn-sm btn-outline-danger border-0"><i class="fa-solid fa-trash-can"></i></button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-center py-5">
                                                <i class="fa-solid fa-bag-shopping text-gold fs-1 mb-3 d-block opacity-50"></i>
                                                <p class="text-secondary mb-3">Giỏ hàng của bạn đang trống.</p>
                                                <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold btn-sm px-4">
                                                    <i class="fa-solid fa-mug-hot me-1"></i> Khám Phá Thực Đơn
                                                </a>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Right: Order Summary Card -->
            <div class="col-lg-4">
                <div class="card-luxury p-4">
                    <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">Tóm Tắt Đơn Hàng</h5>
                    
                    <div class="d-flex justify-content-between mb-2 small text-secondary">
                        <span>Tổng tiền món:</span>
                        <span class="text-light fw-bold">125.000₫</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2 small text-secondary">
                        <span>Phí giao hàng:</span>
                        <span class="text-success">Miễn Phí</span>
                    </div>
                    <div class="d-flex justify-content-between mb-3 small text-secondary">
                        <span>Ưu đãi voucher:</span>
                        <span class="text-gold">-20.000₫</span>
                    </div>
                    <hr class="border-secondary opacity-25">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="fw-bold">Thành Tiền:</span>
                        <span class="price-gold fs-4">105.000₫</span>
                    </div>

                    <a href="${pageContext.request.contextPath}/cart/checkout" class="btn btn-gold w-100 py-3 fw-bold">
                        <i class="fa-solid fa-credit-card me-1"></i> Tiến Hành Thanh Toán
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
