# 05. Kế hoạch kiểm thử, nghiệm thu và vận hành UTECoffe

**Phiên bản 1.2 — 148 ca kiểm thử dự kiến. Đây là đặc tả kiểm thử tương lai.** Chưa có ứng dụng được xây trong phiên lập hồ sơ này, vì vậy các ca dưới đây chưa được chạy. Khi thực hiện, thêm build/commit, môi trường, dữ liệu, actual result, trạng thái, người kiểm và bằng chứng cho từng ca. Các kiểm tra tính nhất quán tài liệu không thay thế việc chạy những ca ứng dụng này.

## 1. Chiến lược kiểm thử

| Lớp | Kiểm điều gì | Công cụ dự kiến |
|---|---|---|
| Unit/domain | Công thức, giá, phân bổ, state transition, điểm | JUnit, clock cố định |
| Repository/integration | FK/check, transaction, lock, concurrency, outbox | PostgreSQL qua Testcontainers; không thay bằng H2 cho test khóa |
| Security/API | Auth, CSRF, ownership, branch scope, idempotency | Spring test và client HTTP |
| Adapter contract | Callback hợp lệ/sai, timeout, duplicate, inquiry | Fake provider có fixture và sandbox |
| WebSocket | CONNECT/SUBSCRIBE/SEND, expiry, reconnect | STOMP test client + browser |
| UI/E2E | Chọn ly, checkout, pha, nhận, phản hồi | Trình duyệt tự động và kiểm tay trên mobile |
| Vận hành | Build WAR, migrations, restart, backup/restore | Staging và runbook ghi bằng chứng |

Không chỉ kiểm happy path. Test ưu tiên những lỗi có thể làm sai tiền, sai tồn, giao nhầm hoặc đọc dữ liệu người khác. Sau mỗi thay đổi chạy bộ liên quan; trước gate chạy hồi quy xuyên luồng. Mocks dùng cho bên ngoài, không dùng mock để tuyên bố khóa PostgreSQL đã đúng.

## 2. Bộ dữ liệu mẫu có chủ đích

Tất cả tên, tài khoản, địa chỉ và giá là dữ liệu hư cấu. Không dùng thông tin khách thật trong demo/CI.

| Nhóm | Dữ liệu |
|---|---|
| Cơ sở A | UTECoffe Cơ sở A, mở 07:00–22:00, cutoff pickup 21:30, capacity thử 10 đơn vị/5 phút |
| Cơ sở B | UTECoffe Cơ sở B, giá một món khác A, hết trân châu, nhân viên riêng |
| Cơ sở C | Tạm đóng, có một đơn cũ chưa xử lý để kiểm đóng không xóa lịch sử |
| Khách | khach1, khach2, một tài khoản khóa, một tài khoản chưa xác minh |
| Nhân viên | Thu ngân A, barista A, quản lý A, quản lý B, admin chuỗi, CSKH/tài chính |
| Món 1 | Trà sữa ô long M lạnh 40.000đ; topping trân châu 5.000đ/phần |
| Món 2 | Cà phê sữa 35.000đ; tùy chọn nóng/lạnh theo cấu hình riêng |
| Món 3 | Trà trái cây, không cho sữa/topping không tương thích |
| Công thức test | Mỗi ly trà sữa M dùng 120ml sữa; thêm trân châu dùng 30g; một ly + nắp |
| Lô | Một lô hết hạn; một lô gần hạn; một lô hợp lệ; một lô cách ly |
| Tồn tranh chấp | Chỉ còn 120ml sữa khả dụng cho hai người cùng mua một ly cần 120ml |
| Giá đổi | Giá mới hiệu lực giữa lúc quote và xác nhận |
| Voucher | Giảm 20.000đ đơn món đủ điều kiện từ 100.000đ, còn một lượt toàn chương trình |
| Điểm | Tài khoản có điểm còn hạn, sắp hết và điểm đã dùng từ đơn sắp hoàn |
| Payment fixtures | Success, fail, duplicate, sai chữ ký, sai tiền, callback trễ, timeout UNKNOWN |

Không lấy công thức test làm hướng dẫn pha thực phẩm. Định lượng, hạn và thành phần thực phải do cơ sở duyệt.

## 3. Fixture số học bắt buộc

### FX-01 — Phân bổ giảm và hoàn từng ly

Mua 2 ly trà sữa M có trân châu: 2 × (40.000 + 5.000) = 90.000đ. Thêm 1 cà phê 35.000đ. Tiền món trước giảm 125.000đ. Voucher cấp đơn giảm 20.000đ; pickup không phí.

| Dòng | Trước giảm | Phân bổ giảm | Thực trả | Hoàn tối đa cho một ly |
|---|---:|---:|---:|---:|
| 2 trà sữa + trân châu | 90.000 | 14.400 | 75.600 | 37.800 |
| 1 cà phê | 35.000 | 5.600 | 29.400 | 29.400 |
| Tổng | 125.000 | 20.000 | 105.000 | Theo lượng được duyệt |

Hoàn một ly trà sữa: 37.800đ, giá trị món còn lại 67.200đ. Với quy tắc 10.000đ/điểm: ban đầu 10 điểm, sau hoàn còn xứng đáng 6 điểm, đảo 4 điểm. Hoàn tiếp ly trà sữa thứ hai: còn 29.400đ, xứng đáng 2 điểm, đảo thêm 4. Hoàn cà phê: còn 0, đảo 2. Tổng đảo đúng 10, không làm tròn từng refund một cách độc lập. Nếu đã đổi điểm, ghi khoản cần bù theo BR-18.

### FX-02 — Chia số đồng dư

Ba dòng đủ điều kiện có gross 10.001đ, 10.001đ, 9.998đ, tổng 30.000đ; giảm 1.000đ. Phần tỷ trọng lần lượt 333,366…; 333,366…; 333,266…đ. Làm tròn xuống được 333/333/333, còn 1đ. Gán 1đ cho dòng đầu trong hai dòng đồng phần lẻ theo ID ổn định: giảm 334/333/333, tổng 1.000. Nếu dòng có nhiều ly và cần hoàn một ly, tiếp tục phân bổ xuống từng ly cùng thuật toán và lưu kết quả, không chia rồi bỏ phần dư.

### FX-03 — Nguyên liệu

Ban đầu sữa physical=240ml, reserved=0, available=240. Đơn A giữ120 → physical240, reserved120, available120. Đơn B giữ120 → physical240, reserved240, available0. A bắt đầu → physical120, reserved120, available0. B hủy trước pha → physical120, reserved0, available120. A bị sai phải làm lại → giữ rồi tiêu hao thêm 120, physical0. Hủy/hoàn tiền A không cộng lại sữa. Mỗi bước có source và movement/reservation history.

### FX-04 — Ca tiền mặt

Đầu ca500.000 + bán tiền mặt350.000 − hoàn mặt50.000 − chi30.000 − nộp quỹ400.000 = tiền kỳ vọng370.000đ. Đếm365.000đ → thiếu5.000đ. Giao dịch online200.000đ không được cộng vào ngăn kéo tiền mặt. Chênh lệch cần hồ sơ, không sửa doanh số350.000 thành345.000 để che lệch.

### FX-05 — Chuyển kho thiếu

Cơ sở A xuất1.000g trà; B chưa nhận thì tồn khả dụng B chưa tăng. B nhận950g;50g vào chênh lệch đang xử lý. Khi xác nhận hư/mất, ghi hao hụt hàng đang chuyển50g, đóng lượng in-transit; không trừ A thêm50g vì A đã xuất đủ1.000g. Chứng từ hai cơ sở và chênh lệch phải cùng truy về transferId.

### FX-06 — Hủy một phần trước thu và sau thu

Khi chạy P0 chưa có voucher, dùng đơn fixture hai unit giá 37.800đ và một unit 29.400đ, tổng 105.000đ. Khi chạy P1, dùng giá/voucher FX-01 để tạo đúng các giá trị thực trả đó; kết quả cần so sánh giống nhau. Không để ca P0 phụ thuộc một module P1 chưa được xây.

Dùng đơn FX-01, G=105.000đ. Hủy một ly trà sữa, C=37.800đ, E=67.200đ. Trường hợp trả quầy chưa thu: R=H=0, khách chỉ còn trả 67.200đ. Thu ngân nhận 100.000đ, trả 32.800đ; receipt=67.200đ, không phải100.000đ. Sau khi phần còn lại đã giao, order COMPLETED/PARTIAL; unit bị hủy vẫn có snapshot và quyết định.

Trường hợp đã thu đủ: R=105.000đ, H=0; thừa 37.800đ và có refund pending. Refund tạm thất bại không làm E trở lại 105.000đ; tiếp tục xử lý khoản 37.800đ phải hoàn. Khi thành công H=37.800đ, thu ròng=67.200đ, không còn thừa/thiếu. Nếu trước khi thu mà hủy toàn bộ, E=0, R=H=0, không tạo receipt 0đ hay PAID giả; thể hiện đã đóng nghĩa vụ không qua thanh toán.

### FX-07 — Combo và hoàn một thành phần

Giá lẻ tham chiếu trà40.000đ + bánh25.000đ =65.000đ; combo55.000đ. Phân bổ giá combo theo tỷ trọng và đồng dư: trà33.846đ, bánh21.154đ. Khi bánh lỗi do chuỗi và được hoàn, tối đa21.154đ cho unit bánh; phần trà còn33.846đ, không truy thu6.154đ để đưa trà về giá lẻ. Nếu combo có voucher thêm, tiếp tục phân bổ theo rule đã cho phép và lưu từng lớp giảm; không lấy giá lẻ25.000đ làm số hoàn bánh.

### FX-08 — Một công thức lấy từ nhiều lô

Một ly cần 120 ml sữa. Lô A đủ hạn còn 60 ml, lô B đủ hạn còn 60 ml, safetyStock=0. Reservation có hai allocation 60 ml. Start ticket tạo hai movement consume tương ứng lô, tổng120ml; retry không tạo thêm. Constraint chỉ unique theo ticket+component mà thiếu allocation sẽ chặn nhầm movement thứ hai, vì vậy phải kiểm đúng khóa thiết kế. Khi bỏ ly đã pha, FINISHED_WASTE tham chiếu hai consume đó, không giảm thêm120ml.

### FX-09 — Đối soát chênh lệch tiền két ca làm việc (Cash Drawer Variance)
Ca làm việc có tiền đầu ca float $Starting = 1.000.000	ext{đ}$, tổng thu tiền mặt $3.850.000	ext{đ}$, hoàn hủy đơn $150.000	ext{đ}$, chi mua đá khẩn cấp $50.000	ext{đ}$, rút tiền nộp két an toàn (Cash Drop) $3.000.000	ext{đ}$. Số tiền kỳ vọng trong két:
$$ExpectedCash = 1.000.000 + 3.850.000 - 150.000 - 50.000 - 3.000.000 = 1.650.000	ext{ VND}$$
Ba kịch bản dung sai kiểm toán:
1. *Cấp 1 ($|\Delta| \le 20	ext{k}$)*: Thực đếm $1.642.000	ext{đ}$ (lệch $-8.000	ext{đ}$) $ightarrow$ Tự động hạch toán Nợ TK 642 / Có TK 1111: $8.000	ext{đ}$. Đóng ca bình thường.
2. *Cấp 2 ($20	ext{k} - 100	ext{k}$)*: Thực đếm $1.600.000	ext{đ}$ (lệch $-50.000	ext{đ}$) $ightarrow$ Đếm lại lần 2 + giải trình lý do + PIN Quản lý ca duyệt đóng ca.
3. *Cấp 3 ($> 100	ext{k}$)*: Thực đếm $1.400.000	ext{đ}$ (lệch $-250.000	ext{đ}$) $ightarrow$ Khóa đóng ca thường. Xuất Biên bản kiểm quỹ bất thường: Nợ TK 1388 / Có TK 1111: $250.000	ext{đ}$, trừ lương thu ngân.

### FX-10 — Đối soát tổn thất xuất hủy kho do sự cố nhiệt độ
Sự cố hỏng lốc tủ mát gây biến chất các lô nguyên liệu:
- Lô Sữa tươi Barista Milk (`LOT-MILK-01`): $32.000	ext{đ}$ x 25 hộp $= 800.000	ext{đ}$.
- Lô Kem béo Rich's (`LOT-CREAM-02`): $65.000	ext{đ}$ x 8 hộp $= 520.000	ext{đ}$.
- Lô Sốt Phô mai (`LOT-CHEESE-03`): $45.000	ext{đ}$ x 6 hũ $= 270.000	ext{đ}$.
Tổng giá trị tổn thất: $800.000 + 520.000 + 270.000 = 1.590.000	ext{ VND}$. Store Manager ký duyệt phiếu xuất hủy kèm 2 ảnh hiện trường.
Bút toán tài chính: Nợ TK 811 (Chi phí khác) / Có TK 152: $1.590.000	ext{đ}$. Giữ nguyên vẹn TK 632 (COGS) để bảo vệ tỷ lệ Food Cost % quầy bar chuẩn xác ở mức 28.5%.

### FX-11 — Đối soát số học Gộp bàn và Tách hóa đơn (Monetary Invariants)
- *Gộp bàn*: Bàn A ($115	ext{k}$ - Voucher $15	ext{k} = 100	ext{k}$) và Bàn B ($135	ext{k}$ + Cọc $50	ext{k}$ - Voucher $20	ext{k} = 65	ext{k}$). Voucher Bàn B hoàn lại ví khách; tổng gốc mới: $115	ext{k} + 135	ext{k} = 250.000	ext{đ}$; voucher Bàn A nâng mức giảm lên $30.000	ext{đ}$; cọc kết chuyển $50.000	ext{đ}$. Cần thu mới: $250.000 - 30.000 - 50.000 = 170.000	ext{ VND}$. Bất biến: $170	ext{k} + 50	ext{k} + 30	ext{k} = 250.000	ext{đ}$.
- *Tách chia đều Dutch Treat*: Hóa đơn $500.000	ext{đ}$ chia 3 người. Thuật toán Largest Remainder: Người 1 trả $166.667	ext{đ}$, Người 2 trả $166.667	ext{đ}$, Người 3 trả $166.666	ext{đ}$. Tổng $= 500.000	ext{ VND}$ chính xác 100% đến từng đồng.

### FX-12 — Đối soát Thanh toán kết hợp Split Payment & Hủy dở dang hoàn tiền
Đơn hàng tiệc sinh nhật $750.000	ext{ VND}$. Khách thanh toán:
1. Điểm thành viên: $50.000	ext{ Điểm} ightarrow$ Balance còn $700.000	ext{đ}$.
2. Quét MoMo: $300.000	ext{đ} ightarrow$ Giao dịch `TXN_MOMO_9942` thành công. Balance còn $400.000	ext{đ}$.
3. Quẹt thẻ: $200.000	ext{đ} ightarrow$ Máy POS ngân hàng báo lỗi "Thẻ bị từ chối".
Khách không còn nguồn tiền khác, thu ngân bấm "Hủy giao dịch dở dang": Hệ thống tự động gọi API MoMo Refund hoàn $300.000	ext{đ}$ về ví MoMo và gọi Loyalty Ledger hoàn $50.000	ext{ Điểm}$ về ví khách. Đơn chuyển `PAYMENT_ABORTED_REFUNDED`. Số quỹ tiền mặt và tài khoản ngân hàng khớp 100%, không bị lệch dòng tiền.

## 4. Danh sách ca kiểm thử

### 4.1 Danh mục, giỏ và quote

| Mã | Mức | Thao tác | Kết quả đạt |
|---|---|---|---|
| TC-001 | P0 | Từ chối GPS rồi tìm cơ sở theo tên | Vẫn chọn/mua được |
| TC-002 | P0 | Chọn cơ sở đóng hoặc quá cutoff | Menu có thể xem, checkout bị từ chối có lý do |
| TC-003 | P0 | Ngày nghỉ ngoại lệ trùng lịch mở thường | Ngoại lệ được ưu tiên |
| TC-004 | P0 | Chọn nóng + đá hoặc topping bị cấm qua HTTP trực tiếp | Server từ chối, không chỉ UI ẩn |
| TC-005 | P0 | Hai ly cùng món nhưng khác đường | Hai cấu hình/nhãn riêng |
| TC-006 | P0 | Hai cấu hình giống nhau, thứ tự option gửi khác nhau | Chuẩn hóa và gộp đúng |
| TC-007 | P0 | Đổi A sang B đang hết topping | Preview nêu khác biệt; chưa xác nhận không đổi giỏ |
| TC-008 | P0 | Sửa giá trên request checkout | Server tính lại, không dùng giá client |
| TC-009 | P0 | Giá thay đổi sau quote | 409/422 theo hợp đồng, quote mới cần xác nhận |
| TC-010 | P0 | Quote hết hạn, cartVersion cũ hoặc quote của người khác | Không tạo đơn bằng quote không hợp lệ |
| TC-011 | P0 | Gửi qty âm, quá giới hạn, note/script dài | Validation/escape, không chạy script |
| TC-012 | P1 | Áp voucher không đủ ngưỡng, sai kênh/cơ sở | Lý do cụ thể, không giữ quota |

### 4.2 Tồn, capacity và đồng thời

| Mã | Mức | Thao tác | Kết quả đạt |
|---|---|---|---|
| TC-013 | P0 | Hai khách cùng đặt lượng sữa cuối | Một thành công, một hết khả dụng; không âm |
| TC-014 | P0 | Hai món khác nhau dùng chung một nguyên liệu | Tổng giữ không vượt balance chung |
| TC-015 | P0 | Một đơn thiếu duy nhất nắp ly | Toàn đơn rollback; không giữ nửa nguyên liệu |
| TC-016 | P0 | Lô gần hạn và lô xa hạn cùng đủ | FEFO đúng, lô hết hạn/cách ly không dùng |
| TC-017 | P0 | Lô hết hạn sau giữ trước pha | Đổi lô hợp lệ hoặc review, không pha lô hết hạn |
| TC-018 | P0 | Sửa recipe sau khi đặt | Đơn dùng snapshot đã xác nhận |
| TC-019 | P0 | Hai request tranh capacity cuối | Một hold được, bên kia nhận ETA/quote mới |
| TC-020 | P0 | Chạy expiry job hai lần và restart giữa chừng | Release một lần, balance khớp |
| TC-021 | P0 | Deadlock/lock timeout giả lập | Rollback an toàn; retry có giới hạn cùng khóa |
| TC-022 | P0 | Hủy đồng thời với bắt đầu pha | Một chuyển trạng thái thắng; không vừa release vừa consume |
| TC-023 | P1 | Transfer nhận thiếu rồi gửi lại request nhận | Không tăng tồn lặp; FX-05 đúng |
| TC-024 | P1 | Kiểm kê giảm dưới lượng đang giữ | Chặn hoặc mở xử lý các đơn bị ảnh hưởng, không phá invariant |

### 4.3 Đơn, tiền và refund

| Mã | Mức | Thao tác | Kết quả đạt |
|---|---|---|---|
| TC-025 | P0 | Double click hoặc retry do mất mạng | Cùng orderId, không thêm hold |
| TC-026 | P0 | Cùng idempotency key nhưng request khác | Conflict, không âm thầm trả nhầm đơn |
| TC-027 | P0 | Callback success lặp nhiều lần | Một receipt và một tác dụng nghiệp vụ |
| TC-028 | P0 | Callback sai chữ ký/tiền/currency/merchant | Không paid; có dấu vết điều tra an toàn |
| TC-029 | P0 | Mở URL return success giả | UI chờ kiểm, không tự đổi paid |
| TC-030 | P0 | Success về sau cancel/expire | Ghi thu và review/hoàn; không tự pha lại |
| TC-031 | P0 | Hai attempts cùng thu thành công | Ghi cả hai tiền thật, khoản thừa chờ hoàn |
| TC-032 | P0 | Payment timeout không rõ đã thu | UNKNOWN/inquiry, không yêu cầu trả lần nữa một cách chắc chắn |
| TC-033 | P0 | Refund gửi xong nhưng mất response | Inquiry/retry cùng key, không hoàn hai lần |
| TC-034 | P0 | Hai nhân viên cùng duyệt hoàn toàn bộ | Một khoản giữ hạn mức, khoản còn lại bị chặn |
| TC-035 | P0 | Hủy trước pha khi đã thu | Release nguyên liệu, refund có trạng thái riêng |
| TC-036 | P0 | Hủy/làm lại sau pha | Không restock nguyên liệu; phiếu remake tiêu hao mới |
| TC-037 | P1 | Hoàn một ly có voucher | FX-01 đúng đến từng đồng |
| TC-038 | P1 | Giá trị giảm có đồng dư | FX-02 không mất hoặc thừa1đ |
| TC-039 | P1 | Callback completed/paid/point được gửi lặp | Cộng điểm một lần |
| TC-040 | P1 | Nhiều refund nhỏ và điểm đã đổi | Đảo đúng tổng điểm, không cản hoàn tiền |

### 4.4 Quầy, giao và realtime

| Mã | Mức | Thao tác | Kết quả đạt |
|---|---|---|---|
| TC-041 | P0 | Hai barista claim cùng phiếu | Một người thành công; người kia thấy phiên bản mới |
| TC-042 | P0 | Bấm start/ready lặp hoặc gọi sai thứ tự | Không consume thêm, state transition bị kiểm |
| TC-043 | P0 | Đơn ba ly mới xong hai ly | Chưa READY cả đơn |
| TC-044 | P0 | Bàn giao bằng mã sai/đã dùng/chưa trả tiền | Từ chối, rate limit; đơn không hoàn tất nhầm |
| TC-045 | P0 | Đơn READY quá thời gian chất lượng | NEEDS_REVIEW, không tự tịch thu tiền hoặc completed |
| TC-046 | P0 | WS disconnect trong lúc đổi trạng thái | Reconnect lấy snapshot đúng, không tạo thao tác mới |
| TC-047 | P0 | Event version cũ đến sau event mới | Không lùi UI/trạng thái |
| TC-048 | P0 | Thu hồi membership khi WS đang mở | Ngắt/revoke nhận sự kiện trong giới hạn thiết kế |
| TC-049 | P1 | Giao ngoài vùng hoặc đổi địa chỉ sau quote | Tính lại/chặn trước thu, không dùng phí cũ |
| TC-050 | P1 | Tài xế giao thất bại và chưa thu COD | Đơn không paid; ly không nhập lại tồn |
| TC-051 | P1 | Tài xế thu rồi chưa nộp | Tiền đang giữ còn trong báo cáo công nợ nội bộ |
| TC-052 | P1 | Import cùng bảng kê hai lần | Không nhân giao dịch, có kết quả đã nhập |

### 4.5 Bảo mật, media và quyền

| Mã | Mức | Thao tác | Kết quả đạt |
|---|---|---|---|
| TC-053 | P0 | Khách1 đổi orderId sang khách2 | Không đọc/hủy/hoàn đơn người khác |
| TC-054 | P0 | Thu ngân A sửa branchId/objectId sang B | Mọi endpoint liên quan từ chối |
| TC-055 | P0 | Subscribe topic B bằng nhân viên A | Từ chối tại server, không gửi PII rồi ẩn |
| TC-056 | P0 | Client SEND giả sự kiện READY/PAID | Không đổi dữ liệu, SEND không cho phép bị chặn |
| TC-057 | P0 | Thiếu CSRF, Origin lạ với cookie | Command/CONNECT bị xử lý đúng chính sách |
| TC-058 | P0 | JWT hết hạn/sai alg/sai iss/aud hoặc đã thu hồi | HTTP/WS không tiếp tục có quyền |
| TC-059 | P0 | Replay refresh đã rotate, reset token đã dùng | Phát hiện/thu hồi family theo thiết kế |
| TC-060 | P0 | Brute-force login/mã pickup | Rate limit không làm lộ thông tin nhạy cảm |
| TC-061 | P0 | Upload file giả MIME/quá lớn/asset người khác | Từ chối; không gắn được vào menu/hồ sơ |
| TC-062 | P0 | Truy cập ảnh khiếu nại khi không có quyền | Không xem bản gốc/biến đổi qua URL công khai |
| TC-063 | P0 | Input XSS/SQL injection qua tìm kiếm/note | Không chạy script/truy vấn ngoài ý muốn |
| TC-064 | P1 | Export vượt scope hoặc ô CSV bắt đầu công thức | Chặn scope và escape nội dung nguy hiểm |

### 4.6 Vận hành, UI và báo cáo

| Mã | Mức | Thao tác | Kết quả đạt |
|---|---|---|---|
| TC-065 | P0 | Build/running WAR ngoài IDE | JSP/JSTL/SiteMesh/UTF-8/API/WS chạy |
| TC-066 | P0 | Restart sau commit trước gửi outbox | Đơn còn, event gửi lại an toàn |
| TC-067 | P0 | DB ngắt trong checkout | Không báo thành công giả; retry không lặp đơn |
| TC-068 | P0 | Cloudinary/email lỗi tạm | Lỗi có retry/fallback, không mất đơn |
| TC-069 | P0 | Khôi phục backup DB và manifest ảnh | Đối chiếu đủ mẫu đơn/tiền/tồn/ảnh và job |
| TC-070 | P0 | 50 người đồng thời theo workload ghi rõ | Đạt hoặc báo không đạt mục tiêu p95, không sai dữ liệu |
| TC-071 | P0 | 320/390/768/1440px, bàn phím | Không che nút, focus/label/lỗi rõ |
| TC-072 | P0 | Menu/đơn tiếng Việt, qua nửa đêm UTC | Hiển thị và báo cáo theo ngày VN đúng |
| TC-073 | P1 | Đóng ca theo FX-04 | Thiếu5.000đ và tiền gateway tách riêng |
| TC-074 | P1 | Refund sau khi chốt kỳ | Tạo adjustment, không sửa entry cũ |
| TC-075 | P1 | Tổng dashboard chuỗi so từng cơ sở | Cộng đúng cùng bộ lọc/định nghĩa |
| TC-076 | P1 | Ẩn món/nội dung hoặc đóng tài khoản | Lịch sử đơn, tiền, hỗ trợ còn truy nguyên đúng quyền |

### 4.7 Bổ sung sau rà soát nghiệp vụ và thiết kế

| Mã | Mức | Thao tác | Kết quả đạt |
|---|---|---|---|
| TC-077 | P0 | Cùng quote, hai Idempotency-Key khác nhau | Một order; request sau nhận resource đã tạo đúng quyền |
| TC-078 | P0 | Hai quote cùng cart generation, đặt từ hai tab | Unique generation ngăn đơn thứ hai; không giữ thêm |
| TC-079 | P0 | Đăng nhập khi giỏ vãng lai và tài khoản khác cơ sở | Hiện preview/chọn giỏ; retry confirm không cộng đôi |
| TC-080 | P0 | Sửa giỏ đồng thời và refresh token từ nhiều tab | CartVersion chặn ghi đè; refresh không vòng lặp, phiên lỗi yêu cầu đăng nhập lại an toàn |
| TC-081 | P0 | Hủy một ly trước trả quầy theo FX-06 | Chỉ thu 67.200đ; giao phần còn lại, COMPLETED/PARTIAL |
| TC-082 | P0 | Hủy một phần đã paid, refund thất bại | E giữ67.200đ; còn nghĩa vụ hoàn 37.800đ, không thu thêm |
| TC-083 | P0 | Hủy toàn đơn trước thu hoặc lỗi ly giá 0đ | Không tạo receipt giả; miễn phí vẫn có thể remake, refund không vượt0 |
| TC-084 | P0 | Thu trùng 105.000đ rồi hoàn chất lượng 37.800đ | Hoàn thu trùng không dùng hạn mức ly; tổng refund theo từng receipt hợp lệ |
| TC-085 | P0 | Paid ở phút 9,9 khi slot vẫn khả thi, rồi cơ sở không nhận | Chuyển accept deadline; quá hạn đóng phần phục vụ/giữ, khoản đã thu có refund obligation |
| TC-086 | P0 | Success đến sau paymentDueAt nhưng expiry job chưa chạy | Không lách deadline để hồi đơn; review/inquiry/hoàn |
| TC-087 | P0 | Fail/cancel provider event đến sau success | Receipt không bị mất; event được lưu/phân loại, không hạ paid |
| TC-088 | P0 | Start ticket lấy sữa từ hai lô theo FX-08 | Hai movement60ml hợp lệ; retry vẫn tổng120ml |
| TC-089 | P0 | Bỏ ly sau consume và ghi hao hụt lần nữa | Chỉ tổn thất thành phẩm; không trừ nguyên liệu hai lần |
| TC-090 | P1 | Thu hồi lô giữa lúc giữ và pha | Start bị chặn ngay, job trace có danh sách đơn ảnh hưởng và quyền đọc |
| TC-091 | P0 | Publish món thiếu recipe/giá hoặc options mâu thuẫn | Dry-run chỉ lỗi; không public món mua được nhưng không thực hiện được |
| TC-092 | P0 | Claim lease hết trước start | Reassign có quyền/version; một người sở hữu mới, không consume |
| TC-093 | P0 | Start đã commit nhưng browser timeout rồi người khác nhận | Snapshot vẫn PREPARING, không auto reset/start lại; kiểm thực tế trước giao lại |
| TC-094 | P1 | Bánh hết hạn hoặc hủy sau picking | Không lấy hàng hết hạn; restock chỉ qua kiểm/duyệt, có movement đảo |
| TC-095 | P1 | Combo thiếu thành phần, rồi refund bánh FX-07 | Chặn bán khi thiếu; khi hoàn dùng21.154đ, không truy thu phần trà |
| TC-096 | P1 | Cùng món mua pickup và dùng tại chỗ | Bao bì/công thức theo mode; ON_PREMISE thu trước, không tạo nợ bàn |
| TC-097 | P0 | Khách đưa200.000đ cho đơn105.000đ, in lại biên nhận | Change95.000đ; receipt105.000đ, không tăng tiền khi in lại |
| TC-098 | P0 | Tự duyệt, vượt hạn mức, tự nâng role hoặc khóa admin cuối | Từ chối theo policy; audit; không cộng quyền để lách hạn |
| TC-099 | P0 | Chủ đơn refresh xem mã pickup rồi đổi mã | Xem lại được bằng quyền hợp lệ; mã cũ vô hiệu, không log plaintext |
| TC-100 | P0 | Sao chép URL ảnh bằng chứng rồi logout/thu hồi quyền | Request mới bị từ chối; không lộ signed CDN URL lâu dài; bản đã tải không được hứa thu hồi |
| TC-101 | P0 | Job dọn ảnh orphan đua với gắn asset vào complaint | Một transaction/lease quyết định; không xóa ảnh đã được reference hợp lệ |
| TC-102 | P1 | Voucher đổi điểm hết hạn và cấp bù do lỗi chuỗi | Một replacement; không vừa trả điểm vừa cấp thêm voucher |
| TC-103 | P1 | 10 điểm hết hạn, job chạy lặp, refund giảm quyền hưởng4 điểm | Số dư0, không tạo nợ 4; entitlement giảm đúng, không đảo/hết hạn hai lần |
| TC-104 | P1 | Yêu cầu xóa khi có hold, hoặc user khác tải export | Giữ hồ sơ cần thiết; từ chối export; log đúng phạm vi, không phá ledger |
| TC-105 | P1 | Reset MFA và dùng recovery code lần hai | Recovery cần xác minh; code một lần, phiên cũ bị thu hồi |
| TC-106 | P1 | Đơn giao kỳ trước, refund được duyệt kỳ này | Báo cáo kỳ/cohort có định nghĩa khác nhau rõ; không ghi lại doanh số ngày cũ khi khóa |
| TC-107 | P0 | Migration từ DB trống và từ snapshot phiên bản trước | Dữ liệu cũ còn, constraint mới kiểm được, app rollback theo compatibility plan |
| TC-108 | P0 | Dọn IdempotencyRecord cũ rồi replay provider/job source | Business unique keys của receipt/movement/quote vẫn chặn tác dụng lặp |

### 4.5. Bổ sung đối chiếu đề và luồng chi tiết lần hai

Mỗi dòng dưới đây là một kịch bản kiểm thử có thể tách thành các subcase a/b/c khi triển khai; phải ghi actual result cho từng nhánh, không chỉ chạy một happy path rồi đánh dấu cả dòng PASS. Các test P0/P1 dùng dữ liệu giả xác định và chưa được thực thi trong phiên lập tài liệu.

| Mã | Mức | Dữ liệu/tình huống | Kết quả bắt buộc |
|---|---|---|---|
| TC-109 | P0 | Build WAR sạch Boot4.1/SiteMesh3.3/Tomcat11, chạy ngoài IDE, trang JSP qua resolver include | HTML không rỗng, UTF-8 đúng, artifact và dependency manifest lưu được; API không bị decorate |
| TC-110 | P0 | JSP dưới WEB-INF; JSTL render danh sách rỗng/nhiều dòng, thành phần/cảnh báo theo dữ liệu được duyệt, text có script và ký tự Việt | Không mở JSP trực tiếp, không scriptlet/DB ở view; text escape đúng, format tiền đúng, không thực thi payload |
| TC-111 | P0 | Ba layout khách/nhân viên/admin; trang lỗi, redirect, JSON, WS, ảnh riêng và assets | Title/head/body một lần, status lỗi đúng; các route không phải HTML không bị SiteMesh bọc |
| TC-112 | P0 | Bootstrap form/menu/modal/table ở390px và1440px, chỉ dùng bàn phím, lỗi form | Không tràn toàn trang/che nút; label/focus/validation đọc được, đóng modal trả focus |
| TC-113 | P0 | JPA lưu/query phân trang/restart, entity version race và rollback trên PostgreSQL; menu theo cơ sở | Persist đúng, unique/FK/lock hiệu lực, không N+1 tăng theo từng dòng, không trả entity/PII thừa |
| TC-114 | P0 | Access hết hạn lúc GET JSP và lúc POST đặt đơn; return URL ngoài origin, nhiều tab refresh | Refresh chỉ POST có CSRF, không loop/open redirect; tra operation và retry key cũ, không gửi lại mutation mù |
| TC-115 | P0 | Đăng ký email trùng đồng thời, gửi lại/xác minh/reset token hết hạn; sửa profile/địa chỉ và xem đơn cũ | Một tài khoản, token một lần, phản hồi không dò email; owner-only, snapshot địa chỉ đơn không đổi |
| TC-116 | P1 | Đổi email mới bị người khác chiếm trước confirm; token cũ dùng lại, đổi phone | Không mất email đang dùng, unique kiểm lúc commit; userId/đơn/điểm giữ nguyên, phone không giả verified |
| TC-117 | P1 | Thu hồi một phiên/cả phiên khi HTTP và WS đang hoạt động, đổi membership | Phiên được thu hồi mất quyền trong giới hạn đã chốt, phiên khác đúng policy; không lộ refresh token |
| TC-118 | P0 | Khách vãng lai có receipt mở case tại quầy; người khác chỉ biết phone/orderCode | Nhân viên xác minh và ghi behalf-of, không ép đăng ký; không tự chuyển order cho account cùng phone |
| TC-119 | P1 | Mua lại/lưu favorite; món ngừng bán, option/giá đổi, đọc favorite người khác | Owner-only; cấu hình cần xác nhận lại, không giữ tồn/giá/quota cũ; mua lại tạo generation mới |
| TC-120 | P0 | Một account có1 đơn chờ, hai request khác key cùng tạo; hai account chung IP | Chỉ tổng2 đơn chờ theo cap demo, số ly giữ không vượt cap; retry cũ trả đơn cũ, không chặn nhầm user vì chung IP |
| TC-121 | P0 | Capacity slot10 workUnits, đơn6 và5 cùng chốt; đơn hai dòng tổng11 workUnits vượt mọi slot; giảm max dưới đã giữ | Không overbook; chọn slot sau hoặc báo contact đặt nhóm; không chia đơn tự phát, không xóa cam kết khi giảm max |
| TC-122 | P0 | Đổi ETA trên5 phút, khách accept/reject/hết5 phút hoặc hai lần trả lời | Không tự pha trước consent; một kết quả, capacity swap/release đúng, E không tăng |
| TC-123 | P0/P1 | Checklist mở/đóng và incident pause giữa giờ, còn đơn đã pha/chưa pha | Lịch không tự bật lại, affected orders có owner và phương án; không batch cancel sai phần đã consume |
| TC-124 | P1 | Đóng ca còn đơn giao/COD/refund, người nhận ca chưa xác nhận | Hiện việc chưa bàn giao và cảnh báo; không ép order completed, custody/deadline còn truy được |
| TC-125 | P0/P1 | P0 nhập cơ bản có chứng từ/lô/đơn vị; P1 PO10kg, nhận6kg đạt và1kg bị từ chối, nhập lại receipt, đóng4kg thiếu | Stock chỉ tăng6kg một lần, outstanding4kg trước close-short, reason/approver và supplier trace đủ |
| TC-126 | P1 | Trả lô đã nhập có một phần consumed/reserved, duyệt và dispatch đồng thời/lặp | Không trả quá phần thực có; quarantine và xử lý holds trước dispatch; một movement xuất trả |
| TC-127 | P1 | Supplier credit chấp nhận một phần sau trả; sửa giá mua khi ly cũ đã bán | Credit reference tách quantity; không sửa cost snapshot của ly cũ; báo cáo ghi rõ giá vốn ước tính |
| TC-128 | P1 | Batch sơ chế dùng nhiều lô, yield thấp, source request lặp rồi bán topping từ output | Consume nguồn một lần, output theo yield thực, bán output không trừ nguồn lần hai, variance có người duyệt |
| TC-129 | P0/P1 | Mở bao, tách lô, gần hết hạn; thử đổi kg sang ml không có conversion | Chọn hạn sớm hơn, giữ nguồn gốc; không gia hạn bằng split/transfer, chặn chuyển đơn vị không hợp lệ |
| TC-130 | P1 | Đang count theo cutoff thì có lệnh reserve/receive/transfer trên cùng ingredient | Lệnh bị chặn theo count lock, không trộn số ở hai thời điểm; abort/recount nếu mở khẩn cấp, post variance một lần |
| TC-131 | P1 | Chuyển driver trước và sau pickup, một bên chưa xác nhận custody | Trước pickup audit; sau pickup cần event/handover hoặc supervisor exception, không mất người giữ hàng/COD |
| TC-132 | P1 | Giao thất bại, retry trong/ngoài hạn chất lượng, khách không đồng ý | Một active attempt; không reset giờ pha; hết hạn dùng remake mới/resolve, không tự thu thêm |
| TC-133 | P1 | Đã giao thật có POD nhưng COD thu thiếu/không thu, driver gửi lại cùng event | Lưu fulfilled/POD và collectionException NEEDS_REVIEW; không double receipt/handover hay yêu cầu giao lại |
| TC-134 | P1 | Voucher còn1 lượt/budget cuối, hai checkout cùng chốt; lỗi kho sau reserve quota | Một người thắng hoặc rollback đầy đủ; quota/budget không âm, scope/time/threshold được kiểm |
| TC-135 | P1 | Một wallet đủ một lần đổi, hai tab đổi đồng thời, point lot hết hạn sát commit | Một redemption, ledger/balance khớp; lot hết hạn không được chi dù job expiry chưa chạy |
| TC-136 | P1 | Voucher không được cộng dồn, món không eligible, hoàn một phần rồi thử lấy lại toàn quota | Lý do rõ, allocation chỉ eligible và tổng đúng; quota/điểm theo snapshot, không cấp lợi ích kép |
| TC-137 | P1 | Người chưa mua review, mua rồi review lặp/edit; báo cáo review tiêu cực và appeal | Chặn giả/trùng; giữ history; không gỡ chỉ vì chê, moderator reason và kết quả appeal có audit |
| TC-138 | P1 | CMS draft/preview/scheduled publish/unpublish qua ngày VN, job trễ; link món ngừng bán | Không lộ nháp, visibility theo thời gian, cache không giữ nội dung bị gỡ; link giải thích trạng thái |
| TC-139 | P0/P1 | Gửi event thông báo lặp, email lỗi, tắt marketing nhưng có đơn đang xử lý | Dedup/retry/status, không mất order; marketing theo consent, thông báo giao dịch theo purpose riêng |
| TC-140 | P1 | Import có dòng sai/asset ngoài quyền/URL tùy ý; giá đổi sau preview; ô CSV là công thức | Không commit nửa file, conflict yêu cầu preview lại, không fetch URL/SSRF, export lỗi an toàn |
| TC-141 | P1 | Confirm batch hai lần, cùng file khác owner; thử import balance/paid/role | Một apply đúng scope; fileHash không cấp quyền; không cho sửa tiền/tồn/quyền qua import master |
| TC-142 | P1 | Refund cash hôm sau ở ca khác, tender/change, nộp COD và in lại receipt | Ngày/ca thực thu chi đúng, liên kết order cũ; không nhân doanh thu khi nộp tiền/in lại |
| TC-143 | P0 | G105000,C37800,E67200,R105000,H0 rồi H37800; thu dư do duplicate và partial refund | Coverage/refundProgress độc lập; không nhắc thu thêm, nghĩa vụ/cap/điểm đúng từng nguồn |
| TC-144 | P1 | In lại nhãn khi mất kết nối, hai attempts remake cùng unit, đọc mã cũ khi handover | Nhãn thuộc unit/attempt có lịch sử, không tạo unit/consume mới; không dư PII, handover chống lặp |
| TC-145 | P0/P1 | Case quá SLA4 giờ làm việc chuyển owner/cảnh báo, đổi cấu hình ngưỡng có version, xuất audit/report quá scope hoặc file hết hạn | Quyền/approver/version đúng; không lộ token/password/PII thừa; file hết hạn không tải, lịch sử không sửa |
| TC-146 | P0/P1 | Upload ảnh giả nội dung/quá nhiều pixel, orphan cleanup đua attach, ảnh bị legal hold | Validate/quota/owner/purpose; không xóa asset đã gắn/hold, proxy no-store kiểm quyền từng request |
| TC-147 | P0 | Hai worker claim event, worker cũ mất lease, crash sau side effect trước ack | Fencing/version/dedup ngăn tác động kép; replay giữ source key; backlog/UNKNOWN có alert và owner |
| TC-148 | P0 | Dựng sạch từ README/seed, migrate/restore, chạy lại tác vụ sau điểm backup và quay lui app | Không phụ thuộc DB máy cá nhân; đơn/tiền/tồn/media khớp; tra soát provider trước resume, bằng chứng runbook rõ |

### 4.9 Bổ sung ca kiểm thử kịch bản biên và sự cố vận hành F&B thực tế (TC-149 đến TC-191)

| Mã | Mức | Thao tác | Kết quả đạt |
|---|---|---|---|
| TC-149 | P0 | Rút cáp mạng máy in bill; thanh toán đơn hàng 85k | Đơn hàng lưu PAID, PrintJob lưu FAILED, pop-up cảnh báo hiện trên POS, không bị mất đơn |
| TC-150 | P0 | Mở nắp máy in bill lấy giấy ra ngoài, gửi lệnh in | POS nhận cờ Paper End, hiển thị cảnh báo đỏ, Spooler chuyển RETRYING |
| TC-151 | P0 | Tắt nguồn Máy in 1, cấu hình Máy in 2 là backup | Hệ thống retry 3 lần thất bại, cho phép bấm chuyển Máy in 2 in thành công trọn vẹn |
| TC-152 | P0 | Bàn B02 đang có 2 ly cafe, nhập thêm 1 Trà đào | Máy in Barista chỉ in DUY NHẤT 1 phiếu cho Trà đào có tiêu đề "Bổ sung Lần 2" |
| TC-153 | P0 | Đơn 3 ly: Ly 1 Trà sữa Ô long 50% đường 50% đá | Tem nhãn 50x30mm in rõ: Tên món, Size, Chi tiết tùy chỉnh, Ly 1/3, Barcode định danh ly |
| TC-154 | P0 | Đơn đã thanh toán; Thu ngân bấm "In lại hóa đơn" | Yêu cầu PIN Quản lý; bill in ra có chữ *** BẢN SAO / REPRINT - LẦN 1 ***, reprintCount = 1 |
| TC-155 | P0 | Thu ngân 1 đã in lại 3 hóa đơn khác nhau, bấm in lần 4 | Khóa tính năng in lại của tài khoản, gửi cảnh báo bảo mật thời gian thực đến Store Manager |
| TC-156 | P0 | Đang in đơn 8 món thì cuộn giấy hết ở món thứ 3 | Tác vụ dở dang bị hủy; nạp giấy mới in lại toàn bộ 8 món với nhãn "BẢN IN THAY THẾ" |
| TC-157 | P1 | Bàn B04 đang AVAILABLE, tạo đơn, in tạm tính, trả tiền | Bàn đổi tuần tự: AVAILABLE -> OCCUPIED -> BILL_PRINTED -> CLEANING |
| TC-158 | P1 | Bàn A01 OCCUPIED, Bàn B02 AVAILABLE, Bàn C03 bận | Chuyển sang B02 thành công, A01 chuyển CLEANING. Chuyển sang C03 báo lỗi TABLE_BUSY |
| TC-159 | P1 | Đơn hàng đang pha trên màn hình KDS Barista | Thực hiện chuyển bàn trên POS; KDS Barista nhấp nháy dòng thông báo vàng cập nhật số bàn mới |
| TC-160 | P1 | Bàn 1 (150k + voucher 20k), Bàn 2 (100k + voucher 15k) | Món Bàn 2 nhập vào Bàn 1; voucher Bàn 2 hoàn lại ví; Đơn 2 chuyển MERGED_VOID |
| TC-161 | P1 | Đơn 300k dùng voucher giảm 50k cho đơn từ 250k | Tách 2 món 120k sang đơn mới; đơn gốc còn 180k < 250k -> voucher tự động bị hủy |
| TC-162 | P1 | Đơn bàn 600.000đ; nhóm 3 người yêu cầu chia đều | Sinh đúng 3 biên lai 200k; đơn chỉ COMPLETED khi cả 3 biên lai thanh toán thành công |
| TC-163 | P1 | Bàn VIP đặt hẹn 19:00, cọc 200k, đồng hồ đến 19:16 | Bàn tự động chuyển về AVAILABLE, đơn đặt bàn chuyển NO_SHOW_FORFEITED |
| TC-164 | P1 | Đơn đặt bàn bị No-show quá hạn | Tự động tạo bút toán chuyển 200k từ TK 3386 sang TK 711 (Thu nhập khác) có mã tham chiếu |
| TC-165 | P0 | Mở ca lúc 22:00 ngày 19/11; Bán đơn lúc 01:30 ngày 20/11 | Đơn hàng mang businessDate = 2026-11-19, két tiền không bị reset lúc 00:00 |
| TC-166 | P1 | Ca đêm vắt qua đêm 31/10 sang 01/11 | Doanh thu trước 23:59:59 vào tháng 10; sau 00:00:01 vào tháng 11; tổng ca đóng lúc 06:00 khớp |
| TC-167 | P0 | Két tiền có 3.500.000đ theo hệ thống | Màn hình ẩn số 3.500.000đ, chỉ hiện bảng kê mệnh giá tiền bắt buộc đếm thực tế |
| TC-168 | P0 | Expected = 3.500.000đ; Thực đếm = 3.490.000đ (lệch 10k) | Tự động ghi nhận chênh lệch vào chi phí làm tròn TK 642, hoàn tất đóng ca bình thường |
| TC-169 | P0 | Expected = 3.500.000đ; Thực đếm = 3.300.000đ (thiếu 200k) | Khóa đóng ca thường; bắt buộc Quản lý cùng ký Biên bản kiểm quỹ bất thường điện tử |
| TC-170 | P0 | Két thu tiền đạt 6.500.000đ; thực hiện Cash Drop 4.000.000đ | Cảnh báo vàng xuất hiện; xác thực kép Quản lý + Thu ngân; in 2 liên phiếu; expected cash còn 2.500k |
| TC-171 | P0 | Cửa hàng đột ngột mất điện toàn phần | Ca chuyển FORCED_CLOSED; đơn đang pha chuyển INCIDENT_ABORTED và tự động hoàn tiền online |
| TC-172 | P1 | Khách đăng ký ngày sinh 25/11 vào ngày 15/11 (trước 10 ngày) | Không được cấp voucher sinh nhật vì đăng ký chưa đủ 30 ngày; chặn tạo tài khoản nhận quà ngay |
| TC-173 | P1 | Khách áp dụng Voucher Sinh Nhật tặng ly nước 65k | POS bắt buộc hiển thị hộp thoại đối chiếu CCCD; thu ngân phải tích chọn xác nhận mới áp dụng được |
| TC-174 | P0 | Đơn 100k; cố tình áp 2 voucher cấp đơn (30k + 20k) | Từ chối voucher thứ 2; thử áp voucher làm giá < 20% giá gốc bị chặn commit giao dịch |
| TC-175 | P0 | Voucher hết hạn 23:59; Khách checkout MoMo lúc 23:58 | Voucher được bảo lưu ưu đãi trong 15 phút TTL; đơn thanh toán xong lúc 00:02 thành công PAID |
| TC-176 | P0 | Khách checkout giữ voucher lúc 14:00 nhưng không trả tiền | Đến 14:16, Background Job tự động chuyển Voucher từ RESERVED về RELEASED |
| TC-177 | P1 | Đơn 200k = Voucher giảm 50k + Điểm cũ 30k + Tiền mặt 120k | Chỉ tích điểm trên 120k thực chi (12 điểm), không tích điểm trên 80k tiền voucher và điểm cũ |
| TC-178 | P1 | Đơn hàng ở TC-177 bị hủy toàn bộ trước khi pha | Hoàn lại 120k tiền mặt, hoàn trả 30.000 điểm về ví, khôi phục voucher 50k về trạng thái ACTIVE |
| TC-179 | P1 | Tủ mát ghi nhận 9°C liên tục trong 130 phút | Toàn bộ các lô sữa tươi thanh trùng trong tủ tự động chuyển sang QUARANTINED, POS báo động đỏ |
| TC-180 | P0 | Lô sữa tươi thanh trùng bị QUARANTINED ở TC-179 | Các món Latte, Cappuccino, Trà sữa tươi tự động hiển thị nhãn Tạm hết hàng, nút mua bị vô hiệu |
| TC-181 | P0 | Xuất hủy 15 hộp sữa tươi hỏng do mất điện | Hệ thống chặn gửi duyệt nếu chưa chụp ảnh; bắt buộc chụp trực tiếp từ camera 2 ảnh (tem và đổ bỏ) |
| TC-182 | P0 | Phiếu 1 (250k); Phiếu 2 (1.200k); Phiếu 3 (3.500k) | Phiếu 1 Quản lý ca duyệt; Phiếu 2 Quản lý cửa hàng duyệt; Phiếu 3 bắt buộc Giám đốc OM duyệt |
| TC-183 | P1 | Phiếu xuất hủy do hỏng tủ mát được duyệt | Ghi nhận chi phí tổn thất vào TK 811; trừ tồn kho chính xác theo lô nhập; Food Cost % không bị méo |
| TC-184 | P0 | Vé pha chế đang ở trạng thái IN_PROGRESS | Lỗi quán hoàn 100% tiền; khách đổi ý yêu cầu PIN Quản lý ca phê duyệt; ghi nhận lãng phí pha chế |
| TC-185 | P0 | Ly Macchiato đã pha xong (READY), khách bỏ đi; đơn sau có Macchiato | Barista bấm Reassign Cup; ly nước gán sang đơn sau ngay lập tức, quán không bị mất ly nước |
| TC-186 | P0 | Đơn thanh toán quẹt thẻ 5 phút trước, chưa pha chế | Cổng thanh toán đảo giao dịch trực tiếp không mất phí quẹt thẻ; đơn hàng chuyển VOIDED |
| TC-187 | P0 | Khách trả 1 Ly giữ nhiệt (nguyên seal) và 1 Ly Trà đào | Ly giữ nhiệt được tích chọn nhập lại kho bán lẻ; Ly trà đào cấm nhập kho, ghi nhận xuất hủy chất lượng |
| TC-188 | P1 | Ngắt toàn bộ cáp mạng Internet vào máy POS | Đơn tạo thành công, in bill bình thường; bản ghi SQLite gắn mã offline và có chữ ký HMAC SHA-256 |
| TC-189 | P1 | Cắm lại dây mạng Internet cho POS | Đơn quầy offline được server ghi nhận thành công; đơn Web xung đột bị hủy tự động và hoàn tiền + voucher |
| TC-190 | P0 | Đơn 650k = 50k Điểm + 200k MoMo + 200k Thẻ + 200k Tiền mặt | Mỗi phương thức sinh 1 bản ghi PaymentTransaction; đơn chuyển PAID khi remainingBalance = 0 |
| TC-191 | P0 | Đã trừ 50k điểm và 200k MoMo thành công; bước quẹt thẻ lỗi | Hệ thống tự động hoàn 200k về ví MoMo, hoàn 50k điểm về ví khách, hủy đơn an toàn không lệch quỹ |

## 5. Ma trận truy vết yêu cầu

| Quy tắc | Chức năng | Màn hình | Dữ liệu/API trọng tâm | Ca kiểm |
|---|---|---|---|---|
| BR-01/02 | F-009–016,043 | C02,C05,C06,A02 | Branch, Hours, Capacity; change-branch, quotes | 001–003,007,019 |
| BR-03/04/05 | F-017–024,041–046 | C03,C04,A03 | Variant, Options, Price, Snapshot | 004–011,018 |
| BR-06/07 | F-047,073–074 | C06,A06 | DiscountAllocation, Redemption | 012,037,038 |
| BR-08/09/10 | F-025–040,049,054 | S06,S07,A04 | Lot, Balance, Reservation, Movement | 013–024 |
| BR-11 | F-049–056 | C07,C08,A08 | Attempt, Receipt, ProviderEvent | 025–032 |
| BR-12/13/14 | F-057–064 | S01–S05 | Ticket, PickupProof, Remake | 022,035,036,041–045 |
| BR-15/16 | F-065–072,090–092 | C13,S08,S09,A08 | Delivery, Cash, Reconciliation | 049–052,073,074 |
| BR-17 | F-081–086 | C11,A07 | Complaint, Refund, Evidence | 033,034,036,037,062 |
| BR-18 | F-075–080 | C12,A06 | LoyaltyLedger, SpendAllocation | 039,040 |
| BR-19/21 | F-001–008,024,082 | C09,A05,A09 | Session, Membership, Media | 053–064 |
| BR-20/22 | F-095,097–103 | C08,S03,A10 | Outbox, Audit, Policy | 046–048,065–072 |
| BR-23/24 | F-087,089–096 | C14,S10,A01 | Content, FinancePeriod, reports | 074–076 |
| BR-25 | F-105,106 | C05,C06,C09 | CartMergeProposal, Quote, checkoutGeneration | 077–080,108 |
| BR-26/27 | F-107–109 | C08,S05,A07 | OrderUnit, Adjustment, deadlines, Receipt | 081–087 |
| BR-28 | F-110,111,118 | C04,S01,S06,A03 | Bundle, PackagedStockMapping, serviceMode | 094–096 |
| BR-29/30 | F-112,113,119 | S03,S06,S07,A03 | Recall, allocation, Ticket lease, PublishCheck | 088–093,101 |
| BR-31 | F-114,115,117,120 | S01,S08,A05,A06,A07 | CashTender, Approval, RewardIssue, MFA | 097,098,102,103,105 |
| BR-32 | F-116 | C09,C11,A10 | PrivacyRequest, Retention, Hold, media proxy | 099–101,104 |

Các nhóm bổ sung: BR-33/F-121→TC-118; BR-34/F-123→TC-125–127; BR-35/F-124→TC-131–133; BR-36/F-125→TC-123–124; BR-37/F-122→TC-119; BR-38/F-126/127→TC-114–117,120; BR-39/F-128→TC-140–141; BR-40/F-013/109→TC-121–122. Ma trận đầy đủ từng F ở tài liệu10.

Ký hiệu C/S/A trong ma trận là tiền tố UI-C/UI-S/UI-A của tài liệu kế hoạch. Mã ca dạng 013–024 nghĩa TC-013 đến TC-024. Khi mở ticket triển khai, chọn ca phù hợp trong khoảng, không tuyên bố một test bao phủ toàn module.

## 6. Kịch bản demo bảo vệ đồ án

### Kịch bản 1 — Hành trình tiêu chuẩn, khoảng 8 phút

Admin giới thiệu hai cơ sở và quyền → khách chọn A → thêm hai ly khác đường/topping → quote → thanh toán sandbox → thu ngân nhận → barista thấy phiếu qua WebSocket → bắt đầu/hoàn từng ly → khách nhận READY → thu ngân kiểm mã và bàn giao → khách xem chi tiết. Chỉ ra Spring Boot xử lý nghiệp vụ, JSP/JSTL render, SiteMesh layout, Bootstrap responsive, JPA/PostgreSQL lưu, JWT kiểm quyền, WS cập nhật và Cloudinary phục vụ ảnh.

### Kịch bản 2 — Đúng dữ liệu dưới cạnh tranh, khoảng 4 phút

Đặt tồn sữa chỉ đủ một ly → hai tài khoản xác nhận cùng lúc → chỉ một đơn giữ thành công → replay cùng request không tạo đơn thứ hai → nhân viên B thử mở đơn A bị từ chối. Trình bày bằng request/test report, không sửa DB bằng tay để tạo kết quả mong muốn.

### Kịch bản 3 — Lỗi và hậu mãi, khoảng 5 phút

Một ly bị sai → mở khiếu nại có ảnh riêng → quản lý duyệt làm lại hoặc refund → đối chiếu nguyên liệu và tiền → gửi callback lặp → ledger không nhân đôi. Nếu P1 đã làm, dùng FX-01 trình bày phân bổ giảm và đảo điểm.

### Kịch bản 4 — Vận hành, khoảng 3 phút

Mất kết nối queue rồi nối lại → snapshot đúng → mở audit theo mã đơn → xem ca/đối soát nếu có P1 → trình biên bản restore. Có video dự phòng, fixture và fake adapter khi Internet/đối tác lỗi; nói rõ khi đang dùng giả lập.

## 7. Tiêu chí gate và mức lỗi

| Mức lỗi | Ví dụ | Xử lý trước bàn giao |
|---|---|---|
| Blocker | Mất dữ liệu, sai tiền, âm tồn, vượt quyền cơ sở, không build | Phải sửa và test lại |
| Major | Không hoàn tất một luồng đã cam kết, queue không phục hồi, refund không theo dõi | Phải sửa hoặc loại khỏi phạm vi có biên bản, không giấu |
| Minor | Lỗi trình bày không chặn thao tác | Ghi rõ ảnh hưởng, ưu tiên theo UX |
| Improvement | Tính năng tiện thêm hoặc P2 | Đưa backlog sau, không làm trượt gate |

G3 yêu cầu tất cả ca P0 liên quan đạt, không blocker/major trong luồng cam kết, đủ stack và bằng chứng restore thử. G5 yêu cầu toàn bộ P1 đã công bố đạt ca tương ứng, báo cáo đúng phạm vi và tài liệu chạy máy mới. Không dùng tỷ lệ “95% test pass” để bỏ qua một ca sai tiền.

Biên bản UAT cần: build, phạm vi P0/P1, người đóng vai khách/quầy/quản lý, ngày, ca, expected/actual, ảnh/log đã che PII, lỗi, người xử lý, kết quả retest, quyết định đạt/chưa đạt. Chưa có ứng dụng thì trạng thái phải là “chưa thực hiện”.

## 8. Runbook sự cố dự kiến

| Sự cố | Phát hiện | Hành động có thứ tự | Điều kiện đóng |
|---|---|---|---|
| Database không truy cập | Health/errors và checkout fail | Dừng nhận mới; giữ thông báo rõ; khôi phục kết nối; đối chiếu request idempotent | Không có đơn báo thành công mà không có bản ghi |
| Queue WS ngắt | Client disconnected, lag tăng | Chuyển snapshot/poll giới hạn; khôi phục WS; kiểm version | Không mất/nhân phiếu, mọi client tải lại đúng |
| Payment UNKNOWN | Attempt quá hạn/inquiry lỗi | Không pha nếu chưa đủ điều kiện; inquiry theo provider; đối chiếu bảng kê | Ghi nhận thu/không thu/hoàn có chứng cứ |
| Callback lặp/trễ | Inbox duplicate/late flag | Xử lý lại an toàn hoặc đưa review; không xóa event để thử lại | Receipt và trạng thái đúng, khoản thừa có hồ sơ |
| Hết nguyên liệu giữa ca | Availability/nhân viên báo thiếu | Tạm dừng món; kiểm lô/giữ; đổi lô hợp lệ hoặc liên hệ khách | Cân đối đúng, đơn bị ảnh hưởng có quyết định |
| Pha sai/nắp đổ | Complaint/ticket exception | Ghi hao hụt; duyệt remake/refund; phiếu mới nếu cần | Tiêu hao và tiền không bị sửa ngược sai |
| Outbox/job kẹt | Pending age/retry tăng | Xác định lỗi; sửa điều kiện; retry cùng business key | Không có tác dụng lặp, backlog giảm |
| Ảnh riêng bị cấu hình public | Kiểm truy cập/feedback | Ngừng cấp URL; hạn chế asset/derived; đánh giá phạm vi và xử lý theo quy trình | Quyền bản gốc/biến đổi được kiểm lại |
| Chênh tiền ca | Expected khác actual | Giữ nguyên giao dịch; kiểm thu/hoàn/nộp; quản lý duyệt chênh | Có chứng từ xử lý, không ép số khớp |
| Release lỗi | Smoke/regression thất bại | Tạm ngừng nhận mới nếu cần; rollback app tương thích; xử lý migration theo runbook | Đơn đang có đọc/xử lý được và kiểm tra lại |

## 9. Sao lưu và phục hồi

Đề xuất cho đồ án: backup PostgreSQL tự động hằng ngày và trước migration, lưu bản ngoài máy chạy ứng dụng; backup/manifest media cần thiết; giữ khóa/cấu hình phục hồi ở nơi an toàn tách log. Mục tiêu thử ban đầu **RPO ≤24 giờ, RTO ≤4 giờ**, cần đo bằng diễn tập. Đây không đủ để tự nhận là mức phù hợp mọi hoạt động bán thật.

Trước thí điểm tiền thật, đánh giá PITR/WAL và mục tiêu chặt hơn, ví dụ RPO≤15 phút/RTO≤2 giờ như mục tiêu thiết kế, chỉ công bố khi đã đo và đủ ngân sách. Khôi phục DB cũ không khôi phục thế giới bên ngoài: tiền có thể đã thu, hàng có thể đã giao trong khoảng mất dữ liệu.

Diễn tập: ghi thời điểm backup → tạo thêm một số đơn/thu giả lập → gây gián đoạn có kiểm soát trên staging → phục hồi vào môi trường tách → kiểm tổng dòng, FK, balances, receipts, assets → đối chiếu provider/nhật ký giao khoảng gián đoạn → xử lý pending/late events → đo thời gian và dữ liệu mất → ghi biên bản. Không replay mù outbox chứa lệnh hoàn/thu thật; từng adapter phải có idempotency và inquiry.

## 10. Chỉ số theo dõi hằng ngày khi thí điểm

| Chỉ số | Ý nghĩa | Người xử lý |
|---|---|---|
| Đơn chờ nhận/pha quá hạn | Khả năng phục vụ hoặc job lỗi | Quản lý cơ sở |
| Hold quá hạn chưa release | Giảm khả dụng giả | Người vận hành kỹ thuật |
| Balance/lot/reservation lệch | Rủi ro sai nguyên liệu | Kho + kỹ thuật |
| Payment UNKNOWN/thu thừa/refund pending | Nghĩa vụ tiền chưa kết thúc | Tài chính/CSKH |
| COD đã thu chưa nộp | Tiền do tài xế giữ | Quản lý/tài chính |
| Hao hụt/làm lại theo món | Chất lượng và recipe | Quản lý cơ sở |
| Complaint quá SLA | Khách chưa được giải quyết | CSKH |
| Outbox retry, API errors, WS lag | Sự cố kỹ thuật | Người trực vận hành |

Các dashboard phải cho đi đến bản ghi gốc; một số tổng đẹp không thay được danh sách đơn/tiền cần xử lý. Đồ án kết thúc khi bàn giao đúng phạm vi và bằng chứng; mở bán thực tế là quyết định riêng sau nghiệm thu vận hành.

## 11. Cấu hình kiểm thử và hồ sơ chứng minh cụ thể

### 11.1 Tải thử có thể tái hiện

Đề xuất profile đầu:3 cơ sở, 100 món, 300 biến thể, 50 nguyên liệu, 200 lô, 10.000 đơn lịch sử. Môi trường tham chiếu để dự toán: app2vCPU/4GB RAM, PostgreSQL2vCPU/4GB RAM, cùng vùng mạng; người chạy phải ghi cấu hình thực tế nếu khác. Không coi đây là tài nguyên production đã benchmark.

Chạy 50 virtual users, tăng tải 2 phút, giữ 10 phút, think time2–5 giây. Mix mục tiêu 70% đọc menu/đơn,20% sửa giỏ/quote,10% command tạo/xử lý đơn; ghi throughput đạt được thay vì suy ra từ số user. Payment/email dùng fake có độ trễ đã ghi, tách thời gian xử lý server khỏi thời gian chờ đối tác. Kiểm đúng dữ liệu sau chạy, không chỉ latency. Bài tranh tồn cuối dùng barrier đồng thời riêng, không hy vọng ngẫu nhiên workload sẽ chạm đúng đua.

### 11.2 Các tổ hợp quyền cần thử

Với mỗi endpoint đọc/ghi nhạy cảm, ít nhất thử: chưa đăng nhập; chủ thể hợp lệ; khách khác; cùng role khác cơ sở; nhân viên nhiều cơ sở nhưng không có quyền thao tác đó; quyền vừa thu hồi; admin hợp lệ. Lặp cho subscribe WS, media proxy và export. HTTP403/404 đúng chưa đủ nếu response/log/event vẫn chứa dữ liệu ngoài scope.

### 11.3 Dạng bằng chứng cần lưu

| Nhóm | Bằng chứng tối thiểu khi xây ứng dụng |
|---|---|
| Đồng thời | Fixture trước/sau, request IDs, thứ tự commit, balance/movements và assertions |
| Tiền | Payload đã che bí mật, verification result, attempt/receipt/refund IDs, số dư đối chiếu |
| UI | Kịch bản, viewport/trình duyệt, ảnh lỗi và retest, bàn phím/focus |
| Quyền | Actor/scope, resource scope, response và kiểm WS/log không rò |
| Migration/restore | Artifact/version, schema trước/sau, thời gian, checksum/sample counts và đối chiếu bên ngoài |
| Nghiệm thu | Expected/actual theo mã TC, trạng thái PASSED/FAILED/NOT_RUN/NOT_APPLICABLE có lý do |

NOT_APPLICABLE chỉ dùng khi tính năng đã được xác nhận ngoài scope của bản bàn giao; không dùng để né lỗi P0. Chưa có runtime thì mọi ca ứng dụng là NOT_RUN, dù kiểm cấu trúc tài liệu đã đạt.

## 12. Bằng chứng nghiệm thu theo phiên bản 1.2

Tổng148 mã là danh mục thiết kế test, chưa phải148 kết quả PASS. Mẫu ghi kết quả: TC/subcase, F/RQ, build/commit, môi trường, seed/clock, người chạy, bước thực tế, expected/actual, trạng thái PASS/FAIL/BLOCKED/NOT RUN, link ảnh/log/requestId đã che PII, bugId và lần retest. Ca P0/P1 có nhiều nhánh phải tách kết quả; sandbox chưa có tài khoản ghi BLOCKED tích hợp, fake vẫn ghi riêng.

Nguồn truy vết mới: [đối chiếu đề](07-DOI-CHIEU-DE-BAI-VA-PHAM-VI.md), [28 luồng](08-DAC-TA-LUONG-NGHIEP-VU-CHI-TIET.md), [hợp đồng triển khai](09-HOP-DONG-DU-LIEU-LENH-VA-VAN-HANH.md), [128 chức năng](10-MA-TRAN-TRUY-VET-CHUC-NANG.md). Gate G0 cuối tuần3; G3 tuần12; G4 tuần20; G5 tuần24 theo kế hoạch1.2. Các con số tuần trong hồ sơ1.1 là lịch sử.
