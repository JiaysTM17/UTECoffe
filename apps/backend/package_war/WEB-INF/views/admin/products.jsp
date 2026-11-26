<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Quản Lý Thực Đơn & Món - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="font-serif fw-bold text-primary mb-0">Quản Lý Thực Đơn &amp; Danh Mục Món</h4>
            <small class="text-secondary">Giám sát danh mục 36 món đặc sản, điều chỉnh giá bán và trạng thái sẵn sàng phục vụ</small>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-dark-roast border border-gold text-gold px-3 py-2 font-accent">
                Tổng: <strong>${products.size()}</strong> Sản Phẩm
            </span>
        </div>
    </div>

    <!-- Filter & Search Toolbar -->
    <div class="card-luxury p-3 border-gold shadow-sm mb-3 bg-espresso">
        <div class="row g-2 align-items-center">
            <div class="col-md-5">
                <div class="input-group input-group-sm">
                    <span class="input-group-text bg-dark-roast border-gold text-gold"><i class="fa-solid fa-magnifying-glass"></i></span>
                    <input type="text" id="productSearchInput" class="form-control form-control-luxury" placeholder="Tìm kiếm theo tên món..." onkeyup="filterProductsTable()">
                </div>
            </div>
            <div class="col-md-7 text-md-end text-start">
                <div class="d-flex flex-wrap gap-1 justify-content-md-end">
                    <button type="button" class="btn btn-sm btn-gold cat-filter-btn active" data-cat="ALL" onclick="filterByCategory('ALL', this)">Tất Cả</button>
                    <c:forEach var="cat" items="${categories}">
                        <button type="button" class="btn btn-sm btn-outline-gold cat-filter-btn" data-cat="${cat.name}" onclick="filterByCategory('${cat.name}', this)">
                            ${cat.name}
                        </button>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- Products Table -->
    <div class="card-luxury p-4 border-gold shadow-lg mb-4">
        <div class="table-responsive">
            <table class="table table-luxury align-middle" id="productsTable">
                <thead>
                    <tr>
                        <th style="width: 70px;">Ảnh</th>
                        <th>Tên Món Đặc Sản</th>
                        <th>Danh Mục</th>
                        <th>Giá Niêm Yết</th>
                        <th>Đặc Tính</th>
                        <th>Trạng Thái</th>
                        <th class="text-end">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr class="product-row" data-cat="${p.category.name}" id="product-row-${p.id}">
                            <td>
                                <img src="${p.imageUrl}" alt="${p.name}" style="width: 50px; height: 50px; object-fit: cover;" class="rounded-3 border border-gold-subtle shadow-sm">
                            </td>
                            <td>
                                <div class="fw-bold text-primary product-name">${p.name}</div>
                                <small class="text-secondary font-accent">${p.slug}</small>
                            </td>
                            <td>
                                <span class="badge bg-dark-roast border border-secondary text-secondary small">${p.category.name}</span>
                            </td>
                            <td>
                                <span class="text-gold fw-bold">
                                    <fmt:formatNumber value="${p.basePrice}" pattern="#,##0"/> VNĐ
                                </span>
                            </td>
                            <td>
                                <span class="badge ${p.isFeatured ? 'bg-warning-subtle text-warning border border-warning' : 'bg-dark text-secondary'} small">
                                    ${p.isFeatured ? '⭐ Signature' : 'Tiêu Chuẩn'}
                                </span>
                            </td>
                            <td>
                                <span class="badge ${p.isAvailable ? 'bg-success-subtle text-success border border-success' : 'bg-danger-subtle text-danger border border-danger'} px-2 py-1">
                                    ${p.isAvailable ? 'Đang Bán' : 'Tạm Hết Hàng'}
                                </span>
                            </td>
                            <td class="text-end">
                                <button type="button" class="btn btn-outline-gold btn-sm rounded-pill px-3" onclick="toggleProduct(${p.id})">
                                    <i class="fa-solid fa-arrows-rotate me-1"></i> ${p.isAvailable ? 'Báo Hết' : 'Bật Bán'}
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        let currentCategory = 'ALL';

        function filterByCategory(cat, btn) {
            currentCategory = cat;
            document.querySelectorAll('.cat-filter-btn').forEach(b => {
                b.classList.remove('btn-gold', 'active');
                b.classList.add('btn-outline-gold');
            });
            btn.classList.remove('btn-outline-gold');
            btn.classList.add('btn-gold', 'active');
            filterProductsTable();
        }

        function filterProductsTable() {
            const keyword = document.getElementById('productSearchInput').value.toLowerCase().trim();
            const rows = document.querySelectorAll('.product-row');

            rows.forEach(row => {
                const name = row.querySelector('.product-name').textContent.toLowerCase();
                const cat = row.getAttribute('data-cat');

                const matchesKeyword = !keyword || name.includes(keyword);
                const matchesCat = (currentCategory === 'ALL' || cat === currentCategory);

                if (matchesKeyword && matchesCat) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function toggleProduct(id) {
            fetch('${pageContext.request.contextPath}/admin/products/' + id + '/toggle', {
                method: 'POST'
            }).then(res => res.json()).then(data => {
                if (data.success) {
                    location.reload();
                }
            }).catch(err => console.error(err));
        }
    </script>
</body>
