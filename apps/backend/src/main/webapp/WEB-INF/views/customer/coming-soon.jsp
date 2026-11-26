<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>${title} - UTECoffe Specialty</title>
</head>
<body class="bg-obsidian text-primary">
    <div class="container py-5 text-center my-5">
        <div class="card-luxury p-5 mx-auto border-gold shadow-lg" style="max-width: 650px; border-radius: 24px;">
            <div class="mb-4">
                <div class="d-inline-flex align-items-center justify-content-center rounded-circle border border-gold p-4" style="background: radial-gradient(circle, rgba(222,183,106,0.18) 0%, rgba(14,13,11,0) 70%); width: 110px; height: 110px;">
                    <i class="fa-solid fa-sparkles text-gold fs-1"></i>
                </div>
            </div>
            
            <span class="badge bg-gold-gradient text-obsidian px-3 py-1 rounded-pill font-accent fw-bold small text-uppercase mb-3" style="letter-spacing: 0.12em;">
                ✨ Trải Nghiệm Đang Hoàn Thiện
            </span>
            
            <h2 class="font-serif fw-bold text-gold-gradient mb-3">${title}</h2>
            
            <p class="text-secondary fs-6 mb-4 px-lg-3" style="line-height: 1.8;">
                ${not empty message ? message : 'Kênh truyền thông & tính năng này của <strong>UTECOFFE Artisanal Roasters</strong> đang trong quá trình hoàn thiện nội dung độc quyền nhằm đem lại tiêu chuẩn phục vụ tinh tế và trọn vẹn nhất cho bạn. Xin vui lòng đón chờ trong thời gian sớm nhất!'}
            </p>

            <div class="p-3 bg-espresso border border-gold-subtle rounded-3 mb-4 text-start small text-secondary">
                <div class="d-flex align-items-center gap-2 mb-1 text-gold fw-bold">
                    <i class="fa-solid fa-circle-info"></i> Thông tin hỗ trợ trực tiếp 24/7:
                </div>
                <div>• Hotline Tổng đài Chăm sóc Khách hàng: <strong class="text-primary">1900 2026</strong></div>
                <div>• Email tiếp nhận yêu cầu: <strong class="text-primary">contact@utecoffe.vn</strong></div>
                <div>• Chi nhánh Flagship Thủ Đức: <strong class="text-primary">01 Võ Văn Ngân, TP. Thủ Đức</strong></div>
            </div>

            <div class="d-flex justify-content-center gap-3 flex-wrap">
                <a href="${pageContext.request.contextPath}/" class="btn btn-gold btn-sm px-4 py-2 rounded-pill font-accent">
                    <i class="fa-solid fa-house me-1"></i> Về Trang Chủ
                </a>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-gold btn-sm px-4 py-2 rounded-pill font-accent">
                    <i class="fa-solid fa-mug-saucer me-1"></i> Khám Phá Thực Đơn
                </a>
            </div>
        </div>
    </div>
</body>
</html>
