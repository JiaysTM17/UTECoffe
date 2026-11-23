<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Thanh Toán Đơn Hàng - UTECoffe</title>
</head>
<body class="bg-obsidian">
    <div class="container py-5">
        <div class="section-title-wrap mb-4">
            <span class="section-subtitle">Xác Nhận Đơn Hàng</span>
            <h2 class="section-title">Thông Tin Giao Nhận &amp; Thanh Toán</h2>
            <div class="gold-divider"></div>
        </div>

        <form action="${pageContext.request.contextPath}/api/orders" method="post" id="checkoutForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="row g-4">
                <!-- Left: Shipping & Customer Details -->
                <div class="col-lg-7">
                    <div class="card-luxury p-4 mb-4">
                        <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2"><i class="fa-solid fa-truck-fast me-2"></i>1. Phương Thức Nhận Hàng</h5>
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <input type="radio" class="btn-check" name="orderType" id="typeDelivery" value="DELIVERY" checked>
                                <label class="btn btn-outline-gold w-100 py-3 text-center" for="typeDelivery">
                                    <i class="fa-solid fa-motorcycle fs-4 d-block mb-1"></i> Giao Tận Nơi
                                </label>
                            </div>
                            <div class="col-6">
                                <input type="radio" class="btn-check" name="orderType" id="typeTakeaway" value="TAKEAWAY">
                                <label class="btn btn-outline-gold w-100 py-3 text-center" for="typeTakeaway">
                                    <i class="fa-solid fa-store fs-4 d-block mb-1"></i> Lấy Tại Quán
                                </label>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small text-gold fw-bold">Chi Nhánh Chế Biến:</label>
                            <select class="form-select form-control-luxury" name="storeId" required>
                                <option value="1">UTECoffe Flagship Thủ Đức - 01 Võ Văn Ngân, TP. Thủ Đức</option>
                                <option value="2">UTECoffe Roastery Quận 1 - 68 Lê Lợi, Quận 1</option>
                            </select>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small text-gold fw-bold">Họ và Tên:</label>
                                <input type="text" class="form-control form-control-luxury" name="recipientName" placeholder="Nguyễn Văn A" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small text-gold fw-bold">Số Điện Thoại:</label>
                                <input type="tel" class="form-control form-control-luxury" name="recipientPhone" placeholder="0901234567" required>
                            </div>
                        </div>

                        <div class="mb-3" id="deliveryAddressGroup">
                            <label class="form-label small text-gold fw-bold">Địa Chỉ Giao Hàng:</label>
                            <input type="text" class="form-control form-control-luxury" name="deliveryAddress" placeholder="Số nhà, tên đường, phường/xã, quận/huyện...">
                        </div>

                        <div>
                            <label class="form-label small text-gold fw-bold">Ghi Chú Cho Barista / Shipper:</label>
                            <textarea class="form-control form-control-luxury" name="note" rows="2" placeholder="Ví dụ: Ít đá, giao trước 11h..."></textarea>
                        </div>
                    </div>

                    <!-- Payment Gateways -->
                    <div class="card-luxury p-4">
                        <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2"><i class="fa-solid fa-credit-card me-2"></i>2. Cổng Thanh Toán</h5>
                        <div class="d-flex flex-column gap-2">
                            <label class="p-3 border border-gold rounded-3 bg-espresso d-flex align-items-center gap-3 cursor-pointer">
                                <input type="radio" name="paymentMethod" value="VIETQR" checked class="form-check-input">
                                <div>
                                    <div class="fw-bold"><i class="fa-solid fa-qrcode text-gold me-2"></i>Chuyển Khoản Ngân Hàng Tự Động (VietQR Động)</div>
                                    <small class="text-secondary">Tạo mã QR chứa mã đơn và số tiền chính xác, tự động kích hoạt chế biến</small>
                                </div>
                            </label>

                            <label class="p-3 border border-gold rounded-3 bg-espresso d-flex align-items-center gap-3 cursor-pointer">
                                <input type="radio" name="paymentMethod" value="VNPAY" class="form-check-input">
                                <div>
                                    <div class="fw-bold"><i class="fa-regular fa-credit-card text-gold me-2"></i>Ví / Cổng VNPay Sandbox</div>
                                    <small class="text-secondary">Thanh toán qua thẻ ATM nội địa, QR Pay hoặc thẻ quốc tế</small>
                                </div>
                            </label>

                            <label class="p-3 border border-gold rounded-3 bg-espresso d-flex align-items-center gap-3 cursor-pointer">
                                <input type="radio" name="paymentMethod" value="MOMO" class="form-check-input">
                                <div>
                                    <div class="fw-bold"><i class="fa-solid fa-wallet text-gold me-2"></i>Ví Điện Tử MoMo Sandbox</div>
                                    <small class="text-secondary">Xác thực chữ ký HMAC-SHA256 bảo mật cao</small>
                                </div>
                            </label>

                            <label class="p-3 border border-gold rounded-3 bg-espresso d-flex align-items-center gap-3 cursor-pointer">
                                <input type="radio" name="paymentMethod" value="COD" class="form-check-input">
                                <div>
                                    <div class="fw-bold"><i class="fa-solid fa-money-bill-wave text-gold me-2"></i>Tiền Mặt Khi Nhận Hàng (COD)</div>
                                    <small class="text-secondary">Thanh toán trực tiếp cho nhân viên giao hàng khi nhận thức uống</small>
                                </div>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Right: Order Review -->
                <div class="col-lg-5">
                    <div class="card-luxury p-4 sticky-top" style="top: 100px;">
                        <h5 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold pb-2">Đơn Hàng Của Bạn</h5>
                        <div class="d-flex justify-content-between mb-2 small text-secondary">
                            <span>Sản phẩm:</span>
                            <span class="text-light fw-bold">Cà Phê Cold Brew Cam Vàng (L) x1</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2 small text-secondary">
                            <span>Phí vận chuyển:</span>
                            <span class="text-success">Miễn Phí</span>
                        </div>
                        <hr class="border-secondary opacity-25">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="fw-bold fs-5">Tổng Thanh Toán:</span>
                            <span class="price-gold fs-3">65.000₫</span>
                        </div>

                        <button type="submit" class="btn btn-gold w-100 py-3 fw-bold fs-6">
                            <i class="fa-solid fa-lock me-2"></i> Hoàn Tất Đặt Hàng
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</body>
