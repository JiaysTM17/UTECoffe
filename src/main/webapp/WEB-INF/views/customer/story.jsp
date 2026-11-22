<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<head>
    <title>Câu Chuyện Thương Hiệu - UTECoffe Specialty Tea & Coffee</title>
    <style>
        .story-hero {
            background: linear-gradient(rgba(18, 16, 14, 0.8), rgba(18, 16, 14, 0.88)), url('https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?q=80&w=1600') center/cover;
            color: #FFFFFF;
            padding: 110px 0 90px;
        }
        .quote-box {
            border-left: 3px solid #D4AF37;
            padding: 20px 25px;
            background: #F8F5EE;
            font-style: italic;
            border-radius: 0 8px 8px 0;
        }
        .story-img {
            border-radius: 12px;
            object-fit: cover;
            width: 100%;
            height: 380px;
        }
    </style>
</head>
<body>
    <!-- Story Hero -->
    <section class="story-hero text-center">
        <div class="container">
            <span class="badge bg-warning text-dark px-3 py-1 text-uppercase fw-bold mb-3">Tôn Vinh Tinh Hoa Nông Sản Việt</span>
            <h1 class="display-4 fw-bold mb-3" style="letter-spacing: 2px;">CÂU CHUYỆN UTECOFFE</h1>
            <p class="lead text-light opacity-75 max-w-700 mx-auto" style="max-width: 680px;">
                Hành trình tìm kiếm và tôn vinh những hạt cà phê đặc sản Cầu Đất cùng búp trà cổ thụ Mộc Châu qua lăng kính công nghệ hiện đại.
            </p>
        </div>
    </section>

    <!-- Main Content -->
    <div class="container py-5 my-3">
        <!-- Section 1: Khởi nguồn -->
        <div class="row g-5 align-items-center mb-5 pb-4">
            <div class="col-lg-6">
                <span class="text-warning text-uppercase fw-bold letter-spacing-2 small d-block mb-2">01 / KHỞI NGUỒN CẢM HỨNG</span>
                <h2 class="fw-bold text-dark mb-4">Hạt Cà Phê Từ Độ Cao 1.600m &amp; Lá Trà Cao Nguyên</h2>
                <p class="text-muted lead" style="font-size: 1.05rem;">
                    UTECOFFE ra đời từ niềm đam mê thuần khiết với hạt cà phê Arabica Cầu Đất (Đà Lạt) và những búp trà Ô Long thượng hạng vùng Mộc Châu, Lâm Đồng.
                </p>
                <p class="text-muted">
                    Tại Việt Nam, chúng ta sở hữu những vùng thổ nhưỡng bazan màu mỡ và khí hậu quanh năm mây phủ lý tưởng để sản sinh ra những mẻ hạt mang nốt hương trái cây nhiệt đới, mật ong và hoa nhài thanh tao. UTECoffe lựa chọn con đường Direct Trade — thu mua trực tiếp từ nông hộ với giá cao hơn thị trường để bảo tồn kỹ thuật hái chín thủ công 100%.
                </p>
                <div class="quote-box mt-4">
                    "Chúng tôi tin rằng ly cà phê hay tách trà ngon không chỉ bắt đầu từ quầy bar, mà đã hình thành từ giọt sương sớm trên những đồi chè và bàn tay nâng niu của người nông dân."
                </div>
            </div>
            <div class="col-lg-6">
                <img src="https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=800" alt="Specialty Coffee Beans" class="story-img shadow">
            </div>
        </div>

        <!-- Section 2: Nghệ thuật rang mộc -->
        <div class="row g-5 align-items-center mb-5 pb-4 flex-lg-row-reverse">
            <div class="col-lg-6">
                <span class="text-warning text-uppercase fw-bold letter-spacing-2 small d-block mb-2">02 / NGHỆ THUẬT RANG MỘC</span>
                <h2 class="fw-bold text-dark mb-4">Quy Trình Rang Xay Artisanal Small-Batch</h2>
                <p class="text-muted lead" style="font-size: 1.05rem;">
                    Mỗi mẻ hạt tại UTECoffe được rang mộc hoàn toàn bằng máy rang công nghệ khí nóng hồng ngoại hồi lưu, nói KHÔNG với bơ, hương liệu hay chất bảo quản.
                </p>
                <p class="text-muted">
                    Các Master Roaster kiểm soát tỉ mỉ từng giai đoạn: từ sấy khô (drying), tạo hương (Maillard) đến phát triển hương vị (development time ratio - DTR). Mức độ rang Light & Medium roast được ưu tiên để giữ lại lượng acid amin hữu cơ phong phú, mang lại hậu vị ngọt sâu và độ trong trẻo (clarity) tối đa trong từng giọt chiết xuất.
                </p>
            </div>
            <div class="col-lg-6">
                <img src="https://images.unsplash.com/photo-1509785307050-d4066910ec1e?q=80&w=800" alt="Artisanal Roasting" class="story-img shadow">
            </div>
        </div>

        <!-- Section 3: Công nghệ OMO -->
        <div class="row g-5 align-items-center mb-5">
            <div class="col-lg-6">
                <span class="text-warning text-uppercase fw-bold letter-spacing-2 small d-block mb-2">03 / TRẢI NGHIỆM ĐA KÊNH</span>
                <h2 class="fw-bold text-dark mb-4">Mô Hình OMO &amp; Trải Nghiệm Số Hiện Đại</h2>
                <p class="text-muted lead" style="font-size: 1.05rem;">
                    Sự giao thoa hoàn hảo giữa tay nghề barista thủ công và giải pháp công nghệ thời gian thực.
                </p>
                <p class="text-muted">
                    Khách hàng có thể đặt món trước mang đi (Takeaway), dùng tại bàn (Dine-in) qua quét mã QR hoặc giao tận nơi (Delivery). Mọi thao tác đều được kết nối tức thì với màn hình Kitchen Display System (KDS) tại quầy pha chế qua giao thức WebSocket STOMP, đảm bảo sự chuẩn xác tuyệt đối theo công thức định lượng (BOM).
                </p>
            </div>
            <div class="col-lg-6">
                <img src="https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=800" alt="Modern F&B Space" class="story-img shadow">
            </div>
        </div>

        <!-- CTA Banner -->
        <div class="card border-0 shadow-sm p-5 text-center bg-white rounded-4 mt-5">
            <h3 class="fw-bold mb-3">Sẵn Sàng Trải Nghiệm Hương Vị Khác Biệt?</h3>
            <p class="text-muted max-w-700 mx-auto mb-4" style="max-width: 600px;">
                Khám phá thực đơn đồ uống đặc sản hoặc ghé thăm các chi nhánh UTECoffe gần bạn nhất ngay hôm nay.
            </p>
            <div class="d-flex justify-content-center gap-3">
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-gold btn-lg px-4">
                    <i class="fa-solid fa-mug-hot me-2"></i> Xem Thực Đơn
                </a>
                <a href="${pageContext.request.contextPath}/stores" class="btn btn-outline-dark btn-lg px-4">
                    <i class="fa-solid fa-store me-2"></i> Tìm Chi Nhánh
                </a>
            </div>
        </div>
    </div>
</body>
