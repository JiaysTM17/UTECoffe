<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<head>
    <title>Đặc Quyền Hội Viên UTEClub - UTECoffe Specialty Roastery</title>
</head>
<body class="bg-obsidian">

    <!-- UTEClub Hero Banner -->
    <section class="py-5 bg-espresso border-bottom border-gold text-center position-relative overflow-hidden">
        <div class="position-absolute top-0 start-50 translate-middle-x w-100 h-100 opacity-25 pointer-events-none" style="background: radial-gradient(circle at 50% 30%, rgba(212,175,55,0.2) 0%, transparent 70%);"></div>
        <div class="container py-lg-4 position-relative" style="z-index: 2;">
            <div class="d-inline-flex align-items-center gap-2 px-3 py-1.5 rounded-pill mb-3 border border-gold" style="background: rgba(212,175,55,0.1);">
                <i class="fa-solid fa-crown text-gold"></i>
                <span class="text-gold font-accent fw-bold text-uppercase small" style="letter-spacing: 0.15em;">UTECLUB LOYALTY PRIVILEGE</span>
            </div>
            <h1 class="font-serif display-4 fw-bold text-gold-gradient mb-3">
                Đặc Quyền Hội Viên UTEClub
            </h1>
            <p class="lead text-secondary mx-auto mb-4" style="max-width: 760px; font-weight: 300; line-height: 1.8;">
                Hệ thống tri ân khách hàng thân thiết được thiết kế riêng cho những tâm hồn đồng điệu yêu cà phê đặc sản và trà thượng hạng. Tích lũy 10% cho mọi chi tiêu và tận hưởng đẳng cấp dịch vụ chuẩn quốc tế.
            </p>
            <div class="d-flex flex-wrap justify-content-center gap-3">
                <sec:authorize access="!isAuthenticated()">
                    <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-gold rounded-pill px-4 py-2.5 fw-semibold shadow-gold-sm">
                        <i class="fa-solid fa-user-plus me-2"></i>Đăng Ký Hội Viên Miễn Phí
                    </a>
                    <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-outline-gold rounded-pill px-4 py-2.5 fw-semibold">
                        <i class="fa-solid fa-arrow-right-to-bracket me-2"></i>Đăng Nhập UTEClub
                    </a>
                </sec:authorize>
                <sec:authorize access="isAuthenticated()">
                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-gold rounded-pill px-4 py-2.5 fw-semibold shadow-gold-sm">
                        <i class="fa-solid fa-award me-2"></i>Xem Hạng Thẻ Của Bạn
                    </a>
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-gold rounded-pill px-4 py-2.5 fw-semibold">
                        <i class="fa-solid fa-mug-hot me-2"></i>Đặt Món Tích Điểm Ngay
                    </a>
                </sec:authorize>
            </div>
        </div>
    </section>

    <!-- 4 Core Pillars -->
    <section class="py-5 bg-dark-roast border-bottom border-gold">
        <div class="container">
            <div class="text-center mb-5">
                <span class="text-gold font-accent text-uppercase small fw-bold" style="letter-spacing: 0.12em;">4 TRỤ CỘT ĐẶC QUYỀN</span>
                <h3 class="font-serif fw-bold text-gold-gradient mt-1">Trải Nghiệm Dịch Vụ Vượt Chuẩn</h3>
            </div>
            <div class="row g-4">
                <div class="col-lg-3 col-md-6">
                    <div class="card-luxury p-4 h-100 text-center">
                        <div class="rounded-circle d-inline-flex align-items-center justify-content-center border border-gold mb-3 mx-auto" style="width: 60px; height: 60px; background: rgba(212,175,55,0.1);">
                            <i class="fa-solid fa-percent text-gold fs-4"></i>
                        </div>
                        <h5 class="font-serif fw-bold text-gold mb-2">Tích 10% Mọi Hóa Đơn</h5>
                        <p class="text-secondary small mb-0">Mỗi 1.000₫ thanh toán tại cửa hàng hoặc đặt online đều được tự động cộng 1 điểm vào ví thành viên.</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card-luxury p-4 h-100 text-center">
                        <div class="rounded-circle d-inline-flex align-items-center justify-content-center border border-gold mb-3 mx-auto" style="width: 60px; height: 60px; background: rgba(212,175,55,0.1);">
                            <i class="fa-solid fa-cake-candles text-gold fs-4"></i>
                        </div>
                        <h5 class="font-serif fw-bold text-gold mb-2">Quà Tặng Sinh Nhật</h5>
                        <p class="text-secondary small mb-0">Nhận ngay 01 ly cà phê hoặc trà Signature cùng phần thiệp chúc mừng thiết kế thủ công độc bản.</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card-luxury p-4 h-100 text-center">
                        <div class="rounded-circle d-inline-flex align-items-center justify-content-center border border-gold mb-3 mx-auto" style="width: 60px; height: 60px; background: rgba(212,175,55,0.1);">
                            <i class="fa-solid fa-arrow-up-right-dots text-gold fs-4"></i>
                        </div>
                        <h5 class="font-serif fw-bold text-gold mb-2">Free Up-size Thứ 5</h5>
                        <p class="text-secondary small mb-0">Thỏa thích nâng cấp ly Size M lên Size L hoàn toàn miễn phí cho tất cả đồ uống mỗi thứ Năm hàng tuần.</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card-luxury p-4 h-100 text-center">
                        <div class="rounded-circle d-inline-flex align-items-center justify-content-center border border-gold mb-3 mx-auto" style="width: 60px; height: 60px; background: rgba(212,175,55,0.1);">
                            <i class="fa-solid fa-couch text-gold fs-4"></i>
                        </div>
                        <h5 class="font-serif fw-bold text-gold mb-2">Ưu Tiên VIP Lounge</h5>
                        <p class="text-secondary small mb-0">Đặc quyền giữ chỗ bàn trung tâm view đẹp và phòng hội thảo riêng tại chuỗi 10 chi nhánh Flagship.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 4 Membership Tiers Details -->
    <section class="py-5 bg-espresso border-bottom border-gold">
        <div class="container py-lg-3">
            <div class="text-center mb-5">
                <span class="badge bg-gold text-obsidian px-3 py-1 font-accent fw-bold text-uppercase">HỆ THỐNG THĂNG HẠNG</span>
                <h2 class="font-serif display-5 fw-bold text-gold-gradient mt-2 mb-2">4 Cấp Bậc Hội Viên Danh Dự</h2>
                <p class="text-secondary small mx-auto" style="max-width: 640px;">
                    Điểm tích lũy trọn đời được ghi nhận minh bạch trên từng đơn hàng. Khi đạt đủ mốc điểm, hệ thống tự động thăng hạng thẻ và mở khóa đặc quyền mới.
                </p>
            </div>

            <div class="row g-4">
                <!-- Bronze -->
                <div class="col-lg-3 col-md-6">
                    <div class="card-luxury p-4 h-100 text-start border position-relative" style="border-color: #cd7f32 !important;">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <span class="badge px-3 py-1.5 text-white fw-bold font-accent" style="background: #cd7f32;">HẠNG ĐỒNG</span>
                            <span class="text-secondary small font-monospace">0 - 499 pts</span>
                        </div>
                        <h4 class="font-serif fw-bold text-light mb-2">Bronze Member</h4>
                        <p class="text-secondary small mb-4">Cấp bậc khởi đầu tự động kích hoạt ngay khi bạn hoàn tất đăng ký tài khoản.</p>
                        
                        <h6 class="font-accent fw-bold text-gold small text-uppercase mb-2">Đặc Quyền Bao Gồm:</h6>
                        <ul class="list-unstyled small text-secondary d-flex flex-column gap-2 mb-4">
                            <li><i class="fa-solid fa-check text-gold me-2"></i> Voucher <strong>giảm 20%</strong> cho đơn hàng đầu tiên</li>
                            <li><i class="fa-solid fa-check text-gold me-2"></i> Tích lũy <strong>10% điểm</strong> mọi hóa đơn</li>
                            <li><i class="fa-solid fa-check text-gold me-2"></i> Đặt bàn trực tuyến nhanh chóng</li>
                            <li><i class="fa-solid fa-check text-gold me-2"></i> Nhận thư tin tức mẻ rang mộc mới</li>
                        </ul>
                    </div>
                </div>

                <!-- Silver -->
                <div class="col-lg-3 col-md-6">
                    <div class="card-luxury p-4 h-100 text-start border position-relative" style="border-color: #c0c0c0 !important;">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <span class="badge px-3 py-1.5 text-dark fw-bold font-accent" style="background: #c0c0c0;">HẠNG BẠC</span>
                            <span class="text-secondary small font-monospace">500 - 1.499 pts</span>
                        </div>
                        <h4 class="font-serif fw-bold text-light mb-2">Silver Member</h4>
                        <p class="text-secondary small mb-4">Dành cho những thực khách thân thiết gắn bó thường nhật cùng không gian UTECoffe.</p>
                        
                        <h6 class="font-accent fw-bold text-gold small text-uppercase mb-2">Đặc Quyền Bao Gồm:</h6>
                        <ul class="list-unstyled small text-secondary d-flex flex-column gap-2 mb-4">
                            <li><i class="fa-solid fa-check text-gold me-2"></i> Toàn bộ đặc quyền của Hạng Đồng</li>
                            <li><i class="fa-solid fa-check text-gold me-2"></i> <strong>Free Up-size</strong> (Size M lên L) mỗi thứ Năm</li>
                            <li><i class="fa-solid fa-check text-gold me-2"></i> Voucher <strong>giảm 10%</strong> gửi tặng đầu mỗi tháng</li>
                            <li><i class="fa-solid fa-check text-gold me-2"></i> Miễn phí 01 phần topping tự chọn hàng tháng</li>
                        </ul>
                    </div>
                </div>

                <!-- Gold -->
                <div class="col-lg-3 col-md-6">
                    <div class="card-luxury p-4 h-100 text-start border position-relative" style="border-color: #ffd700 !important; background: linear-gradient(180deg, rgba(212,175,55,0.08) 0%, rgba(20,20,20,0.8) 100%);">
                        <div class="position-absolute top-0 end-0 translate-middle-y me-3">
                            <span class="badge bg-gold text-obsidian fw-bold small px-2 py-1 shadow-gold-sm">ĐƯỢC YÊU THÍCH NHẤT</span>
                        </div>
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <span class="badge px-3 py-1.5 text-dark fw-bold font-accent" style="background: #ffd700;">HẠNG VÀNG</span>
                            <span class="text-gold small font-monospace fw-bold">1.500 - 2.999 pts</span>
                        </div>
                        <h4 class="font-serif fw-bold text-gold-gradient mb-2">Gold VIP Member</h4>
                        <p class="text-secondary small mb-4">Trải nghiệm dịch vụ cao cấp với mức ưu đãi giảm giá trực tiếp và quà tặng sinh nhật.</p>
                        
                        <h6 class="font-accent fw-bold text-gold small text-uppercase mb-2">Đặc Quyền Bao Gồm:</h6>
                        <ul class="list-unstyled small text-secondary d-flex flex-column gap-2 mb-4">
                            <li><i class="fa-solid fa-check text-gold me-2"></i> <strong>Giảm trực tiếp 10%</strong> trên toàn bộ thực đơn</li>
                            <li><i class="fa-solid fa-check text-gold me-2"></i> <strong>01 Ly cà phê Signature</strong> miễn phí ngày Sinh Nhật</li>
                            <li><i class="fa-solid fa-check text-gold me-2"></i> Ưu tiên giữ bàn đẹp nhất tại khu vực VIP Lounge</li>
                            <li><i class="fa-solid fa-check text-gold me-2"></i> Toàn bộ đặc quyền của Hạng Bạc &amp; Đồng</li>
                        </ul>
                    </div>
                </div>

                <!-- Diamond -->
                <div class="col-lg-3 col-md-6">
                    <div class="card-luxury p-4 h-100 text-start border position-relative" style="border-color: #b9f2ff !important; background: linear-gradient(180deg, rgba(185,242,255,0.08) 0%, rgba(20,20,20,0.8) 100%);">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <span class="badge px-3 py-1.5 text-dark fw-bold font-accent" style="background: #b9f2ff;">KIM CƯƠNG</span>
                            <span class="text-info small font-monospace fw-bold">3.000+ pts</span>
                        </div>
                        <h4 class="font-serif fw-bold text-light mb-2">Diamond Elite</h4>
                        <p class="text-secondary small mb-4">Đỉnh cao tôn vinh khách hàng thân thiết với những trải nghiệm cà phê độc bản duy nhất.</p>
                        
                        <h6 class="font-accent fw-bold text-gold small text-uppercase mb-2">Đặc Quyền Bao Gồm:</h6>
                        <ul class="list-unstyled small text-secondary d-flex flex-column gap-2 mb-4">
                            <li><i class="fa-solid fa-check text-gold me-2"></i> <strong>Giảm trực tiếp 15% trọn đời</strong> mọi hóa đơn</li>
                            <li><i class="fa-solid fa-check text-gold me-2"></i> Tặng <strong>01 phần bánh sừng bò</strong> thủ công mỗi tuần</li>
                            <li><i class="fa-solid fa-check text-gold me-2"></i> Vé mời tham dự <strong>Private Cupping</strong> cùng Master Roaster</li>
                            <li><i class="fa-solid fa-check text-gold me-2"></i> Đường dây hỗ trợ &amp; đặt bàn ưu tiên 24/7</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Comparison Table -->
    <section class="py-5 bg-dark-roast border-bottom border-gold">
        <div class="container">
            <div class="text-center mb-5">
                <span class="text-gold font-accent text-uppercase small fw-bold" style="letter-spacing: 0.12em;">BẢNG ĐỐI CHIẾU CHI TIẾT</span>
                <h3 class="font-serif fw-bold text-gold-gradient mt-1">So Sánh Quyền Lợi Theo Hạng Thẻ</h3>
            </div>
            <div class="table-responsive rounded-3 border border-gold-subtle">
                <table class="table table-dark table-hover mb-0 align-middle text-center small">
                    <thead style="background: rgba(212,175,55,0.15);">
                        <tr class="text-gold font-accent text-uppercase">
                            <th class="text-start py-3 ps-4" style="width: 35%;">Đặc Quyền Hội Viên</th>
                            <th class="py-3" style="width: 15%; color: #cd7f32;">Đồng (Bronze)</th>
                            <th class="py-3" style="width: 15%; color: #c0c0c0;">Bạc (Silver)</th>
                            <th class="py-3" style="width: 15%; color: #ffd700;">Vàng (Gold)</th>
                            <th class="py-3" style="width: 20%; color: #b9f2ff;">Kim Cương (Diamond)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="text-start ps-4 fw-semibold">Điều kiện tích lũy</td>
                            <td>0 - 499 điểm</td>
                            <td>500 - 1.499 điểm</td>
                            <td>1.500 - 2.999 điểm</td>
                            <td>Từ 3.000 điểm trở lên</td>
                        </tr>
                        <tr>
                            <td class="text-start ps-4 fw-semibold">Tỷ lệ tích điểm cho mọi đơn</td>
                            <td><span class="text-gold fw-bold">10%</span> (1k = 1đ)</td>
                            <td><span class="text-gold fw-bold">10%</span> (1k = 1đ)</td>
                            <td><span class="text-gold fw-bold">10%</span> (1k = 1đ)</td>
                            <td><span class="text-gold fw-bold">10%</span> (1k = 1đ)</td>
                        </tr>
                        <tr>
                            <td class="text-start ps-4 fw-semibold">Ưu đãi giảm giá trực tiếp trên menu</td>
                            <td class="text-muted">—</td>
                            <td class="text-muted">—</td>
                            <td><span class="badge bg-gold text-obsidian fw-bold">Giảm 10%</span></td>
                            <td><span class="badge bg-info text-dark fw-bold">Giảm 15%</span></td>
                        </tr>
                        <tr>
                            <td class="text-start ps-4 fw-semibold">Voucher tặng định kỳ hàng tháng</td>
                            <td class="text-muted">—</td>
                            <td><i class="fa-solid fa-circle-check text-gold"></i> Giảm 10%</td>
                            <td><i class="fa-solid fa-circle-check text-gold"></i> Giảm 15%</td>
                            <td><i class="fa-solid fa-circle-check text-gold"></i> Giảm 20%</td>
                        </tr>
                        <tr>
                            <td class="text-start ps-4 fw-semibold">Free Up-size Thứ 5 (Size M lên L)</td>
                            <td class="text-muted">—</td>
                            <td><i class="fa-solid fa-circle-check text-gold"></i></td>
                            <td><i class="fa-solid fa-circle-check text-gold"></i></td>
                            <td><i class="fa-solid fa-circle-check text-gold"></i></td>
                        </tr>
                        <tr>
                            <td class="text-start ps-4 fw-semibold">Quà tặng thức uống ngày Sinh Nhật</td>
                            <td class="text-muted">—</td>
                            <td class="text-muted">—</td>
                            <td><i class="fa-solid fa-gift text-gold me-1"></i> 01 Ly Signature</td>
                            <td><i class="fa-solid fa-gift text-gold me-1"></i> 01 Ly Signature + Bánh</td>
                        </tr>
                        <tr>
                            <td class="text-start ps-4 fw-semibold">Bánh ngọt thủ công miễn phí mỗi tuần</td>
                            <td class="text-muted">—</td>
                            <td class="text-muted">—</td>
                            <td class="text-muted">—</td>
                            <td><i class="fa-solid fa-crown text-gold"></i> 01 Phần/tuần</td>
                        </tr>
                        <tr>
                            <td class="text-start ps-4 fw-semibold">Ưu tiên giữ chỗ phòng VIP Lounge</td>
                            <td class="text-muted">—</td>
                            <td class="text-muted">—</td>
                            <td><i class="fa-solid fa-circle-check text-gold"></i></td>
                            <td><i class="fa-solid fa-circle-check text-gold"></i> Ưu tiên số 1</td>
                        </tr>
                        <tr>
                            <td class="text-start ps-4 fw-semibold">Tham gia Roastery Tour &amp; Private Cupping</td>
                            <td class="text-muted">—</td>
                            <td class="text-muted">—</td>
                            <td class="text-muted">—</td>
                            <td><i class="fa-solid fa-certificate text-gold me-1"></i> Vé mời VIP</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <!-- 4 Easy Steps to Join -->
    <section class="py-5 bg-espresso border-bottom border-gold">
        <div class="container py-3">
            <div class="text-center mb-5">
                <span class="text-gold font-accent text-uppercase small fw-bold" style="letter-spacing: 0.12em;">HƯỚNG DẪN THAM GIA</span>
                <h3 class="font-serif fw-bold text-gold-gradient mt-1">4 Bước Trở Thành Hội Viên UTEClub</h3>
            </div>
            <div class="row g-4 text-center">
                <div class="col-md-3 col-6">
                    <div class="p-3">
                        <div class="rounded-circle border border-gold d-inline-flex align-items-center justify-content-center text-gold fs-4 fw-bold mb-3" style="width: 50px; height: 50px;">1</div>
                        <h6 class="font-serif fw-bold text-light mb-1">Đăng Ký Miễn Phí</h6>
                        <p class="text-secondary small mb-0">Tạo tài khoản trực tuyến chỉ với Email hoặc Số điện thoại trong 30 giây.</p>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="p-3">
                        <div class="rounded-circle border border-gold d-inline-flex align-items-center justify-content-center text-gold fs-4 fw-bold mb-3" style="width: 50px; height: 50px;">2</div>
                        <h6 class="font-serif fw-bold text-light mb-1">Thưởng Thức Đồ Uống</h6>
                        <p class="text-secondary small mb-0">Đặt món trực tuyến hoặc đến trực tiếp chuỗi 10 cửa hàng Flagship.</p>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="p-3">
                        <div class="rounded-circle border border-gold d-inline-flex align-items-center justify-content-center text-gold fs-4 fw-bold mb-3" style="width: 50px; height: 50px;">3</div>
                        <h6 class="font-serif fw-bold text-light mb-1">Tích Điểm Tự Động</h6>
                        <p class="text-secondary small mb-0">Mỗi hóa đơn được hệ thống ghi nhận và tích lũy 10% giá trị ngay lập tức.</p>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="p-3">
                        <div class="rounded-circle border border-gold d-inline-flex align-items-center justify-content-center text-gold fs-4 fw-bold mb-3" style="width: 50px; height: 50px;">4</div>
                        <h6 class="font-serif fw-bold text-light mb-1">Tận Hưởng Đặc Quyền</h6>
                        <p class="text-secondary small mb-0">Thăng hạng thẻ, nhận voucher giảm giá và tận hưởng trọn vẹn đặc quyền.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ Accordion -->
    <section class="py-5 bg-dark-roast border-bottom border-gold">
        <div class="container py-3" style="max-width: 860px;">
            <div class="text-center mb-5">
                <span class="text-gold font-accent text-uppercase small fw-bold" style="letter-spacing: 0.12em;">CÂU HỎI THƯỜNG GẶP</span>
                <h3 class="font-serif fw-bold text-gold-gradient mt-1">Giải Đáp Về Chương Trình UTEClub</h3>
            </div>

            <div class="accordion accordion-flush" id="uteClubFaqAccordion">
                <div class="accordion-item bg-espresso border border-gold-subtle mb-3 rounded-3 overflow-hidden">
                    <h2 class="accordion-header" id="faqHeading1">
                        <button class="accordion-button collapsed bg-espresso text-light fw-semibold" type="button" data-bs-toggle="collapse" data-bs-target="#faqCollapse1">
                            <i class="fa-solid fa-circle-question text-gold me-2"></i> Điểm UTEClub được tính như thế nào?
                        </button>
                    </h2>
                    <div id="faqCollapse1" class="accordion-collapse collapse" data-bs-parent="#uteClubFaqAccordion">
                        <div class="accordion-body text-secondary small">
                            Cứ mỗi 1.000 VNĐ chi tiêu thực tế cho đơn hàng hoàn tất (sau khi đã áp dụng mã giảm giá nếu có), bạn sẽ được tích lũy 1 Điểm UTEClub. Điểm số được hệ thống ghi nhận tức thời vào tài khoản cá nhân.
                        </div>
                    </div>
                </div>

                <div class="accordion-item bg-espresso border border-gold-subtle mb-3 rounded-3 overflow-hidden">
                    <h2 class="accordion-header" id="faqHeading2">
                        <button class="accordion-button collapsed bg-espresso text-light fw-semibold" type="button" data-bs-toggle="collapse" data-bs-target="#faqCollapse2">
                            <i class="fa-solid fa-circle-question text-gold me-2"></i> Hạng thẻ hội viên có thời hạn sử dụng hay bị hạ hạng không?
                        </button>
                    </h2>
                    <div id="faqCollapse2" class="accordion-collapse collapse" data-bs-parent="#uteClubFaqAccordion">
                        <div class="accordion-body text-secondary small">
                            Điểm tích lũy thăng hạng của UTEClub là điểm trọn đời (Lifetime Points). Khi bạn đã thăng hạng thẻ Bạc, Vàng hoặc Kim Cương, bạn sẽ được duy trì thứ hạng của mình và hưởng trọn vẹn đặc quyền mà không lo lắng bị hạ hạng.
                        </div>
                    </div>
                </div>

                <div class="accordion-item bg-espresso border border-gold-subtle mb-3 rounded-3 overflow-hidden">
                    <h2 class="accordion-header" id="faqHeading3">
                        <button class="accordion-button collapsed bg-espresso text-light fw-semibold" type="button" data-bs-toggle="collapse" data-bs-target="#faqCollapse3">
                            <i class="fa-solid fa-circle-question text-gold me-2"></i> Làm thế nào để nhận quà tặng sinh nhật?
                        </button>
                    </h2>
                    <div id="faqCollapse3" class="accordion-collapse collapse" data-bs-parent="#uteClubFaqAccordion">
                        <div class="accordion-body text-secondary small">
                            Thành viên từ Hạng Vàng trở lên chỉ cần cập nhật ngày sinh nhật trong mục Thông tin cá nhân. Vào đúng tháng sinh nhật, hệ thống UTECoffe sẽ tự động gửi mã quà tặng 01 ly đồ uống Signature miễn phí vào ví voucher của bạn.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Bottom CTA Banner -->
    <section class="py-5 bg-espresso text-center position-relative">
        <div class="container py-4">
            <h3 class="font-serif fw-bold text-gold-gradient mb-2">Sẵn Sàng Trở Thành Hội Viên UTEClub?</h3>
            <p class="text-secondary small mx-auto mb-4" style="max-width: 560px;">
                Đăng ký ngay hôm nay để nhận Voucher ưu đãi 20% cho đơn hàng đầu tiên và mở khóa hàng loạt đặc quyền ẩm thực tinh hoa.
            </p>
            <div class="d-flex justify-content-center gap-3">
                <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-gold rounded-pill px-4 py-2.5 fw-semibold shadow-gold-sm">
                    <i class="fa-solid fa-user-plus me-2"></i>Đăng Ký Tài Khoản Miễn Phí
                </a>
                <a href="${pageContext.request.contextPath}/reservation" class="btn btn-outline-gold rounded-pill px-4 py-2.5 fw-semibold">
                    <i class="fa-solid fa-chair me-2"></i>Đặt Bàn Thưởng Thức
                </a>
            </div>
        </div>
    </section>

</body>
