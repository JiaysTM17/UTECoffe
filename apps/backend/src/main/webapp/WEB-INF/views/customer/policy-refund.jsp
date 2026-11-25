<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Chính Sách Đổi Trả & Bồi Hoàn Điểm - UTECoffe</title>
</head>
<body class="bg-obsidian text-light">
    <div class="container py-5 my-3" style="max-width: 900px;">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb small font-accent">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none hover-gold">Trang Chủ</a></li>
                <li class="breadcrumb-item active text-gold" aria-current="page">Chính Sách Đổi Trả & Bồi Hoàn</li>
            </ol>
        </nav>

        <div class="card-luxury p-5 border-gold shadow-lg bg-espresso">
            <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom border-gold-subtle">
                <div class="p-3 bg-dark-roast rounded-circle border border-gold text-gold fs-3">
                    <i class="fa-solid fa-hand-holding-dollar"></i>
                </div>
                <div>
                    <h2 class="font-serif fw-bold text-gold-gradient mb-1">Chính Sách Bồi Hoàn & Đổi Trả</h2>
                    <small class="text-secondary">Cam Kết Chất Lượng Đỉnh Cao Từ UTECoffe Artisanal Roasters</small>
                </div>
            </div>

            <div class="space-y-4 text-secondary fs-6" style="line-height: 1.8;">
                <h5 class="text-gold font-accent fw-bold mb-2">1. Cam Kết Trải Nghiệm Hoàn Mỹ</h5>
                <p>
                    Tại UTECoffe, sự hài lòng trọn vẹn của bạn là tôn chỉ cao nhất. Nếu món nước hay bánh thủ công không đạt chuẩn chất lượng cam kết (độ chua, ngọt, nhiệt độ hoặc sai lệch so với đơn đặt), chúng tôi sẵn sàng pha chế lại ngay lập tức tại quầy hoặc bồi hoàn 100% giá trị đơn hàng.
                </p>

                <h5 class="text-gold font-accent fw-bold mb-2">2. Các Trường Hợp Được Bồi Hoàn / Đổi Món</h5>
                <ul class="list-unstyled ps-3">
                    <li class="mb-2"><i class="fa-solid fa-circle-check text-gold me-2"></i><strong>Sự cố vận chuyển giao hàng:</strong> Thức uống bị nghiêng đổ, rách seal bảo quản hoặc nguội/tan đá do giao chậm quá 30 phút.</li>
                    <li class="mb-2"><i class="fa-solid fa-circle-check text-gold me-2"></i><strong>Sai sót đơn hàng:</strong> Quầy bar chuẩn bị sai kích cỡ (Size), sai loại sữa hạt/sữa tươi hoặc thiếu topping đã thanh toán.</li>
                    <li class="mb-2"><i class="fa-solid fa-circle-check text-gold me-2"></i><strong>Chất lượng hạt đặc sản:</strong> Hương vị chiết xuất không đạt điểm Cupping 85+ SCA như cam kết.</li>
                </ul>

                <h5 class="text-gold font-accent fw-bold mb-2">3. Hình Thức & Thời Gian Hoàn Tiền</h5>
                <p>
                    • <strong>Hoàn điểm UTEClub tức thì:</strong> Điểm thưởng tích lũy tương đương 100% giá trị đơn được hoàn trực tiếp vào tài khoản hội viên trong vòng <strong>15 phút</strong>.<br>
                    • <strong>Chuyển khoản VietQR / MoMo:</strong> Hoàn trả về tài khoản thanh toán ban đầu trong vòng 24 - 48 giờ làm việc.
                </p>

                <h5 class="text-gold font-accent fw-bold mb-2">4. Kênh Tiếp Nhận Khiếu Nại</h5>
                <p class="mb-0">
                    Quý khách chỉ cần thông báo cho Barista tại quầy hoặc chụp ảnh gửi về Hotline CSKH: <strong class="text-light">1900 2026</strong> hoặc Email: <strong class="text-light">cskh@utecoffe.vn</strong>. Đội ngũ quản lý sẽ xử lý thỏa đáng ngay lập tức.
                </p>
            </div>

            <div class="text-center mt-5 pt-3 border-top border-gold-subtle">
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold btn-sm px-4 py-2 rounded-pill font-accent">
                    <i class="fa-solid fa-mug-saucer me-1"></i> Quay Lại Đặt Món
                </a>
            </div>
        </div>
    </div>
</body>
</html>
