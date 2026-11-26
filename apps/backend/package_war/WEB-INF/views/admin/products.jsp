<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Quản Lý Thực Đơn & Món - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
        <div>
            <h5 class="fw-semibold text-primary mb-0" style="font-family: var(--font-sans); font-size: 1.05rem;">Quản lý thực đơn &amp; danh mục món</h5>
            <small class="text-secondary" style="font-size: 0.75rem;">Giám sát danh mục ${products.size()} món đặc sản, thêm mới, điều chỉnh giá bán và phân loại danh mục</small>
        </div>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-gold btn-sm px-3 fw-semibold shadow-gold-sm" data-bs-toggle="modal" data-bs-target="#addProductModal">
                <i class="fa-solid fa-plus me-1.5"></i> Thêm Món Mới
            </button>
            <button type="button" class="btn btn-outline-gold btn-sm px-3 fw-semibold" data-bs-toggle="modal" data-bs-target="#manageCategoryModal">
                <i class="fa-solid fa-layer-group me-1.5"></i> Quản Lý Danh Mục
            </button>
            <span class="badge bg-dark-roast border border-gold-subtle text-gold px-2.5 py-1.5 font-sans rounded-2 d-none d-sm-inline-flex align-items-center" style="font-size: 0.75rem;">
                Tổng: <strong>${products.size()}</strong> món
            </span>
        </div>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show card-luxury p-2.5 mb-3 border-success text-success small d-flex align-items-center justify-content-between" role="alert">
            <div>
                <i class="fa-solid fa-circle-check me-2"></i>
                <c:choose>
                    <c:when test="${param.success == 'create'}">Thêm món đặc sản mới thành công!</c:when>
                    <c:when test="${param.success == 'update'}">Cập nhật thông tin món thành công!</c:when>
                    <c:when test="${param.success == 'delete'}">Đã lưu trữ / tắt trạng thái món thành công!</c:when>
                    <c:when test="${param.success == 'cat_create'}">Tạo danh mục mới thành công!</c:when>
                    <c:when test="${param.success == 'cat_update'}">Cập nhật danh mục thành công!</c:when>
                    <c:when test="${param.success == 'cat_delete'}">Đã vô hiệu hóa danh mục thành công!</c:when>
                    <c:otherwise>Thao tác dữ liệu thành công!</c:otherwise>
                </c:choose>
            </div>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Filter & Search Toolbar -->
    <div class="card-luxury p-2.5 p-md-3 border-gold shadow-sm mb-3">
        <div class="row g-2 align-items-center">
            <div class="col-md-5">
                <div class="input-group input-group-sm">
                    <span class="input-group-text bg-dark-roast border-gold text-gold"><i class="fa-solid fa-magnifying-glass"></i></span>
                    <input type="text" id="productSearchInput" class="form-control form-control-luxury" placeholder="Tìm kiếm theo tên món..." onkeyup="filterProductsTable()">
                </div>
            </div>
            <div class="col-md-7 text-md-end text-start">
                <div class="d-flex flex-wrap gap-1 justify-content-md-end">
                    <button type="button" class="btn btn-sm btn-gold cat-filter-btn active rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;" data-cat="ALL" onclick="filterByCategory('ALL', this)">Tất Cả</button>
                    <c:forEach var="cat" items="${categories}">
                        <button type="button" class="btn btn-sm btn-outline-gold cat-filter-btn rounded-2 px-2.5 py-1 font-sans" style="font-size: 0.78rem;" data-cat="${cat.name}" onclick="filterByCategory('${cat.name}', this)">
                            ${cat.name}
                        </button>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- Products Table -->
    <div class="card-luxury p-3 p-md-3.5 border-gold shadow-sm mb-3">
        <div class="table-responsive">
            <table class="table table-luxury table-sm align-middle" id="productsTable">
                <thead>
                    <tr style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.03em; color: var(--text-secondary);">
                        <th class="py-2" style="width: 60px;">Ảnh</th>
                        <th class="py-2">Tên Món Đặc Sản</th>
                        <th class="py-2">Danh Mục</th>
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
                            <td class="text-end text-nowrap">
                                <div class="d-inline-flex gap-1 align-items-center">
                                    <button type="button" class="btn btn-outline-gold btn-sm px-2.5 py-1" 
                                            onclick="openEditProductModal('${p.id}', '${p.name}', '${p.category.id}', '${p.basePrice}', '${p.imageUrl}', '${p.description}', ${p.isFeatured}, ${p.isAvailable})">
                                        <i class="fa-solid fa-pen-to-square me-1"></i> Sửa
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary btn-sm px-2.5 py-1" onclick="toggleProduct(${p.id})">
                                        <i class="fa-solid fa-arrows-rotate me-1"></i> ${p.isAvailable ? 'Báo Hết' : 'Bật Bán'}
                                    </button>
                                    <form action="${pageContext.request.contextPath}/admin/products/${p.id}/delete" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn lưu trữ / tắt món này?');">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button type="submit" class="btn btn-outline-danger btn-sm px-2 py-1" title="Lưu trữ / Tắt món">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 1. Modal: Thêm Món Mới -->
    <div class="modal fade" id="addProductModal" tabindex="-1" aria-labelledby="addProductModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content card-luxury border-gold shadow-lg" style="background: rgba(18, 14, 11, 0.98);">
                <div class="modal-header border-bottom border-gold pb-2.5">
                    <h5 class="modal-title font-serif fw-bold text-gold fs-5" id="addProductModalLabel">
                        <i class="fa-solid fa-plus-circle me-2"></i>Thêm Món Đặc Sản Mới
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/products/create" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div class="modal-body p-3 p-md-4">
                        <div class="row g-3">
                            <div class="col-md-7">
                                <label class="form-label text-gold small fw-bold mb-1">Tên Món Đặc Sản:</label>
                                <input type="text" name="name" class="form-control form-control-luxury" placeholder="Ví dụ: Pour-Over Gesha Cầu Đất" required>
                            </div>
                            <div class="col-md-5">
                                <label class="form-label text-gold small fw-bold mb-1">Danh Mục:</label>
                                <select name="categoryId" class="form-select form-control-luxury" required>
                                    <c:forEach var="c" items="${categories}">
                                        <option value="${c.id}">${c.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-gold small fw-bold mb-1">Giá Niêm Yết (VNĐ):</label>
                                <input type="number" name="basePrice" class="form-control form-control-luxury font-monospace" placeholder="55000" min="0" step="1000" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-gold small fw-bold mb-1">URL Ảnh Đại Diện:</label>
                                <input type="url" name="imageUrl" class="form-control form-control-luxury" placeholder="https://images.unsplash.com/...">
                            </div>
                            <div class="col-12">
                                <label class="form-label text-gold small fw-bold mb-1">Mô Tả Hương Vị &amp; Nguồn Gốc:</label>
                                <textarea name="description" class="form-control form-control-luxury" rows="3" placeholder="Ghi chú hương hoa quả, độ cao thổ nhưỡng, phong cách rang..."></textarea>
                            </div>
                            <div class="col-md-6">
                                <div class="form-check form-switch pt-2">
                                    <input class="form-check-input" type="checkbox" name="isFeatured" value="true" id="addIsFeatured">
                                    <label class="form-check-label text-primary small" for="addIsFeatured">⭐ Đánh dấu món Signature (Bán Chạy)</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-check form-switch pt-2">
                                    <input class="form-check-input" type="checkbox" name="isAvailable" value="true" id="addIsAvailable" checked>
                                    <label class="form-check-label text-primary small" for="addIsAvailable">✅ Sẵn sàng phục vụ (Đang Bán)</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-secondary border-opacity-25 p-3">
                        <button type="button" class="btn btn-outline-secondary btn-sm px-3" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-gold btn-sm px-4 fw-semibold"><i class="fa-solid fa-check me-1"></i> Tạo Món Mới</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 2. Modal: Chỉnh Sửa Món -->
    <div class="modal fade" id="editProductModal" tabindex="-1" aria-labelledby="editProductModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content card-luxury border-gold shadow-lg" style="background: rgba(18, 14, 11, 0.98);">
                <div class="modal-header border-bottom border-gold pb-2.5">
                    <h5 class="modal-title font-serif fw-bold text-gold fs-5" id="editProductModalLabel">
                        <i class="fa-solid fa-pen-to-square me-2"></i>Chỉnh Sửa Món Đặc Sản
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editProductForm" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div class="modal-body p-3 p-md-4">
                        <div class="row g-3">
                            <div class="col-md-7">
                                <label class="form-label text-gold small fw-bold mb-1">Tên Món Đặc Sản:</label>
                                <input type="text" id="editProductName" name="name" class="form-control form-control-luxury" required>
                            </div>
                            <div class="col-md-5">
                                <label class="form-label text-gold small fw-bold mb-1">Danh Mục:</label>
                                <select id="editProductCategory" name="categoryId" class="form-select form-control-luxury" required>
                                    <c:forEach var="c" items="${categories}">
                                        <option value="${c.id}">${c.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-gold small fw-bold mb-1">Giá Niêm Yết (VNĐ):</label>
                                <input type="number" id="editProductPrice" name="basePrice" class="form-control form-control-luxury font-monospace" min="0" step="1000" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-gold small fw-bold mb-1">URL Ảnh Đại Diện:</label>
                                <input type="url" id="editProductImage" name="imageUrl" class="form-control form-control-luxury">
                            </div>
                            <div class="col-12">
                                <label class="form-label text-gold small fw-bold mb-1">Mô Tả Hương Vị &amp; Nguồn Gốc:</label>
                                <textarea id="editProductDesc" name="description" class="form-control form-control-luxury" rows="3"></textarea>
                            </div>
                            <div class="col-md-6">
                                <div class="form-check form-switch pt-2">
                                    <input class="form-check-input" type="checkbox" name="isFeatured" value="true" id="editIsFeatured">
                                    <label class="form-check-label text-primary small" for="editIsFeatured">⭐ Đánh dấu món Signature (Bán Chạy)</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-check form-switch pt-2">
                                    <input class="form-check-input" type="checkbox" name="isAvailable" value="true" id="editIsAvailable">
                                    <label class="form-check-label text-primary small" for="editIsAvailable">✅ Sẵn sàng phục vụ (Đang Bán)</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-secondary border-opacity-25 p-3">
                        <button type="button" class="btn btn-outline-secondary btn-sm px-3" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-gold btn-sm px-4 fw-semibold"><i class="fa-solid fa-floppy-disk me-1"></i> Lưu Cập Nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 3. Modal: Quản Lý Danh Mục -->
    <div class="modal fade" id="manageCategoryModal" tabindex="-1" aria-labelledby="manageCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content card-luxury border-gold shadow-lg" style="background: rgba(18, 14, 11, 0.98);">
                <div class="modal-header border-bottom border-gold pb-2.5">
                    <h5 class="modal-title font-serif fw-bold text-gold fs-5" id="manageCategoryModalLabel">
                        <i class="fa-solid fa-layer-group me-2"></i>Quản Lý Danh Mục Món
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-3 p-md-4">
                    <!-- Form Tạo Danh Mục Mới -->
                    <div class="card-luxury p-3 mb-4 border-gold-subtle" style="background: rgba(30, 24, 20, 0.7);">
                        <h6 class="text-gold fw-bold mb-2 small"><i class="fa-solid fa-plus me-1"></i> Thêm Danh Mục Mới:</h6>
                        <form action="${pageContext.request.contextPath}/admin/categories/create" method="post" class="row g-2 align-items-end">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <div class="col-md-5">
                                <label class="form-label text-secondary small mb-1">Tên Danh Mục:</label>
                                <input type="text" name="name" class="form-control form-control-luxury form-control-sm" placeholder="VD: Trà Đậm Vị Mới" required>
                            </div>
                            <div class="col-md-5">
                                <label class="form-label text-secondary small mb-1">Mô Tả Ngắn:</label>
                                <input type="text" name="description" class="form-control form-control-luxury form-control-sm" placeholder="Mô tả nhóm món...">
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-gold btn-sm w-100 fw-semibold">Tạo Mới</button>
                            </div>
                        </form>
                    </div>

                    <!-- Danh sách các Danh Mục Hiện Có -->
                    <div class="table-responsive">
                        <table class="table table-luxury table-sm align-middle mb-0">
                            <thead>
                                <tr class="text-secondary small">
                                    <th>ID</th>
                                    <th>Tên Danh Mục</th>
                                    <th>Mô Tả</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-end">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${categories}">
                                    <tr>
                                        <td class="font-monospace text-gold small">#${c.id}</td>
                                        <td class="fw-bold text-primary small">${c.name}</td>
                                        <td class="text-secondary small text-truncate" style="max-width: 200px;">${c.description}</td>
                                        <td>
                                            <span class="badge ${c.isActive ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} small">
                                                ${c.isActive ? 'Hoạt Động' : 'Đã Tắt'}
                                            </span>
                                        </td>
                                        <td class="text-end text-nowrap">
                                            <button type="button" class="btn btn-outline-gold btn-sm px-2 py-0.5" 
                                                    onclick="openEditCategoryModal('${c.id}', '${c.name}', '${c.description}')">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </button>
                                            <form action="${pageContext.request.contextPath}/admin/categories/${c.id}/delete" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc muốn vô hiệu hóa danh mục ${c.name}?');">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-outline-danger btn-sm px-2 py-0.5">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 4. Modal: Chỉnh Sửa Danh Mục -->
    <div class="modal fade" id="editCategoryModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content card-luxury border-gold shadow-lg" style="background: rgba(18, 14, 11, 0.98);">
                <div class="modal-header border-bottom border-gold pb-2">
                    <h5 class="modal-title font-serif fw-bold text-gold fs-5">
                        <i class="fa-solid fa-pen-to-square me-2"></i>Sửa Danh Mục
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editCategoryForm" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div class="modal-body p-3">
                        <div class="mb-3">
                            <label class="form-label text-gold small fw-bold mb-1">Tên Danh Mục:</label>
                            <input type="text" id="editCategoryName" name="name" class="form-control form-control-luxury" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-gold small fw-bold mb-1">Mô Tả:</label>
                            <textarea id="editCategoryDesc" name="description" class="form-control form-control-luxury" rows="2"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-secondary border-opacity-25 p-2.5">
                        <button type="button" class="btn btn-outline-secondary btn-sm px-3" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-gold btn-sm px-4 fw-semibold">Lưu Thay Đổi</button>
                    </div>
                </form>
            </div>
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
                method: 'POST',
                headers: {
                    'X-CSRF-TOKEN': '${_csrf.token}'
                }
            }).then(res => res.json()).then(data => {
                if (data.success) {
                    location.reload();
                }
            }).catch(err => console.error(err));
        }

        function openEditProductModal(id, name, catId, price, img, desc, featured, available) {
            const form = document.getElementById('editProductForm');
            form.action = '${pageContext.request.contextPath}/admin/products/' + id + '/update';
            document.getElementById('editProductName').value = name;
            document.getElementById('editProductCategory').value = catId;
            document.getElementById('editProductPrice').value = price;
            document.getElementById('editProductImage').value = (img && img !== 'null') ? img : '';
            document.getElementById('editProductDesc').value = (desc && desc !== 'null') ? desc : '';
            document.getElementById('editIsFeatured').checked = (featured === true || featured === 'true');
            document.getElementById('editIsAvailable').checked = (available === true || available === 'true');

            const modal = new bootstrap.Modal(document.getElementById('editProductModal'));
            modal.show();
        }

        function openEditCategoryModal(id, name, desc) {
            const form = document.getElementById('editCategoryForm');
            form.action = '${pageContext.request.contextPath}/admin/categories/' + id + '/update';
            document.getElementById('editCategoryName').value = name;
            document.getElementById('editCategoryDesc').value = (desc && desc !== 'null') ? desc : '';

            // Hide manageCategoryModal temporarily
            const manageModal = bootstrap.Modal.getInstance(document.getElementById('manageCategoryModal'));
            if (manageModal) manageModal.hide();

            const modal = new bootstrap.Modal(document.getElementById('editCategoryModal'));
            modal.show();
        }
    </script>
</body>
