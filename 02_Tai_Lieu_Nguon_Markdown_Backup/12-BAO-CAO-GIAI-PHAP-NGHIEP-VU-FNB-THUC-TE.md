# BÁO CÁO TỔNG HỢP RÀ SOÁT VÀ ĐỀ XUẤT GIẢI PHÁP NGHIỆP VỤ F&B THỰC TẾ
## DỰ ÁN HỆ THỐNG WEBSITE CHUỖI BÁN TRÀ VÀ CÀ PHÊ UTECOFFE

**Mã tài liệu:** `UTECOFFE-BC-FB-01`  
**Phiên bản:** `1.3` — Ngày 19/11/2026  
**Đơn vị thực hiện:** Nhóm Phân tích Nghiệp vụ & Kiến trúc Hệ thống UTECoffe  
**Phạm vi áp dụng:** Toàn bộ hệ thống quản lý chuỗi, ứng dụng POS bán hàng tại quầy, KDS pha chế, ứng dụng quản lý kho, Cổng khách hàng Web/App và Sổ cái kế toán nội bộ.

---

## MỤC LỤC TỔNG QUAN

1. **Tóm tắt điều hành (Executive Summary)**
2. **Khảo sát thực trạng & Khoảng trống nghiệp vụ F&B chuỗi**
3. **Phân tích chi tiết 6 nhóm kịch bản biên vận hành F&B**
   - 3.1 Nhóm 1: In ấn hóa đơn POS & Sự cố phần cứng máy in
   - 3.2 Nhóm 2: Quản lý bàn ăn & Phục vụ tại chỗ (Dine-in)
   - 3.3 Nhóm 3: Quản lý ca làm việc & Vận hành xuyên ngày (Cross-day)
   - 3.4 Nhóm 4: Khuyến mãi, Voucher sinh nhật & Điểm thành viên
   - 3.5 Nhóm 5: Xuất hủy nguyên liệu & Sự cố bảo quản nhiệt độ
   - 3.6 Nhóm 6: Các kịch bản biên vận hành khác (Hủy pha chế, POS ngoại tuyến, Thanh toán kết hợp)
4. **Đề xuất giải pháp kiến trúc & Quy trình vận hành chuẩn**
5. **Danh mục các mục bổ sung kế thừa mã tiếp nối**
   - 5.1 Danh mục 25 Quy tắc nghiệp vụ mới (BR-41 đến BR-65)
   - 5.2 Danh mục 30 Chức năng hệ thống mới (F-129 đến F-158)
   - 5.3 Danh mục 13 Luồng nghiệp vụ chi tiết mới (UC-29 đến UC-41)
   - 5.4 Danh mục 43 Ca kiểm thử định danh mới (TC-149 đến TC-191)
   - 5.5 Danh mục 4 Bài toán đối soát số học mới (FX-09 đến FX-12)
   - 5.6 Kế hoạch 6 Gói công việc WBS bổ sung (W28 đến W33)
6. **Ma trận truy vết toàn diện (End-to-End Traceability Matrix) - 100% Coverage**
7. **Kế hoạch triển khai & Khuyến nghị trước khi viết code**

---

## 1. TÓM TẮT ĐIỀU HÀNH (EXECUTIVE SUMMARY)

Dự án website chuỗi trà và cà phê **UTECoffe** đang ở giai đoạn hoàn thiện hồ sơ đặc tả nghiệp vụ, kiến trúc dữ liệu và kế hoạch kiểm thử để chuẩn bị bước vào giai đoạn cài đặt phần mềm (coding phase). Hồ sơ hiện hành (bản v1.2) đã thiết lập một nền tảng rất vững chắc với 40 Quy tắc nghiệp vụ bắt buộc (`BR-01` đến `BR-40`), 128 Chức năng backlog (`F-001` đến `F-128`), 28 Luồng nghiệp vụ Use Case (`UC-01` đến `UC-28`), 148 Ca kiểm thử định danh (`TC-001` đến `TC-148`), 8 Fixture đối soát số học (`FX-01` đến `FX-08`) và kế hoạch 27 gói công việc WBS (`W01` đến `W27`).

Tuy nhiên, qua rà soát đối chiếu chuyên sâu với thực tế vận hành tại các chuỗi F&B hàng đầu tại Việt Nam (như Highlands Coffee, Phúc Long, The Coffee House, Katinat Saigon Kafe), nhóm phân tích đã phát hiện **6 nhóm khoảng trống nghiệp vụ và kịch bản biên (Edge Cases) sống còn**. Nếu không được đặc tả và thiết kế kỹ lưỡng trước khi lập trình, hệ thống sẽ phát sinh lỗi nghiêm trọng khi triển khai thực tế, bao gồm:
1. Máy in hóa đơn POS bị nghẽn làm treo màn hình thanh toán; nhân viên in lại hóa đơn tùy tiện gây thất thoát tiền mặt.
2. Khách ngồi tại chỗ đổi bàn, gộp nhóm hoặc tách hóa đơn tính tiền riêng khiến nhân viên thao tác thủ công, lệch số liệu và thất lạc đồ uống.
3. Cửa hàng vận hành ca đêm xuyên qua 00:00 bị xé đôi doanh thu, reset két tiền lúc nửa đêm gây hỗn loạn khi bàn giao ca.
4. Trục lợi khuyến mãi qua việc đổi ngày sinh nhận voucher nhiều lần; xung đột voucher làm chiết khấu vượt giá sàn bảo vệ giá vốn.
5. Sự cố tủ mát / mất điện làm sữa chua, kem béo biến chất nhưng không được cảnh báo, dẫn đến nguy cơ ngộ độc thực phẩm; xuất hủy kho không có bằng chứng hình ảnh gây thất thoát tài sản.
6. Mất mạng Internet làm tê liệt toàn bộ quầy thu ngân; thiếu cơ chế thanh toán kết hợp nhiều nguồn tiền (Split Tender).

Để giải quyết triệt để các rủi ro trên, báo cáo này chuẩn hóa toàn bộ giải pháp kỹ thuật thành **hệ thống định danh kế thừa nối tiếp (Continuous ID Allocation)**, bảo đảm **giữ nguyên vẹn 100% cấu trúc của hồ sơ hiện hành** mà không làm thay đổi hoặc phá vỡ bất kỳ mã số nào:

```
========================================================================================
BẢNG TỔNG HỢP TIẾN HÓA ĐỊNH DANH HỆ THỐNG UTECOFFE (BASELINE vs BỔ SUNG)
========================================================================================
Thực thể               Baseline v1.2         Bổ sung mới (Rà soát F&B)     Tổng sau bổ sung
----------------------------------------------------------------------------------------
Quy tắc nghiệp vụ (BR) 40 (BR-01 đến BR-40)  25 (BR-41 đến BR-65)          65 Quy tắc
Chức năng hệ thống (F)128 (F-001 đến F-128)  30 (F-129 đến F-158)         158 Chức năng
  - Phân loại P0       74 Chức năng P0       16 Chức năng P0               90 Chức năng P0
  - Phân loại P1       48 Chức năng P1       14 Chức năng P1               62 Chức năng P1
  - Phân loại P2        6 Chức năng P2        0 Chức năng P2                6 Chức năng P2
Use Case chi tiết (UC) 28 (UC-01 đến UC-28)  13 (UC-29 đến UC-41)          41 Use Cases
Ca kiểm thử định danh 148 (TC-001 đến TC-148)43 (TC-149 đến TC-191)        191 Test Cases
Đối soát số học (FX)    8 (FX-01 đến FX-08)   4 (FX-09 đến FX-12)          12 Fixtures
Gói công việc WBS (W)  27 (W01 đến W27)       6 (W28 đến W33)              33 Gói WBS
========================================================================================
```

---

## 2. KHẢO SÁT THỰC TRẠNG & KHOẢNG TRỐNG NGHIỆP VỤ F&B CHUỖI

Qua khảo sát thực tế tại các cửa hàng trà & cà phê, chu trình vận hành tại quầy chịu áp lực cực lớn về tốc độ: mỗi giao dịch thanh toán chỉ được kéo dài từ **30 đến 45 giây**, và mỗi ly nước phải được hoàn thành trong vòng **120 đến 180 giây**. Mọi sự cố kỹ thuật hoặc thiếu sót quy trình đều trực tiếp gây ách tắc hàng dài khách hàng, phát sinh xung đột và thất thoát tài chính.

### 2.1 Bảng đối chiếu Khoảng trống giữa Hồ sơ v1.2 và Thực tế F&B
| Phân hệ nghiệp vụ | Hiện trạng trong hồ sơ v1.2 | Thực tế vận hành chuỗi F&B | Hậu quả nếu không xử lý trước khi code |
|---|---|---|---|
| **In ấn POS & Phần cứng** | Chỉ chuyển trạng thái đơn (QUEUED, READY), không đặc tả máy in nhiệt ESC/POS, không có cơ chế in lại (Reprint). | Máy in nhiệt thường xuyên kẹt giấy, hết giấy K80, đứt cáp mạng LAN. Thu ngân có thể in lại bill đưa cho khách trả tiền mặt rồi hủy đơn gốc để biển thủ. | Màn hình POS bị đơ khi máy in lỗi; thất thoát doanh thu tiền mặt lớn do gian lận in lại không kiểm soát. |
| **Quản lý Bàn (Dine-in)** | `BR-28` chỉ có nhãn bàn đơn giản (`ServingLocation`), không hỗ trợ chuyển/gộp/tách bàn. | Khách dùng tại chỗ chiếm 50–70% doanh thu; thường xuyên chuyển chỗ cắm sạc laptop, gộp bàn khi bạn đến đông, tách hóa đơn chia tiền riêng. | Thu ngân phải tính toán giấy ngoài hệ thống; Barista bưng nước nhầm bàn; lệch số liệu doanh thu và kho. |
| **Quản lý Ca & Ca đêm** | `BR-36` chỉ quy định mở/đóng cửa cơ sở và giao ca theo ngày lịch thông thường. | Cửa hàng mở muộn hoặc 24/7 có ca đêm (22:00 - 06:00) vắt qua mốc 00:00. Két tiền mặt tích tụ lớn trong giờ cao điểm. | Doanh thu bị cắt đôi lúc nửa đêm; két tiền bị reset về 0 lúc 00:00 làm hỏng việc kiểm quỹ bàn giao lúc 06:00 sáng. |
| **Khuyến mãi & Voucher** | `BR-07` và `BR-18` mới quy định voucher chung và tích điểm cơ bản, chưa có ma trận xếp chồng. | Khách dùng đồng thời Happy Hour + Voucher hóa đơn + Mã ship + Điểm thưởng. Khách đổi ngày sinh liên tục để nhận quà sinh nhật. | Giảm giá âm, bán dưới giá vốn; tranh chấp khi voucher hết hạn trong lúc khách đang thanh toán MoMo. |
| **Sự cố Kho & Hỏng lạnh** | `BR-09` và `BR-29` chỉ có trừ kho theo hạn dùng FEFO và hao hụt thông thường. | Sự cố mất điện hoặc cháy lốc tủ mát làm sữa tươi, kem béo chua hỏng hàng loạt. | Nguy cơ ngộ độc thực phẩm; nhân viên tuồn hàng ra ngoài rồi báo hỏng; bóp méo tỷ lệ Food Cost % quầy Bar. |
| **Vận hành Quầy khác** | Hủy đơn cơ bản, chưa có quy định hủy khi đang pha, chưa có POS ngoại tuyến và Split Payment. | Khách hủy khi Barista đang đánh sữa; đứt cáp quang Internet; khách thanh toán kết hợp tiền mặt + thẻ + ví điện tử. | Đổ bỏ lãng phí ly nước; cửa hàng tê liệt khi mất mạng cáp quang; từ chối khách vì không chia được tiền. |

---

## 3. PHÂN TÍCH CHI TIẾT 6 NHÓM KỊCH BẢN BIÊN VẬN HÀNH F&B

### 3.1 Nhóm 1: In ấn hóa đơn POS & Sự cố phần cứng máy in

#### Vấn đề thực tế
Máy in nhiệt (Epson, Xprinter, Bixolon) kết nối qua mạng LAN (IP), USB hoặc Bluetooth tại quầy thu ngân thường xuyên gặp sự cố: hết cuộn giấy K80 giữa giờ cao điểm, kẹt giấy trong dao cắt tự động, hoặc đứt cáp mạng LAN. Nếu giao dịch thanh toán (checkout) gắn chặt đồng bộ với tác vụ in, khi máy in lỗi thì giao dịch thanh toán sẽ bị treo hoặc bị rollback sai lệch dù khách đã quẹt thẻ thành công. Ngoài ra, việc in lại hóa đơn (Bill Reprint) là kẽ hở gian lận lớn nhất của thu ngân nếu không có cơ chế watermark và phê duyệt của quản lý.

#### Quy tắc nghiệp vụ và Giải pháp kỹ thuật
1. **Bất đồng bộ hóa (Asynchronous Decoupling)**: Tách rời hoàn toàn giao dịch thanh toán và tác vụ in ấn. Đơn hàng chuyển sang `PAID` ngay khi tiền được ghi nhận thành công, tuyệt đối KHÔNG rollback đơn vì lý do máy in lỗi.
2. **Hàng đợi in Spooler & Retry Queue**: Lệnh in được lưu vào hàng đợi cục bộ. Driver thăm dò cờ `DLE EOT n` của máy in. Nếu phát hiện Paper-End hoặc Jam, hệ thống chuyển trạng thái `RETRYING`, tự động thử lại 3 lần với khoảng cách 3s - 5s - 10s. Sau 3 lần thất bại, cho phép chuyển hướng sang máy in phụ (`Failover Routing`) hoặc gửi E-Receipt qua QR/SMS.
3. **Phân định Phiếu pha chế (KOT) vs Hóa đơn khách (Bill)**: Đồ uống gửi máy in Barista/Tem ly (50x30mm không in giá tiền); Đồ ăn gửi máy in Bếp; Hóa đơn tài chính gửi máy in Bill quầy. Khi khách gọi thêm món lần $k \ge 2$, hệ thống chỉ in **KOT vi sai** cho các món mới gọi thêm, cấm in lại món cũ để tránh Barista pha trùng lãng phí.
4. **Kiểm soát In lại hóa đơn (Bill Reprint)**: Bản gốc in tự động DUY NHẤT 1 LẦN. Mọi lần in lại bắt buộc phải có dòng chữ in hoa cực lớn `*** BẢN SAO / REPRINT - LẦN N ***`, ghi rõ nhân viên yêu cầu và thời gian. Bắt buộc Quản lý ca nhập **mã PIN 6 số** và chọn lý do. Hệ thống khóa tài khoản thu ngân và cảnh báo bảo mật nếu in lại quá 3 lần/ca.
5. **Phục hồi in dở dang**: Khi máy in hết giấy giữa trang, hủy tác vụ dở dang (`ABORTED_PARTIAL`), nạp giấy mới in lại TOÀN BỘ hóa đơn có nhãn "BẢN IN THAY THẾ". Mẩu giấy rách thu hồi gạch chéo lưu hồ sơ đối soát.

---

### 3.2 Nhóm 2: Quản lý bàn ăn & Phục vụ tại chỗ (Dine-in)

#### Vấn đề thực tế
Khách dùng tại chỗ đòi hỏi sự linh hoạt tối đa: khách chuyển bàn tìm chỗ có máy lạnh hoặc ổ cắm sạc laptop, gộp bàn khi nhóm bạn đến đông, tách hóa đơn trả tiền riêng, hoặc đặt bàn trước có đặt cọc. Nếu hệ thống từ chối các nghiệp vụ này, nhân viên sẽ thao tác thủ công, dẫn đến thất lạc đơn hàng, Barista bưng nước nhầm bàn và thất thoát chiết khấu.

#### Quy tắc nghiệp vụ và Giải pháp kỹ thuật
1. **Máy trạng thái bàn hữu hạn thời gian thực (Real-time Table FSM)**: Mỗi bàn thuộc 1 trong 6 trạng thái:
   - `AVAILABLE`: Bàn trống sạch sẽ.
   - `RESERVED`: Đã có khách đặt hẹn, tự động khóa trước 30 phút.
   - `OCCUPIED`: Đang có khách ngồi, liên kết với 1 Tab đơn hàng mở.
   - `BILL_PRINTED`: Đã in phiếu tạm tính, đang chờ thanh toán.
   - `CLEANING`: Khách đã thanh toán rời đi, bàn đang dọn dẹp vệ sinh.
   - `OUT_OF_SERVICE`: Bàn ghế hỏng hóc hoặc khu vực sửa chữa.
2. **Chuyển bàn nguyên tử (Atomic Table Move)**: Bàn nguồn phải `OCCUPIED`, bàn đích bắt buộc `AVAILABLE`. Hệ thống áp dụng khóa `SELECT FOR UPDATE` trên bàn đích, hoán chuyển mã bàn trên Tab đơn hàng, đưa bàn nguồn về `CLEANING` và bắn sự kiện WebSocket `TABLE_MOVED` cập nhật tức thì màn hình KDS của Barista.
3. **Gộp bàn (Table Merging)**: Chọn 1 Master Order và 1 Slave Order. Chuyển toàn bộ dòng món và tiền cọc từ Đơn 2 sang Đơn 1. Voucher của Đơn 2 bị hủy hoàn trả ví khách; Voucher Đơn 1 được tính lại theo tổng tiền mới. Đơn 2 chuyển trạng thái `MERGED_VOID`.
4. **Tách bàn / Tách hóa đơn (Split Bill)**:
   - *Tách theo món*: Tạo đơn con mới. Nếu đơn gốc giảm dưới Min Spend của voucher thì TỰ ĐỘNG HỦY VOUCHER trên đơn gốc và tính lại giá chuẩn.
   - *Tách chia đều (Dutch Treat)*: Giữ nguyên 1 Order, chia tổng tiền thành $N$ biên lai thanh toán riêng theo thuật toán đồng dư lớn nhất (Largest Remainder). Tổng tiền các biên lai khớp đúng 100% không lệch 1 đồng.
5. **Ân hạn đặt bàn & Tịch thu cọc No-show**: Khóa bàn trước 30 phút ($T-30m$). Ân hạn giữ bàn tối đa 15 phút ($T+15m$). Quá 15 phút khách không check-in, bàn tự động chuyển về `AVAILABLE` đón khách vãng lai, đơn chuyển `NO_SHOW_FORFEITED`, kế toán tự động tịch thu 100% tiền cọc vào tài khoản Thu nhập khác TK 711.

---

### 3.3 Nhóm 3: Quản lý ca làm việc & Vận hành xuyên ngày (Cross-day)

#### Vấn đề thực tế
Cửa hàng 24/7 hoặc mở muộn có ca đêm vận hành từ 22:00 hôm trước đến 06:00 sáng hôm sau (vắt qua mốc nửa đêm 00:00). Nếu phần mềm tự động chốt sổ doanh thu và reset két tiền lúc 00:00, số liệu ca đêm sẽ bị xé đôi, trách nhiệm tiền mặt của thu ngân bị chia cắt và không thể đối soát khi bàn giao ca sáng. Ngoài ra, tiền mặt tích tụ lớn trong két tạo rủi ro an ninh nghiêm trọng.

#### Quy tắc nghiệp vụ và Giải pháp kỹ thuật
1. **Phân định Ngày kinh doanh (businessDate) vs Ngày lịch (calendarDate)**: Mọi đơn hàng, phiếu thu tiền mặt và tiêu hao nguyên liệu phát sinh từ 22:00 ngày D đến 06:00 ngày D+1 đều gắn chặt với `businessDate = D` của ca đêm đó. Két tiền duy trì trạng thái `OPEN` liên tục qua nửa đêm, không bị ngắt lúc 00:00.
2. **Cơ chế Chốt sổ kép (Midnight Snapshot)**: Phục vụ báo cáo thuế cuối tháng: Tự động phân bổ doanh thu phát sinh trước 23:59:59 vào tháng cũ và sau 00:00:01 vào tháng mới trên sổ cái tài chính pháp định mà không làm gián đoạn ca làm việc vật lý của thu ngân.
3. **Kiểm tiền mù (Blind Cash Count) & 3 Ngưỡng dung sai**: Khi đóng ca, màn hình POS ẩn hoàn toàn số tiền sổ sách hệ thống. Thu ngân bắt buộc đếm thực tế từng tờ tiền theo bảng kê mệnh giá (500k đến 1k). Hệ thống tính chênh lệch $\Delta = Actual - Expected$:
   - *Cấp 1 ($|\Delta| \le 20.000\text{đ}$)*: Tự động ghi nhận vào Chi phí/Thu nhập làm tròn tiền lẻ (TK 642/711), đóng ca bình thường.
   - *Cấp 2 ($20.000\text{đ} < |\Delta| \le 100.000\text{đ}$)*: Đếm lại lần 2 + giải trình lý do + PIN Quản lý ca duyệt đóng ca.
   - *Cấp 3 ($|\Delta| > 100.000\text{đ}$)*: Khóa đóng ca thường. Bắt buộc Quản lý cửa hàng cùng kiểm đếm, lập Biên bản kiểm quỹ bất thường điện tử (`CashDiscrepancyReport`) có chữ ký hai bên; khoản thiếu trừ lương thu ngân.
4. **Rút tiền giữa ca (Cash Drop)**: Khi tiền mặt trong hộc vượt 5.000.000đ, POS cảnh báo vàng. Thu ngân và Quản lý thực hiện xác thực kép, rút bớt tiền bỏ phong bì niêm phong ghi mã vạch `EnvelopeBarcode`, bỏ vào khe két sắt an toàn (Drop Safe). In 2 liên biên nhận: 1 liên bỏ phong bì, 1 liên giữ trong hộc để trừ expected cash.
5. **Đóng ca khẩn cấp (Emergency Force Close)**: Khi mất điện toàn phần hoặc thiên tai, Quản lý kích hoạt đóng ca cưỡng chế `FORCED_CLOSED`. Đóng băng toàn bộ giao dịch đã commit; đơn đang dở dang chuyển `INCIDENT_ABORTED` và tự động hoàn tiền online 100%; tiền két niêm phong thủ công bằng văn bản giấy.

---

### 3.4 Nhóm 4: Khuyến mãi, Voucher sinh nhật & Điểm thành viên

#### Vấn đề thực tế
Chương trình khuyến mãi sinh nhật có giá trị cao thường bị trục lợi bằng cách đổi ngày sinh liên tục hoặc tạo tài khoản ảo. Việc khách áp dụng đồng thời nhiều loại ưu đãi (giảm giá món, voucher hóa đơn, mã ship, điểm thưởng) nếu không có quy tắc xếp chồng sẽ dẫn đến giảm giá âm, bán dưới giá thành sản xuất. Ngoài ra, việc voucher hết hạn trong lúc khách đang nhập OTP ngân hàng cũng gây tranh chấp gay gắt.

#### Quy tắc nghiệp vụ và Giải pháp kỹ thuật
1. **Voucher Sinh Nhật KYC & Chống trục lợi**:
   - Ngày sinh phải đăng ký trước ngày sinh nhật ít nhất **30 ngày**.
   - Ngày sinh chỉ được chỉnh sửa tối đa **1 lần duy nhất** trong suốt vòng đời tài khoản (sửa lần 2 bắt buộc xuất trình CCCD cho CSKH).
   - Voucher chỉ có hạn trong tháng sinh ($01/M$ đến cuối tháng $M$).
   - Tại quầy POS: Màn hình bắt buộc thu ngân đối chiếu CCCD/VNeID trùng khớp tên và ngày sinh thì voucher mới có hiệu lực giảm giá.
2. **Ma trận Xếp chồng Ưu đãi 4 cấp bậc (4-Tier Stacking Matrix)**:
   - *Cấp 1 (`ITEM_DISCOUNT`)*: Giảm giá trực tiếp từng món (Happy Hour, Flash Sale).
   - *Cấp 2 (`ORDER_DISCOUNT`)*: Voucher giảm giá trên tổng tiền món ăn (áp dụng trên phần nguyên giá).
   - *Cấp 3 (`SHIPPING_DISCOUNT`)*: Mã miễn giảm phí vận chuyển.
   - *Cấp 4 (`LOYALTY_POINTS`)*: Điểm thành viên trừ trên số tiền còn lại sau khi đã trừ Cấp 1, 2, 3.
   - Cùng cấp không cộng dồn (chỉ 1 voucher đơn + 1 mã ship).
   - **Ràng buộc Giá sàn bảo vệ giá vốn (Floor Price)**: Tổng mức giảm tối đa không vượt quá **80%** giá trị đơn hàng; thực thu tối thiểu $\ge 5.000\text{đ}$.
3. **Khóa giữ Voucher có thời hạn (Voucher Reservation TTL 15 phút)**: Khi bấm "Thanh toán", voucher chuyển sang `RESERVED` trong 15 phút. Quyền lợi ưu đãi được bảo lưu trọn vẹn kể cả khi trong 15 phút đó đồng hồ đã chạy qua hạn chót của chiến dịch. Quá 15 phút không thanh toán, voucher tự động giải phóng `RELEASED`.
4. **Tích điểm Net chi tiêu & Hoàn trả ưu đãi**: Chỉ tích điểm trên số tiền khách tự bỏ tiền túi ra trả (`Net Out-of-pocket`), không tích điểm trên tiền voucher và điểm cũ. Khi hủy đơn toàn bộ: hoàn 100% tiền, 100% điểm và khôi phục voucher `ACTIVE` (gia hạn thêm 24h nếu voucher hết hạn trong lúc chờ phục vụ).

---

### 3.5 Nhóm 5: Xuất hủy nguyên liệu & Sự cố bảo quản nhiệt độ

#### Vấn đề thực tế
Sữa tươi thanh trùng, kem béo thực vật, sữa chua bắt buộc bảo quản lạnh từ $2^\circ\text{C}$ đến $6^\circ\text{C}$. Khi tủ mát hỏng lốc hoặc mất điện kéo dài quá 2 giờ trong đêm, nguyên liệu bị biến chất. Nếu nhân viên sáng hôm sau không hay biết, tiếp tục đem pha chế sẽ gây ngộ độc thực phẩm hàng loạt. Ngược lại, nếu quy trình xuất hủy lỏng lẻo, nhân viên có thể thông đồng tuồn nguyên liệu ra ngoài bán rồi báo hỏng do mất điện.

#### Quy tắc nghiệp vụ và Giải pháp kỹ thuật
1. **Giám sát Nhiệt độ & Tự động Cách ly Lô (QUARANTINED)**: Tủ mát có dải an toàn $2^\circ\text{C} - 6^\circ\text{C}$ (ngưỡng cảnh báo $> 8^\circ\text{C}$). Nếu nhiệt độ $> 8^\circ\text{C}$ liên tục quá 120 phút (hoặc mất điện $> 2$ giờ): Hệ thống phát còi báo động đỏ trên POS, chuyển toàn bộ các lô nguyên liệu nhạy cảm lạnh trong tủ đó sang trạng thái `QUARANTINED` (Cách ly kiểm định chất lượng).
2. **Khóa bán tự động trên Menu (OUT_OF_STOCK Lock)**: Ngay khi lô nguyên liệu bị `QUARANTINED`, hệ thống tự động quét công thức và chuyển toàn bộ các món đồ uống có dùng nguyên liệu này (Latte, Cappuccino, Trà sữa tươi) sang trạng thái `OUT_OF_STOCK` trên cả Website và POS quầy, ngăn chặn triệt để nguy cơ pha chế nguyên liệu hỏng.
3. **Quy trình Xuất hủy khẩn cấp có 2 Ảnh hiện trường**: Mọi hao hụt bất thường đều phải lập `InventoryDisposalVoucher` ghi rõ lô. Ứng dụng bắt buộc nhân viên mở camera chụp trực tiếp 2 ảnh:
   - *Ảnh 1*: Cận cảnh tem nhãn lô (`lotCode`) và hạn sử dụng sản phẩm.
   - *Ảnh 2*: Toàn cảnh hiện trường đổ bỏ nguyên liệu vào bồn rửa/thùng rác trước mặt Quản lý.
4. **Phân quyền Phê duyệt Đa cấp 3 hạn mức**:
   - Giá trị tổn thất $\le 300.000\text{đ}$: Quản lý ca (Supervisor) duyệt tại chỗ.
   - $300.000\text{đ} - 2.000.000\text{đ}$: Quản lý trưởng cửa hàng (Store Manager) duyệt.
   - $> 2.000.000\text{đ}$: Bắt buộc Giám đốc Vận hành khu vực (Area Operations Manager - OM) duyệt điện tử.
5. **Hạch toán Tổn thất Kho tách biệt Giá vốn COGS**: Hao hụt chế biến bình thường hạch toán vào Giá vốn hàng bán (TK 632). Tổn thất do hỏng tủ mát/mất điện bắt buộc hạch toán vào **Chi phí khác TK 811** hoặc Chi phí quản lý TK 642, trừ tồn kho chính xác theo lô nhập FEFO nguyên thủy, bảo vệ chỉ số Food Cost % của quầy bar không bị méo mó.

---

### 3.6 Nhóm 6: Các kịch bản biên vận hành khác

#### 1. Hủy món trong quá trình pha chế & Tái phân bổ ly nước (Reassign Cup)
- *Chưa pha (`QUEUED`)*: Hủy hoàn tiền 100%, giải phóng nguyên liệu.
- *Đang pha (`IN_PROGRESS`)*: Dừng pha ngay. Lỗi quán hoàn 100%; khách đổi ý trừ phí hoặc duyệt PIN Quản lý ca hủy thiện chí.
- *Đã pha xong (`READY`)*: Không hủy tự do. Barista kiểm tra hàng đợi pha chế: Nếu có đơn hàng sau gọi đúng món (cùng size, đường, đá, topping), Barista bấm `REASSIGN_CUP` để chuyển ly nước sang phục vụ ngay cho đơn sau! Cửa hàng không bị mất ly nước. Nếu không có đơn sau, đổ bỏ ly nước và ghi sổ `DrinkWasteLog`.

#### 2. Trả hàng, Hủy hóa đơn (Void) và Phân loại nhập kho
- `POST_PAYMENT_VOID`: Áp dụng trong vòng **10 phút** kể từ lúc thanh toán khi đồ chưa pha. Đảo giao dịch thẻ/ví điện tử không mất phí cổng; hủy đơn hoàn toàn.
- **Phân loại hiện vật hoàn trả**:
  - Hàng hóa đóng gói bán lẻ (ly giữ nhiệt, bình nước, cà phê gói) nguyên seal niêm phong $\rightarrow$ Quản lý kiểm tra cho phép `RESTOCK_AVAILABLE` (Nhập lại kho bán lẻ).
  - Đồ uống tươi pha chế và bánh tươi đã bóc vỏ $\rightarrow$ **TUYỆT ĐỐI CẤM NHẬP LẠI KHO**, bắt buộc ghi nhận xuất hủy chất lượng (`QUALITY_DISPOSAL`). Thu hồi điểm tích lũy; nếu thiếu điểm ghi nợ điểm `PointsDebt` bù trừ lần mua sau.

#### 3. Chế độ POS Ngoại tuyến (Offline POS Mode) & Ưu tiên tại quầy
- Mất mạng cáp quang Internet: POS tự động chuyển sang chế độ Offline Mode.
- Cho phép: Bán hàng tiền mặt, in hóa đơn tạm tính/KOT mạng LAN nội bộ, tối đa 500 đơn hoặc 30 triệu đồng/phiên.
- Đơn hàng offline được lưu vào SQLite cục bộ, gắn mã `[Branch]-POS01-OFF-[Seq]` và ký số điện tử HMAC SHA-256 bằng secret key phần cứng.
- Khi có mạng lại: POS Agent kích hoạt Background Sync đẩy đơn FIFO lên server.
- **Xử lý xung đột hết hàng**: Nếu đơn quầy offline bán hết các chai sữa hạt cuối cùng trùng với lúc đơn Web online đặt mua, hệ thống áp dụng nguyên tắc **ƯU TIÊN KHÁCH TẠI QUẦY (Physical Store Priority)**: Chấp thuận đơn quầy ghi sổ kho; Đơn Web online bị đánh dấu xung đột `STOCK_OUT_CONFLICT_REJECTED`, tự động hoàn tiền 100% kèm voucher đền bù 20%.

#### 4. Thanh toán Kết hợp Đa phương thức (Split Payment / Mixed Tender)
- Cho phép 1 đơn hàng thanh toán bằng nhiều nguồn tiền theo trình tự: Điểm/Voucher $\rightarrow$ Cổng ví MoMo/VNPAY $\rightarrow$ Quẹt thẻ ngân hàng $\rightarrow$ Tiền mặt thu cuối cùng.
- Đơn hàng chỉ chuyển `PAID` khi `remainingBalance == 0`.
- **Hủy dở dang an toàn (Graceful Abort)**: Nếu khách đã trừ 50k điểm và 200k MoMo thành công nhưng đến bước quẹt thẻ bị lỗi và khách không còn tiền mặt, thu ngân bấm "Hủy giao dịch dở dang": Hệ thống tự động kích hoạt API Refund hoàn 200k về ví MoMo và hoàn 50k điểm về ví khách, hủy đơn an toàn, không làm lệch sổ quỹ.

---

## 4. ĐỀ XUẤT GIẢI PHÁP KIẾN TRÚC & QUY TRÌNH VẬN HÀNH CHUẨN

Để hiện thực hóa các giải pháp nghiệp vụ trên, kiến trúc hệ thống UTECoffe được bổ sung các thành phần kỹ thuật chuyên biệt:

```
+-----------------------------------------------------------------------------------+
|                           KIẾN TRÚC HỆ THỐNG MỞ RỘNG                              |
+-----------------------------------------------------------------------------------+
|  [POS Client / Tablet]            [Barista KDS Screen]        [Web/Mobile Customer]|
|        |                                   ^                           |          |
|        | WebSocket STOMP                   | WebSocket Events          | HTTPS    |
|        v                                   |                           v          |
|  +-----------------------------------------------------------------------------+  |
|  |                           SPRING BOOT 4.1 APPLICATION                       |  |
|  |  +---------------------+  +---------------------+  +---------------------+  |  |
|  |  | Print Spooler Queue |  | Real-time Table FSM |  | 4-Tier Pricing     |  |  |
|  |  | & Retry Failover    |  | Engine (Move/Merge) |  | & Floor Price 80%   |  |  |
|  |  +---------------------+  +---------------------+  +---------------------+  |  |
|  |  +---------------------+  +---------------------+  +---------------------+  |  |
|  |  | Business Date &     |  | Cold Storage IoT    |  | Multi-Tender Split  |  |  |
|  |  | Blind Cash Count    |  | & Quarantine Engine |  | Payment Engine      |  |  |
|  |  +---------------------+  +---------------------+  +---------------------+  |  |
|  +-----------------------------------------------------------------------------+  |
|        |                                   |                           |          |
|        v                                   v                           v          |
|  [PostgreSQL 17 Database]         [IoT Chiller Sensor]       [Thermal Printers]   |
|  - pos_printer_devices            - ESP32 / Modbus           - Bill Printer (LAN) |
|  - print_jobs                     - Temp threshold > 8°C     - Barista KOT/Tem    |
|  - restaurant_tables              - Auto-quarantine batch    - Failover Backup    |
|  - table_reservations                                                             |
|  - cashier_shifts                                                                 |
|  - cash_discrepancy_reports                                                       |
|  - cold_storage_units                                                             |
|  - inventory_disposal_vouchers                                                    |
|  - drink_waste_logs                                                               |
+-----------------------------------------------------------------------------------+
```

---

## 5. DANH MỤC CÁC MỤC BỔ SUNG KẾ THỪA MÃ TIẾP NỐI

### 5.1 Danh mục 25 Quy tắc nghiệp vụ mới (BR-41 đến BR-65)

| Mã BR | Tên quy tắc nghiệp vụ | Phạm vi | Sự kiện kích hoạt | Tuyên bố quy tắc nghiệp vụ (Rule Statement) | Chế tài & Ràng buộc vi phạm |
|---|---|---|---|---|---|
| **BR-41** | Bất đồng bộ hóa giao dịch thanh toán và in ấn POS | Quầy bán, Phần cứng | Thu ngân bấm "Hoàn tất thanh toán" | Giao dịch chuyển `PAID` độc lập với máy in; lệnh in vào Spooler Queue. Thăm dò `DLE EOT`, retry 3 lần (3s-5s-10s); lỗi cho phép failover máy in phụ hoặc gửi E-receipt. | Cấm tuyệt đối rollback đơn hàng vì lý do máy in hết giấy/kẹt giấy. |
| **BR-42** | Phân định KOT/Tem nhãn ly vs Hóa đơn khách | Quầy Bar, Bếp, Quầy | Tạo đơn hoặc thêm món mới | Đồ uống gửi máy in Barista/Tem ly (50x30mm không in giá); Thức ăn gửi Bếp; Hóa đơn gửi máy in Bill. Khi thêm món lần $k \ge 2$, chỉ in KOT bổ sung các món mới, cấm in lại món cũ. | In trùng món cũ gây lãng phí nguyên liệu; nhân viên chịu trách nhiệm hao hụt. |
| **BR-43** | Kiểm soát in lại hóa đơn (Bill Reprint) có Watermark | Thu ngân, Quản lý ca | Yêu cầu in lại bill đã thanh toán | Bản in lại bắt buộc có dòng chữ `*** BẢN SAO / REPRINT - LẦN N ***`, tăng `reprintCount`. Bắt buộc Quản lý ca nhập PIN 6 số và chọn lý do. Khóa tài khoản nếu in lại > 3 lần/ca. | In lại bill không có watermark hoặc không có PIN bị quy vào hành vi gian lận tài chính. |
| **BR-44** | Phục hồi in dở dang và tiêu hủy chứng từ rách | Phần cứng, Thu ngân | Máy in báo Paper-End / Jam giữa trang in | Hủy tác vụ dở dang (`ABORTED_PARTIAL`), nạp giấy mới in lại TOÀN BỘ hóa đơn có nhãn "BẢN IN THAY THẾ". Thu hồi mẩu giấy rách, gạch chéo lưu hồ sơ kiểm quỹ. | Bỏ qua mẩu rách bị phạt tiền quỹ cuối ca do không chứng minh được tiêu hao giấy in. |
| **BR-45** | Vòng đời và máy trạng thái quản lý bàn thời gian thực | Phục vụ, Thu ngân | Đổi trạng thái bàn tại cơ sở | Bàn chỉ thuộc 1 trong 6 trạng thái: `AVAILABLE`, `RESERVED`, `OCCUPIED`, `BILL_PRINTED`, `CLEANING`, `OUT_OF_SERVICE`. Đơn `COMPLETED` tự động chuyển bàn sang `CLEANING`; phục vụ dọn xong mới về `AVAILABLE`. | Cấm xếp khách mới vào bàn đang `CLEANING` hoặc bàn đang `RESERVED`. |
| **BR-46** | Chuyển bàn nguyên tử & Đồng bộ KDS Barista | Phục vụ, Quầy Bar | Khách yêu cầu đổi chỗ ngồi | Bàn nguồn phải `OCCUPIED`, bàn đích bắt buộc `AVAILABLE`. Khóa `SELECT FOR UPDATE` bàn đích. Chuyển `Order.tableId`, bàn nguồn sang `CLEANING`. Bắn tin WebSocket cập nhật KDS Barista tức thì. | Xung đột chuyển trùng bàn sẽ bị rollback toàn bộ giao dịch. |
| **BR-47** | Gộp bàn, hợp nhất đơn hàng và xử lý cọc/voucher | Phục vụ, Thu ngân | Hai nhóm khách nhập chung bàn | Chọn Master Order (Đơn 1) và Slave Order (Đơn 2). Chuyển toàn bộ dòng món và cọc từ Đơn 2 sang Đơn 1. Voucher của Đơn 2 bị hủy hoàn trả khách; voucher Đơn 1 tính lại theo ngưỡng mới. Đơn 2 chuyển `MERGED_VOID`. | Cấm gộp 2 voucher cấp đơn vào 1 hóa đơn gộp; vi phạm bị hệ thống từ chối commit. |
| **BR-48** | Tách bàn và tách hóa đơn (Theo món / Chia đều Dutch Treat) | Thu ngân, Quản lý ca | Khách yêu cầu thanh toán riêng | Tách theo món: tạo Child Order mới, nếu đơn gốc giảm dưới Min Spend của voucher thì TỰ ĐỘNG HỦY VOUCHER đơn gốc. Tách chia đều: 1 Order chia thành $N$ biên lai thanh toán riêng. Tổng tiền sau tách = đúng 100% đơn gốc. | Sai lệch số học dòng tiền khiến ca không thể đóng; kiểm toán truy cứu trách nhiệm. |
| **BR-49** | Thời gian ân hạn đặt bàn và tịch thu cọc No-show | Đặt bàn, Lễ tân | Quá giờ hẹn đặt bàn | Khóa bàn trước 30 phút ($T-30m$). Ân hạn giữ bàn tối đa 15 phút ($T+15m$). Sau $T+15m$ khách không check-in: Bàn tự động về `AVAILABLE`, đơn chuyển `NO_SHOW_FORFEITED`, tịch thu 100% cọc vào TK 711. | Hủy trước $\ge 2$ giờ hoàn 100% cọc; nhân viên tự ý hoàn cọc sau hạn phải đền bù tiền túi. |
| **BR-50** | Ca làm việc xuyên ngày và phân định Ngày kinh doanh | Thu ngân, Kế toán | Ca đêm (22:00 - 06:00) | Mọi đơn hàng, phiếu thu tiền và tiêu hao kho từ 22:00 ngày D đến 06:00 ngày D+1 đều gắn chặt với `businessDate = D`. Két tiền duy trì 1 ca `OPEN` duy nhất, không bị reset lúc 00:00 nửa đêm. | Xé đôi doanh thu ca đêm vào lúc nửa đêm sẽ làm sai lệch đối soát tiền mặt cuối ca. |
| **BR-51** | Chốt sổ doanh thu kép (Midnight Snapshot) cuối tháng | Kế toán, Quản trị | Đêm giao kỳ kế toán tháng | Duy trì 2 sổ đối chiếu: Sổ ca nội bộ gắn theo `shiftId`/`businessDate`; Sổ tài chính pháp định tự động tách doanh thu trước 23:59:59 vào tháng cũ và sau 00:00:01 vào tháng mới mà không ngắt ca thu ngân. | Báo cáo thuế sai lệch kỳ phát sinh chịu phạt chậm nộp thuế theo luật định. |
| **BR-52** | Kiểm tiền mù và 3 cấp độ dung sai chênh lệch tiền két | Thu ngân, Quản lý ca | Đóng ca làm việc (Shift Close) | Thu ngân bắt buộc đếm tiền theo bảng kê mệnh giá mà không được xem số dư sổ sách. Dung sai: Cấp 1 ($\le 20\text{k}$) tự động hạch toán làm tròn; Cấp 2 ($20\text{k}-100\text{k}$) đếm lại lần 2 + giải trình; Cấp 3 ($> 100\text{k}$) lập biên bản kiểm quỹ + trừ lương. | Khóa tính năng đóng ca bình thường nếu lệch Cấp 3 chưa có biên bản ký duyệt. |
| **BR-53** | Rút tiền giữa ca về két an toàn (Cash Drop) | Thu ngân, Quản lý cơ sở | Tiền mặt trong hộc két $> 5.000.000\text{đ}$ | Bắt buộc xác thực kép (Thu ngân + Quản lý). Bỏ tiền vào phong bì niêm phong ghi mã vạch `EnvelopeBarcode`, bỏ khe két Drop Safe. In 2 liên biên nhận: 1 bỏ phong bì, 1 giữ trong hộc tiền để trừ expected cash. | Để két vượt hạn mức bị kỷ luật an toàn kho quỹ; mất mát thu ngân chịu 100% thiệt hại. |
| **BR-54** | Đóng ca khẩn cấp (Emergency Force Close) do sự cố | Quản lý cơ sở, Admin | Mất điện toàn phần, thiên tai | Kích hoạt đóng ca cưỡng chế `FORCED_CLOSED` kèm mã sự cố. Niêm phong tiền két vật lý bằng văn bản giấy. Tự động chuyển đơn đang dở dang sang `INCIDENT_ABORTED` và hoàn tiền tự động 100% cho đơn online. | Cấm tiếp tục nhận đơn khi cơ sở gặp sự cố mất an toàn vận hành. |
| **BR-55** | Quy chế Voucher Sinh Nhật và xác minh KYC chống trục lợi | Marketing, Thu ngân | Đăng ký ngày sinh / Áp dụng voucher | Ngày sinh phải đăng ký trước ngày sinh $\ge 30$ ngày; chỉ sửa 1 lần duy nhất trong đời tài khoản. Voucher có hạn trong tháng sinh. Tại quầy, voucher giá trị cao bắt buộc thu ngân đối chiếu CCCD/VNeID. Cấm chuyển nhượng. | Nhân viên không kiểm CCCD để khách trục lợi voucher bị truy thu số tiền chiết khấu. |
| **BR-56** | Ma trận xếp chồng ưu đãi 4 cấp và Giá sàn bảo vệ giá vốn | Khách hàng, Giỏ hàng | Tính giá giỏ hàng / Checkout | 4 cấp: Item $\rightarrow$ Order $\rightarrow$ Shipping $\rightarrow$ Points. Cùng cấp không cộng dồn; khác cấp chỉ áp dụng voucher đơn trên phần nguyên giá. Tổng mức giảm không vượt quá **80%** giá gốc; thực thu tối thiểu $\ge 5.000\text{đ}$. | Bán dưới giá sàn hoặc chiết khấu âm bị hệ thống chặn commit giao dịch ngay lập tức. |
| **BR-57** | Khóa giữ Voucher trong phiên thanh toán (TTL 15 phút) | Checkout, Cổng thanh toán | Nhấn "Tiến hành thanh toán" | Trạng thái chuyển `RESERVED` với TTL 15 phút. Nếu cổng thanh toán trả về `PAID` trong 15 phút, ưu đãi được bảo lưu trọn vẹn kể cả khi qua giờ chốt campaign. Quá 15 phút không thanh toán tự động giải phóng `RELEASED`. | Tránh tranh chấp khi khách đang nhập OTP ngân hàng mà voucher bị người khác cướp. |
| **BR-58** | Tích điểm theo số tiền thực chi và hoàn trả điểm/voucher | Khách hàng, CSKH | Thanh toán đơn / Hủy hoàn tiền | Chỉ tích điểm trên số tiền tự bỏ ra thanh toán (Net Out-of-pocket). Tiền giảm từ voucher và điểm cũ không được tích điểm tiếp. Khi hủy toàn bộ: hoàn 100% tiền, 100% điểm và khôi phục voucher. Hoàn một phần: chia theo tỷ lệ snapshot. | Tích điểm vòng lặp bị hệ thống quét audit log thu hồi và phạt tài khoản vi phạm. |
| **BR-59** | Cảnh báo nhiệt độ tủ mát & Tự động cách ly lô (QUARANTINED) | Kho, Quầy Bar, Bếp | Nhiệt độ tủ mát $> 8^\circ\text{C}$ quá 120 phút | Kích hoạt còi báo động POS. Chuyển toàn bộ các lô nguyên liệu nhạy cảm lạnh trong tủ đó sang trạng thái `QUARANTINED`. Hệ thống tự động chuyển các món menu dùng nguyên liệu này sang `OUT_OF_STOCK` tức thì. | Đem nguyên liệu đã bị `QUARANTINED` ra pha chế bị sa thải ngay lập tức do vi phạm ATVSTP. |
| **BR-60** | Quy trình xuất hủy nguyên liệu khẩn cấp có 2 ảnh hiện trường | Quản lý kho, Quản lý | Xuất hủy nguyên liệu hỏng/sự cố | Tạo phiếu `InventoryDisposalVoucher` ghi rõ lô. Bắt buộc mở camera chụp trực tiếp 2 ảnh: Ảnh 1 (Cận cảnh tem lô + hạn dùng); Ảnh 2 (Toàn cảnh đổ bỏ vào bồn/thùng rác). Duyệt 3 cấp: Ca ($\le 300\text{k}$), Cửa hàng ($\le 2\text{tr}$), OM ($> 2\text{tr}$). | Không có ảnh hiện trường hợp lệ thì phiếu xuất hủy không thể duyệt; kế toán từ chối trừ tồn. |
| **BR-61** | Định khoản chi phí tổn thất bất thường vs Giá vốn hàng bán | Kế toán, Kho | Phê duyệt phiếu xuất hủy nguyên liệu | Hao hụt chế biến bình thường vào Giá vốn TK 632. Tổn thất do hỏng tủ mát/mất điện bắt buộc hạch toán vào Chi phí khác TK 811 hoặc Chi phí quản lý TK 642. Trừ kho chính xác theo lô nhập FEFO nguyên thủy. | Hạch toán sai bản chất chi phí làm sai lệch chỉ số Food Cost bị kỷ luật kế toán. |
| **BR-62** | Xử lý hủy món trong pha chế & Tái phân bổ ly nước (Reassign) | Thu ngân, Barista | Khách yêu cầu hủy món đã thanh toán | Chưa pha: hủy hoàn 100%. Đang pha: lỗi quán hoàn 100%, khách đổi ý trừ phí hoặc duyệt PIN. Đã pha xong: Barista kiểm queue, nếu có đơn sau cùng cấu hình thì bấm `REASSIGN_CUP` phục vụ ngay; không có thì đổ bỏ ghi `DrinkWasteLog`. | Tự ý hủy đơn bỏ túi tiền khi nước đã pha xong bị coi là hành vi trộm cắp tài sản chuỗi. |
| **BR-63** | Phân định Void trong 10 phút vs Phân loại nhập kho hoàn trả | Thu ngân, Quản lý ca | Khách khiếu nại trả hàng sau thanh toán | `VOID` chỉ áp dụng trong 10 phút đầu khi chưa pha. Hàng hóa đóng gói bán lẻ (ly, bình, gói cafe) nguyên seal được phép `RESTOCK_AVAILABLE`. Đồ uống tươi pha chế cấm tuyệt đối nhập kho (`QUALITY_DISPOSAL`). Thu hồi điểm; thiếu điểm ghi nợ `PointsDebt`. | Nhập lại đồ uống thừa vào kho bán lại bị tước giấy phép kinh doanh cơ sở. |
| **BR-64** | Chế độ POS Ngoại tuyến (Offline Mode) & Ưu tiên tại quầy | Thu ngân, Hệ thống POS | Mất mạng Internet tại cửa hàng | Cho phép bán hàng tiền mặt, in hóa đơn/KOT mạng LAN nội bộ, tối đa 500 đơn hoặc 30 triệu/phiên. Lưu SQLite có chữ ký HMAC SHA-256. Khi có mạng lại, đồng bộ FIFO; xung đột hết hàng với đơn Web: ƯU TIÊN ĐƠN QUẦY, đơn Web bị hủy hoàn tiền + đền voucher 20%. | Cố tình làm giả đơn offline hoặc can thiệp file SQLite bị khóa vĩnh viễn POS ID. |
| **BR-65** | Sổ cái thanh toán kết hợp nhiều hình thức (Split Payment) | Thu ngân, Khách hàng | Khách chia nhiều hình thức thanh toán | 1 Order có nhiều `PaymentTransaction`. Khấu trừ: Điểm/Voucher $\rightarrow$ Cổng điện tử $\rightarrow$ Thẻ POS $\rightarrow$ Tiền mặt. Chỉ `PAID` khi `remainingBalance == 0`. Nếu thất bại dở dang, bấm nút hủy tự động hoàn lại tiền các cổng đã thu và trả điểm. | Cấm thu tiền mặt đè lên giao dịch ví điện tử bị treo khi chưa có kết quả tra soát. |

---

### 5.2 Danh mục 30 Chức năng hệ thống mới (F-129 đến F-158)

| Mã F | Tên chức năng | Mô tả chức năng | Mức | Tác nhân / Vai trò | Tiêu chí nghiệm thu hoàn thành |
|---|---|---|---|---|---|
| **F-129** | Quản lý danh mục máy in POS | Khai báo thiết bị in (IP, port, USB, vai trò Bill/KOT/Tem ly, giấy K80/K58, máy in dự phòng) | **P1** | Quản lý cơ sở / IT | Gửi lệnh test in ra đúng cổng; tự động phát hiện trạng thái online/offline qua heartbeat. |
| **F-130** | Hàng đợi in Spooler & Retry Failover | Quản lý tác vụ in bất đồng bộ, tự động thử lại 3 lần khi lỗi và điều hướng sang máy in phụ | **P0** | Hệ thống / Thu ngân | Đơn `PAID` không bao giờ bị nghẽn; khi kẹt giấy pop-up báo đỏ tức thì; chuyển máy in phụ in ngay lập tức. |
| **F-131** | In KOT vi sai & Tem dán ly Barcode | Phân loại in bếp/bar và chỉ in món gọi thêm lần $k$; in tem nhãn ly kích thước chuẩn kèm mã vạch | **P0** | Thu ngân / Barista | Thêm 1 ly vào bàn cũ chỉ in 1 tem nhãn mới; tem nhãn chứa đầy đủ size, đường, đá, topping và mã ly. |
| **F-132** | In lại hóa đơn có Watermark & PIN Quản lý | Cho phép in bản sao hóa đơn, bắt buộc nhập PIN Quản lý ca, ghi nhận lý do và watermark BẢN SAO | **P0** | Thu ngân / Quản lý ca | Bản in lại có chữ BẢN SAO cỡ lớn, tăng `reprintCount`; cảnh báo kiểm toán khi 1 thu ngân in lại $> 3$ lần/ca. |
| **F-133** | Phục hồi in dở dang khi sự cố giấy | Tự động hủy tác vụ in rách/kẹt giữa trang, in lại toàn bộ bản thay thế và ghi log thu hồi mẩu rách | **P0** | Thu ngân / Hệ thống | Bản in mới có ghi chú "Bản in thay thế do kẹt giấy"; không bị đứt đoạn dòng món. |
| **F-134** | Sơ đồ bàn trực quan & FSM trạng thái | Hiển thị bản đồ bàn theo tầng/khu vực với 6 màu trạng thái; tự động chuyển trạng thái theo đơn hàng | **P1** | Phục vụ / Thu ngân | Thanh toán xong bàn tự đổi màu xám `CLEANING`; bấm hoàn tất dọn chuyển màu xanh `AVAILABLE`. |
| **F-135** | Thao tác Chuyển bàn nguyên tử | Chuyển đơn hàng từ bàn nguồn sang bàn đích trống và bắn thông báo WebSocket sang màn hình KDS Barista | **P1** | Phục vụ / Barista | Không bao giờ chuyển được vào bàn đang có khách; KDS Barista nhấp nháy thông báo đổi số bàn ngay lập tức. |
| **F-136** | Thao tác Gộp bàn & Hợp nhất đơn | Hợp nhất 2 đơn hàng tại 2 bàn vào 1 Master Order, kết chuyển cọc và hoàn trả voucher đơn phụ | **P1** | Quản lý ca / Thu ngân | Dòng món Đơn 2 chuyển sang Đơn 1; Đơn 2 đóng với trạng thái `MERGED_VOID`; voucher phụ được trả về ví khách. |
| **F-137** | Thao tác Tách bàn & Tách hóa đơn | Tách đơn thành nhiều đơn con theo món hoặc chia đều số tiền (Dutch Treat) thành $N$ biên lai | **P1** | Thu ngân / Quản lý ca | Tách món vi phạm Min Spend voucher tự hủy voucher; tách chia đều bảo đảm tổng tiền khớp 100% không lệch 1 đồng. |
| **F-138** | Đặt bàn, quản lý cọc & Hủy No-show | Nhận đặt bàn có tiền cọc, tự động gửi tin nhắc giờ, tự động giải phóng bàn sau 15 phút ân hạn và tịch thu cọc | **P1** | Lễ tân / Quản lý / Khách | Quá 15 phút không check-in bàn tự mở cho khách vãng lai; tiền cọc chuyển sang tài khoản thu nhập khác TK 711. |
| **F-139** | Mở và quản lý ca đêm xuyên ngày | Mở ca làm việc vắt qua mốc nửa đêm (22:00 - 06:00) gắn toàn bộ doanh thu với `businessDate` thống nhất | **P0** | Thu ngân / Quản lý ca | Đơn hàng phát sinh lúc 02:00 sáng vẫn mang đúng `businessDate` của ngày mở ca; két tiền không bị ngắt lúc 00:00. |
| **F-140** | Báo cáo chốt doanh thu kép Midnight Snapshot | Cung cấp 2 góc nhìn đối soát: Sổ ca nội bộ theo `shiftId` và Sổ tài chính pháp định cắt lát lúc 23:59:59 cuối tháng | **P1** | Kế toán / Quản trị chuỗi | Số liệu báo cáo thuế tháng khớp tuyệt đối với thời điểm giao thừa mà không làm xáo trộn ca làm việc của nhân viên. |
| **F-141** | Kiểm tiền mù cuối ca & Phân loại dung sai | Thu ngân nhập bảng kê đếm tiền mặt mà không thấy số dư sổ sách; hệ thống phân loại 3 cấp độ dung sai | **P0** | Thu ngân / Quản lý ca | Dung sai $\le 20\text{k}$ đóng ca tự động; $> 100\text{k}$ khóa màn hình đóng ca thông thường, bắt buộc lập biên bản. |
| **F-142** | Lập biên bản kiểm quỹ bất thường điện tử | Tạo biên bản giải trình chênh lệch tiền mặt Cấp 3, ghi nhận chữ ký điện tử hai bên và chế tài bồi hoàn | **P1** | Quản lý cơ sở / Kế toán | Biên bản lưu trữ không thể xóa sửa; đính kèm vào hồ sơ quyết toán kỳ lương của nhân viên thu ngân. |
| **F-143** | Rút tiền mặt giữa ca (Cash Drop) | Cảnh báo két tiền $> 5$ triệu; thực hiện rút tiền xác thực kép Quản lý + Thu ngân, in 2 liên biên nhận | **P0** | Thu ngân / Quản lý cơ sở | Expected Cash trong két tự động trừ đi số tiền đã rút nộp két an toàn; phong bì có mã niêm phong. |
| **F-144** | Cưỡng chế đóng ca khẩn cấp do sự cố | Chức năng đóng ca khẩn cấp `FORCED_CLOSED` khi mất điện/thiên tai, tự động hủy và hoàn tiền đơn dở dang | **P0** | Quản lý cơ sở / Admin | Toàn bộ đơn online đang chờ pha được tự động kích hoạt API hoàn tiền; doanh thu commit đến thời điểm đóng băng. |
| **F-145** | Quản lý và áp dụng Voucher Sinh Nhật | Khóa ngày sinh KYC, kiểm tra điều kiện đăng ký $\ge 30$ ngày, yêu cầu kiểm tra CCCD tại quầy POS | **P1** | Marketing / Thu ngân | Khách đổi ngày sinh lần 2 bị chặn; thu ngân phải tích chọn đã kiểm CCCD thì voucher sinh nhật mới có hiệu lực. |
| **F-146** | Bộ tính toán ma trận xếp chồng ưu đãi 4 cấp | Áp dụng ưu đãi theo thứ tự Item $\rightarrow$ Order $\rightarrow$ Shipping $\rightarrow$ Points; kiểm soát giá sàn 80% | **P0** | Hệ thống / Khách hàng | Chặn áp dụng 2 voucher cấp đơn cùng lúc; tổng chiết khấu không bao giờ vượt 80% giá gốc; không có đơn âm tiền. |
| **F-147** | Khóa giữ Voucher có thời hạn (TTL 15 phút) | Khóa voucher ở trạng thái `RESERVED` trong 15 phút của phiên thanh toán online, bảo lưu ưu đãi | **P0** | Hệ thống / Khách hàng | Khách thanh toán MoMo qua 00:00 vẫn được giảm giá; quá 15 phút không thanh toán tự động trả voucher về kho. |
| **F-148** | Tích điểm Net chi tiêu & Thuật toán hoàn trả | Tích điểm dựa trên số tiền thực trả bằng tiền túi; tự động hoàn trả điểm và voucher khi hủy đơn hoặc hoàn 1 phần | **P1** | Hệ thống / CSKH | Khách dùng voucher và điểm cũ không bị tích điểm kép; hủy đơn được trả lại nguyên vẹn điểm và khôi phục voucher. |
| **F-149** | Giám sát nhiệt độ kho lạnh & Cảnh báo vượt ngưỡng | Ghi nhận nhiệt độ tủ mát/tủ đông, cảnh báo khi $> 8^\circ\text{C}$ quá 120 phút và tự động đổi lô sang `QUARANTINED` | **P1** | Kho / Quản lý cơ sở | Màn hình POS báo động đỏ; lô sữa tươi tự động khóa cách ly trên hệ thống, không cho phép chọn pha chế. |
| **F-150** | Khóa bán tự động trên Menu khi nguyên liệu cách ly | Quét công thức món, tự động chuyển các món dùng nguyên liệu trong lô bị `QUARANTINED` sang `OUT_OF_STOCK` | **P0** | Hệ thống / Barista | Menu website và POS lập tức ẩn nút mua Latte, Cappuccino khi sữa tươi bị hỏng; chống bán hàng vượt tồn an toàn. |
| **F-151** | Lập phiếu xuất hủy nguyên liệu khẩn cấp có 2 ảnh | Tạo phiếu hủy kho, bắt buộc chụp 2 ảnh hiện trường từ camera (tem lô và đổ bỏ) và phê duyệt đa cấp theo hạn mức | **P0** | Quản lý kho / Quản lý cơ sở | Không chụp đủ 2 ảnh không thể gửi duyệt; vượt 2 triệu bắt buộc Giám đốc Vận hành (OM) duyệt điện tử. |
| **F-152** | Hạch toán chi phí tổn thất kho bất thường | Ghi nhận chi phí xuất hủy do hỏng tủ mát vào Chi phí khác TK 811 thay vì COGS; trừ tồn chính xác theo lô | **P1** | Kế toán / Quản lý kho | Báo cáo giá vốn bán hàng (Food Cost %) của quầy Bar không bị đội chi phí bất công do sự cố cháy lốc tủ lạnh. |
| **F-153** | Xử lý hủy món đang pha & Tái phân bổ ly nước | Hủy đơn theo 3 giai đoạn pha chế; chức năng `REASSIGN_CUP` chuyển ly nước đã pha sẵn cho đơn sau cùng cấu hình | **P0** | Thu ngân / Barista | Barista tái phân bổ thành công ly trà sữa cho khách sau, cửa hàng không bị mất ly nước; không tái phân bổ thì ghi waste log. |
| **F-154** | Hủy giao dịch (Void 10 phút) & Phân loại nhập kho | Hủy nhanh đảo giao dịch trong 10 phút; phân loại hàng hóa đóng gói được nhập kho vs đồ uống cấm nhập kho | **P0** | Thu ngân / Quản lý ca | Ly giữ nhiệt chưa dùng được nhập lại kho; ly trà sữa đã pha đổ bỏ bắt buộc ghi hao hụt; thiếu điểm ghi nợ điểm. |
| **F-155** | Vận hành POS Ngoại tuyến (Offline Mode) | Cho phép bán hàng tiền mặt khi đứt mạng Internet, lưu trữ IndexedDB/SQLite có ký số HMAC SHA-256 | **P1** | Thu ngân / POS Agent | Đứt mạng POS vẫn hoạt động trơn tru; hóa đơn in ra mang mã offline duy nhất; dữ liệu không bị can thiệp gian lận. |
| **F-156** | Đồng bộ đơn hàng ngoại tuyến & Ưu tiên quầy | Tiến trình đồng bộ nền FIFO khi có mạng lại; giải quyết xung đột hết hàng: ưu tiên đơn quầy, hủy hoàn tiền đơn Web | **P1** | POS Agent / Hệ thống | Toàn bộ 50 đơn offline đẩy lên server thành công không trùng lặp; đơn Web xung đột được tự động hoàn tiền + voucher đền bù. |
| **F-157** | Thanh toán kết hợp nhiều hình thức (Split Payment) | Cho phép thanh toán 1 đơn hàng bằng nhiều nguồn (Điểm + MoMo + Thẻ + Tiền mặt) đến khi số dư còn lại bằng 0 | **P0** | Thu ngân / Khách hàng | Hỗ trợ chia bill linh hoạt; mỗi giao dịch thành phần sinh 1 bản ghi `PaymentTransaction` độc lập và chuẩn xác. |
| **F-158** | Hủy giao dịch thanh toán kết hợp dở dang | Nút hủy giao dịch khi thanh toán dở dang thất bại; tự động gọi API hoàn tiền các cổng đã trừ và hoàn trả điểm | **P0** | Thu ngân / Hệ thống | Khách quẹt thẻ lỗi sau khi đã trừ MoMo: hệ thống hoàn lại ngay 200k về ví MoMo và trả lại điểm, hủy đơn an toàn. |

---

### 5.3 Danh mục 13 Luồng nghiệp vụ chi tiết mới (UC-29 đến UC-41)

- **UC-29**: Quản lý thiết bị in ấn POS, hàng đợi in Spooler và xử lý sự cố kẹt giấy/hết giấy (`F-129`, `F-130`, `F-131`, `F-133`).
- **UC-30**: In lại hóa đơn thanh toán với Watermark bản sao và xác thực PIN Quản lý ca (`F-132`).
- **UC-31**: Vận hành sơ đồ bàn, FSM bàn thời gian thực, Chuyển bàn, Gộp bàn và Tách hóa đơn (`F-134`, `F-135`, `F-136`, `F-137`).
- **UC-32**: Đặt bàn trực tuyến, thu cọc giữ chỗ, ân hạn 15 phút và tịch thu cọc No-show (`F-138`).
- **UC-33**: Mở và quản lý ca làm việc xuyên ngày, liên kết Ngày kinh doanh và rút tiền an toàn Cash Drop (`F-139`, `F-140`, `F-143`).
- **UC-34**: Đóng ca bằng kiểm tiền mù, phân loại dung sai chênh lệch và cưỡng chế đóng ca khẩn cấp (`F-141`, `F-142`, `F-144`).
- **UC-35**: Áp dụng Voucher Sinh Nhật có đối chiếu CCCD và tính toán ma trận xếp chồng ưu đãi 4 cấp (`F-145`, `F-146`).
- **UC-36**: Khóa giữ Voucher có thời hạn (TTL 15m) trong thanh toán và xử lý hoàn trả ưu đãi khi hủy đơn (`F-147`, `F-148`).
- **UC-37**: Giám sát nhiệt độ tủ bảo quản, tự động cách ly lô nguyên liệu và khóa bán menu (`F-149`, `F-150`).
- **UC-38**: Quy trình xuất hủy nguyên liệu khẩn cấp có bằng chứng chụp ảnh và phân quyền phê duyệt đa cấp (`F-151`, `F-152`).
- **UC-39**: Xử lý hủy món theo 3 giai đoạn pha chế, tái phân bổ ly nước và hủy giao dịch sau thanh toán (`F-153`, `F-154`).
- **UC-40**: Bán hàng ngoại tuyến khi mất mạng Internet, lưu trữ ký số và đồng bộ ưu tiên tại quầy (`F-155`, `F-156`).
- **UC-41**: Thanh toán 1 đơn hàng bằng nhiều hình thức và xử lý hủy giao dịch dở dang hoàn tiền (`F-157`, `F-158`).

---

### 5.4 Danh mục 43 Ca kiểm thử định danh mới (TC-149 đến TC-191)

| Mã TC | Mức | Mục tiêu kiểm thử | Quy tắc / Chức năng | Thao tác thực hiện | Kết quả mong đợi |
|---|---|---|---|---|---|
| **TC-149** | P0 | Kiểm tra in bill bất đồng bộ khi ngắt kết nối máy in | F-130, BR-41 | Rút cáp mạng máy in bill; thanh toán đơn hàng 85k | Đơn hàng lưu `PAID`, PrintJob lưu `FAILED`, pop-up cảnh báo hiện trên POS, không bị mất đơn. |
| **TC-150** | P0 | Kiểm tra cảm biến Paper-Out / Jam máy in POS | F-130, BR-41 | Mở nắp máy in bill lấy giấy ra ngoài, gửi lệnh in | POS nhận cờ Paper End, hiển thị cảnh báo đỏ, Spooler chuyển `RETRYING`. |
| **TC-151** | P0 | Kiểm tra Spooler tự động retry và Failover máy in phụ | F-130, BR-41 | Tắt nguồn Máy in 1, cấu hình Máy in 2 là backup | Hệ thống retry 3 lần thất bại, cho phép bấm chuyển Máy in 2 in thành công trọn vẹn. |
| **TC-152** | P0 | Kiểm tra in KOT vi sai cho món gọi thêm lần 2 | F-131, BR-42 | Bàn B02 đang có 2 ly cafe, nhập thêm 1 Trà đào | Máy in Barista chỉ in DUY NHẤT 1 phiếu cho Trà đào có tiêu đề "Bổ sung Lần 2". |
| **TC-153** | P0 | Kiểm tra in tem nhãn ly (Cup Sticker) Barcode | F-131, BR-42 | Đơn 3 ly: Ly 1 Trà sữa Ô long 50% đường 50% đá | Tem nhãn 50x30mm in rõ: Tên món, Size, Chi tiết tùy chỉnh, Ly 1/3, Barcode định danh ly. |
| **TC-154** | P0 | Kiểm tra in lại hóa đơn có Watermark và PIN Quản lý | F-132, BR-43 | Đơn đã thanh toán; Thu ngân bấm "In lại hóa đơn" | Yêu cầu PIN Quản lý; bill in ra có chữ `*** BẢN SAO / REPRINT - LẦN 1 ***`, `reprintCount = 1`. |
| **TC-155** | P0 | Kiểm tra cảnh báo gian lận in lại bill quá 3 lần/ca | F-132, BR-43 | Thu ngân 1 đã in lại 3 hóa đơn khác nhau, bấm in lần 4 | Khóa tính năng in lại của tài khoản, gửi cảnh báo bảo mật thời gian thực đến Store Manager. |
| **TC-156** | P0 | Kiểm tra phục hồi in dở dang và in lại bản thay thế | F-133, BR-44 | Đang in đơn 8 món thì cuộn giấy hết ở món thứ 3 | Tác vụ dở dang bị hủy; nạp giấy mới in lại toàn bộ 8 món với nhãn "BẢN IN THAY THẾ". |
| **TC-157** | P1 | Kiểm tra FSM máy trạng thái bàn thời gian thực | F-134, BR-45 | Bàn B04 đang `AVAILABLE`, tạo đơn, in tạm tính, trả tiền | Bàn đổi tuần tự: `AVAILABLE` $\rightarrow$ `OCCUPIED` $\rightarrow$ `BILL_PRINTED` $\rightarrow$ `CLEANING`. |
| **TC-158** | P1 | Kiểm tra chuyển bàn nguyên tử từ Bàn A sang Bàn B | F-135, BR-46 | Bàn A01 `OCCUPIED`, Bàn B02 `AVAILABLE`, Bàn C03 bận | Chuyển sang B02 thành công, A01 chuyển `CLEANING`. Chuyển sang C03 báo lỗi `TABLE_BUSY`. |
| **TC-159** | P1 | Kiểm tra đồng bộ thông báo chuyển bàn sang KDS | F-135, BR-46 | Đơn hàng đang pha trên màn hình KDS Barista | Thực hiện chuyển bàn trên POS; KDS Barista nhấp nháy dòng thông báo vàng cập nhật số bàn mới. |
| **TC-160** | P1 | Kiểm tra gộp bàn và hợp nhất đơn hàng | F-136, BR-47 | Bàn 1 (150k + voucher 20k), Bàn 2 (100k + voucher 15k) | Món Bàn 2 nhập vào Bàn 1; voucher Bàn 2 hoàn lại ví; Đơn 2 chuyển `MERGED_VOID`. |
| **TC-161** | P1 | Kiểm tra tách hóa đơn theo món và hủy voucher vi phạm | F-137, BR-48 | Đơn 300k dùng voucher giảm 50k cho đơn từ 250k | Tách 2 món 120k sang đơn mới; đơn gốc còn 180k < 250k $\rightarrow$ voucher tự động bị hủy. |
| **TC-162** | P1 | Kiểm tra tách hóa đơn chia đều Dutch Treat | F-137, BR-48 | Đơn bàn 600.000đ; nhóm 3 người yêu cầu chia đều | Sinh đúng 3 biên lai 200k; đơn chỉ `COMPLETED` khi cả 3 biên lai thanh toán thành công. |
| **TC-163** | P1 | Kiểm tra tự động giải phóng bàn đặt trước No-show | F-138, BR-49 | Bàn VIP đặt hẹn 19:00, cọc 200k, đồng hồ đến 19:16 | Bàn tự động chuyển về `AVAILABLE`, đơn đặt bàn chuyển `NO_SHOW_FORFEITED`. |
| **TC-164** | P1 | Kiểm tra hạch toán tịch thu tiền cọc đặt bàn | F-138, BR-49 | Đơn đặt bàn bị No-show quá hạn | Tự động tạo bút toán chuyển 200k từ TK 3386 sang TK 711 (Thu nhập khác) có mã tham chiếu. |
| **TC-165** | P0 | Kiểm tra ca đêm xuyên ngày gắn businessDate | F-139, BR-50 | Mở ca lúc 22:00 ngày 19/11; Bán đơn lúc 01:30 ngày 20/11 | Đơn hàng mang `businessDate = 2026-11-19`, két tiền không bị reset lúc 00:00. |
| **TC-166** | P1 | Kiểm tra chốt sổ kép Midnight Snapshot cuối tháng | F-140, BR-51 | Ca đêm vắt qua đêm 31/10 sang 01/11 | Doanh thu trước 23:59:59 vào tháng 10; sau 00:00:01 vào tháng 11; tổng ca đóng lúc 06:00 khớp. |
| **TC-167** | P0 | Kiểm tra kiểm tiền mù (Blind Cash Count) khi đóng ca | F-141, BR-52 | Két tiền có 3.500.000đ theo hệ thống | Màn hình ẩn số 3.500.000đ, chỉ hiện bảng kê mệnh giá tiền bắt buộc đếm thực tế. |
| **TC-168** | P0 | Kiểm tra xử lý dung sai chênh lệch két Cấp 1 (<= 20k) | F-141, BR-52 | Expected = 3.500.000đ; Thực đếm = 3.490.000đ (lệch 10k) | Tự động ghi nhận chênh lệch vào chi phí làm tròn TK 642, hoàn tất đóng ca bình thường. |
| **TC-169** | P0 | Kiểm tra xử lý dung sai két Cấp 3 (> 100k) khóa đóng ca | F-141, F-142, BR-52 | Expected = 3.500.000đ; Thực đếm = 3.300.000đ (thiếu 200k) | Khóa đóng ca thường; bắt buộc Quản lý cùng ký Biên bản kiểm quỹ bất thường điện tử. |
| **TC-170** | P0 | Kiểm tra cảnh báo két tiền > 5 triệu và Cash Drop | F-143, BR-53 | Két thu tiền đạt 6.500.000đ; thực hiện Cash Drop 4.000.000đ | Cảnh báo vàng xuất hiện; xác thực kép Quản lý + Thu ngân; in 2 liên phiếu; expected cash còn 2.500k. |
| **TC-171** | P0 | Kiểm tra đóng ca cưỡng chế khẩn cấp (Emergency Close) | F-144, BR-54 | Cửa hàng đột ngột mất điện toàn phần | Ca chuyển `FORCED_CLOSED`; đơn đang pha chuyển `INCIDENT_ABORTED` và tự động hoàn tiền online. |
| **TC-172** | P1 | Kiểm tra Voucher Sinh Nhật khóa KYC 30 ngày | F-145, BR-55 | Khách đăng ký ngày sinh 25/11 vào ngày 15/11 (trước 10 ngày) | Không được cấp voucher sinh nhật vì đăng ký chưa đủ 30 ngày; chặn tạo tài khoản nhận quà ngay. |
| **TC-173** | P1 | Kiểm tra bắt buộc đối chiếu CCCD tại quầy cho Voucher SN | F-145, BR-55 | Khách áp dụng Voucher Sinh Nhật tặng ly nước 65k | POS bắt buộc hiển thị hộp thoại đối chiếu CCCD; thu ngân phải tích chọn xác nhận mới áp dụng được. |
| **TC-174** | P0 | Kiểm tra ma trận xếp chồng ưu đãi và Giá sàn 80% | F-146, BR-56 | Đơn 100k; cố tình áp 2 voucher cấp đơn (30k + 20k) | Từ chối voucher thứ 2; thử áp voucher làm giá < 20% giá gốc bị chặn commit giao dịch. |
| **TC-175** | P0 | Kiểm tra khóa giữ Voucher TTL 15 phút qua nửa đêm | F-147, BR-57 | Voucher hết hạn 23:59; Khách checkout MoMo lúc 23:58 | Voucher được bảo lưu ưu đãi trong 15 phút TTL; đơn thanh toán xong lúc 00:02 thành công `PAID`. |
| **TC-176** | P0 | Kiểm tra giải phóng voucher khi hết hạn TTL 15 phút | F-147, BR-57 | Khách checkout giữ voucher lúc 14:00 nhưng không trả tiền | Đến 14:16, Background Job tự động chuyển Voucher từ `RESERVED` về `RELEASED`. |
| **TC-177** | P1 | Kiểm tra tích điểm chỉ tính trên tiền Net Out-of-pocket | F-148, BR-58 | Đơn 200k = Voucher giảm 50k + Điểm cũ 30k + Tiền mặt 120k | Chỉ tích điểm trên 120k thực chi (12 điểm), không tích điểm trên 80k tiền voucher và điểm cũ. |
| **TC-178** | P1 | Kiểm tra hoàn trả 100% điểm và khôi phục voucher khi hủy | F-148, BR-58 | Đơn hàng ở TC-177 bị hủy toàn bộ trước khi pha | Hoàn lại 120k tiền mặt, hoàn trả 30.000 điểm về ví, khôi phục voucher 50k về trạng thái `ACTIVE`. |
| **TC-179** | P1 | Kiểm tra cảm biến tủ mát > 8°C tự động cách ly lô sữa | F-149, BR-59 | Tủ mát ghi nhận 9°C liên tục trong 130 phút | Toàn bộ các lô sữa tươi thanh trùng trong tủ tự động chuyển sang `QUARANTINED`, POS báo động đỏ. |
| **TC-180** | P0 | Kiểm tra tự động khóa bán (OUT_OF_STOCK) trên Menu | F-150, BR-59 | Lô sữa tươi thanh trùng bị `QUARANTINED` ở TC-179 | Các món Latte, Cappuccino, Trà sữa tươi tự động hiển thị nhãn `Tạm hết hàng`, nút mua bị vô hiệu. |
| **TC-181** | P0 | Kiểm tra lập phiếu xuất hủy kho bắt buộc 2 ảnh hiện trường | F-151, BR-60 | Xuất hủy 15 hộp sữa tươi hỏng do mất điện | Hệ thống chặn gửi duyệt nếu chưa chụp ảnh; bắt buộc chụp trực tiếp từ camera 2 ảnh (tem và đổ bỏ). |
| **TC-182** | P0 | Kiểm tra phân quyền phê duyệt xuất hủy 3 cấp | F-151, BR-60 | Phiếu 1 (250k); Phiếu 2 (1.200k); Phiếu 3 (3.500k) | Phiếu 1 Quản lý ca duyệt; Phiếu 2 Quản lý cửa hàng duyệt; Phiếu 3 bắt buộc Giám đốc OM duyệt. |
| **TC-183** | P1 | Kiểm tra định khoản tổn thất xuất hủy vào TK 811 vs COGS | F-152, BR-61 | Phiếu xuất hủy do hỏng tủ mát được duyệt | Ghi nhận chi phí tổn thất vào TK 811; trừ tồn kho chính xác theo lô nhập; Food Cost % không bị méo. |
| **TC-184** | P0 | Kiểm tra hủy món khi đang pha chế dở dang | F-153, BR-62 | Vé pha chế đang ở trạng thái `IN_PROGRESS` | Lỗi quán hoàn 100% tiền; khách đổi ý yêu cầu PIN Quản lý ca phê duyệt; ghi nhận lãng phí pha chế. |
| **TC-185** | P0 | Kiểm tra tái phân bổ ly nước đã pha sẵn (Reassign Cup) | F-153, BR-62 | Ly Macchiato đã pha xong (`READY`), khách bỏ đi; đơn sau có Macchiato | Barista bấm Reassign Cup; ly nước gán sang đơn sau ngay lập tức, quán không bị mất ly nước. |
| **TC-186** | P0 | Kiểm tra Hủy giao dịch (Void) trong vòng 10 phút | F-154, BR-63 | Đơn thanh toán quẹt thẻ 5 phút trước, chưa pha chế | Cổng thanh toán đảo giao dịch trực tiếp không mất phí quẹt thẻ; đơn hàng chuyển `VOIDED`. |
| **TC-187** | P0 | Kiểm tra phân loại thu hồi hiện vật khi hoàn trả | F-154, BR-63 | Khách trả 1 Ly giữ nhiệt (nguyên seal) và 1 Ly Trà đào | Ly giữ nhiệt được tích chọn nhập lại kho bán lẻ; Ly trà đào cấm nhập kho, ghi nhận xuất hủy chất lượng. |
| **TC-188** | P1 | Kiểm tra POS ngoại tuyến lưu SQLite có ký số HMAC | F-155, BR-64 | Ngắt toàn bộ cáp mạng Internet vào máy POS | Đơn tạo thành công, in bill bình thường; bản ghi SQLite gắn mã offline và có chữ ký HMAC SHA-256. |
| **TC-189** | P1 | Kiểm tra đồng bộ đơn offline và ưu tiên đơn tại quầy | F-156, BR-64 | Cắm lại dây mạng Internet cho POS | Đơn quầy offline được server ghi nhận thành công; đơn Web xung đột bị hủy tự động và hoàn tiền + voucher. |
| **TC-190** | P0 | Kiểm tra thanh toán kết hợp Split Payment đa kênh | F-157, BR-65 | Đơn 650k = 50k Điểm + 200k MoMo + 200k Thẻ + 200k Tiền mặt | Mỗi phương thức sinh 1 bản ghi `PaymentTransaction`; đơn chuyển `PAID` khi remainingBalance = 0. |
| **TC-191** | P0 | Kiểm tra hủy giao dịch dở dang khi thanh toán kết hợp | F-158, BR-65 | Đã trừ 50k điểm và 200k MoMo thành công; bước quẹt thẻ lỗi | Hệ thống tự động hoàn 200k về ví MoMo, hoàn 50k điểm về ví khách, hủy đơn an toàn không lệch quỹ. |

---

### 5.5 Danh mục 4 Bài toán đối soát số học mới (FX-09 đến FX-12)

#### FX-09 — Đối soát chênh lệch tiền két ca làm việc (Cash Drawer Variance)
- **Công thức tiền kỳ vọng**:
  $$ExpectedCash = StartingFloat + TotalCashCollected - TotalCashRefunded - PettyCashExpense - TotalCashDropped$$
- **Bài toán số học**: Đầu ca $1.000.000\text{đ}$, thu bán hàng $3.850.000\text{đ}$, hoàn hủy đơn $150.000\text{đ}$, chi mua đá khẩn cấp $50.000\text{đ}$, rút tiền giữa ca nộp két an toàn $3.000.000\text{đ}$.
  $$ExpectedCash = 1.000.000 + 3.850.000 - 150.000 - 50.000 - 3.000.000 = 1.650.000\text{ VND}$$
- **Kiểm toán 3 cấp dung sai**:
  1. *Thực đếm $1.642.000\text{đ}$*: Lệch $-8.000\text{đ}$ ($\le 20\text{k}$) $\rightarrow$ Tự động hạch toán Nợ TK 642 / Có TK 1111: $8.000\text{đ}$. Đóng ca bình thường.
  2. *Thực đếm $1.600.000\text{đ}$*: Lệch $-50.000\text{đ}$ ($20\text{k} - 100\text{k}$) $\rightarrow$ Đếm lại lần 2 + giải trình lý do + PIN Quản lý ca duyệt.
  3. *Thực đếm $1.400.000\text{đ}$*: Lệch $-250.000\text{đ}$ ($> 100\text{k}$) $\rightarrow$ Khóa đóng ca thường. Lập Biên bản kiểm quỹ bất thường: Nợ TK 1388 / Có TK 1111: $250.000\text{đ}$. Trừ trực tiếp vào lương thu ngân.

#### FX-10 — Đối soát tổn thất xuất hủy kho & Phân tách chi phí bất thường vs COGS
- **Bài toán số học**: Sự cố hỏng lốc tủ mát gây biến chất 3 lô nguyên liệu:
  - Lô Sữa tươi Barista Milk (`LOT-MILK-01`): Giá nhập $32.000\text{đ}$/hộp x 25 hộp $= 800.000\text{đ}$.
  - Lô Kem béo Rich's (`LOT-CREAM-02`): Giá nhập $65.000\text{đ}$/hộp x 8 hộp $= 520.000\text{đ}$.
  - Lô Sốt Phô mai (`LOT-CHEESE-03`): Giá thành sản xuất $45.000\text{đ}$/hũ x 6 hũ $= 270.000\text{đ}$.
  - **Tổng giá trị tổn thất**: $800.000 + 520.000 + 270.000 = 1.590.000\text{ VND}$.
- **Hạch toán kiểm toán**: Store Manager ký duyệt phiếu xuất hủy kèm 2 ảnh hiện trường.
  - Bút toán kho: Giảm trừ tồn kho từng lô trong bảng `IngredientLot`.
  - Bút toán tài chính: Nợ TK 811 (Chi phí khác do sự cố) / Có TK 152: $1.590.000\text{đ}$.
  - **Bảo toàn tỷ lệ Food Cost**: Không đưa $1.590.000\text{đ}$ vào TK 632 (Giá vốn hàng bán). Tỷ lệ Food Cost % quầy Bar giữ nguyên mức chuẩn 28.5%.

#### FX-11 — Đối soát số học Gộp bàn và Tách hóa đơn (Monetary Invariants)
- **Gộp bàn**:
  - Bàn A: $115.000\text{đ}$ - Voucher $15.000\text{đ} = 100.000\text{đ}$.
  - Bàn B: $135.000\text{đ}$ + Cọc $50.000\text{đ}$ - Voucher $20.000\text{đ} = 65.000\text{đ}$.
  - Hợp nhất: Voucher Bàn B ($20\text{k}$) hoàn lại ví khách; tổng gốc mới: $115\text{k} + 135\text{k} = 250.000\text{đ}$; voucher Bàn A đạt ngưỡng 250k nâng mức giảm lên $30.000\text{đ}$; cọc kết chuyển $50.000\text{đ}$.
  - Số tiền cần thanh toán: $250.000 - 30.000 - 50.000 = 170.000\text{ VND}$.
  - Bất biến bảo toàn: Thực thu ($170\text{k}$) + Cọc ($50\text{k}$) + Giảm giá ($30\text{k}$) = đúng $250.000\text{đ}$ giá trị đồ uống.
- **Tách chia đều Dutch Treat**: Hóa đơn $500.000\text{đ}$ chia 3 người:
  - Phép chia: $500.000 / 3 = 166.666,666...$
  - Thuật toán Largest Remainder: Người 1 trả $166.667\text{đ}$, Người 2 trả $166.667\text{đ}$, Người 3 trả $166.666\text{đ}$.
  - Tổng: $166.667 + 166.667 + 166.666 = 500.000\text{ VND}$ (Chính xác tuyệt đối đến từng đồng).

#### FX-12 — Đối soát Thanh toán kết hợp Split Payment & Hủy dở dang hoàn tiền
- **Bài toán số học**: Đơn hàng tiệc sinh nhật $750.000\text{ VND}$.
  - Bước 1: Trừ $50.000\text{ Điểm} \rightarrow$ Balance còn $700.000\text{đ}$.
  - Bước 2: Quét MoMo $300.000\text{đ} \rightarrow$ Giao dịch `TXN_MOMO_9942` thành công. Balance còn $400.000\text{đ}$.
  - Bước 3: Quẹt thẻ $200.000\text{đ} \rightarrow$ Báo lỗi "Thẻ hết hạn / Từ chối giao dịch".
- **Xử lý sự cố dở dang**: Khách không có thẻ khác và không có đủ tiền mặt, thu ngân bấm "Hủy giao dịch dở dang":
  - Tự động gọi API MoMo Refund đảo giao dịch `TXN_MOMO_9942`: Hoàn trả $300.000\text{đ}$ về ví MoMo của khách.
  - Tự động gọi Loyalty Ledger: Hoàn trả $50.000\text{ Điểm}$ vào số dư tài khoản khách.
  - Đơn hàng chuyển `PAYMENT_ABORTED_REFUNDED`. Số quỹ tiền mặt và tài khoản ngân hàng khớp 100%, không bị treo tiền.

---

### 5.6 Kế hoạch 6 Gói công việc WBS bổ sung (W28 đến W33)

| Mã WBS | Tên gói công việc | Phụ thuộc | Mức | Ước lượng | Sản phẩm bàn giao (Deliverables) |
|---|---|---|---|---|---|
| **W28** | Quản lý thiết bị in ấn POS, hàng đợi Spooler và in lại chống gian lận | W11, W13 | P0/P1 | 30 giờ (4–5 ngày) | - Driver ESC/POS qua TCP Socket 9100 và USB.<br>- Spooler Queue bất đồng bộ tự động retry 3 lần.<br>- Mẫu in tem nhãn ly Barcode 50x30mm và KOT vi sai.<br>- Luồng Bill Reprint có Watermark BẢN SAO và PIN Quản lý.<br>- **Bàn giao**: Module in POS, test ngắt mạng/kẹt giấy đạt 100%. |
| **W29** | Quản lý sơ đồ bàn, FSM vòng đời bàn, chuyển/gộp/tách bàn và đặt cọc | W05, W11 | P1 | 40 giờ (5–7 ngày) | - Thực thể `RestaurantTable`, `TableZone` và FSM 6 trạng thái.<br>- Giao diện Sơ đồ bàn trực quan kéo thả.<br>- Giao dịch chuyển bàn nguyên tử và WebSocket sang KDS.<br>- Nghiệp vụ Gộp bàn và Tách hóa đơn (Dutch Treat).<br>- Đặt bàn trước, cọc, tự động giải phóng bàn quá 15 phút No-show.<br>- **Bàn giao**: Màn hình quản lý bàn, test FX-11 đạt. |
| **W30** | Vận hành ca làm việc xuyên ngày, quản lý tiền két và đóng ca khẩn cấp | W10, W18 | P0/P1 | 35 giờ (4–6 ngày) | - Chuẩn hóa `businessDate` cho ca đêm 22:00 - 06:00.<br>- Cơ chế chốt sổ kép Midnight Snapshot cho kế toán cuối tháng.<br>- Giao diện Kiểm tiền mù cuối ca và bộ lọc 3 cấp dung sai.<br>- Rút tiền giữa ca (Cash Drop) xác thực kép Quản lý + Thu ngân.<br>- Đóng ca khẩn cấp khi mất điện và hoàn tiền đơn dở dang.<br>- **Bàn giao**: Module quản lý ca quầy thu ngân, test FX-09 đạt. |
| **W31** | Khuyến mãi nâng cao, Voucher Sinh Nhật KYC, ma trận xếp chồng 4 cấp | W08, W15 | P0/P1 | 35 giờ (4–5 ngày) | - Voucher Sinh Nhật: Khóa ngày sinh KYC 30 ngày, đối chiếu CCCD tại quầy.<br>- Pricing Engine thực thi Ma trận xếp chồng 4 cấp và Giá sàn 80%.<br>- Voucher Reservation Lock với TTL 15 phút bảo lưu ưu đãi qua đêm.<br>- Tích điểm theo Net chi tiêu và hoàn trả điểm/voucher.<br>- **Bàn giao**: Engine tính giá khuyến mãi, test xếp chồng đạt. |
| **W32** | Giám sát nhiệt độ kho lạnh, cách ly lô, khóa menu và xuất hủy nguyên liệu | W07, W16 | P0/P1 | 30 giờ (4–6 ngày) | - Kết nối cảm biến IoT / Form nhập nhiệt độ tủ mát, cảnh báo $> 8^\circ\text{C}$.<br>- Tự động chuyển trạng thái lô sang `QUARANTINED` và khóa menu `OUT_OF_STOCK`.<br>- Phiếu xuất hủy khẩn cấp bắt buộc 2 ảnh camera hiện trường.<br>- Phân quyền phê duyệt đa cấp 3 hạn mức (Ca, Cửa hàng, Giám đốc OM).<br>- Hạch toán chi phí bất thường TK 811 tách biệt Giá vốn COGS TK 632.<br>- **Bàn giao**: Module kiểm soát ATVSTP kho lạnh, test FX-10 đạt. |
| **W33** | Tối ưu vận hành quầy F&B, Void/Refund, POS Offline và Split Payment | W11, W12, W17 | P0/P1 | 45 giờ (6–8 ngày) | - Hủy món 3 giai đoạn và Tái phân bổ ly nước `REASSIGN_CUP`.<br>- Hủy nhanh (Void trong 10 phút) và phân loại thu hồi hiện vật nhập kho.<br>- Chế độ POS Ngoại tuyến (Offline Mode) lưu SQLite ký số HMAC SHA-256.<br>- Tiến trình đồng bộ nền FIFO và giải quyết xung đột ưu tiên quầy.<br>- Sổ cái thanh toán kết hợp nhiều hình thức (Split Payment) và hoàn tiền dở dang.<br>- **Bàn giao**: POS Offline Agent, Module Split Payment, test FX-12 đạt. |

---

## 6. MA TRẬN TRUY VẾT TOÀN DIỆN (END-TO-END TRACEABILITY MATRIX) - 100% COVERAGE

| STT | Chủ đề Kịch bản biên F&B thực tế | Quy tắc nghiệp vụ (BR) | Chức năng hệ thống (F) | Use Case chi tiết (UC) | Ca kiểm thử xác minh (TC) | Gói WBS thực hiện |
|:---:|---|---|---|---|---|:---:|
| **1** | Mất kết nối máy in POS, hết giấy, kẹt dao cắt, Spooler retry queue | BR-41 | F-129, F-130 | UC-29 | TC-149, TC-150, TC-151 | W28 |
| **2** | Phân định KOT bếp/bar vs Bill khách hàng, in bổ sung vi sai theo đợt | BR-42 | F-131 | UC-29 | TC-152, TC-153 | W28 |
| **3** | In lại hóa đơn thanh toán (Bill Reprint), Watermark BẢN SAO, PIN Quản lý | BR-43 | F-132 | UC-30 | TC-154, TC-155 | W28 |
| **4** | Phục hồi in dở dang khi sự cố giấy và tiêu hủy mẩu rách | BR-44 | F-133 | UC-29 | TC-156 | W28 |
| **5** | Sơ đồ bàn trực quan và máy trạng thái bàn thời gian thực (FSM Table) | BR-45 | F-134 | UC-31 | TC-157 | W29 |
| **6** | Chuyển bàn nguyên tử (Atomic Table Move) và đồng bộ KDS Barista | BR-46 | F-135 | UC-31 | TC-158, TC-159 | W29 |
| **7** | Gộp bàn, hợp nhất đơn hàng, kết chuyển cọc và hoàn trả voucher phụ | BR-47 | F-136 | UC-31 | TC-160 | W29 |
| **8** | Tách bàn / Tách hóa đơn theo món hoặc chia đều Dutch Treat (FX-11) | BR-48 | F-137 | UC-31 | TC-161, TC-162 | W29 |
| **9** | Đặt bàn trước, cọc giữ chỗ, ân hạn 15 phút và tịch thu cọc No-show | BR-49 | F-138 | UC-32 | TC-163, TC-164 | W29 |
| **10** | Ca làm việc xuyên ngày (22:00 - 06:00), Ngày kinh doanh (businessDate) | BR-50 | F-139 | UC-33 | TC-165 | W30 |
| **11** | Chốt sổ doanh thu kép Midnight Snapshot giao thời kỳ kế toán cuối tháng | BR-51 | F-140 | UC-33 | TC-166 | W30 |
| **12** | Kiểm tiền mù cuối ca, 3 cấp dung sai chênh lệch két tiền mặt (FX-09) | BR-52 | F-141, F-142 | UC-34 | TC-167, TC-168, TC-169 | W30 |
| **13** | Rút tiền mặt giữa ca về két an toàn (Cash Drop) xác thực kép | BR-53 | F-143 | UC-33 | TC-170 | W30 |
| **14** | Đóng ca cưỡng chế khẩn cấp (Emergency Force Close) do mất điện | BR-54 | F-144 | UC-34 | TC-171 | W30 |
| **15** | Voucher Sinh Nhật: Khóa ngày sinh KYC, kiểm tra CCCD tại quầy | BR-55 | F-145 | UC-35 | TC-172, TC-173 | W31 |
| **16** | Ma trận xếp chồng ưu đãi 4 cấp bậc và Giá sàn bảo vệ giá vốn 80% | BR-56 | F-146 | UC-35 | TC-174 | W31 |
| **17** | Khóa giữ Voucher trong phiên thanh toán có TTL 15 phút | BR-57 | F-147 | UC-36 | TC-175, TC-176 | W31 |
| **18** | Tích điểm Net chi tiêu và thuật toán hoàn trả điểm/voucher khi hủy đơn | BR-58 | F-148 | UC-36 | TC-177, TC-178 | W31 |
| **19** | Giám sát nhiệt độ tủ mát, cảnh báo sự cố và cách ly lô (QUARANTINED) | BR-59 | F-149, F-150 | UC-37 | TC-179, TC-180 | W32 |
| **20** | Xuất hủy nguyên liệu khẩn cấp, bắt buộc 2 ảnh hiện trường, duyệt đa cấp | BR-60 | F-151 | UC-38 | TC-181, TC-182 | W32 |
| **21** | Định khoản chi phí tổn thất bất thường TK 811 vs COGS TK 632 (FX-10) | BR-61 | F-152 | UC-38 | TC-183 | W32 |
| **22** | Hủy món đang pha dở dang và tái phân bổ ly nước đã pha sẵn (Reassign Cup) | BR-62 | F-153 | UC-39 | TC-184, TC-185 | W33 |
| **23** | Hủy giao dịch (Void trong 10 phút), phân loại hàng nhập kho vs đồ uống hủy | BR-63 | F-154 | UC-39 | TC-186, TC-187 | W33 |
| **24** | Chế độ POS Ngoại tuyến (Offline Mode), lưu SQLite ký số HMAC SHA-256 | BR-64 | F-155, F-156 | UC-40 | TC-188, TC-189 | W33 |
| **25** | Thanh toán kết hợp nhiều hình thức (Split Payment) và hủy dở dang (FX-12) | BR-65 | F-157, F-158 | UC-41 | TC-190, TC-191 | W33 |

**Đánh giá độ phủ ma trận:** **100% COVERAGE**. Toàn bộ 25 kịch bản biên và nghiệp vụ F&B thực tế đều được truy vết 1-1 không sót bất kỳ mục nào sang Quy tắc nghiệp vụ (BR-41..65), Chức năng hệ thống (F-129..158), Use Case (UC-29..41), Ca kiểm thử (TC-149..191) và Gói công việc triển khai (W28..W33).

---

## 7. KẾ HOẠCH TRIỂN KHAI & KHUYẾN NGHỊ TRƯỚC KHI VIẾT CODE

1. **Đồng bộ hóa 100% hồ sơ tài liệu**: Toàn bộ các định danh và đặc tả mới trong báo cáo này được cập nhật đồng bộ vào các tài liệu Markdown nguồn (`02`, `04`, `05`, `03/06`, `08`, `10` và `README.md`) và biên dịch ra hệ thống tài liệu Word chuẩn TCVN trong `01_Tai_Lieu_Bao_Cao_Word/`.
2. **Không phá vỡ Baseline cũ**: Quá trình triển khai code tiếp theo phải tuân thủ nghiêm ngặt tính bất biến của các module cốt lõi đã nghiệm thu từ `W01` đến `W27`. Các gói công việc mới `W28` đến `W33` được thực hiện theo nguyên tắc bổ sung dạng plugin / module mở rộng độc lập.
3. **Ưu tiên triển khai theo mức P0**: Tập trung hoàn thành 16 chức năng P0 bổ sung trước (gồm Print Spooler, Bill Reprint PIN, Ca đêm businessDate, Blind Cash Count, Cash Drop, Emergency Close, Floor Price 80%, Voucher Hold TTL, Cách ly lô hỏng, Xuất hủy có 2 ảnh, Hủy món pha chế, Void 10 phút, Split Payment) trước khi triển khai các tính năng P1 mở rộng.
4. **Kiểm thử tự động trên 4 Fixture mới**: Thiết lập bộ Unit Test chạy tự động cho 4 Fixture số học `FX-09`, `FX-10`, `FX-11`, `FX-12` trong CI/CD pipeline để bảo đảm mọi giao dịch tài chính, kho quỹ và tiền két luôn chính xác 100% đến từng đồng.
