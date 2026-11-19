# 06. Nhật ký rà soát, bổ sung và quyết định — lịch sử1.1 và cập nhật1.2

**Ghi chú bản1.2 ngày18/11/2026:** các mục1–6 dưới đây lưu kết quả rà soát1.1. Baseline Boot3.5/SiteMesh3.2,120F/108TC/32BR và lịch20 tuần ở phần lịch sử đã được thay thế. Đọc mục7 và tài liệu07–10 cho quyết định hiện hành; không dùng đoạn lịch sử để ghi đè tài liệu03/04.

**Đợt rà soát:** 17–18/11/2026. **Yêu cầu:** rà soát toàn bộ hồ sơ UTECoffe, bổ sung phần thiếu và chỉnh điểm chưa nhất quán. **Phạm vi thực hiện:** tài liệu trong thư mục Đ.Án; không triển khai ứng dụng và không chỉnh dự án quần áo.

## 1. Kết quả thay đổi

| Hạng mục | Bản 1.0 | Bản 1.1 |
|---|---|---|
| Quy tắc nghiệp vụ | 24 BR | 32 BR; sửa trực tiếp các quy tắc tiền/tồn/deadline cũ |
| Danh mục chức năng | 104 F | 120 F, giữ mã cũ và thêm F-105–120 |
| Ca kiểm thử dự kiến | 76 TC | 108 TC, thêm 32 ca cho khoảng trống vừa phát hiện |
| Fixture số học | 5 | 8; thêm partial order, combo và một component lấy nhiều lô |
| Lịch một người | 18 tuần +2–4 dự phòng | 20 tuần +2–4 dự phòng,30–35 giờ/tuần |
| Hồ sơ | 6 Markdown +HTML | 7 Markdown +HTML xuất lại, có nhật ký rà soát |

Các con số chức năng gồm P0/P1/P2. Tăng số hàng không phải mục tiêu; mục tiêu là mỗi tình huống quan trọng có quy tắc, dữ liệu, hành động và kết quả kiểm được. Những con số trên mô tả **đặc tả**, không phải tính năng đã xây hay test ứng dụng đã chạy.

## 2. Phát hiện và cách xử lý

| Mã | Khoảng trống/mâu thuẫn được thấy | Sửa trong tài liệu chính | Bằng chứng nghiệm thu tương lai |
|---|---|---|---|
| RV-01 | Idempotency chỉ theo request key, đổi key vẫn có thể đặt lại quote | BR-25; unique quote và cart generation; TX-01 | TC-077,078,108 |
| RV-02 | Giỏ vãng lai đăng nhập và hai tab chưa có quy tắc hợp nhất | Preview/gộp một lần/version; CartMergeProposal | TC-079,080 |
| RV-03 | Hủy một phần nhưng không có đơn vị giao và nghĩa vụ tiền hiệu lực | OrderUnit/Adjustment, BR-26, COMPLETED/PARTIAL, FX-06 | TC-081–084 |
| RV-04 | Câu hạn mức refund có thể bị hiểu là trừ hoàn hai lần | Tổng success+pending≤receipt; tách hoàn chất lượng với thu trùng | TC-033,034,084 |
| RV-05 | Paid gần hạn chưa có acceptance deadline riêng; event đến trễ dễ hồi đơn | BR-08/27, deadline theo giai đoạn, callback không ghi đè tùy thời gian đến | TC-085–087 |
| RV-06 | Unique ticket theo line/cupIndex gây xung đột với remake | Unit+attemptNo, parent ticket, một attempt phục vụ active | TC-036,093 |
| RV-07 | Unique movement thiếu allocation khi một nguyên liệu lấy nhiều lô | Source theo allocation+kind; FX-08 | TC-088 |
| RV-08 | Bỏ ly sau pha có thể bị hiểu là trừ nguyên liệu lần nữa | RAW/FINISHED/TRANSIT waste, FINISHED tham chiếu consumption | TC-089, FX-03/08 |
| RV-09 | Combo/bánh đã nằm P1 nhưng chưa có model, refund, task/test | BR-28, Bundle/PackagedStockMapping, W24, FX-07 | TC-094,095 |
| RV-10 | Bán tại quầy chưa phân biệt mang đi và dùng tại chỗ | Channel/serviceMode riêng; ON_PREMISE cơ bản P1, bao bì theo mode | TC-096 |
| RV-11 | Khả dụng chưa phân biệt tổng vật lý và lô đủ điều kiện; recall chưa trace | BR-29, LotRecall, TX-07; công thức không trừ reservation hai lần | TC-016,017,090 |
| RV-12 | Claim quầy mất kết nối chưa có lease và đường giao lại | BR-30, claimLeaseUntil; PREPARING không tự reset | TC-092,093 |
| RV-13 | Menu CRUD chưa có kiểm tra khả năng bán/pha trước publish | F-119, dry-run và publish version atomic | TC-091 |
| RV-14 | Thu mặt chưa tách tiền khách đưa và tiền trả lại | CashTender, TX-08, F-114; P0 receipt khác P1 đóng ca | TC-097, FX-04/06 |
| RV-15 | Hạn mức/quyền duyệt chỉ mô tả chung, chưa có contract | ApprovalPolicy, requester/approver, F-120, ngăn admin tự nâng quyền | TC-098 |
| RV-16 | Điểm đã hết hạn rồi refund có thể bị trừ kép; voucher đổi điểm chưa có vòng đời | BR-31, entitlement/balance riêng, replacement có liên kết | TC-102,103 |
| RV-17 | “URL có chữ ký” dễ bị hiểu là URL tự hết hạn và thu hồi theo user | P0 media proxy kiểm quyền từng request, authenticated assets, no-store | TC-062,100,101 |
| RV-18 | Pickup chỉ lưu hash nhưng cần hiển thị lại mã cho chủ đơn | Thêm ciphertext/keyVersion, rotate vô hiệu mã cũ | TC-099 |
| RV-19 | Privacy/MFA mới có định hướng, chưa có yêu cầu vận hành/test | BR-32, D-06/07, W25, UI-C15/A12, recovery/hold | TC-104,105 |
| RV-20 | Báo cáo doanh số/thu/hoàn theo ngày còn dễ trộn | Từ điển 15 ở thiết kế; phát sinh và cohort tách | TC-073–075,106 |
| RV-21 | Test P0 về partial có thể phụ thuộc voucher P1 | FX-06 có fixture đơn giá độc lập cho P0 | TC-081/082 chạy được trước loyalty/promotions |
| RV-22 | Lịch chưa chứa các phần bổ sung; thiếu môi trường đo tải cụ thể | W23–25, lịch20 tuần, G3 tuần 11/G4 tuần 17; profile tải thử | TC-070,107 và gate theo phạm vi |

Các RV nêu điểm của **bản thiết kế**, không cáo buộc lỗi đã xảy ra ở phần mềm vì phần mềm chưa được xây. Các tài liệu 02–05 đã được sửa trực tiếp; bảng này chỉ giúp đối chiếu.

## 3. Đối chiếu phạm vi với đầu ra

| Phạm vi cần có | Nguồn nghiệp vụ | Nguồn thiết kế/kế hoạch | Kiểm chứng khi triển khai |
|---|---|---|---|
| Khách chọn đúng cơ sở và ly | BR-01–06,25 | Cart/menu/quote, UI-C02–06, W05–09/W23 | TC-001–015,077–080 |
| Tiền và hậu mãi đúng | BR-11,13,17,26,27,31 | Receipt/refund/unit/adjustment, W10–12/W23 | TC-025–040,081–087,097,098 |
| Kho và pha chế đúng | BR-08–10,12,29,30 | Recipe/lots/allocation/tickets, W07/W11/W16 | TC-013–024,041–048,088–093 |
| Phạm vi P1 đã hứa | BR-07,15,16,18,28,31,32 | W15–19/W24/W25 | TC P1, gồm combo/tại chỗ/MFA/privacy |
| Đủ stack đề tài | Tài liệu03 mục2,9–11 | G0, WAR/JSP/SiteMesh/JWT/WS/Cloudinary | TC-055–065,100,105 |
| Làm một người nhưng có thể chia nhóm | README, tài liệu04 | WBS/phụ thuộc/gate,20 tuần +dự phòng | Theo actual hours và scope được duyệt |
| Khảo sát có căn cứ | Tài liệu01 | 7 chuỗi, nguồn chính thức, giới hạn quan sát | Trích nguồn/ngày; không suy đoán backend của chuỗi |
| Chỉ lập hồ sơ | README và trạng thái đầu mỗi tài liệu | Markdown/HTML và bằng chứng kiểm tài liệu | Không có app Java/JSP/migration được tạo |

## 4. Rà lại nguồn kỹ thuật và giới hạn khảo sát

Đã đọc lại tài liệu Spring Boot về servlet/JSP và ma trận SiteMesh. Giữ baseline Boot3.5/SiteMesh3.2 làm phương án tương thích đề xuất, vẫn yêu cầu kiểm bản vá/vòng hỗ trợ và spike trước code. Không khẳng định đó là bản mới nhất. [Spring Boot](https://docs.spring.io/spring-boot/3.5/reference/web/servlet.html) · [SiteMesh](https://github.com/sitemesh/sitemesh3).

Đã kiểm lại phần authenticated media, signed delivery và cơ chế có hạn trong tài liệu Cloudinary; lựa chọn proxy ở P0 là quyết định thiết kế UTECoffe để kiểm quyền từng lần đọc. [Cloudinary access control](https://cloudinary.com/documentation/control_access_to_media). MFA/recovery tham khảo nguyên tắc của [OWASP](https://cheatsheetseries.owasp.org/cheatsheets/Multifactor_Authentication_Cheat_Sheet.html).

URL tài liệu thanh toán VNPAY bị timeout trong lần đọc bổ sung; hồ sơ không thêm chi tiết giao thức dựa trên suy đoán. Việc chọn/khóa hợp đồng adapter vẫn là đầu việc W10 trước code sandbox. Chưa có giao dịch mua thử tại 7 chuỗi hoặc thử tiền thật ở bất kỳ cổng nào.

## 5. Điều còn cần xác nhận và điều đã được giải quyết

Đã chốt theo yêu cầu người dùng: chủ đề UTECoffe, PostgreSQL, stack đề tài, định hướng một người, chỉ làm tài liệu trong Đ.Án. Đã chốt thiết kế đề xuất: một order một branch; pickup P0; quyền backend; code chưa được viết;8 điểm D-01–08 trong nghiệp vụ là các quyết định kinh doanh/vận hành còn mở.

Các D chưa được doanh nghiệp/giảng viên xác nhận không làm bộ hồ sơ phân tích thiếu: mỗi mục có mặc định đồ án, owner và gate cần quyết định. Khi thông tin thật đến phải cập nhật xuyên BR → data/API → WBS → tests, không chỉ sửa một câu trong README. Không tự nhận bộ hồ sơ đã được doanh nghiệp nghiệm thu hoặc sẵn sàng thu tiền thật.

## 6. Cách kiểm tra bản cập nhật này

Kiểm các mã BR/F/TC liên tục và không trùng; bảng Markdown đủ cột; link tệp/anchor HTML đúng; đếm 120 chức năng và 108 ca; đối chiếu các sửa RV với mục tương ứng; tính lại FX-01–08; so HTML với nội dung Markdown; kiểm tìm kiếm, mục lục, viewport hẹp và chế độ in. Kết quả kiểm tài liệu lưu riêng trong `kiem-tra-tai-lieu`; không đánh dấu các TC ứng dụng PASSED chỉ vì tài liệu render đúng.

Kiểm tra cuối ngày 18/11/2026: hồ sơ có 72 chức năng P0, 42 P1 và 6 P2; 32 quy tắc, 108 ca kiểm thử dự kiến và 22 điểm rà soát. Các mã, liên kết nội bộ, bảng, ví dụ số học và nội dung Markdown–HTML đã được đối chiếu. Bản đọc đã được mở và kiểm tra trên desktop/mobile, tìm kiếm và chế độ in. Đây là kết quả kiểm tài liệu; các ca ứng dụng vẫn chưa được chạy. Tài liệu VNPAY vẫn timeout khi đọc lại ngày 18/11, nên chi tiết giao thức tiếp tục là đầu việc phải xác minh ở W10.

## 7. Rà soát lần hai và quyết định hiện hành

Ngày18/11/2026, người dùng xác nhận tên đề và stack chỉ là mức tối thiểu, cần phát triển nghiệp vụ đầy đủ hơn. Bản1.2 bổ sung BR-33–40, F-121–128, TC-109–148; giữ nguyên ID cũ để truy lịch sử. Tổng40BR,128F (74P0/48P1/6P2),148TC; test đều là thiết kế tương lai.

Bổ sung bốn tài liệu:07 đối chiếu12 yêu cầu đề và16 khoảng trống;08 đặc tả28 luồng;09 hợp đồng dữ liệu/lệnh/quyền/job;10 truy vết128 chức năng. W03 vàW20 tăng kiểm tương thích/hồi quy, thêm W26/W27;27gói95–139 ngày6 giờ. Lịch đề xuất24 tuần+2–4 dự phòng, một người30–35 giờ/tuần.

Sau khi kiểm lại vòng hỗ trợ chính thức, thay baseline sang Boot4.1/SiteMesh3.3/Tomcat11, vẫn giữ JSP/JSTL và WAR theo đề. Cần spike `alwaysInclude`/decorator trên artifact thật; không chỉ đổi số phiên bản trong dependency. Nguồn và căn cứ nằm ở03/07.

Các bổ sung là thiết kế đề xuất, chưa phải chính sách kinh doanh thật đã duyệt. Trước pilot phải chốt menu/recipe, thời hạn chất lượng, hoàn tiền, privacy/retention và đối tác như bảng quyết định07. Không thể bảo đảm không phát sinh yêu cầu mới; mọi F hiện tại phải có đường truy sang UC/WBS/test.

## 4. Đợt rà soát lần 3 (v1.3 — 19/11/2026): Rà soát kịch bản biên và nghiệp vụ F&B thực tế

Đợt rà soát toàn diện phục vụ chuẩn bị cài đặt phần mềm, kế thừa 100% hồ sơ v1.2 và giải quyết 25 điểm kỹ thuật kịch bản biên F&B thực tế:

| Mã | Khoảng trống nghiệp vụ phát hiện | Quyết định kỹ thuật & Giải pháp chuẩn hóa | Bằng chứng kiểm thử / Nghiệm thu |
|---|---|---|---|
| RV3-01 | Mất mạng LAN, hết giấy, kẹt dao cắt máy in bill gây treo checkout | Tách bất đồng bộ thanh toán và in ấn; Spooler retry 3 lần, failover máy in phụ (BR-41, F-130) | TC-149, TC-150, TC-151 |
| RV3-02 | In KOT pha chế in lại toàn bộ món khi khách gọi thêm lần 2 | Phân định KOT vs Bill; chỉ in KOT vi sai cho món thêm mới kèm nhãn bổ sung (BR-42, F-131) | TC-152, TC-153 |
| RV3-03 | Thu ngân in lại bill đưa khách trả tiền mặt rồi hủy đơn gian lận | In lại bill bắt buộc watermark BẢN SAO, tăng reprintCount, yêu cầu PIN Quản lý ca (BR-43, F-132) | TC-154, TC-155 |
| RV3-04 | Hết giấy giữa trang hóa đơn in dở dang | Hủy tác vụ dở dang, nạp giấy in lại bản thay thế hoàn chỉnh, gạch chéo mẩu rách (BR-44, F-133) | TC-156 |
| RV3-05 | Phục vụ tại chỗ thiếu máy trạng thái bàn, dễ xếp nhầm bàn chưa dọn | Xây dựng FSM 6 trạng thái thời gian thực cho bàn ăn, tự động đổi màu trạng thái (BR-45, F-134) | TC-157 |
| RV3-06 | Khách đổi chỗ ngồi cắm sạc laptop làm thất lạc đồ uống | Chuyển bàn nguyên tử có khóa bi quan, bắn tin WebSocket cập nhật KDS Barista (BR-46, F-135) | TC-158, TC-159 |
| RV3-07 | Hai nhóm bạn nhập chung bàn cần gộp hóa đơn | Hợp nhất vào Master Order, kết chuyển cọc, hoàn voucher phụ về ví khách (BR-47, F-136) | TC-160, FX-11 |
| RV3-08 | Nhóm khách chia tiền trả riêng theo món hoặc chia đều Dutch Treat | Tách món sang đơn con mới (hủy voucher nếu vi phạm Min Spend); chia đều theo Largest Remainder (BR-48, F-137) | TC-161, TC-162, FX-11 |
| RV3-09 | Đặt bàn trước No-show chiếm giữ bàn ảo giờ cao điểm | Khóa bàn trước 30m, ân hạn 15m; quá hạn tự động giải phóng bàn, tịch thu 100% cọc vào TK 711 (BR-49, F-138) | TC-163, TC-164 |
| RV3-10 | Ca đêm 22:00-06:00 bị reset doanh thu và két tiền lúc nửa đêm 00:00 | Chuẩn hóa businessDate cho ca đêm, duy trì két OPEN liên tục qua nửa đêm (BR-50, F-139) | TC-165 |
| RV3-11 | Báo cáo tài chính cuối tháng vắt qua 2 kỳ kế toán đêm 31/10 | Chốt sổ kép Midnight Snapshot: sổ nội bộ theo shiftId, sổ pháp định cắt lúc 23:59:59 (BR-51, F-140) | TC-166 |
| RV3-12 | Nhân viên nhìn số tiền sổ sách để đếm tiền đối phó khi đóng ca | Áp dụng Blind Cash Count (đếm tiền mù), phân loại 3 cấp độ dung sai chênh lệch két (BR-52, F-141) | TC-167, TC-168, TC-169, FX-09 |
| RV3-13 | Tiền mặt tích tụ lớn trong két quầy (> 5 triệu) rủi ro an ninh | Cảnh báo két tiền vượt ngưỡng; thực hiện Cash Drop rút tiền nộp két an toàn xác thực kép (BR-53, F-143) | TC-170 |
| RV3-14 | Mất điện toàn phần hoặc thiên tai không thể đóng ca thông thường | Cưỡng chế đóng ca FORCED_CLOSED, đóng băng commit, auto-refund đơn dở dang, niêm phong tiền giấy (BR-54, F-144) | TC-171 |
| RV3-15 | Khách sửa ngày sinh liên tục để nhận Voucher Sinh Nhật nhiều lần | Khóa ngày sinh KYC 30 ngày trước sinh nhật, chỉ sửa 1 lần duy nhất, đối chiếu CCCD tại quầy (BR-55, F-145) | TC-172, TC-173 |
| RV3-16 | Cộng dồn nhiều voucher làm giảm giá âm hoặc bán dưới giá vốn | Ma trận xếp chồng ưu đãi 4 cấp, cùng cấp không cộng dồn, ràng buộc Floor Price 80% (BR-56, F-146) | TC-174 |
| RV3-17 | Voucher hết hạn trong lúc khách đang nhập OTP thanh toán MoMo | Khóa giữ voucher ở trạng thái RESERVED với TTL 15 phút, bảo lưu ưu đãi qua đêm (BR-57, F-147) | TC-175, TC-176 |
| RV3-18 | Tích điểm vòng lặp trên tiền voucher và điểm cũ | Chỉ tích điểm trên Net Out-of-pocket thực chi; hủy đơn hoàn trả 100% điểm và khôi phục voucher (BR-58, F-148) | TC-177, TC-178 |
| RV3-19 | Tủ mát hỏng lốc / mất điện > 2 giờ làm sữa tươi biến chất | Cảm biến IoT cảnh báo > 8°C, tự động cách ly lô QUARANTINED, khóa menu OUT_OF_STOCK (BR-59, F-149, F-150) | TC-179, TC-180 |
| RV3-20 | Xuất hủy nguyên liệu lỏng lẻo dễ thông đồng tuồn hàng ra ngoài | Lập phiếu xuất hủy bắt buộc mở camera chụp trực tiếp 2 ảnh hiện trường, duyệt đa cấp 3 hạn mức (BR-60, F-151) | TC-181, TC-182 |
| RV3-21 | Đưa tổn thất hỏng kho do mất điện vào COGS làm méo mó Food Cost % | Định khoản tổn thất vào Chi phí khác TK 811 thay vì Giá vốn TK 632, trừ tồn theo lô FEFO (BR-61, F-152) | TC-183, FX-10 |
| RV3-22 | Khách hủy khi đồ uống đang pha dở dang hoặc đã pha xong | Hủy theo 3 giai đoạn; ly đã pha xong cho phép Reassign Cup cho đơn sau cùng cấu hình (BR-62, F-153) | TC-184, TC-185 |
| RV3-23 | Trả hàng sau thanh toán thu hồi nhầm đồ uống đã dùng vào kho bán lại | Void trong 10 phút; hàng đóng gói nguyên seal được restock; đồ tươi cấm tuyệt đối nhập kho (BR-63, F-154) | TC-186, TC-187 |
| RV3-24 | Đứt cáp quang Internet làm tê liệt toàn bộ quầy bán hàng | Chế độ POS Ngoại tuyến lưu SQLite ký số HMAC SHA-256; đồng bộ FIFO ưu tiên khách tại quầy (BR-64, F-155, F-156) | TC-188, TC-189 |
| RV3-25 | Khách muốn chia nhiều nguồn tiền (Điểm + MoMo + Thẻ + Tiền mặt) | Sổ cái thanh toán kết hợp Split Payment; hỗ trợ Graceful Abort hoàn tiền an toàn khi dở dang (BR-65, F-157, F-158) | TC-190, TC-191, FX-12 |
