<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Chuẩn Hóa Công Thức SOP - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="font-serif fw-bold text-primary mb-0">Chuẩn Hóa Công Thức Pha Chế (Master Recipes &amp; SOP)</h4>
            <small class="text-secondary">Quy định định mức gram/ml nguyên liệu tiêu hao cho từng món nước, đảm bảo tính đồng nhất 100% hương vị toàn chuỗi</small>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-dark-roast border border-gold text-gold px-3 py-2 font-accent">
                <i class="fa-solid fa-flask me-1"></i> Định Lượng Chuẩn SOP F&B
            </span>
        </div>
    </div>

    <!-- SOP Standards Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Tỷ Lệ Chiết Xuất Cà Phê</span>
                    <h4 class="font-serif fw-bold text-gold mb-0">1:2 Espresso / 1:10 Cold Brew</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-gold text-gold"><i class="fa-solid fa-mortar-pestle"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Nhiệt Độ Nước Pha Chuẩn</span>
                    <h4 class="font-serif fw-bold text-primary mb-0">92°C - 94°C</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-secondary text-secondary"><i class="fa-solid fa-temperature-half"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Thời Gian Ủ Lạnh (Cold Brew)</span>
                    <h4 class="font-serif fw-bold text-success mb-0">18 - 24 Tiếng</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-success text-success"><i class="fa-solid fa-hourglass-half"></i></div>
            </div>
        </div>
    </div>

    <!-- Recipes Table -->
    <div class="card-luxury p-4 border-gold shadow-lg mb-4">
        <div class="table-responsive">
            <table class="table table-luxury align-middle">
                <thead>
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
