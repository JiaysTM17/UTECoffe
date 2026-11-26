<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Chuẩn Hóa Công Thức SOP - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h5 class="fw-semibold text-primary mb-0" style="font-family: var(--font-sans); font-size: 1.05rem;">Chuẩn hóa công thức pha chế (Master Recipes &amp; SOP)</h5>
            <small class="text-secondary" style="font-size: 0.75rem;">Quy định định mức gram/ml nguyên liệu tiêu hao cho từng món nước, đảm bảo tính đồng nhất 100% hương vị toàn chuỗi</small>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-dark-roast border border-gold-subtle text-gold px-2.5 py-1.5 font-sans rounded-2" style="font-size: 0.75rem;">
                <i class="fa-solid fa-flask me-1"></i> Định lượng chuẩn SOP F&B
            </span>
        </div>
    </div>

    <!-- SOP Standards Cards -->
    <div class="row g-2.5 mb-3">
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-secondary fw-semibold small" style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.03em;">Tỷ lệ chiết xuất cà phê</span>
                    <div class="fw-bold text-gold mb-0" style="font-family: var(--font-sans); font-size: 1.15rem;">1:2 Espresso / 1:10 Cold Brew</div>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-2" style="width: 32px; height: 32px; background: rgba(222, 183, 106, 0.12); color: var(--gold-primary);">
                    <i class="fa-solid fa-mortar-pestle" style="font-size: 0.88rem;"></i>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-secondary fw-semibold small" style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.03em;">Nhiệt độ nước pha chuẩn</span>
                    <div class="fw-bold text-primary mb-0" style="font-family: var(--font-sans); font-size: 1.15rem;">92°C - 94°C</div>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-2" style="width: 32px; height: 32px; background: rgba(255, 255, 255, 0.08); color: var(--text-secondary);">
                    <i class="fa-solid fa-temperature-half" style="font-size: 0.88rem;"></i>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-secondary fw-semibold small" style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.03em;">Thời gian ủ lạnh (Cold Brew)</span>
                    <div class="fw-bold text-success mb-0" style="font-family: var(--font-sans); font-size: 1.15rem;">18 - 24 Tiếng</div>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-2" style="width: 32px; height: 32px; background: rgba(25, 135, 84, 0.12); color: #198754;">
                    <i class="fa-solid fa-hourglass-half" style="font-size: 0.88rem;"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Recipes Table -->
    <div class="card-luxury p-3 p-md-3.5 border-gold shadow-sm mb-3">
        <div class="table-responsive">
            <table class="table table-luxury table-sm align-middle">
                <thead>
                    <tr style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.03em; color: var(--text-secondary);">
                    <tr>
                        <th>Món Nước Đặc Sản</th>
                        <th>Nguyên Liệu Cấu Thành</th>
                        <th>Định Mức Tiêu Hao</th>
                        <th>Đơn Vị Tính</th>
                        <th>Quy Trình Pha Chế Chuẩn (SOP)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="rec" items="${recipes}">
                        <tr>
                            <td class="fw-bold text-gold font-accent">${rec.product.name}</td>
                            <td>
                                <div class="fw-bold text-primary">${rec.ingredient.name}</div>
                            </td>
                            <td>
                                <span class="badge bg-espresso border border-gold text-gold fs-6 font-monospace">
                                    ${rec.quantityRequired}
                                </span>
                            </td>
                            <td><span class="text-secondary">${rec.ingredient.unit}</span></td>
                            <td>
                                <small class="text-secondary">
                                    <i class="fa-solid fa-circle-check text-success me-1"></i> Đong chuẩn xác bằng cân điện tử 0.1g, trừ kho tự động khi Barista hoàn tất ly.
                                </small>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
