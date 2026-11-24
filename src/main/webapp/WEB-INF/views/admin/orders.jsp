<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Sổ Cái Đơn Hàng - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="font-serif fw-bold text-gold-gradient mb-0">Quản Lý Đơn Hàng Toàn Hệ Thống</h4>
            <small class="text-secondary">Theo dõi, điều phối và đối soát giao dịch thời gian thực OMO</small>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/orders/export" class="btn btn-gold btn-sm rounded-pill px-3">
                <i class="fa-solid fa-file-excel me-1"></i> Xuất File Excel (.xlsx)
            </a>
            <a href="${pageContext.request.contextPath}/barista/kds" class="btn btn-outline-warning btn-sm rounded-pill px-3">
                <i class="fa-solid fa-display me-1"></i> KDS Barista
            </a>
        </div>
    </div>

    <!-- Filter & Search Toolbar -->
    <div class="card-luxury p-3 border-gold shadow-sm mb-3 bg-espresso">
        <div class="row g-2 align-items-center">
            <!-- Search Input -->
            <div class="col-lg-5 col-md-6">
                <div class="input-group input-group-sm">
                    <span class="input-group-text bg-dark-roast border-gold text-gold"><i class="fa-solid fa-magnifying-glass"></i></span>
                    <input type="text" id="orderSearchInput" class="form-control form-control-luxury" placeholder="Tìm theo mã đơn, tên khách, SĐT..." onkeyup="filterOrdersTable()">
                </div>
            </div>

            <!-- Branch Filter -->
            <div class="col-lg-3 col-md-6">
                <select id="branchFilterSelect" class="form-select form-select-sm form-select-luxury" onchange="filterOrdersTable()">
                    <option value="ALL">-- Tất Cả Chi Nhánh --</option>
                    <c:forEach var="st" items="${stores}">
                        <option value="${st.name}">${st.name}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Status Filter Pills -->
            <div class="col-lg-4 col-md-12 text-lg-end text-start">
                <div class="d-flex flex-wrap gap-1 justify-content-lg-end align-items-center">
                    <button type="button" class="btn btn-sm btn-gold status-filter-btn active rounded-pill px-2 py-1 font-accent" data-status="ALL" onclick="setStatusFilter('ALL', this)">Tất Cả</button>
                    <button type="button" class="btn btn-sm btn-outline-gold status-filter-btn rounded-pill px-2 py-1 font-accent" data-status="PENDING" onclick="setStatusFilter('PENDING', this)">Chờ Xử Lý</button>
                    <button type="button" class="btn btn-sm btn-outline-gold status-filter-btn rounded-pill px-2 py-1 font-accent" data-status="PREPARING" onclick="setStatusFilter('PREPARING', this)">Đang Pha</button>
                    <button type="button" class="btn btn-sm btn-outline-gold status-filter-btn rounded-pill px-2 py-1 font-accent" data-status="COMPLETED" onclick="setStatusFilter('COMPLETED', this)">Hoàn Tất</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Orders Table -->
    <div class="card-luxury p-4 border-gold shadow-lg">
        <div class="table-responsive">
            <table class="table table-luxury align-middle" id="adminOrdersTable">
                <thead>
                    <tr>
                        <th>Mã Đơn</th>
                        <th>Khách Hàng</th>
                        <th>Chi Nhánh</th>
                        <th>Hình Thức</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th class="text-end">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ord" items="${orders}">
                        <tr class="order-row" data-status="${ord.status}" data-store="${ord.store.name}" id="order-row-${ord.id}">
                            <td class="fw-bold font-accent">
                                <a href="${pageContext.request.contextPath}/orders/tracking/${ord.orderCode}" class="text-gold text-decoration-none">
                                    #${ord.orderCode}
                                </a>
                            </td>
                            <td>
                                <div class="fw-bold text-light">${ord.recipientName}</div>
                                <small class="text-secondary">${ord.recipientPhone}</small>
                            </td>
                            <td><span class="badge bg-dark-roast border border-secondary text-light">${ord.store.name}</span></td>
                            <td>
                                <span class="badge bg-espresso border border-secondary text-light">
                                    <c:choose>
                                        <c:when test="${ord.orderType == 'DINE_IN'}">🍽️ Tại Quán</c:when>
                                        <c:when test="${ord.orderType == 'TAKE_AWAY'}">🥤 Mang Đi</c:when>
                                        <c:otherwise>🛵 Giao Hàng</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td class="text-gold fw-bold">
                                <fmt:formatNumber value="${ord.finalAmount}" pattern="#,##0"/> VNĐ
                            </td>
                            <td>
                                <span class="badge ${ord.status == 'COMPLETED' ? 'bg-success' : (ord.status == 'CANCELLED' ? 'bg-danger' : (ord.status == 'PREPARING' ? 'bg-warning text-dark' : 'bg-secondary text-light'))} px-2 py-1 row-status-badge-${ord.id}">
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