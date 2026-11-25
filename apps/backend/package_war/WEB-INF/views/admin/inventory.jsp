<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Kho Nguyên Liệu BOM - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="font-serif fw-bold text-gold-gradient mb-0">Quản Lý Tồn Kho &amp; Định Mức BOM</h4>
            <small class="text-secondary">Tự động trừ kho nguyên liệu theo định lượng công thức pha chế của từng ly nước bán ra</small>
        </div>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-gold btn-sm px-3 rounded-pill font-accent fw-bold" onclick="openEoqOptimizationModal()">
                <i class="fa-solid fa-chart-pie me-1"></i> Tối Ưu EOQ &amp; ROP Chuỗi Cung Ứng
            </button>
            <span class="badge bg-dark-roast border border-gold text-gold px-3 py-2 font-accent">
                Tổng: <strong>${inventories.size()}</strong> Mặt Hàng Định Lượng
            </span>
        </div>
    </div>

    <!-- Quick Stats Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Tồn Kho Khả Dụng</span>
                    <h4 class="font-serif fw-bold text-light mb-0">${inventories.size()} Mặt Hàng</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-warehouse"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Cảnh Báo Tồn Thấp</span>
                    <h4 class="font-serif fw-bold ${lowStockCount > 0 ? 'text-danger' : 'text-success'} mb-0">
                        ${lowStockCount} Mặt Hàng
                    </h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border ${lowStockCount > 0 ? 'border-danger text-danger' : 'border-success text-success'}">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Trừ Kho Tự Động (BOM)</span>
                    <h4 class="font-serif fw-bold text-success mb-0">100% Hoàn Hảo</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-success text-success"><i class="fa-solid fa-bolt"></i></div>
            </div>
        </div>
    </div>

    <!-- Branch Filter Strip -->
    <div class="card-luxury p-3 border-gold shadow-sm mb-3 bg-espresso d-flex flex-wrap justify-content-between align-items-center">
        <div class="d-flex align-items-center gap-2">
            <span class="small text-secondary"><i class="fa-solid fa-filter me-1 text-gold"></i> Lọc theo chi nhánh:</span>
            <select id="invBranchSelect" class="form-select form-select-sm form-select-luxury" onchange="filterInventoryByBranch()">
                <option value="ALL">-- Tất Cả 3 Chi Nhánh --</option>
                <c:forEach var="st" items="${stores}">
                    <option value="${st.name}">${st.name}</option>
                </c:forEach>
            </select>
        </div>
        <div class="text-secondary small mt-2 mt-md-0">
            <i class="fa-solid fa-circle-info text-gold me-1"></i> Nguyên liệu tự động cập nhật trừ khi Barista bấm "Pha Xong".
        </div>
    </div>

    <!-- Inventory Table -->
    <div class="card-luxury p-4 border-gold shadow-lg mb-4">
        <div class="table-responsive">
            <table class="table table-luxury align-middle" id="invTable">
                <thead>
                    <tr>
                        <th>Chi Nhánh</th>
                        <th>Nguyên Liệu Đặc Sản</th>
                        <th>Tồn Kho Hiện Tại</th>
                        <th>Mức Cảnh Báo An Toàn</th>
                        <th>Trạng Thái</th>
                        <th class="text-end">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="inv" items="${inventories}">
                        <tr class="inv-row" data-store="${inv.store.name}">
                            <td>
                                <span class="badge bg-dark-roast border border-secondary text-light">${inv.store.name}</span>
                            </td>
                            <td>
                                <div class="fw-bold text-light">${inv.ingredient.name}</div>
                                <small class="text-secondary">Đơn vị: ${inv.ingredient.unit}</small>
                            </td>
                            <td>
                                <span class="fw-bold ${inv.currentStock <= inv.safetyStock ? 'text-danger' : 'text-gold'} fs-6">
                                    ${inv.currentStock} ${inv.ingredient.unit}
                                </span>
                            </td>
                            <td>
                                <span class="text-secondary small">${inv.safetyStock} ${inv.ingredient.unit}</span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${inv.currentStock <= inv.safetyStock}">
                                        <span class="badge bg-danger-subtle text-danger border border-danger px-2 py-1">
                                            <i class="fa-solid fa-triangle-exclamation me-1"></i> Cần Nhập Thêm
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success-subtle text-success border border-success px-2 py-1">
                                            <i class="fa-solid fa-circle-check me-1"></i> Đầy Đủ
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <button type="button" class="btn btn-outline-gold btn-sm rounded-pill px-3" onclick="restockPrompt(${inv.id}, '${inv.ingredient.name}')">
                                    <i class="fa-solid fa-plus me-1"></i> Nhập Kho
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Recent Logs -->
    <c:if test="${not empty logs}">
        <div class="card-luxury p-4 border-gold shadow-lg mb-4">
            <h6 class="font-serif fw-bold text-gold-gradient mb-3 border-bottom border-gold-subtle pb-2">
                <i class="fa-solid fa-clock-rotate-left me-1"></i> Lịch Sử Xuất Nhập Kho Gần Nhất
            </h6>
            <div class="table-responsive">
                <table class="table table-luxury align-middle small">
                    <thead>
                        <tr>
                            <th>Thời Gian</th>
                            <th>Hành Động</th>
                            <th>Số Lượng</th>
                            <th>Lý Do</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="l" items="${logs}">
                            <tr>
                                <td class="text-secondary">${l.createdAt}</td>
                                <td><span class="badge bg-dark-roast border border-gold text-gold">${l.actionType}</span></td>
                                <td class="text-light fw-bold">${l.quantity}</td>
                                <td class="text-secondary">${l.reason}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

    <!-- EOQ & ROP Supply Chain Optimization Modal -->
    <div class="modal fade" id="eoqModal" tabindex="-1" aria-labelledby="eoqModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content bg-card-dark border border-gold text-light">
                <div class="modal-header border-gold bg-espresso">
                    <h5 class="modal-title font-serif text-gold-gradient" id="eoqModalLabel">
                        <i class="fa-solid fa-chart-line me-2 text-gold"></i>Mô Hình Kinh Tế Tối Ưu Tồn Kho EOQ &amp; Điểm Đặt Hàng ROP
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="alert alert-dark border border-gold mb-3 small" style="background: rgba(222, 183, 106, 0.08);">
                        <i class="fa-solid fa-info-circle text-gold me-2"></i>
                        <strong>Mô hình toán học:</strong> EOQ (Economic Order Quantity) $\sqrt{\frac{2DS}{H}}$ tính toán kích thước lô đặt hàng tối thiểu hóa tổng chi phí đặt và lưu kho. ROP (Reorder Point) $(d \cdot L) + SS$ bảo vệ 95% không bị gián đoạn nguyên liệu.
                    </div>
                    <div class="table-responsive">
                        <table class="table table-luxury align-middle">
                            <thead>
                                <tr>
                                    <th>Nguyên Liệu</th>
                                    <th>Tồn Hiện Tại</th>
                                    <th>Lô Đặt Tối Ưu (EOQ)</th>
                                    <th>Điểm Đặt Lại (ROP)</th>
                                    <th>Tồn An Toàn (SS)</th>
                                    <th>Dự Trữ Còn Lại</th>
                                    <th>Khuyến Nghị Chuỗi Cung Ứng</th>
                                </tr>
                            </thead>
                            <tbody id="eoqTableBody">
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-gold">
                                        <i class="fa-solid fa-spinner fa-spin me-2"></i> Đang tải dữ liệu mô hình EOQ &amp; ROP...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer border-gold">
                    <button type="button" class="btn btn-secondary btn-sm rounded-pill font-accent" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-gold btn-sm rounded-pill font-accent" onclick="loadEoqData()">
                        <i class="fa-solid fa-arrows-rotate me-1"></i> Làm Mới Dữ Liệu
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function openEoqOptimizationModal() {
            const modalEl = document.getElementById('eoqModal');
            if (!modalEl) return;
            const modal = new bootstrap.Modal(modalEl);
            modal.show();
            loadEoqData();
        }

        function loadEoqData() {
            const tbody = document.getElementById('eoqTableBody');
            if (!tbody) return;
            tbody.innerHTML = '<tr><td colspan="7" class="text-center py-4 text-gold"><i class="fa-solid fa-spinner fa-spin me-2"></i> Đang tính toán định mức dự trữ tối ưu...</td></tr>';

            fetch('${pageContext.request.contextPath}/api/inventory/optimization')
                .then(res => res.json())
                .then(res => {
                    if (res.success && res.data && res.data.length > 0) {
                        tbody.innerHTML = '';
                        res.data.forEach(item => {
                            let badgeClass = 'bg-success text-light';
                            if (item.stockStatus === 'CRITICAL_REORDER') badgeClass = 'bg-danger text-light';
                            else if (item.stockStatus === 'WARNING_LOW') badgeClass = 'bg-warning text-dark';

                            const tr = document.createElement('tr');
                            tr.innerHTML = `
                                <td>
                                    <strong class="text-light">${item.ingredientName}</strong>
                                    <small class="text-secondary d-block font-monospace">${item.sku}</small>
                                </td>
                                <td><span class="fw-bold text-light">${item.currentStock} ${item.unit}</span></td>
                                <td><span class="badge bg-gold text-dark font-accent fw-bold fs-6">${item.eoqOptimalBatch} ${item.unit}</span></td>
                                <td><span class="text-gold fw-bold">${item.reorderPoint} ${item.unit}</span></td>
                                <td><span class="text-secondary">${item.safetyStock} ${item.unit}</span></td>
                                <td><span class="badge ${badgeClass} font-accent">${item.daysOfInventoryLeft} ngày</span></td>
                                <td><small class="text-secondary d-block" style="font-size:0.8rem; line-height:1.4;">${item.actionRecommendation}</small></td>
                            `;
                            tbody.appendChild(tr);
                        });
                    } else {
                        tbody.innerHTML = '<tr><td colspan="7" class="text-center text-secondary py-3">Chưa có dữ liệu tồn kho để phân tích</td></tr>';
                    }
                })
                .catch(err => {
                    console.error('Lỗi tải dữ liệu EOQ:', err);
                    tbody.innerHTML = '<tr><td colspan="7" class="text-center text-danger py-3">Không thể kết nối đến API phân tích tồn kho</td></tr>';
                });
        }

        function filterInventoryByBranch() {
            const branch = document.getElementById('invBranchSelect').value;
            const rows = document.querySelectorAll('.inv-row');
            rows.forEach(r => {
                const store = r.getAttribute('data-store');
                if (branch === 'ALL' || store === branch) {
                    r.style.display = '';
                } else {
                    r.style.display = 'none';
                }
            });
        }

        function restockPrompt(id, name) {
            const amount = prompt('Nhập số lượng bổ sung cho "' + name + '":', '10');
            if (amount && !isNaN(amount) && parseFloat(amount) > 0) {
                fetch('${pageContext.request.contextPath}/admin/inventory/' + id + '/restock?amount=' + amount, {
                    method: 'POST'
                }).then(res => res.json()).then(data => {
                    if (data.success) {
                        alert('Đã nhập kho thành công! Tồn kho mới: ' + data.newStock);
                        location.reload();
                    }
                }).catch(err => console.error(err));
            }
        }
    </script>
</body>