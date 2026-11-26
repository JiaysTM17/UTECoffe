<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Sổ Cái Đơn Hàng - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h5 class="fw-semibold text-primary mb-0" style="font-family: var(--font-sans); font-size: 1.05rem;">Quản lý đơn hàng toàn hệ thống</h5>
            <small class="text-secondary" style="font-size: 0.75rem;">Theo dõi, điều phối và đối soát giao dịch thời gian thực OMO</small>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/orders/export" class="btn btn-gold btn-sm rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;">
                <i class="fa-solid fa-file-excel me-1"></i> Xuất File Excel
            </a>
            <a href="${pageContext.request.contextPath}/barista/kds" class="btn btn-outline-warning btn-sm rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;">
                <i class="fa-solid fa-display me-1"></i> KDS Barista
            </a>
        </div>
    </div>

    <!-- Filter & Search Toolbar (2-Tier Immune to Overflow) -->
    <div class="card-luxury p-2.5 p-md-3 border-gold shadow-sm mb-3">
        <!-- Row 1: Search & Branch Selector -->
        <div class="row g-2 align-items-center mb-2 pb-2 border-bottom border-gold-subtle">
            <div class="col-md-7">
                <div class="input-group input-group-sm">
                    <span class="input-group-text bg-dark-roast border-gold text-gold"><i class="fa-solid fa-magnifying-glass"></i></span>
                    <input type="text" id="orderSearchInput" class="form-control form-control-luxury" placeholder="Tìm theo mã đơn #ORD, tên khách hàng, số điện thoại..." onkeyup="filterOrdersTable()">
                </div>
            </div>
            <div class="col-md-5">
                <select id="branchFilterSelect" class="form-select form-select-sm form-select-luxury" onchange="filterOrdersTable()">
                    <option value="ALL">-- Tất Cả 3 Chi Nhánh --</option>
                    <c:forEach var="st" items="${stores}">
                        <option value="${st.name}">${st.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <!-- Row 2: Status Filter Pills with Full Width (Never Overflows) -->
        <div class="d-flex flex-wrap gap-2 align-items-center justify-content-between">
            <div class="d-flex align-items-center gap-1 small text-secondary" style="font-size: 0.78rem;">
                <i class="fa-solid fa-filter text-gold me-1"></i> <span>Trạng thái:</span>
            </div>
            <div class="d-flex flex-wrap gap-1">
                <button type="button" class="btn btn-sm btn-gold status-filter-btn active rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;" data-status="ALL" onclick="setStatusFilter('ALL', this)">
                    Tất Cả (${orders.size()})
                </button>
                <button type="button" class="btn btn-sm btn-outline-gold status-filter-btn rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;" data-status="PENDING" onclick="setStatusFilter('PENDING', this)">
                    <i class="fa-regular fa-clock me-1"></i> Chờ Xử Lý
                </button>
                <button type="button" class="btn btn-sm btn-outline-gold status-filter-btn rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;" data-status="PREPARING" onclick="setStatusFilter('PREPARING', this)">
                    <i class="fa-solid fa-mug-hot me-1"></i> Đang Pha
                </button>
                <button type="button" class="btn btn-sm btn-outline-gold status-filter-btn rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;" data-status="COMPLETED" onclick="setStatusFilter('COMPLETED', this)">
                    <i class="fa-solid fa-check me-1"></i> Hoàn Tất
                </button>
                <button type="button" class="btn btn-sm btn-outline-gold status-filter-btn rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;" data-status="CANCELLED" onclick="setStatusFilter('CANCELLED', this)">
                    <i class="fa-solid fa-ban me-1"></i> Đã Hủy
                </button>
            </div>
        </div>
    </div>

    <!-- Orders Table -->
    <div class="card-luxury p-3 p-md-3.5 border-gold shadow-sm">
        <div class="table-responsive">
            <table class="table table-luxury table-sm align-middle" id="adminOrdersTable">
                <thead>
                    <tr style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.03em; color: var(--text-secondary);">
                        <th class="py-2">Mã Đơn</th>
                        <th class="py-2">Khách Hàng</th>
                        <th class="py-2">Chi Nhánh</th>
                        <th class="py-2">Hình Thức</th>
                        <th class="py-2">Tổng Tiền</th>
                        <th class="py-2">Trạng Thái</th>
                        <th class="text-end py-2">Thao Tác</th>
                    </tr>
                </thead>
                <tbody style="font-size: 0.82rem;">
                    <c:forEach var="ord" items="${orders}">
                        <tr class="order-row" data-status="${ord.status}" data-store="${ord.store.name}" id="order-row-${ord.id}">
                            <td class="fw-semibold">
                                <a href="${pageContext.request.contextPath}/orders/tracking/${ord.orderCode}" class="text-gold text-decoration-none">
                                    #${ord.orderCode}
                                </a>
                            </td>
                            <td>
                                <div class="fw-medium text-primary">${ord.recipientName}</div>
                                <small class="text-secondary" style="font-size: 0.75rem;">${ord.recipientPhone}</small>
                            </td>
                            <td><span class="badge font-sans" style="font-size: 0.75rem; background: var(--bg-secondary); border: 1px solid var(--border-gold-subtle); color: var(--text-primary);">${ord.store.name}</span></td>
                            <td>
                                <span class="badge font-sans" style="font-size: 0.75rem; background: var(--bg-secondary); border: 1px solid var(--border-gold-subtle); color: var(--text-primary);">
                                    <c:choose>
                                        <c:when test="${ord.orderType == 'DINE_IN'}"><i class="fa-solid fa-utensils text-gold me-1"></i>Tại Quán</c:when>
                                        <c:when test="${ord.orderType == 'TAKE_AWAY'}"><i class="fa-solid fa-cup-straw text-warning me-1"></i>Mang Đi</c:when>
                                        <c:otherwise><i class="fa-solid fa-motorcycle text-info me-1"></i>Giao Hàng</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td class="text-gold fw-bold" style="font-variant-numeric: tabular-nums;">
                                <fmt:formatNumber value="${ord.finalAmount}" pattern="#,##0"/> VNĐ
                            </td>
                            <td>
                                <span class="badge ${ord.status == 'COMPLETED' ? 'bg-success-subtle text-success border border-success-subtle' : (ord.status == 'CANCELLED' ? 'bg-danger-subtle text-danger border border-danger-subtle' : (ord.status == 'PREPARING' ? 'bg-warning-subtle text-warning border border-warning-subtle' : 'bg-secondary text-primary'))} px-2 py-1 row-status-badge-${ord.id}" style="font-size: 0.75rem;">
                                    <c:choose>
                                        <c:when test="${ord.status == 'COMPLETED'}">Hoàn Tất</c:when>
                                        <c:when test="${ord.status == 'PREPARING'}">Đang Pha</c:when>
                                        <c:when test="${ord.status == 'PENDING'}">Chờ Xử Lý</c:when>
                                        <c:when test="${ord.status == 'CANCELLED'}">Đã Hủy</c:when>
                                        <c:otherwise>${ord.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td class="text-end">
                                <div class="btn-group btn-group-sm">
                                    <a href="${pageContext.request.contextPath}/orders/tracking/${ord.orderCode}" class="btn btn-outline-gold btn-sm" title="Theo dõi chi tiết">
                                        <i class="fa-solid fa-eye"></i>
                                    </a>
                                    <c:if test="${ord.status != 'COMPLETED' && ord.status != 'CANCELLED'}">
                                        <button type="button" class="btn btn-outline-success btn-sm" title="Đánh dấu hoàn tất" onclick="adminUpdateStatus(${ord.id}, 'COMPLETED')">
                                            <i class="fa-solid fa-check"></i>
                                        </button>
                                        <button type="button" class="btn btn-outline-danger btn-sm" title="Hủy đơn" onclick="adminUpdateStatus(${ord.id}, 'CANCELLED')">
                                            <i class="fa-solid fa-xmark"></i>
                                        </button>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Filter Script -->
    <script>
        let currentStatusFilter = 'ALL';

        function setStatusFilter(status, btn) {
            currentStatusFilter = status;
            document.querySelectorAll('.status-filter-btn').forEach(b => {
                b.classList.remove('btn-gold', 'active');
                b.classList.add('btn-outline-gold');
            });
            btn.classList.remove('btn-outline-gold');
            btn.classList.add('btn-gold', 'active');
            filterOrdersTable();
        }

        function filterOrdersTable() {
            const keyword = document.getElementById('orderSearchInput').value.toLowerCase().trim();
            const branch = document.getElementById('branchFilterSelect').value;
            const rows = document.querySelectorAll('.order-row');

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                const rowStatus = row.getAttribute('data-status');
                const rowStore = row.getAttribute('data-store');

                const matchesKeyword = !keyword || text.includes(keyword);
                const matchesStatus = (currentStatusFilter === 'ALL' || rowStatus === currentStatusFilter);
                const matchesBranch = (branch === 'ALL' || rowStore === branch);

                if (matchesKeyword && matchesStatus && matchesBranch) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function adminUpdateStatus(orderId, status) {
            if (!confirm('Bạn có chắc chắn muốn chuyển trạng thái đơn hàng sang ' + status + '?')) return;
            fetch('${pageContext.request.contextPath}/admin/orders/' + orderId + '/status?status=' + status, {
                method: 'POST'
            }).then(res => res.json()).then(data => {
                if (data.success) {
                    location.reload();
                }
            }).catch(err => console.error(err));
        }
    </script>
</body>
