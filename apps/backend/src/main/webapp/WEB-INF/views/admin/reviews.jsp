<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Quản Lý Đánh Giá & CSKH - UTECoffe Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h5 class="fw-semibold text-primary mb-0" style="font-family: var(--font-sans); font-size: 1.05rem;">Đánh giá &amp; trải nghiệm khách hàng (CX)</h5>
            <small class="text-secondary" style="font-size: 0.75rem;">Lắng nghe ý kiến thực tế của khách hàng về hương vị, thái độ phục vụ và chất lượng không gian</small>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-dark-roast border border-gold-subtle text-gold px-2.5 py-1.5 font-sans rounded-2" style="font-size: 0.75rem;">
                Tổng: <strong>${reviews.size()}</strong> nhận xét
            </span>
        </div>
    </div>

    <!-- Quick Stats Cards -->
    <div class="row g-2.5 mb-3">
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="text-secondary fw-semibold small" style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.03em;">Điểm đánh giá trung bình</span>
                    <div class="fw-bold text-gold mb-0" style="font-family: var(--font-sans); font-size: 1.35rem; font-variant-numeric: tabular-nums;">4.9 / 5.0</div>
                </div>
                <div class="d-flex align-items-center justify-content-center rounded-2" style="width: 32px; height: 32px; background: rgba(222, 183, 106, 0.12); color: var(--gold-primary);">
                    <i class="fa-solid fa-star" style="font-size: 0.88rem;"></i>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Tỷ Lệ Hài Lòng</span>
                    <h4 class="font-serif fw-bold text-success mb-0">98.5% Tích Cực</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-success text-success"><i class="fa-solid fa-heart"></i></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-luxury p-3 border-gold shadow-sm d-flex align-items-center justify-content-between">
                <div>
                    <span class="small text-secondary font-accent text-uppercase">Phản Hồi CSKH</span>
                    <h4 class="font-serif fw-bold text-primary mb-0">100% Đã Phản Hồi</h4>
                </div>
                <div class="p-2 rounded-circle bg-dark-roast border border-secondary text-secondary"><i class="fa-solid fa-comment-dots"></i></div>
            </div>
        </div>
    </div>

    <!-- Reviews Table -->
    <div class="card-luxury p-4 border-gold shadow-lg mb-4">
        <div class="table-responsive">
            <table class="table table-luxury align-middle">
                <thead>
                    <tr>
                        <th>Khách Hàng</th>
                        <th>Món Thưởng Thức</th>
                        <th>Đánh Giá</th>
                        <th>Nội Dung Nhận Xét</th>
                        <th class="text-end">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${reviews}">
                        <tr id="review-row-${r.id}">
                            <td>
                                <div class="fw-bold text-primary">${r.user != null ? r.user.fullName : 'Hội viên ẩn danh'}</div>
                                <small class="text-secondary">${r.user != null ? r.user.email : ''}</small>
                            </td>
                            <td>
                                <span class="badge bg-dark-roast border border-gold text-gold small">${r.product.name}</span>
                            </td>
                            <td>
                                <div class="text-warning small text-nowrap">
                                    <c:forEach begin="1" end="${r.rating}">
                                        <i class="fa-solid fa-star"></i>
                                    </c:forEach>
                                    <span class="ms-1 fw-bold text-gold">${r.rating}.0</span>
                                </div>
                            </td>
                            <td>
                                <div class="text-primary small" style="max-width: 480px;">"${r.comment}"</div>
                            </td>
                            <td class="text-end">
                                <button type="button" class="btn btn-outline-gold btn-sm rounded-pill px-3 font-accent" onclick="replyReviewPrompt(${r.id}, '${r.user != null ? r.user.fullName : 'Quý khách'}')">
                                    <i class="fa-solid fa-reply me-1"></i> Trả Lời
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function replyReviewPrompt(id, name) {
            const reply = prompt('Nhập nội dung phản hồi CSKH gửi đến ' + name + ':', 'Cảm ơn bạn đã yêu thích trải nghiệm tại UTECoffe! Rất mong được đón tiếp bạn lần sau.');
            if (reply) {
                fetch('${pageContext.request.contextPath}/admin/reviews/' + id + '/reply', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'reply=' + encodeURIComponent(reply)
                }).then(res => res.json()).then(data => {
                    if (data.success) {
                        alert('Đã gửi phản hồi CSKH thành công!');
                    }
                }).catch(err => console.error(err));
            }
        }
    </script>
</body>
