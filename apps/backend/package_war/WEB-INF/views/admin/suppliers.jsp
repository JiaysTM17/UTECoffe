<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Chuỗi Cung Ứng & PO - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="font-serif fw-bold text-primary mb-0">Chuỗi Cung Ứng &amp; Đặt Hàng Nhập Kho (PO)</h4>
            <small class="text-secondary">Quản trị đối tác nông trại cao nguyên Cầu Đất, Mộc Châu và điều phối nhập hàng PO</small>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-gold btn-sm rounded-pill px-3 font-accent fw-bold" data-bs-toggle="modal" data-bs-target="#createPoModal">
                <i class="fa-solid fa-plus me-1"></i> Tạo Đơn Đặt Hàng PO
            </button>
        </div>
    </div>

    <!-- Suppliers Grid -->
    <div class="card-luxury p-4 border-gold shadow-lg mb-4">
        <h5 class="font-serif fw-bold text-primary mb-3 border-bottom border-gold-subtle pb-2">
            <i class="fa-solid fa-handshake me-2"></i>Đối Tác Nông Trại &amp; Nhà Cung Ứng Chiến Lược
        </h5>
        <div class="row g-3">
            <c:forEach var="sup" items="${suppliers}">
                <div class="col-md-6 col-xl-3">
                    <div class="p-3 rounded-3 bg-dark-roast border border-secondary border-opacity-50 h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h6 class="fw-bold text-gold mb-0 text-truncate font-accent" title="${sup.name}">${sup.name}</h6>
                                <span class="badge bg-success-subtle text-success small">Đối Tác VIP</span>
                            </div>
                            <p class="small text-secondary mb-1">
                                <i class="fa-solid fa-user-tie me-1 text-gold"></i> Đại diện: ${sup.contactName}
                            </p>
                            <p class="small text-secondary mb-1">
                                <i class="fa-solid fa-phone me-1 text-gold"></i> ${sup.phone}
                            </p>
                            <p class="small text-secondary mb-2 text-truncate" title="${sup.address}">
                                <i class="fa-solid fa-location-dot me-1 text-gold"></i> ${sup.address}
                            </p>
                        </div>
                        <div class="pt-2 border-top border-secondary border-opacity-25 mt-2">
                            <span class="badge bg-espresso border border-gold-subtle text-gold small">
                                <i class="fa-solid fa-check me-1"></i> Hợp đồng hoạt động
                            </span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Purchase Orders Table -->
    <div class="card-luxury p-4 border-gold shadow-lg mb-4">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-gold">
            <div>
                <h5 class="font-serif fw-bold text-primary mb-0">
                    <i class="fa-solid fa-truck-ramp-box me-2"></i>Sổ Theo Dõi Đơn Nhập Kho (Purchase Orders)
                </h5>
                <small class="text-secondary">Theo dõi tiến độ giao hàng, kiểm đếm chất lượng và đối soát công nợ nguyên liệu</small>
            </div>
            <span class="badge bg-dark-roast border border-secondary text-primary px-3 py-2 font-accent">
                Tổng: <strong>${purchaseOrders.size()}</strong> Phiếu Đặt Hàng
            </span>
        </div>

        <div class="table-responsive">
            <table class="table table-luxury align-middle">
                <thead>
                    <tr>
                        <th>Mã PO</th>
                        <th>Chi Nhánh Đặt</th>
                        <th>Nhà Cung Cấp</th>
                        <th>Tổng Giá Trị</th>
                        <th>Trạng Thái</th>
                        <th class="text-end">Nghiệm Thu</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="po" items="${purchaseOrders}">
                        <tr id="po-row-${po.id}">
                            <td class="font-accent fw-bold text-gold">${po.orderCode}</td>
                            <td><span class="badge bg-dark-roast border border-secondary text-primary">${po.store.name}</span></td>
                            <td class="fw-bold text-primary">${po.supplier.name}</td>
                            <td class="text-gold fw-bold">
                                <fmt:formatNumber value="${po.totalAmount}" pattern="#,##0"/> VNĐ
                            </td>
                            <td>
                                <span class="badge ${po.status == 'RECEIVED' ? 'bg-success-subtle text-success border border-success' : 'bg-warning-subtle text-warning border border-warning'} px-2 py-1">
                                    ${po.status == 'RECEIVED' ? '✅ Đã Nhập Kho' : '🚚 Đang Vận Chuyển'}
                                </span>
                            </td>
                            <td class="text-end">
                                <c:if test="${po.status != 'RECEIVED'}">
                                    <button type="button" class="btn btn-outline-success btn-sm rounded-pill px-3 font-accent" onclick="updatePoStatus(${po.id}, 'RECEIVED')">
                                        <i class="fa-solid fa-box-open me-1"></i> Nghiệm Thu
                                    </button>
                                </c:if>
                                <c:if test="${po.status == 'RECEIVED'}">
                                    <span class="text-secondary small font-accent"><i class="fa-solid fa-circle-check text-success me-1"></i> Hoàn tất</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Modal Create PO -->
    <div class="modal fade" id="createPoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content card-luxury border-gold bg-espresso text-primary shadow-lg">
                <div class="modal-header border-gold pb-3">
                    <h5 class="modal-title font-serif text-primary fw-bold">
                        <i class="fa-solid fa-file-invoice me-2"></i>Tạo Phiếu Đặt Hàng Nhập Kho (PO)
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="createPoForm" onsubmit="handleCreatePo(event)">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label text-gold small fw-bold">Chi Nhánh Nhận Hàng:</label>
                            <select name="storeId" class="form-select form-select-luxury" required>
                                <c:forEach var="st" items="${stores}">
                                    <option value="${st.id}">${st.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-gold small fw-bold">Nhà Cung Cấp Đối Tác:</label>
                            <select name="supplierId" class="form-select form-select-luxury" required>
                                <c:forEach var="sup" items="${suppliers}">
                                    <option value="${sup.id}">${sup.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-gold small fw-bold">Tổng Giá Trị Đơn Hàng (VNĐ):</label>
                            <input type="number" name="totalAmount" class="form-control form-control-luxury" placeholder="VD: 15000000" required>
                        </div>
                    </div>
                    <div class="modal-footer border-gold pt-3">
                        <button type="button" class="btn btn-outline-secondary btn-sm rounded-pill px-3" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-gold btn-sm rounded-pill px-4 font-accent fw-bold">Gửi Phiếu PO</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function updatePoStatus(id, status) {
            if (!confirm('Xác nhận đã nhận và nghiệm thu đầy đủ hàng hóa cho phiếu PO này?')) return;
            fetch('${pageContext.request.contextPath}/admin/suppliers/po/' + id + '/status?status=' + status, {
                method: 'POST'
            }).then(res => res.json()).then(data => {
                if (data.success) {
                    location.reload();
                }
            }).catch(err => console.error(err));
        }

        function handleCreatePo(e) {
            e.preventDefault();
            const form = e.target;
            const formData = new FormData(form);
            const params = new URLSearchParams(formData);

            fetch('${pageContext.request.contextPath}/admin/suppliers/po/create', {
                method: 'POST',
                body: params
            }).then(res => res.json()).then(data => {
                if (data.success) {
                    alert('Đã tạo thành công phiếu PO: ' + data.code);
                    location.reload();
                }
            }).catch(err => console.error(err));
        }
    </script>
</body>
