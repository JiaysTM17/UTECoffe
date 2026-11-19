# 07. Đối chiếu đề bài, phạm vi và bằng chứng phải bàn giao

**Phiên bản 1.2 — 18/11/2026.** Đề bài là mức tối thiểu; các nghiệp vụ P0/P1 là phạm vi đề xuất bổ sung. Tài liệu này chứng minh yêu cầu đã có chỗ trong thiết kế, chưa chứng minh phần mềm đã chạy. Chưa có rubric chấm điểm khác được cung cấp.

## 1. Đề bài làm căn cứ

Nội dung người dùng cung cấp: “Website chuỗi bán trà và cafe UTECoffe bằng Spring Boot + JSP/JSTL + SiteMesh + Bootstrap + JPA + SQL Server/MySQL/PostgreSQL + JWT + WebSocket + Cloudinary”. Tên Cloudairy ở bản gốc được hiểu là Cloudinary. Ba hệ quản trị là các phương án lựa chọn; chọn PostgreSQL, không xây ba bản ứng dụng.

Người dùng xác nhận cần bổ sung nhiều nghiệp vụ hơn đề; định hướng một người phát triển, có thể chia nhóm sau. Vì vậy bản kế hoạch bao gồm bán trực tuyến, tại quầy, điều phối pha chế, nguyên liệu, giao nhận, hậu mãi, khách hàng thân thiết, tài chính quản trị và vận hành chuỗi. Chưa xác nhận hạn nộp, ngân sách hay nhà cung cấp thanh toán thật.

## 2. Ma trận yêu cầu tối thiểu của đề

| Mã | Yêu cầu | Thiết kế cụ thể | Công việc và kiểm chứng dự kiến | Bằng chứng phải có khi bàn giao |
|---|---|---|---|---|
| RQ-01 | Website bán trà và cà phê | Menu, size, đường, đá, topping, công thức, giá theo cơ sở; mua–pha–nhận–hậu mãi | W06–W12; TC-001–040; luồng UC-04–13 | Video giao dịch hoàn chỉnh, snapshot đơn và nguyên liệu, kết quả test |
| RQ-02 | Mô hình chuỗi | Brand dùng chung; Branch sở hữu giờ, kênh, tồn, capacity, nhân sự và báo cáo; một đơn một cơ sở | W05,W07,W16–18; TC-001–003,013–024,053–055 | Hai cơ sở có dữ liệu khác nhau; nhân viên A gọi trực tiếp tài nguyên B bị từ chối |
| RQ-03 | Spring Boot | MVC/controller/service/repository chia module, cấu hình môi trường, WAR, lifecycle và health | W03; TC-109 | Maven Wrapper build sạch, WAR chạy ngoài IDE, manifest phiên bản |
| RQ-04 | JSP | View dưới WEB-INF, ViewModel rõ, không scriptlet và không truy vấn DB ở view | W03,W06,W11; TC-110 | Màn hình menu/queue/chi tiết đơn render bằng JSP, URL view trực tiếp bị chặn |
| RQ-05 | JSTL | Vòng lặp menu/dòng đơn, điều kiện trạng thái, escape nội dung và định dạng hiển thị | W03,W06; TC-110 | Mẫu dữ liệu tiếng Việt, ký tự đặc biệt và dữ liệu rỗng hiển thị đúng; không thực thi script |
| RQ-06 | Decorator SiteMesh | Layout khách, nhân viên, quản trị; ghép title/head/body một lần; loại JSON/media/ws/assets | W03; TC-109,111 | Ba layout hoạt động, trang lỗi phù hợp, API JSON không bị bọc HTML |
| RQ-07 | Bootstrap | Grid, form, navigation, modal và trạng thái trên mobile/desktop; hỗ trợ bàn phím | W06,W11,W20; TC-112 | Ảnh/video ở 390px và desktop, lỗi form đọc được, focus không mắc kẹt |
| RQ-08 | JPA | Entity/repository, transaction service, version, query phân trang; không gửi entity ra client | W02,W07,W09; TC-113 và các test tồn đồng thời | Dữ liệu lưu lại sau restart, rollback nguyên khối, kiểm query trên PostgreSQL |
| RQ-09 | Một hệ quản trị đã chọn | PostgreSQL 17.x, migration có phiên bản, FK/check/unique, khóa tồn và backup | W03,W07,W21; TC-013–024,069,107,113,148 | Dựng DB trống, migrate, seed, backup/restore; không dùng H2 thay test khóa |
| RQ-10 | JWT | Access token được xác minh ở server, refresh có thu hồi, cookie/CSRF, membership theo cơ sở | W04,W25; TC-053–060,080,114–117 | Login/logout/refresh/reset, access hết hạn và quyền thay đổi được kiểm chứng |
| RQ-11 | WebSocket | STOMP báo queue/đơn thay đổi sau commit; quyền CONNECT/SUBSCRIBE/SEND và reconnect snapshot | W11,W13; TC-046–048,055–058,117,147 | Hai trình duyệt nhận cập nhật đúng cơ sở; mất nối/thu hồi phiên không lộ dữ liệu |
| RQ-12 | Cloudinary | Upload menu công khai và bằng chứng riêng; backend giữ secret, quản lý asset theo purpose | W06,W12; TC-061–062,068,100–101,146 | Upload thử trên tài khoản dev, quyền đọc/xóa và dọn orphan; không chỉ lưu URL tự nhập |

Các mã test cũ được nhóm theo miền; mã mới 109–148 trong tài liệu 05 tách riêng các tiêu chí công nghệ để không đánh đồng “trang web chạy” với “đủ stack”. Đánh giá PASS chỉ sau khi có artifact, môi trường và actual result, không căn cứ riêng bảng này.

## 3. Những gì bổ sung vượt tên đề

| Mức | Phạm vi | Lý do và giới hạn |
|---|---|---|
| P0 | Tài khoản, quyền chi nhánh, menu/cấu hình, giỏ/quote, tiền tại quầy và adapter fake/sandbox, kho nguyên liệu, queue, pickup, hủy/hoàn/làm lại, hỗ trợ khách vãng lai, chống lạm dụng giữ hàng | Tạo hành trình hoạt động nhất quán; an toàn tiền, tồn và quyền phải làm ngay |
| P1 | Voucher/điểm, giao nội bộ/COD, tại chỗ, bánh/combo, mua/nhận/trả/chuyển/kiểm kho, ca, đối soát, CMS/review, yêu thích, import có xem trước, MFA/privacy | Phần mở rộng đã nhận vào kế hoạch; chưa được âm thầm bỏ nếu thiếu thời gian |
| P2 | Đặt lịch phức tạp, giao đối tác thật, hạng thành viên/giới thiệu, chat nâng cao, nhiều instance; guest checkout trực tuyến, hóa đơn điện tử/tích hợp kế toán theo dự án riêng | Có đường mở rộng nhưng không tính là đã thiết kế xong hoặc đã có trong bản đồ án |

128 chức năng gồm **74 P0, 48 P1, 6 P2** được định danh trong tài liệu 02 và truy vết từng dòng tại tài liệu 10. Các ý tưởng P2 khác ở đoạn mô tả không tự trở thành chức năng cam kết. Bản nghiệm thu đầy đủ hiện tại là 122 chức năng P0/P1; mỗi thay đổi phạm vi phải cập nhật cả test, WBS và mốc giao.

## 4. Kết quả rà soát lần hai và cách đóng khoảng trống

| Mã | Khoảng trống hoặc rủi ro tìm thấy | Bổ sung có thể kiểm tra |
|---|---|---|
| RV2-01 | Baseline Boot 3.5 không còn phù hợp cho dự án mới cần OSS support | Chuyển baseline Boot 4.1.x, SiteMesh 3.3.x, Tomcat 11; spike WAR/JSP/include trước code lớn |
| RV2-02 | Đủ tên stack nhưng thiếu bằng chứng riêng từng công nghệ | RQ-03–12, TC-109–117, checklist G0 |
| RV2-03 | Tên chức năng chưa nói đủ các bước và ngoại lệ | 28 luồng UC-01–28 trong tài liệu 08 |
| RV2-04 | Khách vãng lai có hóa đơn nhưng thiếu đường hậu mãi | BR-33, F-121, UC-09, TC-118 |
| RV2-05 | Chưa mô tả trả nhà cung cấp và tín dụng tham chiếu | BR-34, F-123, UC-16, TC-125–127 |
| RV2-06 | Giao lại dễ mất lịch sử hoặc chuyển trách nhiệm COD | BR-35, F-124, UC-14, TC-131–133 |
| RV2-07 | Đóng ca bị nhầm là kết thúc mọi đơn | BR-36, F-125, UC-22, TC-123–124 |
| RV2-08 | Chưa có yêu thích/cấu hình món lưu lại | BR-37, F-122, UC-06, TC-119 |
| RV2-09 | Thiếu đổi email an toàn và tự thu hồi phiên | BR-38, F-126, UC-01, TC-116–117 |
| RV2-10 | Giữ nguyên liệu/capacity có thể bị nhiều đơn chờ chiếm hết | BR-38, F-127, UC-07, TC-120 |
| RV2-11 | Import cần preview, ràng buộc version, chống nhập lặp | BR-39, F-128, UC-25, TC-140–141 |
| RV2-12 | Capacity và đổi ETA còn khó suy ra thuật toán | BR-40, UC-07/10, TC-121–122 |
| RV2-13 | JWT cookie trong SSR thiếu nhánh access hết hạn | Tài liệu 09 mục 4; TC-114 |
| RV2-14 | Một nhãn payment không biểu diễn được vừa hoàn vừa thu dư | Tách payment coverage và refund progress, TC-143 |
| RV2-15 | Phiên bản DTO, lệnh, job, quyền và cutoff kiểm kê cần cụ thể | Tài liệu 09, TC-130,145–148 |
| RV2-16 | Backlog và test chưa truy từng F; lịch cũ không đủ phản ánh bổ sung | Tài liệu 10, W26–27; 148 test; lịch 24 tuần + 2–4 dự phòng |

## 5. Kiểm chứng nền trước khi phát triển tính năng

Spring thông báo 3.5.16 là bản OSS cuối của dòng 3.5; vì vậy chọn dòng 4.1 cho kế hoạch mới. [Thông báo Spring](https://spring.io/blog/2026/06/25/spring-boot-3-5-16-available-now/). Boot 4.1 dùng Spring Framework 7 và Tomcat 11; Java 21 đáp ứng mức Java tối thiểu được công bố. Chốt patch và BOM tại ngày code, ghi dependency tree trong ADR. [System requirements](https://docs.spring.io/spring-boot/system-requirements.html).

JSP cần WAR trên stack dự kiến. Ma trận SiteMesh ghép 3.3.x với Boot 4/Tomcat 11; hướng dẫn nêu `alwaysInclude=true` cho JSP ViewResolver. Kiểm độc lập bước include của Spring và decorator dispatch; không coi cấu hình khuyến nghị là đã chạy thành công. [Spring Boot JSP](https://docs.spring.io/spring-boot/reference/web/servlet.html) · [Hướng dẫn SiteMesh](https://github.com/sitemesh/sitemesh3/blob/master/JAKARTA_UPGRADE.md).

Spike phải có một trang dữ liệu thật qua JPA, JSTL, layout SiteMesh và Bootstrap; login JWT rồi mở lại trang khi access hết hạn; một sự kiện STOMP sau commit; một ảnh Cloudinary public và một ảnh riêng qua proxy. Build artifact từ máy/CI sạch rồi chạy ngoài IDE. Nếu fail, sửa tổ hợp dependency/config và ADR; không đổi sang Thymeleaf/React để bỏ yêu cầu JSP.

## 6. Quyết định còn cần chủ dự án hoặc vận hành chốt

Không cần dừng việc lập kế hoạch. Các giá trị demo đã đủ để viết và test; trước áp dụng thật phải có người chịu trách nhiệm xác nhận:

| Nhóm | Quyết định | Hạn chót đề xuất | Khi chưa có quyết định |
|---|---|---|---|
| Môn học | Deadline, định dạng báo cáo, bắt buộc sandbox hay fake được chấp nhận | Trước W01 kết thúc | Giữ hai nhãn bằng chứng riêng, không tự tuyên bố đạt toàn bộ rubric |
| Kinh doanh | Menu, recipe, giá, capacity và SLA từng cơ sở | Trước seed nghiệm thu W06–07 | Dùng dữ liệu giả có nhãn; không dùng thời hạn demo như tiêu chuẩn an toàn thực phẩm |
| Tiền | Chính sách hủy/hoàn, hạn mức duyệt, ca/COD, phí giao | Trước W10/W17 | Không bật thu tiền thật |
| Nhà cung cấp | Tài khoản Cloudinary/dev, thông số VNPAY sandbox, TLS/callback | Trước test adapter | Fake giữ hợp đồng nhưng không thay bằng chứng dịch vụ thật |
| Pháp lý/vận hành | Thuế/hóa đơn, bảo vệ dữ liệu, thời hạn lưu, chứng từ, quy trình thực phẩm | Trước pilot thực tế | Là yêu cầu cần thẩm định riêng; tài liệu này không xác nhận tuân thủ pháp luật |
| Nhân sự | Ai trực sự cố, duyệt hoàn, xử lý khiếu nại và restore | Trước G5 | Chỉ demo học thuật, chưa mở phục vụ khách thật |

## 7. Quy tắc đóng một yêu cầu

Một RQ/F chỉ chuyển “đã nghiệm thu” khi có: thiết kế tham chiếu; implementation commit; test đúng dữ liệu; actual result; bằng chứng UI/API/DB phù hợp; lỗi còn mở và người duyệt. Nếu đối tác chưa cấp môi trường, trạng thái là “chưa kiểm chứng tích hợp”, không đổi thành PASS vì fake chạy. Bản hiện tại mọi RQ đều ở trạng thái **đã lập kế hoạch, chờ triển khai/kiểm thử**.

Đọc tiếp [đặc tả 28 luồng](08-DAC-TA-LUONG-NGHIEP-VU-CHI-TIET.md), [hợp đồng triển khai](09-HOP-DONG-DU-LIEU-LENH-VA-VAN-HANH.md) và [truy vết chức năng](10-MA-TRAN-TRUY-VET-CHUC-NANG.md). Độ đầy đủ được đánh giá theo phạm vi đã biết và tình huống kiểm thử; vẫn phải cập nhật khi chạy UAT hoặc phát sinh yêu cầu thật.
