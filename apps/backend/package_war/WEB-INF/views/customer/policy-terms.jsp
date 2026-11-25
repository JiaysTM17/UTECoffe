<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Điều Khoản Dịch Vụ & Bảo Mật Khách Hàng - UTECoffe</title>
</head>
<body class="bg-obsidian text-light">
    <div class="container py-5 my-3" style="max-width: 900px;">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb small font-accent">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none hover-gold">Trang Chủ</a></li>
                <li class="breadcrumb-item active text-gold" aria-current="page">Điều Khoản Dịch Vụ & Bảo Mật</li>
            </ol>
        </nav>

        <div class="card-luxury p-5 border-gold shadow-lg bg-espresso">
            <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom border-gold-subtle">
                <div class="p-3 bg-dark-roast rounded-circle border border-gold text-gold fs-3">
                    <i class="fa-solid fa-shield-halved"></i>
                </div>
                <div>
                    <h2 class="font-serif fw-bold text-gold-gradient mb-1">Điều Khoản Dịch Vụ & Bảo Mật</h2>
                    <small class="text-secondary">Quy Định Sử Dụng Hệ Thống UTECoffe Platform</small>
                </div>
            </div>

            <div class="space-y-4 text-secondary fs-6" style="line-height: 1.8;">
                <h5 class="text-gold font-accent fw-bold mb-2">1. Điều Khoản Đặt Hàng & Giữ Chỗ</h5>
                <p>
                    Hệ thống đặt bàn trực tuyến và đặt món mang về của UTECoffe phục vụ tất cả khách hàng yêu thích cà phê đặc sản tại 3 chi nhánh Flagship (Thủ Đức, Quận 1, Bình Thạnh). Thời gian giữ chỗ đặt trước tối đa 15 phút so với giờ hẹn để đảm bảo phục vụ các khách hàng tiếp theo.
                </p>

                <h5 class="text-gold font-accent fw-bold mb-2">2. Chính Sách Tích Lũy Điểm UTEClub</h5>
                <p>
                    Mỗi 1.000 VNĐ chi tiêu tương ứng với 1 điểm thưởng UTEClub. Điểm tích lũy có giá trị xét hạng thành viên (Đồng, Bạc, Vàng, Kim Cương) và không có giá trị quy đổi thành tiền mặt trực tiếp mà được sử dụng để đổi voucher, quà tặng sinh nhật và các đặc quyền hội viên.
                </p>

                <h5 class="text-gold font-accent fw-bold mb-2">3. Cam Kết Bảo Mật Thông Tin Khách Hàng</h5>
                <p>
                    Toàn bộ dữ liệu cá nhân bao gồm họ tên, số điện thoại, địa chỉ nhận hàng và lịch sử giao dịch được mã hóa theo tiêu chuẩn an toàn bảo mật, tuyệt đối không chia sẻ cho bên thứ ba ngoại trừ đối tác vận chuyển phục vụ đơn hàng của bạn.
                </p>

                <h5 class="text-gold font-accent fw-bold mb-2">4. Bản Quyền Hình Ảnh & Thương Hiệu</h5>
                <p class="mb-0">
                    Thương hiệu UTECoffe, biểu tượng giọt cà phê hoàng kim và các tài liệu công thức SOP thuộc bản quyền sở hữu của chuỗi cà phê đặc sản UTECoffe. Mọi hành vi sao chép không xin phép đều bị nghiêm cấm.
                </p>
            </div>

            <div class="text-center mt-5 pt-3 border-top border-gold-subtle">
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold btn-sm px-4 py-2 rounded-pill font-accent">
                    <i class="fa-solid fa-mug-saucer me-1"></i> Khám Phá Thực Đơn
                </a>
            </div>
        </div>
    </div>
</body>
</html>
