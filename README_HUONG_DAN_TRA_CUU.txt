================================================================================
HỆ THỐNG TÀI LIỆU TOÀN DIỆN VÀ MÃ NGUỒN THIẾT KẾ ĐỒ ÁN CHUỖI TRÀ & CÀ PHÊ UTECOFFE
================================================================================
Đề tài: "Xây dựng website chuỗi bán trà và cafe UTECoffe bằng Spring boot +
         JSP/JSTL + Decorator Sitemesh + Bootstrap + JPA + PostgreSQL +
         JWT + WebSocket + Cloudinary"
Trường: Đại học Sư phạm Kỹ thuật (UTE)
Phiên bản: 2.0 (Tài Liệu Đặc Tả Nghiệp Vụ Và Thiết Kế Hệ Thống - Đã Tối Ưu & Dọn Sạch File Rác)
Ngày cập nhật: 19/11/2026

================================================================================
CẤU TRÚC THƯ MỤC CHÍNH (KHOA HỌC VÀ ĐỒNG BỘ)
================================================================================
D:\A - Học Tập\Lập Trình Web\Đ.Án├── 01_Tai_Lieu_Bao_Cao_Word/         [13 Tệp .docx hoàn chỉnh - Chuẩn nộp đồ án]
├── 02_Tai_Lieu_Nguon_Markdown_Backup/ [12 Tệp .md đồng bộ hóa 1-1 phục vụ tra cứu mã]
├── 03_Thiet_Ke_Thuong_Hieu_Logo/      [12 Tệp Logo Vector SVG & PNG]
└── README_HUONG_DAN_TRA_CUU.txt       [Tệp điều hướng tổng thể này]

================================================================================
CHI TIẾT 13 TỆP BÁO CÁO WORD TRONG THƯ MỤC 01 (01_Tai_Lieu_Bao_Cao_Word)
================================================================================
00_Bao_Cao_Tong_Hop_Toan_Bo_Do_An_UTECOFFE.docx
   -> Báo cáo tổng thể toàn bộ đề tài (1.300+ đoạn, 100+ bảng dữ liệu), tích hợp logo chính thức.
01_Khao_Sat_Thuc_Te_Cac_Chuoi_FNB.docx
   -> Khảo sát thực tế các chuỗi lớn (Highland, Phúc Long, The Coffee House, % Arabica).
02_Phan_Tich_Nghiep_Vu_Va_65_Quy_Tac_BR.docx
   -> Đặc tả từ điển nghiệp vụ, 65 quy tắc bắt buộc (BR-01 đến BR-65), định lượng công thức F&B.
03_Thiet_Ke_Kien_Truc_CSDL_32_Bang_Va_API.docx
   -> Thiết kế chi tiết 32 bảng cơ sở dữ liệu PostgreSQL/MySQL/SQLServer, Spring Data JPA, REST API.
04_Ke_Hoach_WBS_33_Goi_Va_Tien_Do_24_Tuan.docx
   -> Kế hoạch phân rã công việc (33 gói WBS), phân bổ sprint và tiến độ triển khai 24 tuần.
05_Ke_Hoach_Kiem_Thu_Chat_Luong_191_TC.docx
   -> Kế hoạch kiểm thử nghiệm thu toàn diện với 191 Test Cases (Functional, Edge, Security, Stress).
06_Nhat_Ky_Ra_Soat_Va_Quan_Ly_Quyet_Dinh.docx
   -> Lịch sử thẩm định, nhật ký ra soát lỗi và nhật ký quyết định kiến trúc công nghệ (ADR).
07_Doi_Chieu_12_Tieu_Chi_De_Bai_Va_Cong_Nghe.docx
   -> Ma trận đối chiếu 12 tiêu chí bắt buộc của đề bài (Spring Boot, JSP, Sitemesh, JPA, JWT, WebSocket...).
08_Dac_Ta_Chi_Tiet_41_Luong_Nghiep_Vu_UC.docx
   -> Đặc tả chi tiết 41 luồng ca sử dụng (Use Cases UC-01 đến UC-41) với luồng chính, luồng phụ và ngoại lệ.
09_Hop_Dong_Du_Lieu_Lenh_Va_Van_Hanh_He_Thong.docx
   -> Đặc tả cấu trúc Payload sự kiện, WebSocket STOMP Topics, cấu trúc Token JWT và SLA vận hành.
10_Ma_Tran_Truy_Vet_158_Chuc_Nang_F.docx
   -> Ma trận truy vết 158 chức năng chi tiết (F-001 đến F-158) nối kết giữa BR, UC và Test Case.
11_Quy_Chuan_Logo_Va_Nhan_Dien_Thuong_Hieu.docx
   -> Bản thuyết minh ý nghĩa biểu tượng, tâm lý học màu sắc, quy tắc Typography & khoảng cách an toàn.
12_Bao_Cao_Giai_Phap_Nghiep_Vu_FNB_Thuc_Te.docx
   -> Báo cáo giải pháp xử lý 6 kịch bản biên thực tế (POS Offline, Màn hình Barista KDS, Kho chi nhánh...).

================================================================================
CHI TIẾT TÀI NGUYÊN TRONG THƯ MỤC 03 (03_Thiet_Ke_Thuong_Hieu_Logo)
================================================================================
Toàn bộ logo được thiết kế theo trường phái Tối Giản Đương Đại (The Golden Drop & Camellia Leaf):
- logo_chinh_ngang.png / .svg (1600x500)   : Header Navbar website, hóa đơn VAT, email.
- logo_chinh_doc.png / .svg (1000x1200)   : Màn hình Đăng nhập, Đăng ký, trang Giới thiệu, Footer.
- logo_bieu_tuong_app_icon_512.png / .svg : Icon ứng dụng PWA & Mobile App Launcher.
- favicon.ico, favicon_192x192.png, favicon_32x32.png, favicon_16x16.png : Favicon web browser.
- Ban_Phan_Tich_Y_Nghia_Logo_UTECOFFE.docx : Báo cáo phân tích ý nghĩa logo kèm hình minh họa.
- Ban_Phan_Tich_Y_Nghia_Logo_UTECOFFE.html : Trang web trình diễn trực quan có thể mở bằng Chrome/Edge.

================================================================================
10 KHỐI NGHIỆP VỤ CỐT LÕI ĐÃ ĐƯỢC RÀ SOÁT ĐẦY ĐỦ TỪ A - Z
================================================================================
1. Menu & Tùy Biến Đồ Uống: Size S/M/L, Đường (0-100%), Đá (Nóng, 0-100%, Đá riêng), Topping chọn kèm,
   Mức độ rang & Kiểu xay hạt cà phê, Bánh ngọt ăn kèm (Cross-sell).
2. Đa Chi Nhánh & Phương Thức Nhận Hàng: Giao hàng tận nơi (Delivery - tính khoảng cách theo km) &
   Đặt trước nhận tại quán (Takeaway Pickup - chọn giờ hẹn & mã QR).
3. Quản Lý Tồn Kho Theo Chi Nhánh (Store Inventory): Tự động báo hết món khi chi nhánh hết nguyên liệu.
4. Màn Hình Pha Chế Thời Gian Thực (KDS Barista): Đẩy đơn qua WebSocket STOMP kèm chuông báo;
   Barista đổi trạng thái 1-chạm; Khách hàng theo dõi tiến trình pha chế realtime.
5. Khách Hàng Thân Thiết (Loyalty Beans): Tích điểm (10k = 1 Bean), 4 hạng (Bronze, Silver, Gold, Diamond),
   Ví voucher đổi điểm, ưu đãi sinh nhật.
6. Khuyến Mãi Đa Tầng: Mã Coupon, Happy Hour khung giờ vàng, Mua 1 Tặng 1 (BOGO), Combo tiết kiệm.
7. Thanh Toán Đa Kênh: COD, VNPay, MoMo, VietQR động (chuyển khoản tự động đối soát), xử lý hoàn tiền.
8. Đặt Bàn Trực Tuyến: Đặt bàn theo chi nhánh, ngày giờ, số khách, khu vực (phòng lạnh/ban công), gọi món trước.
9. Đánh Giá & Phản Hồi: Chấm 1-5 sao, nhận xét chữ, đính kèm ảnh thực tế upload Cloudinary.
10. Bảo Mật & Quản Trị Hệ Thống: Spring Security + JWT, phân quyền 5 Roles (Admin, Manager, Barista,
    Shipper, Customer), phân lập dữ liệu chi nhánh và Audit Trail ghi vết mọi thao tác nhạy cảm.
================================================================================
