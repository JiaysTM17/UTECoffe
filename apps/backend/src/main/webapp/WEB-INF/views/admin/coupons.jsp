<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Quản Lý Khuyến Mãi & Voucher - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="font-serif fw-bold text-primary mb-0">Chương Trình Khuyến Mãi &amp; Mã Ưu Đãi</h4>
            <small class="text-secondary">Thiết lập chính sách voucher, ưu đãi hội viên UTEClub và chiến dịch kích cầu</small>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-gold btn-sm rounded-pill px-3 font-accent fw-bold" data-bs-toggle="modal" data-bs-target="#createCouponModal">
                <i class="fa-solid fa-plus me-1"></i> Tạo Mã Mới
            </button>
        </div>
    </div>

    <!-- Quick Stats Strip -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Tổng Mã Phát Hành</span>
                    <h4 class="font-serif fw-bold text-light mb-0">${coupons.size()} Mã</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-tags"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Đang Áp Dụng</span>
                    <h4 class="font-serif fw-bold text-success mb-0">100% Hoạt Động</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-success text-success"><i class="fa-solid fa-circle-check"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Phân Hạng Áp Dụng</span>
                    <h4 class="font-serif fw-bold text-gold mb-0">Đồng, Bạc, Kim Cương</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-crown"></i></div>
            </div>
        </div>
    </div>

    <!-- Coupons Table -->
    <div class="card-luxury p-4 border-gold shadow-lg mb-4">
        <div class="table-responsive">
            <table class="table table-luxury align-middle">
                <thead>
                    <tr>
                        <th>Mã Voucher</th>
                        <th>Chương Trình</th>
                        <th>Loại Giảm</th>
                        <th>Mức Giảm</th>
                        <th>Đơn Tối Thiểu</th>
                        <th>Lượt Đã Dùng</th>
                        <th>Trạng Thái</th>
                        <th class="text-end">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${coupons}">
                        <tr id="coupon-row-${c.id}">
                            <td>
                                <span class="badge bg-espresso border border-gold text-gold fs-6 font-monospace px-2 py-1">
                                    ${c.code}
                                </span>
                            </td>
                            <td>
                                <div class="fw-bold text-light">${c.title}</div>
                                <small class="text-secondary">${not empty c.description ? c.description : 'Ưu đãi dành cho thành viên'}</small>
                            </td>
                            <td>
                                <span class="badge bg-dark-roast border border-secondary text-secondary small">
                                    ${c.discountType == 'PERCENTAGE' ? 'Phần Trăm (%)' : 'Cố Định (VNĐ)'}
                                </span>
                            </td>
                            <td>
                                <span class="text-gold fw-bold">
                                    <c:choose>
                                        <c:when test="${c.discountType == 'PERCENTAGE'}">
                                            Giảm ${c.discountValue}%
                                        </c:when>
                                        <c:otherwise>
                                            Giảm <fmt:formatNumber value="${c.discountValue}" pattern="#,##0"/> VNĐ
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td class="text-light small">
                                <fmt:formatNumber value="${c.minOrderValue}" pattern="#,##0"/> VNĐ
                            </td>
                            <td>
                                <div class="small text-secondary mb-1">${c.usedCount} / ${c.usageLimit} lượt</div>
                                <div class="progress bg-dark" style="height: 5px; width: 90px;">
                                    <div class="progress-bar bg-warning" style="width: ${(c.usedCount / c.usageLimit) * 100}%;"></div>
                                </div>
                            </td>
                            <td>
                                <span class="badge ${c.isActive ? 'bg-success-subtle text-success border border-success' : 'bg-secondary text-light'} px-2 py-1">
                                    ${c.isActive ? 'Đang Chạy' : 'Tạm Dừng'}
                                </span>
                            </td>
                            <td class="text-end">
                                <button type="button" class="btn btn-outline-gold btn-sm rounded-pill px-3" onclick="toggleCoupon(${c.id})">
                                    <i class="fa-solid fa-power-off me-1"></i> ${c.isActive ? 'Tạm Dừng' : 'Bật Lại'}
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Modal Create Coupon -->
    <div class="modal fade" id="createCouponModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content card-luxury border-gold bg-espresso text-light shadow-lg">
                <div class="modal-header border-gold pb-3">
                    <h5 class="modal-title font-serif text-primary fw-bold">
                        <i class="fa-solid fa-tags me-2"></i>Tạo Mã Khuyến Mãi Mới
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="createCouponForm" onsubmit="handleCreateCoupon(event)">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label text-gold small fw-bold">Mã Khuyến Mãi (Code):</label>
                            <input type="text" name="code" class="form-control form-control-luxury text-uppercase font-monospace" placeholder="VD: SUMMER2026" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-gold small fw-bold">Tiêu Đề Ưu Đãi:</label>
                            <input type="text" name="title" class="form-control form-control-luxury" placeholder="VD: Giảm 20k Đơn Đầu Tiên" required>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label text-gold small fw-bold">Loại Giảm:</label>
                                <select name="discountType" class="form-select form-select-luxury">
                                    <option value="PERCENTAGE">Phần Trăm (%)</option>
                                    <option value="FIXED_AMOUNT">Tiền Mặt (VNĐ)</option>
                                </select>
                            </div>
                            <div class="col-6">
                                <label class="form-label text-gold small fw-bold">Giá Trị Giảm:</label>
                                <input type="number" name="discountValue" class="form-control form-control-luxury" placeholder="VD: 15 hoặc 20000" required>
                            </div>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label text-gold small fw-bold">Đơn Tối Thiểu (VNĐ):</label>
                                <input type="number" name="minOrderValue" class="form-control form-control-luxury" placeholder="VD: 50000" value="0">
                            </div>
                            <div class="col-6">
                                <label class="form-label text-gold small fw-bold">Giới Hạn Lượt Dùng:</label>
                                <input type="number" name="usageLimit" class="form-control form-control-luxury" placeholder="VD: 1000" value="1000">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-gold pt-3">
                        <button type="button" class="btn btn-outline-secondary btn-sm rounded-pill px-3" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-gold btn-sm rounded-pill px-4 font-accent fw-bold">Lưu &amp; Kích Hoạt</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function toggleCoupon(id) {
            fetch('${pageContext.request.contextPath}/admin/coupons/' + id + '/toggle', {
                method: 'POST'
            }).then(res => res.json()).then(data => {
                if (data.success) {
                    location.reload();
                }
            }).catch(err => console.error(err));
        }

        function handleCreateCoupon(e) {
            e.preventDefault();
            const form = e.target;
            const formData = new FormData(form);
            const params = new URLSearchParams(formData);

            fetch('${pageContext.request.contextPath}/admin/coupons/create', {
                method: 'POST',
                body: params
            }).then(res => res.json()).then(data => {
                if (data.success) {
                    alert('Đã tạo mã khuyến mãi thành công: ' + data.code);
                    location.reload();
                }
            }).catch(err => console.error(err));
        }
    </script>
</body>
