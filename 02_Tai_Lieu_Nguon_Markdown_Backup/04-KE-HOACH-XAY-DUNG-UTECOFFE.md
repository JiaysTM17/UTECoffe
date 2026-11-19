# 04. Kế hoạch xây dựng UTECoffe từ phân tích đến bàn giao

**Phiên bản 1.2 — 18/11/2026. Nguyên tắc:** lập kế hoạch theo một người thực hiện, dù đề tài đăng ký theo nhóm. Chưa biết hạn nộp; lịch dưới đây là tuần tương đối, không phải cam kết ngày hoàn thành. Tất cả bước “tạo”, “code”, “test”, “deploy” trong tài liệu là công việc tương lai.

## 1. Phương án tiến độ và phạm vi cam kết

Ước lượng bản1.2: **24 tuần × 30–35 giờ tập trung/tuần**, cộng **2–4 tuần dự phòng**. Ngân sách cơ sở720–840 giờ; nếu15 giờ/tuần thì48–56 tuần trước dự phòng. So với lịch20 tuần của bản1.1, tăng thời gian cho spike stack hiện hành, đặc tả/kiểm thử,8 chức năng bổ sung và xử lý vận hành. Đây là ước lượng, chưa phải lịch cam kết với giảng viên. P0/P1 đều được giữ trong kế hoạch; nếu deadline khác phải chốt giảm phạm vi minh bạch.

| Mốc | Nội dung | Định nghĩa xong |
|---|---|---|
| G0 — cuối tuần 3 | Thiết kế và spike công nghệ | ERD lõi, state machine, WAR/JSP/SiteMesh/JWT/WS/DB/media kiểm chứng |
| G1 — cuối tuần 6 | Menu và nguyên liệu | Hai cơ sở bán khác nhau; tùy chỉnh và availability đúng |
| G2 — cuối tuần 9 | Hành trình mua–pha–nhận | Đơn, tiền, giữ/tiêu hao, queue realtime, bàn giao, hủy chạy xuyên suốt |
| G3 — cuối tuần 12 | Lõi P0 đủ nghiệm thu | Có hậu mãi/partial, báo cáo, audit, job, 128 chức năng phân scope, test P0 và restore |
| G4 — cuối tuần 20 | Hoàn thiện P1 | Voucher/điểm, kho/recall, giao/tại chỗ, combo/bánh, tiền, nội dung, MFA/privacy |
| G5 — cuối tuần 24 | Bàn giao đồ án | Staging, báo cáo, video/demo, kết quả test và giới hạn được ghi rõ |
| G6 — sau dự phòng | Quyết định thí điểm | Chỉ khi đạt điều kiện vận hành, không chỉ có demo đẹp |

Nếu hạn nộp ngắn hơn, dùng G3 làm phạm vi thương lượng chính thức: giữ đủ stack, nghiệp vụ giao dịch và xử lý lỗi; cắt P1/P2 rõ ràng trong báo cáo. Không cắt chống trùng, phân quyền, kiểm tồn hoặc khả năng khôi phục để đổi lấy nhiều màn hình CRUD.

## 2. Cấu trúc sản phẩm và bản đồ màn hình

### 2.1 Khách hàng

| Mã màn | Nội dung | Hành động chính | Trạng thái bắt buộc |
|---|---|---|---|
| UI-C01 Trang chủ | Nhận diện, nhóm trà/cà phê, cơ sở đang chọn | Chọn cơ sở, xem menu | Chưa chọn cơ sở, cơ sở đóng |
| UI-C02 Cơ sở | Danh sách, tìm kiếm, giờ, khoảng cách ước lượng | Chọn điểm nhận | Từ chối GPS, không có kết quả |
| UI-C03 Menu | Danh mục, tìm, giá, món đang bán | Mở món | Loading, hết món, lỗi tải |
| UI-C04 Chi tiết/tùy chỉnh | Ảnh, thành phần, size, đường/đá, topping, giá | Thêm vào giỏ | Tùy chọn cấm, topping hết, giá đổi |
| UI-C05 Giỏ | Nhóm cấu hình ly, sửa, tổng tạm | Tính quote, đổi cơ sở | Món ngừng, giỏ rỗng, xung đột phiên bản |
| UI-C06 Checkout | Cơ sở, mode, liên hệ, ETA, phương thức, tổng | Xác nhận đặt | Quote hết hạn, thiếu nguyên liệu, cần đăng nhập |
| UI-C07 Thanh toán | Attempt và hướng dẫn rõ | Mở sandbox/kiểm trạng thái | Pending, fail, timeout, paid trễ |
| UI-C08 Theo dõi đơn | Timeline, cấu hình, tiền, mã nhận | Hủy khi được phép, hỗ trợ | Mất WS, đơn review, đã bàn giao |
| UI-C09 Tài khoản | Đăng ký/nhập/xác minh/reset/profile | Quản lý phiên | Token hết hạn, mật khẩu sai, rate limit |
| UI-C10 Lịch sử | Danh sách và lọc | Xem, P1 đặt lại | Rỗng, trang lỗi, không còn món cũ |
| UI-C11 Phản hồi | Dòng mua, lý do, ảnh và tiến độ | Gửi, bổ sung | Ảnh không hợp lệ, thiếu quyền, đã xử lý |
| UI-C12 Thành viên | Số dư, lịch sử điểm, voucher | Đổi điểm | Điểm chờ/hết hạn/cần bù |
| UI-C13 Địa chỉ/giao | Địa chỉ, vùng, phí | Chọn xác nhận P1 | Ngoài vùng, địa chỉ chưa đủ |
| UI-C14 Tin/FAQ/chính sách | Nội dung dễ tìm | Liên hệ hỗ trợ | Link hết hạn, nội dung chưa công bố |
| UI-C15 Dữ liệu cá nhân | Yêu cầu tải/xóa, trạng thái xác minh | Gửi/nhận kết quả P1 | Đang hold, link hết hạn, không đủ quyền |

### 2.2 Nhân viên và cơ sở

| Mã màn | Nội dung | Hành động | Kiểm soát |
|---|---|---|---|
| UI-S01 Quầy bán | Menu, giỏ nhanh, khách vãng lai/thành viên | Tạo đơn, thu tiền | Cùng pricing/tồn với website |
| UI-S02 Đơn mới | Kênh, tuổi đơn, SLA nhận | Nhận/từ chối | Cơ sở và trạng thái đúng |
| UI-S03 Bảng pha | Phiếu theo cột, tùy chỉnh nổi bật | Claim/start/ready | Version, không thao tác hai lần |
| UI-S04 Bàn giao | Mã nhận, tiền thiếu, đơn ready | Thu/giao | Không mở đơn khác bằng mã đoán |
| UI-S05 Ngoại lệ | Thiếu lô, no-show, làm sai | Đề nghị xử lý | Lý do/duyệt và liên kết phiếu |
| UI-S06 Tồn/lô | Vật lý, giữ, khả dụng, hạn | Nhập/hủy cơ bản | Có chứng từ, không sửa số dư trực tiếp |
| UI-S07 Kho mở rộng | Mua, chuyển, kiểm kê | Duyệt/nhận/đối chiếu | Hai phía điều chuyển |
| UI-S08 Ca/quỹ | Tiền đầu, phát sinh, kỳ vọng, đếm | Mở/đóng/nộp | Chênh lệch có người duyệt |
| UI-S09 Giao nội bộ | Chuyến và trạng thái | Nhận/giao/thất bại/nộp COD | Chỉ chuyến của mình |
| UI-S10 Dashboard cơ sở | Doanh số, chờ pha, lỗi, hao hụt | Drill-down | Không hiển thị số ước tính như đã thu |
| UI-S11 Xử lý một phần đơn | Units cần giao/hủy, tổng gốc/hiệu lực, thu/hoàn | Preview quyết định và chuyển duyệt | Version, hạn mức, không tự lấy đơn vị đã giao thành chưa giao |

### 2.3 Quản trị chuỗi

| Mã màn | Nội dung | Hành động |
|---|---|---|
| UI-A01 Tổng quan | Theo cơ sở/kỳ, tiền và hàng | Lọc và truy nguyên |
| UI-A02 Cơ sở/lịch/capacity | Cấu hình vận hành | Bật/tạm dừng, giờ ngoại lệ |
| UI-A03 Menu/options/giá | Danh mục và version giá | Soạn, xem trước, xuất bản |
| UI-A04 Công thức | Nguyên liệu và định lượng | Draft, duyệt, hiệu lực |
| UI-A05 Nhân viên/quyền | Role và membership | Cấp/thu hồi, xem audit |
| UI-A06 Khuyến mãi/điểm | Rule, phạm vi, ngân sách | Preview điều kiện, xuất bản |
| UI-A07 Hỗ trợ/refund | Hồ sơ, chứng cứ, hạn mức | Phân công, duyệt, theo dõi |
| UI-A08 Đối soát | Bảng kê, chênh, khoản thừa | Match, xử lý, khóa kỳ |
| UI-A09 Nội dung/media | Banner, tin, chính sách, ảnh | Lịch xuất bản, ẩn, quản lý asset |
| UI-A10 Vận hành hệ thống | Audit, job lỗi, cảnh báo | Retry có quyền, tra requestId |
| UI-A11 Combo/bánh/bao bì | Slots, giá phân bổ, SKU lô, mode | Kiểm trước xuất bản và quản lý version |
| UI-A12 An toàn tài khoản/dữ liệu | MFA, recovery, retention/hold, approval limits | Kiểm quyền và audit, chặn tự nâng quyền |

## 3. Định hướng giao diện

UTECoffe dùng phong cách quán trà/cà phê hiện đại: nền kem, chữ nâu espresso, điểm nhấn xanh trà hoặc cam đất; ảnh đồ uống lớn vừa đủ, giá và cơ sở dễ thấy. Bộ màu chỉ là định hướng thiết kế, phải kiểm tương phản trước chốt. Không dùng màu làm dấu hiệu trạng thái duy nhất.

Mobile: giữ cơ sở/phương thức nhận dễ truy cập; bộ tùy chọn dạng trang hoặc sheet có tóm tắt giá; nút thêm giỏ và tổng tiền không che trường nhập; checkout ít bước nhưng không giấu phụ phí. Desktop quầy: bảng pha chữ lớn, nhóm tùy chỉnh rõ, tuổi phiếu và deadline dễ đọc, âm báo tùy chọn có thể tắt. Admin ưu tiên bảng lọc, chi tiết và audit thay vì dashboard trang trí.

Bootstrap giúp có component và layout, nhưng không tự bảo đảm trợ năng; cần markup, focus, label, tương phản và kiểm bằng bàn phím. [Bootstrap accessibility](https://getbootstrap.com/docs/5.3/getting-started/accessibility/).

**Checklist thiết kế trước code từng màn:** happy path; rỗng; đang tải; lỗi mạng; dữ liệu hết hạn; không đủ quyền; màn hình hẹp; lỗi field; yêu cầu gửi lại; trạng thái đang xử lý. Thông báo phải chỉ rõ cách khắc phục, ví dụ “Trân châu tại cơ sở này vừa hết. Bỏ topping hoặc chọn món khác để tính lại đơn.”

## 4. Backlog theo gói công việc

Đơn vị dưới đây là **ngày công tập trung quy ước 6 giờ**, bao gồm thiết kế/test cục bộ của gói. W14/W20 là kiểm tích hợp và hồi quy, W13 chỉ tính phần hạ tầng chung để không tính trùng công việc trong mọi module. Sau hai tuần đầu, đo tốc độ thực tế rồi ước lượng lại phần còn lại.

| WBS | Gói | Phụ thuộc | Mức | Ước lượng | Đầu ra bắt buộc |
|---|---|---|---|---|---|
| W01 | Chốt glossary, phạm vi, BR, prototype giấy | Không | P0 | 3–4 ngày | Luồng, màn hình chính, danh sách quyết định |
| W02 | ERD lõi, state machine, hợp đồng API | W01 | P0 | 3–4 | Model đủ cho đơn–tiền–kho và lỗi |
| W03 | Spike Boot4/WAR/JSP/include, môi trường, CI nền | W01 | P0 | 4–6 | Đủ stack chạy ngoài IDE |
| W04 | Identity, cookie JWT, CSRF, scope | W02,W03 | P0 | 4–6 | Auth/refresh/reset/role HTTP+WS |
| W05 | Cơ sở, lịch và capacity | W04 | P0 | 2–3 | Chặn đơn ngoài giờ/tải |
| W06 | Menu, options, giá, media | W04,W05 | P0 | 4–6 | Menu theo cơ sở, upload kiểm quyền |
| W07 | Recipe, lô, balance, movement | W02,W06 | P0 | 5–7 | Khả dụng và lô/hạn đúng |
| W08 | Giỏ, quote, snapshot, đổi cơ sở | W06,W07 | P0 | 3–4 | Tổng server và báo thay đổi |
| W09 | Đặt đơn/reservation/idempotency | W08 | P0 | 4–6 | Concurrent last ingredient test |
| W10 | Payment fake/sandbox, callback, inquiry | W09 | P0 | 4–5 | Lặp/trễ/timeout không sai tiền |
| W11 | Quầy, ticket, queue WS, pickup | W09,W10 | P0 | 4–6 | Mua–pha–nhận trọn vẹn |
| W12 | Hủy, expiry, refund/remake cơ bản | W10,W11 | P0 | 4–6 | Không restock nguyên liệu đã dùng |
| W13 | Audit, outbox, job/monitor cơ bản | W03 đến W12 | P0 | 3–4 phân bổ | Mỗi gói có audit/retry; không đợi cuối mới ghép |
| W14 | P0 hardening, report, restore, UAT | W04–W13,W23,W26 | P0 | 4–5 | Gate G3 và danh sách lỗi |
| W15 | Voucher và loyalty ledger | W12,W14 | P1 | 4–6 | Fixture phân bổ/hoàn điểm đúng |
| W16 | Procurement/transfer/count/batch | W07,W14 | P1 | 4–6 | Chứng từ hai phía và xử lý chênh |
| W17 | Giao nội bộ và COD | W11,W12,W14 | P1 | 3–5 | Giao lỗi, nộp COD theo dõi được |
| W18 | Ca, reconciliation, reports | W10,W16,W17 | P1 | 4–6 | Tổng/chi tiết khớp, khóa kỳ |
| W19 | Nội dung, review, thông báo/hỗ trợ nâng cao | W12,W15 | P1 | 2–4 | Quyền, kiểm duyệt, SLA |
| W20 | Security/load/UI/UAT toàn bộ | W15–W19,W24,W25,W27 | P0/P1 | 6–8 | Chặn lỗi tiền/quyền/tồn trước giao |
| W21 | Staging, runbook, backup drill | W14,W20 | P0/P1 | 3–5 | Phục hồi được, release có quay lui |
| W22 | Báo cáo, demo, bàn giao | W21 | P0/P1 | 3–4 | Bộ bằng chứng và danh sách hạn chế |
| W23 | Giỏ nhiều tab, partial units, deadlines, claim/recovery, hạn mức | W08–W12 | P0 | 3–4 | F-105–109,113,114,119,120; đưa vào từng module và chốt tuần 11 |
| W24 | Bánh/combos/tại chỗ và phân bổ | W06,W07,W15 | P1 | 3–5 | F-110,111,118; không còn scope chỉ ghi tên |
| W25 | MFA, privacy/retention, review quyền vận hành | W04,W12,W19 | P1 | 2–4 | F-116,117; UI-A12/C15, test recovery/hold |
| W26 | Hậu mãi khách vãng lai, hạn giữ theo tài khoản, capacity/ETA consent và auth SSR chi tiết | W04,W09,W11,W12 | P0 | 3–4 | F-121,127, mở rộng F-013/109; UC-01/07/09/10; chốt tuần11 |
| W27 | Favorites/session, supplier returns, delivery custody, checklist và import có preview | W15–W19,W24,W25 | P1 | 4–6 | F-122–126,128; có UC, data/API và test; chốt tuần20 |
| W28 | Quản lý thiết bị in ấn POS, hàng đợi Spooler và in lại chống gian lận | W11,W13 | P0/P1 | 4–5 | Module in POS độc lập, driver ESC/POS, Spooler retry, mẫu in tem ly, bill reprint có PIN |
| W29 | Quản lý sơ đồ bàn, FSM vòng đời bàn, chuyển/gộp/tách bàn và đặt cọc | W05,W11 | P1 | 5–7 | Màn hình sơ đồ bàn, FSM 6 trạng thái, chuyển/gộp bàn, split bill Dutch Treat, đặt cọc ân hạn 15m |
| W30 | Vận hành ca làm việc xuyên ngày, quản lý tiền két và đóng ca khẩn cấp | W10,W18 | P0/P1 | 4–6 | businessDate ca đêm 22:00-06:00, Midnight Snapshot, kiểm tiền mù, Cash Drop, Emergency close |
| W31 | Khuyến mãi nâng cao, Voucher Sinh Nhật KYC, ma trận xếp chồng 4 cấp | W08,W15 | P0/P1 | 4–5 | Voucher Sinh Nhật KYC 30 ngày, Stacking Engine 4 cấp, Floor Price 80%, Voucher lock TTL 15m |
| W32 | Giám sát nhiệt độ kho lạnh, cách ly lô, khóa menu và xuất hủy nguyên liệu | W07,W16 | P0/P1 | 4–6 | Sensor nhiệt độ > 8°C cảnh báo, lô QUARANTINED, khóa menu OUT_OF_STOCK, xuất hủy 2 ảnh, TK 811 |
| W33 | Tối ưu vận hành quầy F&B, Void/Refund, POS Offline và Split Payment | W11,W12,W17 | P0/P1 | 6–8 | Hủy pha chế, Reassign Cup, Void 10m, POS Offline SQLite ký số HMAC SHA-256, Split tender payment |

Đường phụ thuộc dài nhất: W01 → W02/W03 → W04 → W06/W07 → W08 → W09 → W10/W11 → W12/W23 → W14 → P1 gồm W24/W25 → W20 → W21 → W22. W16 nhận thêm trace thu hồi lô F-112; W15 nhận vòng đời điểm/voucher F-115. Việc tìm ảnh, làm banner hoặc viết blog không được làm chậm chuỗi này.

**Đối chiếu tải công việc:**27 gói cộng95–139 ngày công6 giờ, tức570–834 giờ. Ngân sách24 tuần ở30–35 giờ/tuần là720–840 giờ. Nếu mọi gói chạm cận trên và chỉ đạt30 giờ/tuần, cần27,8 tuần: dùng gần hết4 tuần dự phòng. Chưa tính phát sinh lớn ngoài scope; sau spike và hành trình đầu phải ước lượng lại. Không cộng thêm20% test lần nữa vào WBS vì gói đã gồm test cục bộ, W14/W20 là tích hợp/hồi quy.

## 5. Lịch 24 tuần của bản 1.2

| Tuần | Công việc chính | Đầu ra kiểm tra được |
|---|---|---|
| 1 | Đọc đề, RQ/F/UC, glossary, prototype mobile/quầy, ERD nháp | W01; danh sách quyết định, một đơn một cơ sở |
| 2 | ERD/state/API, bootstrap spike Boot4/JSP/JSTL/SiteMesh/WAR | W02/W03; dependencies và risk register |
| 3 | Hoàn spike packaged, JWT SSR/WS/JPA/Cloudinary, CI nền | G0; TC-109–114 trên artifact, chưa làm hàng loạt CRUD nếu fail |
| 4 | Identity/refresh/reset, branch membership, lịch/kênh | W04/W05; quyền HTTP/WS và test owner/branch |
| 5 | Catalog/options/giá/media, publish readiness, mobile | W06; form errors và menu từng cơ sở |
| 6 | Recipe/lots/nhập cơ bản/availability/capacity | W07, G1; nguyên liệu dùng chung và FEFO |
| 7 | Cart/merge/quote, create order atomic/guard/idempotency | W08/W09/W23/W26; race nguyên liệu/capacity/quote |
| 8 | Cash receipt, fake/sandbox payment, callback/inquiry | W10; pending/late/duplicate không sai tiền |
| 9 | Quầy/queue/claim/start/ready/pickup/WS reconnect | W11, G2; mua–pha–nhận trọn vẹn |
| 10 | Hủy/partial/remake/refund, guest support và ảnh riêng | W12/W23/W26; FX-06, không restock nguyên liệu đã pha |
| 11 | Deadline/ETA consent, anti-hold cap, audit/outbox/recovery | W13/W23/W26; TC-118/120–122, lệnh mất mạng an toàn |
| 12 | P0 integration/UAT/report/restore | W14, G3; đủ stack và test P0 theo scope |
| 13 | Voucher/quota/budget/allocation, điểm/expiry/redemption | W15; FX-01/02 và race quota/points |
| 14 | PO/receiving/transfer/count/batch/recall | W16; cutoff kiểm kê, source lots và variance |
| 15 | Delivery/attempt/custody/retry/COD | W17 và phần W27; POD không bị xóa khi thiếu COD |
| 16 | Ca/statement/reconciliation/locked period/reports | W18; FX-04, refund ngày sau và dashboard khớp |
| 17 | Bánh/combo/tại chỗ, picking/packaging | W24; FX-07, không bỏ sót thành phần |
| 18 | CMS/review/SLA/notification, favorites/mua lại | W19 và phần W27; moderation/consent và menu stale |
| 19 | MFA/privacy/hold/session/emailchange, supplier returns | W25 và phần W27; quyền tiền/dữ liệu và credit refs |
| 20 | Checklist/incident/handover, import preview/version; tích hợp P1 | W27, G4; toàn122 F thuộc P0/P1 có bằng chứng theo test |
| 21 | Security/IDOR/CSRF/WS/concurrency/load | W20; báo cáo lỗi có mức và actual result |
| 22 | Hồi quy/UI mobile/accessibility, khắc phục lỗi chặn | W20;148 mã/subcase theo scope, không gắn PASS cho P2 chưa làm |
| 23 | Staging/TLS/artifact/migrations/backup restore/runbook | W21; diễn tập và rollback tương thích |
| 24 | UAT, báo cáo/slide/video, demo lặp và bàn giao | W22, G5; rubric/RQ/F/test/bằng chứng nối được |
| 25–28 nếu cần | Sửa lỗi UAT, chờ xác minh đối tác, chuẩn hóa pilot | G6 chỉ khi tiêu chí vận hành đạt; không tự thêm P2 |

Mỗi tuần dành khoảng20% thời gian cho kiểm thử/tài liệu/lỗi trong ngân sách gói. W27 là gói chốt P1 mở rộng; phần thiết kế favorites/returns/custody phải làm cùng module liên quan từ tuần14–19, không đợi tuần20 mới phát hiện cần đổi schema. Các công việc hạ tầng audit/job đi xuyên suốt W03–W12.

## 6. Mười ngày đầu: đầu việc cụ thể trước khi code lớn

| Ngày | Việc | Tệp/bằng chứng cần tạo khi triển khai | Kết quả đủ |
|---|---|---|---|
| 1 | Đọc bộ hồ sơ; chốt P0, vai trò, thuật ngữ | Scope + decision log | Mỗi vai trò biết quyền/phạm vi |
| 2 | Vẽ journey pickup, quầy, lỗi/hủy | Activity/sequence nháp | Xác định ai làm gì khi lỗi |
| 3 | Wireframe C02/C04/C06/C08/S03 | Prototype màn hình | Không cần nhìn code để hiểu ly và tổng |
| 4 | ERD order/recipe/inventory/payment | ERD + data dictionary | PK/FK/check và bất biến rõ |
| 5 | Trạng thái và API lõi | State table + API contract | Có callback trễ, expiry và đua hủy/pha |
| 6 | Khóa ma trận phiên bản; spike WAR/JSP/SiteMesh | ADR-02 + kết quả build | Chạy artifact ngoài IDE |
| 7 | Spike JWT cookie/CSRF và quyền | ADR-03 + security checklist | SSR/fetch đều xác thực đúng |
| 8 | Spike WS và private media | ADR-06/07 | User A không subscribe/xem chứng cứ B |
| 9 | Chuẩn hóa migration/test/CI/env | Hướng dẫn máy mới + CI tối thiểu | DB sạch dựng lại được |
| 10 | Dữ liệu hai cơ sở, một món tùy chọn | Demo đọc PostgreSQL → JPA → JSP | Lát cắt đủ tầng, ghi lại tồn tại cần sửa |

Đây là checklist cho giai đoạn bắt đầu thực hiện sau khi bạn chuyển sang viết code; phiên lập hồ sơ hiện tại không khởi tạo những thành phần ứng dụng này.

## 7. Cách tổ chức công việc nếu làm một mình hoặc có nhóm

Một người luân phiên vai trò BA → thiết kế → dev → tester, nhưng không trộn trong một commit khó kiểm. Mỗi task có mô tả đầu vào, BR/F liên quan, màn hình/API/dữ liệu, tiêu chí test và ảnh/video kết quả. Branch ngắn theo tính năng; thay đổi schema đi kèm migration và cập nhật data dictionary.

Nếu có thêm người: người 1 chịu identity/order/payment; người 2 menu/inventory; người 3 JSP/Bootstrap/UX/WS client; người 4 QA, báo cáo và vận hành. Đây là cách phân trách nhiệm đề xuất, không giả định đã có bốn thành viên. API/DTO và ownership bảng phải thống nhất trước; không để hai người viết hai service tính giá riêng.

**Definition of Ready:** quy tắc đã chốt, state transition hợp lệ, dữ liệu đầu vào/ngoại lệ rõ, phụ thuộc sẵn sàng, tiêu chí nghiệm thu đo được. **Definition of Done:** chức năng chạy trên artifact, quyền backend đúng, test phù hợp đạt, lỗi hiển thị có hướng xử lý, migration/tài liệu/audit đầy đủ, không secret/PII trong log. “Có màn hình” không đủ để đóng task.

## 8. Thứ tự học bổ sung

1. Java/HTTP/MVC/JSP/JSTL và SQL quan hệ: hiểu request, response, view model, FK/transaction.
2. Spring Boot/Security/Data JPA: validation, service transaction, fetch và locking.
3. JWT cookie/CSRF/refresh và phân quyền theo dữ liệu; áp ngay vào hai cơ sở.
4. State machine, idempotency, reservation và monetary allocation; làm test nhỏ có số cụ thể.
5. STOMP/outbox/retry, Cloudinary access, integration adapters.
6. Migration, staging TLS, backup restore, quan sát lỗi và báo cáo.

Không học hết microservices, Kubernetes hoặc AI recommendation trước khi có đơn đầu tiên chạy đúng. Những công nghệ đó không phải điều kiện đạt đề tài này.

## 9. Kiểm soát rủi ro

| Rủi ro | Dấu hiệu sớm | Cách giảm/đường lui |
|---|---|---|
| Stack JSP/SiteMesh lệch phiên bản | Chạy IDE được, WAR lỗi hoặc API bị decorate | Spike tuần 2; khóa phiên bản, đọc migration guide |
| Scope vượt một người | G2 chậm trên một tuần, WIP quá nhiều | Dừng P2, ưu tiên G3, giảm P1 công bố rõ |
| Tồn sai do đồng thời | Hai đơn đều giữ được lượng cuối | Test DB thật, chuẩn lock order, rollback atomic |
| Công thức giả làm món hiển thị sai | Đổi size không đổi nguyên liệu/phụ thu | Fixture recipe theo cấu hình, duyệt định lượng |
| Thanh toán lặp/trễ | Redirect được coi paid, timeout tạo attempt mới tùy tiện | Inbox/idempotency/inquiry và refund nghĩa vụ |
| Quyền chỉ nằm ở UI | Gọi thẳng endpoint đọc được cơ sở khác | Access matrix và test IDOR HTTP/WS |
| Realtime mất trạng thái | Refresh mới thấy đúng, event đảo thứ tự | Snapshot/version/outbox, cảnh báo disconnected |
| Phụ thuộc đối tác chưa có account | Cuối kỳ vẫn chờ duyệt tích hợp | Fake từ đầu, sandbox khi có, nêu rõ giới hạn demo |
| Không có hạn nộp cụ thể | Lịch cứ trượt theo học kỳ | Cập nhật khi có deadline, cắt scope có chủ đích |
| Một người bị gián đoạn | Kiến thức chỉ nằm trong đầu | README máy mới, ADR, data fixture, checklist resume |
| Hình ảnh/dữ liệu không hợp lệ | Dùng logo/ảnh thương hiệu làm tài sản sản phẩm | Dữ liệu hư cấu, ảnh tự có hoặc được cấp quyền |

## 10. Ngân sách và tài nguyên cần chuẩn bị

Không đưa giá dịch vụ giả định thành báo giá thực tế. Khi chuẩn bị triển khai, lấy giá hiện hành cho: domain, máy chạy Java, PostgreSQL managed hoặc máy riêng, Cloudinary dung lượng/băng thông, email/SMS, cổng tiền, bản đồ, log và backup. Ghi giới hạn miễn phí và cơ chế vượt quota riêng; không coi free tier là cam kết lâu dài.

Dev đề xuất máy đủ chạy IDE + Java + PostgreSQL/container và trình duyệt; 16GB RAM là mức lập kế hoạch thuận tiện, không phải yêu cầu tối thiểu đã benchmark. CI cần runner build WAR và chạy DB test. Staging ban đầu một instance app và một PostgreSQL, dung lượng/quy mô phải ghi cùng kết quả load test. Mạng/demo offline cần fixture và fake adapter để trình bày khi Internet lỗi; không phát triển POS offline thật trong P0.

## 11. Kế hoạch phát hành và vận hành

### 11.1 Trước staging

Tách dev/staging credentials; build một artifact có version/commit; migration được chạy trên DB trống và DB từ bản trước; seed demo không chứa PII thật; kiểm WAR, UTF-8, timezone, HTTPS cookie và WebSocket qua reverse proxy. Không để trình quản trị DB/Actuator nhạy cảm public.

### 11.2 Trước mỗi release

Chốt changelog và schema impact → backup → rehearsal migration staging → smoke/UAT → phát hành vào cửa sổ phù hợp → kiểm đơn/queue/payment job → theo dõi. Migration phá vỡ tương thích phải chia bước mở rộng–chuyển dữ liệu–thu gọn; rollback app không tự rollback DB. Có phương án tạm dừng nhận đơn mới trong khi vẫn xem/xử lý đơn cũ.

### 11.3 Sau phát hành

Theo dõi đơn quá hạn nhận/pha, outbox pending lâu, callback lỗi, refund pending, nguyên liệu âm hoặc balance lệch, ca lệch, ảnh upload lỗi, lỗi HTTP và p95. Phân công người trực dù chỉ có một người: thời gian kiểm tra, kênh báo lỗi, cách dừng bán, quyền truy cập backup.

### 11.4 Điều kiện từ đồ án sang thực tế

Thêm xác nhận chính sách kinh doanh; kiểm các nghĩa vụ thương mại điện tử, dữ liệu cá nhân, thuế/hóa đơn và thông tin sản phẩm theo quy định hiện hành với người phụ trách phù hợp; xác nhận hợp đồng thanh toán/giao; thử tiền thật với quy mô được cho phép; diễn tập sự cố; có người hỗ trợ. Đây là danh sách công việc cần xác minh lúc mở bán, không phải kết luận pháp lý của hồ sơ này.

P2 mở rộng theo nhu cầu đo được: broker cho nhiều app instance, DB backup/PITR và dự phòng nâng cao, đối tác giao, hóa đơn điện tử, loyalty hạng, POS offline, phân quyền nhượng quyền, forecasting. Mỗi mục cần một ADR và bộ test, không chỉ bật thêm máy chủ.

## 12. Hồ sơ bàn giao cuối đồ án

| Nhóm | Đầu ra |
|---|---|
| Phân tích | Bài toán, khảo sát nguồn, actor/use case, BR, scope, traceability |
| Thiết kế | Wireframe/prototype, ERD, state/sequence, ADR, API, access matrix |
| Ứng dụng tương lai | Repository, Maven build, WAR, migrations, fixture và env example không secret |
| Chất lượng | Test report, lỗi đã sửa/còn lại, load config/result, security cases |
| Vận hành | Hướng dẫn máy mới, deploy/rollback, backup/restore, job/reconciliation runbook |
| Trình bày | Báo cáo môn học, slide, video dự phòng, tài khoản demo và kịch bản |

Trong bộ hồ sơ hiện tại, mới bàn giao phần **phân tích và kế hoạch**. Những đầu ra ứng dụng, test runtime và deployment sẽ được tạo khi bắt đầu giai đoạn lập trình.

## 13. Kiểm soát kế hoạch sau lần rà soát

Ba mốc cần ước lượng lại: cuối tuần 3 sau spike; cuối tuần 7 sau transaction giữ; cuối tuần 12 sau G3. Ghi số giờ thực tế từng WBS, số lỗi phải làm lại, kiến thức còn thiếu và khả năng sẵn có của đối tác. WBS là khoảng ước lượng có bất định; nếu tổng giờ dự báo vượt720–840 giờ thì tăng lịch hoặc chốt giảm P1 với giảng viên, không âm thầm bỏ ca sai tiền/quyền/tồn.

| Hạn chế thực tế | Phạm vi cần bảo vệ | Phần có thể lùi khi được chốt lại |
|---|---|---|
| Không đủ thời gian sau G3 | Đặt–pha–nhận, partial/refund, quyền, chống lặp, đủ stack | Combo, giao nội bộ, CMS nâng cao hoặc procurement P1 |
| Không có tài khoản sandbox đúng hạn | Adapter interface + fake contract tests, nêu giới hạn | Demo đối tác thật; không gọi fake là sandbox nhà cung cấp |
| Không có ngân sách hạ tầng thực tế | Artifact local/staging và restore thử | HA, broker nhiều node, tiền thật |
| Có thành viên nhóm tham gia | Hợp đồng API/ownership entity và test tích hợp | Chia W24/W25/UI cho người khác, không mặc định lịch rút theo tỷ lệ số người |

Chưa có việc cắt phạm vi nào được thực hiện trong bản 1.2: mọi P0/P1 vẫn có WBS, tuần và test tương ứng. Bảng trên là phương án quyết định nếu deadline thực tế khác giả định.

## 14. Màn hình và đầu ra bổ sung của bản 1.2

| Màn hình bổ sung | Actor | Nội dung bắt buộc và gói |
|---|---|---|
| Tài khoản/phiên/email và yêu thích | Khách | Danh sách phiên, revoke, email pending, favorite unavailable; W27 |
| Hậu mãi khách tại quầy | Thu ngân/CSKH | Tìm đơn theo quyền, bằng chứng xác minh, tạo case behalf-of; W26 |
| Đơn chờ và đề nghị ETA | Khách/nhân viên | Giới hạn hold, đơn đang chờ, old/new ETA, countdown server, accept/reject; W26 |
| Trả nhà cung cấp | Kho/quản lý | Lot/receipt, reserved impact, quarantine, approve/dispatch/credit; W27 |
| Delivery attempts/custody | Điều phối/driver | Attempt timeline, người giữ hàng/tiền, POD và collection exception; W17/W27 |
| Checklist/bàn giao/incident | Quản lý/thu ngân | Việc chưa xong, owner/deadline, acknowledge; W27 |
| Import preview | Catalog/inventory admin | Lỗi theo dòng, diff/version, confirm atomic và report; W27 |
| Sơ đồ bàn & quản lý bàn trực quan | Thu ngân/Phục vụ | Sơ đồ tầng, trạng thái bàn, đổi/gộp/tách bàn; W29 |
| Cấu hình máy in POS & hàng đợi Spooler | Quản lý/Thu ngân | Danh mục thiết bị, test in, Spooler retry, in lại bill có PIN; W28 |
| Quản lý ca đêm & Kiểm tiền mù | Thu ngân/Quản lý | Mở ca đêm, businessDate, bảng kê đếm tiền mù, Cash Drop; W30 |
| Giám sát kho lạnh & Xuất hủy nguyên liệu | Quản lý kho/Quản lý cơ sở | Nhiệt độ tủ mát, lô QUARANTINED, phiếu hủy kèm 2 ảnh camera; W32 |
| POS Ngoại tuyến & Thanh toán kết hợp | Thu ngân/Khách hàng | Giao diện offline SQLite HMAC, Split payment đa nguồn, sync FIFO; W33 |

W01/W02 dùng tài liệu07–10 để chuẩn bị trước code. Mỗi module cần UI loading/empty/error/conflict cùng happy path. Không tăng phạm vi chỉ vì bổ sung màn hình kỹ thuật nếu không phục vụ một F/UC cụ thể.
