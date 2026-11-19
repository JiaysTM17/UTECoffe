# UTECoffe — Bộ hồ sơ phân tích và kế hoạch phát triển

**Phiên bản:** 1.3 · **Ngày lập:** 17/11/2026 · **Rà soát cuối:** 19/11/2026 · **Trạng thái:** thiết kế đề xuất, chưa triển khai phần mềm.

**Đề tài:** Website chuỗi bán trà và cà phê UTECoffe bằng Spring Boot, JSP/JSTL, SiteMesh, Bootstrap, JPA, PostgreSQL, JWT, WebSocket và Cloudinary.

## 1. Những quyết định đã chốt

- Người thực hiện định hướng tự xây dựng dù đề tài đăng ký theo nhóm. Tiến độ tính theo **một người**; module và đầu ra vẫn chia được cho thành viên khác.
- Chọn **PostgreSQL** làm cơ sở dữ liệu chính cho đồ án và hướng phát triển thực tế. Không triển khai đồng thời ba hệ quản trị.
- Mô hình là **một thương hiệu sở hữu nhiều chi nhánh**, có quản lý tập trung và quyền theo cơ sở. Đây không phải sàn nhiều người bán độc lập.
- Thị trường đầu tiên: Việt Nam; giao diện tiếng Việt; tiền VND; ưu tiên điện thoại; nhân viên sử dụng máy tính hoặc máy tính bảng.
- “Cloudairy” được hiểu là **Cloudinary**. Giữ nguyên tên đề tài **UTECoffe**.
- Bộ hồ sơ chỉ gồm phân tích, thiết kế dự kiến, khảo sát và kế hoạch kiểm thử. Không có mã nguồn ứng dụng, database đã tạo hoặc tích hợp đã chạy.
- Hồ sơ này độc lập với dự án quần áo trước đó.

## 2. Đọc tài liệu theo thứ tự nào?

| Thứ tự | Tài liệu | Dùng để làm gì? |
|---|---|---|
| 1 | [Khảo sát các chuỗi](01-KHAO-SAT-CHUOI-TRA-CA-PHE.md) | Hiểu nguồn tham khảo, điều học được và giới hạn chứng cứ |
| 2 | [Phân tích nghiệp vụ](02-PHAN-TICH-NGHIEP-VU-UTECOFFE.md) | Chốt phạm vi, vai trò, quy tắc, luồng và danh mục chức năng |
| 3 | [Thiết kế kỹ thuật dự kiến](03-THIET-KE-DU-LIEU-KIEN-TRUC-API.md) | Chọn kiến trúc, dữ liệu, giao dịch, quyền, API và realtime |
| 4 | [Kế hoạch xây dựng](04-KE-HOACH-XAY-DUNG-UTECOFFE.md) | Theo dõi màn hình, backlog, phụ thuộc, lịch, rủi ro và triển khai |
| 5 | [Kiểm thử và nghiệm thu](05-KIEM-THU-NGHIEM-THU-VAN-HANH.md) | Đối chiếu ca kiểm thử, dữ liệu mẫu, demo và điều kiện bàn giao |
| 6 | [Nhật ký rà soát và bổ sung](06-RA-SOAT-BO-SUNG-VA-QUYET-DINH.md) | Xem điểm thiếu đã sửa, phạm vi tác động và các quyết định còn mở |
| 7 | [Đối chiếu đề bài](07-DOI-CHIEU-DE-BAI-VA-PHAM-VI.md) | 12 yêu cầu tối thiểu và bằng chứng phải bàn giao |
| 8 | [Đặc tả luồng chi tiết](08-DAC-TA-LUONG-NGHIEP-VU-CHI-TIET.md) | 28 luồng có tác nhân, đầu vào, bước, ngoại lệ và nghiệm thu |
| 9 | [Hợp đồng dữ liệu/lệnh/vận hành](09-HOP-DONG-DU-LIEU-LENH-VA-VAN-HANH.md) | Validation, quyền, trạng thái, API, jobs và định nghĩa hoàn thành |
| 10 | [Truy vết từng chức năng](10-MA-TRAN-TRUY-VET-CHUC-NANG.md) | Nối128 F với luồng, dữ liệu/màn hình, WBS và test dự kiến |
| Đọc nhanh | [Bản HTML tổng hợp](UTECOFFE-HO-SO-KE-HOACH.html) | Mở bằng trình duyệt, tìm nội dung, dùng mục lục và in |

Tài liệu Markdown là bản gốc để chỉnh sửa. HTML là bản đọc tổng hợp tại thời điểm xuất. Khi nội dung mâu thuẫn: quyết định mới được ghi trong nhật ký thay đổi → nghiệp vụ → kỹ thuật → lịch; không tự sửa quy tắc nghiệp vụ để khớp giao diện đang làm.

## 3. Cách hiểu mức độ ưu tiên

| Mức | Ý nghĩa | Điều kiện |
|---|---|---|
| P0 | Lõi đồ án cần chạy trọn vẹn | Mua đồ uống, xử lý tại cơ sở, đúng tiền–nguyên liệu–quyền; thể hiện đủ công nghệ đề tài |
| P1 | Bản đồ án đầy đủ và chuẩn bị thí điểm | Giao hàng nội bộ, khuyến mãi, tích điểm, vận hành kho, báo cáo và hỗ trợ sâu hơn |
| P2 | Mở rộng kinh doanh sau đồ án | Kết nối đối tác thật, nhiều tiến trình/máy chủ, POS ngoại tuyến, nhượng quyền, tối ưu nâng cao |

P0 không đồng nghĩa với sẵn sàng mở bán. P1 cũng không tự bảo đảm vận hành thực tế; còn phải nghiệm thu bảo mật, phục hồi, chính sách và đối tác. Một tính năng giao dịch đã đưa vào phải có xử lý lỗi và chống lặp ngay trong mức đó.

## 4. Hành trình chuẩn dùng xuyên suốt

Khách chọn cơ sở → chọn nhận tại quầy hoặc giao trong vùng phục vụ → xem menu của cơ sở → tùy chỉnh size, nóng/lạnh, đường, đá và topping hợp lệ → xác nhận giá → đặt đơn → thanh toán theo phương thức cho phép → cơ sở nhận đơn → quầy pha chế cập nhật tiến độ → khách nhận đồ → hóa đơn/biên nhận, đánh giá, điểm thưởng hoặc khiếu nại được theo dõi.

**Một đơn thuộc một cơ sở.** Đổi cơ sở trong giỏ phải kiểm tra lại giá, nguyên liệu, lựa chọn và phí. Sau khi đặt không tự chuyển cơ sở. Đồ uống đã pha không được hủy rồi tự cộng lại nguyên liệu như hàng chưa sử dụng.

## 5. Giả định còn cần xác nhận khi bắt đầu triển khai

1. Hạn nộp và số giờ thực tế chưa được cung cấp. Bản1.2 dùng30–35 giờ/tuần, **24 tuần và2–4 tuần dự phòng**. WBS gồm95–139 ngày công6 giờ (570–834 giờ); phải ước lượng lại sau spike và hành trình đầu.
2. Dữ liệu demo dùng ba cơ sở hư cấu và công thức giả định; chưa đại diện cho định lượng, giá vốn hay chính sách thật của doanh nghiệp.
3. Nhận tại quầy là luồng P0; giao hàng nội bộ là P1. Thanh toán trực tuyến P0 dùng sandbox và bộ giả lập có thể tái hiện lỗi; kích hoạt tiền thật là P2.
4. Khách xem menu không cần tài khoản; đặt hàng trực tuyến P0 cần tài khoản đã xác minh. Bán tại quầy được tạo khách vãng lai. Guest checkout trực tuyến là P2 để tránh mở rộng xác minh và tra cứu riêng quá sớm.
5. Không tự đặt ngày ra mắt khi chưa có hạn nộp, nhân lực vận hành, menu và đối tác.

## 6. Quản lý thay đổi

Mỗi thay đổi ghi ngày, người quyết định, lý do, các mã nghiệp vụ bị ảnh hưởng, tác động đến dữ liệu/API/test và số ngày phát sinh. Ví dụ: cho phép giao liên cơ sở sẽ ảnh hưởng BR-01, đơn hàng, phân quyền, tồn, phí và đối soát; không coi đó là một ô chọn giao diện đơn giản.

| Ngày | Quyết định | Căn cứ |
|---|---|---|
| 17/11/2026 | Lập hồ sơ cho UTECoffe, không chỉnh dự án cũ | Yêu cầu người dùng |
| 17/11/2026 | Lập tiến độ một người, có thể chia module cho nhóm | Người dùng xác nhận |
| 17/11/2026 | Chọn PostgreSQL | Người dùng giao quyền cân nhắc; lý do tại tài liệu kỹ thuật |
| 17/11/2026 | Chỉ phân tích và lập kế hoạch | Phạm vi người dùng yêu cầu |
| 17/11/2026 | Rà soát bản 1.1: 32 quy tắc,120 chức năng,108 ca kiểm thử dự kiến | Bổ sung thiếu sót và chỉnh các điểm chưa nhất quán; xem tài liệu 06 |
| 17/11/2026 | Điều chỉnh lịch từ 18 lên 20 tuần, giữ dự phòng 2–4 tuần | Thêm đặc tả combo/bánh, partial order, dữ liệu và kiểm thử |

## 7. Cách dùng bản rà soát

Đọc tài liệu 06 để nắm thay đổi, sau đó dùng **02** làm nguồn quy tắc chính, **03** cho thiết kế, **04** cho công việc và **05** cho kết quả cần đạt. Không cần tự ghép quy tắc từ nhật ký vào tài liệu cũ: các sửa đổi đã được đưa trực tiếp vào các tài liệu chính và HTML đã được xuất lại cùng phiên bản. 158 chức năng gồm 90 P0, 62 P1, 6 P2; 152 chức năng P0/P1 là phạm vi bản đầy đủ. Có 65 quy tắc nghiệp vụ (BR-01 đến BR-65), 41 Use Cases (UC-01 đến UC-41), 191 ca kiểm thử định danh (TC-001 đến TC-191), 12 Fixtures đối soát số học (FX-01 đến FX-12) và 33 gói công việc WBS (W01 đến W33). Test ứng dụng chưa được chạy; kiểm tài liệu/HTML chỉ chứng minh bộ hồ sơ nhất quán.

## 8. Bổ sung lần hai — bản 1.2

Đề tài được xác nhận là mức tối thiểu, cần bổ sung nghiệp vụ. Tài liệu07 tách12 tiêu chí đề và16 điểm rà soát mới;08 mô tả28 luồng;09 chốt hợp đồng trước code;10 truy vết từng chức năng. Nội dung mới gồm khách vãng lai/hậu mãi, favorites, trả nhà cung cấp, giao lại/custody, checklist/incident, phiên/emailchange, giới hạn giữ hàng và import có xem trước.

Baseline kỹ thuật hiện hành: Java21, **Spring Boot4.1.x, JSP/JSTL, SiteMesh3.3.x, Bootstrap5.3.x, JPA theo BOM, PostgreSQL17.x, JWT, WebSocket và Cloudinary**. Bản đề xuất Boot3.5 ở1.1 đã được thay thế sau khi kiểm vòng hỗ trợ; xem nguồn ở03/07. Khóa patch bằng ADR và spike, chưa có tổ hợp dependency chạy thực tế trong bộ hồ sơ này.

Lịch hiện hành24 tuần+2–4 dự phòng thay lịch20 tuần cũ. Các số của1.1 trong nhật ký06 là lịch sử. Hướng đọc để bắt đầu:07 →08 →09 →10, rồi dùng02/03/04/05 làm tài liệu quy tắc, kiến trúc, backlog và nghiệm thu. Chỉ bổ sung tài liệu, chưa viết phần mềm.

## 9. Bổ sung lần ba — bản 1.3: Nghiệp vụ và kịch bản biên F&B thực tế

Rà soát toàn diện hồ sơ trước khi bước vào giai đoạn code, phát hiện và chuẩn hóa 6 nhóm kịch bản biên vận hành F&B chuỗi:
1. **In ấn POS & Phần cứng**: Bất đồng bộ thanh toán và in, Spooler retry 3 lần, phân định KOT vs Bill, kiểm soát in lại hóa đơn (Bill Reprint) có Watermark BẢN SAO và PIN Quản lý (BR-41..44, F-129..133).
2. **Quản lý Bàn (Dine-in)**: FSM 6 trạng thái thời gian thực, chuyển bàn nguyên tử cập nhật KDS Barista, gộp bàn hợp nhất hóa đơn, tách hóa đơn Dutch Treat, giải phóng bàn đặt trước No-show và tịch thu cọc vào TK 711 (BR-45..49, F-134..138).
3. **Quản lý Ca & Ca đêm**: Chuẩn hóa `businessDate` cho ca đêm 22:00-06:00, chốt sổ kép Midnight Snapshot cuối tháng, kiểm tiền mù cuối ca (Blind Cash Count) và 3 ngưỡng dung sai, rút tiền giữa ca nộp két an toàn (Cash Drop), đóng ca khẩn cấp khi mất điện (BR-50..54, F-139..144).
4. **Khuyến mãi & Loyalty**: Voucher Sinh Nhật KYC khóa 30 ngày và đối chiếu CCCD tại quầy, Ma trận xếp chồng ưu đãi 4 cấp bậc, Floor Price bảo vệ giá vốn 80%, khóa giữ voucher TTL 15 phút qua nửa đêm, tích điểm Net chi tiêu và hoàn trả ưu đãi khi hủy đơn (BR-55..58, F-145..148).
5. **Sự cố Kho & Hỏng lạnh**: Cảm biến nhiệt độ IoT tủ mát $> 8^\circ	ext{C}$ quá 120 phút tự động cách ly lô QUARANTINED, khóa bán tự động menu OUT_OF_STOCK, phiếu xuất hủy khẩn cấp bắt buộc 2 ảnh camera hiện trường, duyệt đa cấp 3 hạn mức, định khoản chi phí khác TK 811 tách biệt Giá vốn COGS TK 632 (BR-59..61, F-149..152).
6. **Vận hành Quầy khác**: Hủy món theo 3 giai đoạn pha chế, tái phân bổ ly nước đã pha sẵn (Reassign Cup), Void đảo giao dịch trong 10 phút, phân loại nhập kho hàng đóng gói vs tiêu hủy đồ tươi, POS Ngoại tuyến (Offline Mode) lưu SQLite ký số HMAC SHA-256 đồng bộ ưu tiên đơn quầy, Sổ cái thanh toán kết hợp nhiều hình thức (Split Payment) và hoàn tiền an toàn khi dở dang (BR-62..65, F-153..158).

Tài liệu báo cáo tóm tắt riêng biệt: `Bao_Cao_Tong_Hop_Ra_Soat_Va_Giai_Phap_FB.md` và `.docx`.
