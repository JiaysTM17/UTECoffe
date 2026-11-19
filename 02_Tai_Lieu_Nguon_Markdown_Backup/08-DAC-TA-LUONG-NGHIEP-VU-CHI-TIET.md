# 08. Đặc tả luồng nghiệp vụ chi tiết để triển khai

**Phiên bản 1.2 — 18/11/2026.** 28 luồng dưới đây bổ sung bước xử lý cho các chức năng trong tài liệu 02. Mọi lệnh ghi phải kiểm quyền ở server, kiểm version, ghi audit và idempotency khi có tác động đơn/tiền/kho. Trạng thái hiển thị không thay thế các sự kiện nghiệp vụ. Tất cả thông số thời gian/số lượng là cấu hình demo, chưa phải chính sách vận hành thật.

## 1. UC-01 — Tài khoản, xác minh, phục hồi và phiên

**Tác nhân:** khách, nhân viên đã được cấp membership; quản trị không được tự đọc mật khẩu. **Đầu vào:** email, mật khẩu, tên hiển thị, consent cần thiết; token xác minh/phục hồi; sessionId khi thu hồi. **Điều kiện:** tài khoản không bị khóa, token đúng purpose và còn hạn. Online checkout yêu cầu đăng nhập; khách mua tại quầy không bắt buộc có tài khoản.

1. Đăng ký chuẩn hóa email theo quy tắc duy nhất của hệ thống, kiểm unique trong DB và trả thông báo không dùng để dò tài khoản. Hash mật khẩu bằng cơ chế PasswordEncoder đã chọn; không lưu bản gốc.
2. Tạo token xác minh dùng một lần, lưu hash và thời hạn; email được gửi qua outbox. Gửi lại không tạo hàng loạt token còn hiệu lực; có cooldown/rate limit và thông báo nhất quán.
3. Xác minh bằng thao tác chủ động, đổi trạng thái tài khoản trong transaction; token bị dùng lại không kích hoạt thêm quyền. Đăng nhập tạo session, access và refresh; JWT không chứa địa chỉ/điện thoại.
4. Quên mật khẩu trả cùng kiểu phản hồi dù email có tồn tại; reset hợp lệ thu hồi các phiên cũ, ghi audit và thông báo. Hai request dùng cùng token chỉ một request đổi mật khẩu.
5. P1: đổi email cần re-auth, xác minh email mới và thông báo email cũ; unique kiểm lại lúc commit. Không thay userId hoặc chủ sở hữu đơn. Đổi số điện thoại không tự đánh dấu đã xác minh OTP nếu chưa có tích hợp.
6. P1: xem danh sách phiên rút gọn, thu hồi một phiên hoặc tất cả; không lộ refresh token. Thu hồi ảnh hưởng HTTP và subscription WS. Giao diện phân biệt phiên đang dùng và cảnh báo sẽ cần đăng nhập lại.

**Nhánh lỗi:** token hết hạn → đề nghị gửi lại; refresh reuse → thu hồi token family theo chính sách; tài khoản đã khóa → từ chối cả refresh; request hết phiên sau khi tạo đơn → sau đăng nhập tra lại đơn bằng operation key, không đặt thêm. **Đầu ra:** identity/session hợp lệ và lịch sử thao tác, không tự cấp quyền nhân viên khi đăng ký. **Nghiệm thu:** TC-053–060,080,114–117; đổi email không đổi lịch sử mua hay điểm.

## 2. UC-02 — Giỏ khách và hợp nhất sau đăng nhập

**Tác nhân:** khách chưa/đã đăng nhập. **Đầu vào:** branchId, cấu hình món, quantity, cartVersion. Giỏ khách là ý định, không có quyền truy cập đơn hoặc giữ hàng.

1. Chọn cơ sở trước khi thêm; canonical key gồm món/size/đường/đá/topping/mode phù hợp. Hai ly khác tùy chỉnh là hai dòng. Quantity tính bằng số nguyên ly; nguyên liệu dùng decimal ở phía server.
2. Canonical key còn bao gồm ghi chú đã chuẩn hóa theo chính sách: khác note không gộp. Mỗi lần sửa tăng cartVersion. Tab dùng version cũ nhận xung đột cùng giỏ hiện tại, không ghi đè thay đổi mới nhất.
3. Sau login, nếu hai giỏ cùng cơ sở, đề nghị hợp nhất bằng canonical key và kiểm giới hạn; món không còn bán được giữ dưới trạng thái cần xử lý. Không im lặng loại món.
4. Nếu khác cơ sở, khách chọn giữ giỏ nào; chỉ sau xác nhận mới chuyển. Không gộp thành đơn nhiều cơ sở. Một cartGeneration đã checkout không tạo đơn mới bằng key khác.
5. Tính lại giá/menu sau merge; thay đổi phải được khách thấy trước quote/đặt hàng. Sau checkout thành công, đánh dấu generation đã dùng, tạo giỏ mới cho lần mua tiếp theo.

**Lỗi:** cookie giỏ khách giả → không tin giá/quyền bên trong; hai tab merge đồng thời → một version thắng; mất mạng → tải lại giỏ. **Nghiệm thu:** TC-005–011,077–080; không giữ nguyên liệu khi chỉ thêm giỏ.

## 3. UC-03 — Chọn cơ sở, giờ và kênh bán

**Tác nhân:** khách, quản lý cơ sở. **Đầu vào:** vị trí tự nhập hoặc vị trí được cho phép, mode PICKUP/DELIVERY/ON_PREMISE, lịch và ngoại lệ. Không bắt chia sẻ vị trí để xem menu.

1. Hiện cơ sở, giờ địa phương, trạng thái nhận đơn, phương thức nhận, ước tính chờ và lý do tạm ngừng nếu có. Vị trí gần nhất chỉ gợi ý; khách quyết định cơ sở.
2. Backend kiểm lịch thường, ngày ngoại lệ, cờ ngừng nhận, mode, vùng phục vụ và khả năng hoàn thành trước giờ giới hạn. Lưu UTC, quy đổi Asia/Ho_Chi_Minh cho lịch.
3. Quản lý đổi lịch hoặc tạm ngừng có reason/version. Không xóa đơn đã nhận; dashboard liệt kê đơn bị ảnh hưởng và yêu cầu phân công xử lý.
4. Đổi cơ sở khi có giỏ cần xác nhận; options/giá/recipe/voucher được tính lại. Đổi địa chỉ giao không tự chuyển đơn đã tạo sang cơ sở khác.

**Lỗi:** không có vùng phục vụ → đề nghị pickup/cơ sở khác; API báo cơ sở đóng trong lúc quote → quote mới hoặc dừng; khôi phục sau sự cố không tự bật bán chỉ vì lịch đang mở. **Nghiệm thu:** TC-001–003,007,019,121–124. Mỗi đơn có đúng một branchId bất biến.

## 4. UC-04 — Tạo và xuất bản món theo cơ sở

**Tác nhân:** quản trị menu và quản lý có quyền giá/menu cơ sở. **Đầu vào:** tên/mô tả, category, size, option group, giá, recipe version, ảnh, allergen/thông tin cần biết, mode và khoảng hiệu lực.

1. Tạo nháp; cấu hình nhóm lựa chọn min/max, option mặc định, phụ thu, ingredient delta, điều kiện hỗ trợ nóng/lạnh và mode.
2. Gắn ảnh từ asset đã kiểm owner/purpose; không nhận URL bất kỳ rồi tải về server. Giá tiền là số nguyên VND; giá cơ sở không tự thay giá chuỗi ngoài phạm vi được cấp.
3. Kiểm readiness: có giá hợp lệ, recipe/ingredient/unit và định mức đủ, tổ hợp option có thể mua, ảnh/slug không xung đột, cơ sở được bật. Lỗi trả về theo trường để sửa bản nháp.
4. Xuất bản version mới; đơn/quote cũ lưu snapshot. Draft không xuất hiện công khai. Ngừng món chặn mua mới nhưng giữ chi tiết đơn và tài liệu hỗ trợ.
5. Giá đến hạn có hiệu lực qua điều kiện thời gian ở truy vấn; scheduler chỉ hỗ trợ thông báo/cache, không là nguồn quyết định duy nhất.

**Lỗi:** option bị xóa đang dùng → soft-disable/version; chỉnh recipe sau khi order reserve → không thay recipe snapshot; asset đã xóa → chặn publish hoặc placeholder theo trạng thái. **Nghiệm thu:** TC-004–011,018,061,091,113. W06/W07 phải bàn giao form lỗi, empty state và preview trước publish.

## 5. UC-05 — Cấu hình một ly và kiểm khả dụng

**Tác nhân:** người mua/thu ngân. **Đầu vào:** itemId, variantId, selections, quantity, branchId, fulfillmentMode.

1. Backend kiểm mọi selection thuộc đúng group của món/size, số lượng trong giới hạn, không trùng topping bị cấm và các tùy chọn phụ thuộc hợp lệ.
2. Tính giá từ price version và phụ thu server; tính nhu cầu nguyên liệu = recipe theo size + delta tùy chọn + topping + bao bì theo mode. Không dùng giá do JavaScript gửi.
3. Tổng hợp nguyên liệu dùng chung trên toàn giỏ; cùng sữa ở hai món phải cộng nhu cầu trước kiểm. Khả dụng = tồn có thể bán − đã giữ, trừ lô khóa/hết hạn.
4. Trả cấu hình canonical, mô tả tiếng Việt, giá hiện hành, giới hạn số lượng tham khảo và lý do không mua được. Thông tin khả dụng chưa là cam kết giữ.

**Lỗi:** đá 0 không được suy ra giảm sữa nếu recipe không định nghĩa; topping hết → để khách tự chọn thay; món nóng không có đá → báo option không hợp lệ, không âm thầm bỏ lựa chọn. **Nghiệm thu:** TC-004–018,088,096; tại chỗ dùng bao bì đúng BR-28.

## 6. UC-06 — Mua lại, yêu thích và mẫu cấu hình

**Tác nhân:** thành viên. **Đầu vào:** orderId cũ hoặc favoriteId, cơ sở muốn mua, nhãn mẫu tối đa 80 ký tự. **Phạm vi:** mua lại lõi; yêu thích/mẫu P1.

1. Kiểm owner trước đọc snapshot; copy cấu hình sang giỏ mới, không copy giá/khuyến mãi/recipe giữ hàng cũ.
2. Đối chiếu menu hiện tại và cơ sở: hiển thị món/option mất, giá đổi, mode khác. Khách chọn thay hoặc bỏ từng dòng; không tự đổi sữa/topping có thể ảnh hưởng dị ứng.
3. Lưu favorite không giữ tồn/capacity hay quyền dùng voucher. Mỗi mẫu chứa product/variant/selection IDs và tên tham khảo, không phải đơn.
4. Món ngừng bán vẫn có thẻ “không còn bán”; xóa favorite chỉ xóa quan hệ của người đó. Đặt lại đi qua UC-05/07 như mua mới.

**Lỗi:** đọc favorite của người khác → từ chối không lộ nội dung; thiếu option → cần sửa; phiên hết hạn → giữ ý định an toàn sau login. **Nghiệm thu:** TC-119,007–010; không tạo đơn chỉ bằng nút “lưu yêu thích”.

## 7. UC-07 — Báo giá, giữ nguyên liệu/capacity và tạo đơn

**Tác nhân:** khách đăng nhập/thu ngân. **Đầu vào:** cartId/version, branch, mode, địa chỉ nếu giao, voucher nếu có, quoteId, idempotency key. **Tiền đề:** toàn bộ dòng hợp lệ và trong giới hạn; quote còn hạn, chưa sử dụng.

1. Tính quote theo server: dòng/đơn vị, giảm phân bổ, phí mode, tổng G, ETA có điều kiện, policy/pricing/cart versions và expiresAt. Quote không giữ tài nguyên.
2. Khi xác nhận, transaction khóa theo thứ tự thống nhất: hạn mức tài khoản → cart/quote → quota khuyến mãi nếu có → capacity → ingredient balances/lots đã sắp ID. Toàn bộ service dùng cùng thứ tự; không gọi provider khi đang khóa.
3. Kiểm quote/cart generation chưa dùng, quyền sở hữu, phiên bản, tổng giá và feasibility. Nếu thay đổi có ảnh hưởng tiền/cấu hình/ETA vượt ngưỡng, không tạo đơn từ dữ liệu cũ; trả quote mới để khách xác nhận.
4. P0 đề xuất tối đa hai đơn đang chờ trả tiền/nhận đơn mỗi tài khoản, đồng thời áp trần số ly đang giữ. Đếm và tạo trong cùng giao dịch có khóa theo account; không dùng truy vấn count ngoài transaction.
5. Tính workUnits cho cả đơn, tìm bucket 5 phút sớm nhất còn chỗ trong giờ làm; cả đơn nằm một bucket P0. Đơn lớn hơn sức chứa một bucket nhận lỗi có hướng liên hệ đặt nhóm. Chốt promisedReadyAt và capacity reservation.
6. Giữ nguyên liệu FEFO có thể sử dụng đến thời điểm pha dự kiến, tạo Order/Line/Unit snapshots, reservation allocations, voucher hold, outbox/audit; consume quote và cart generation cùng commit.
7. Trả orderCode và server state. Nếu kết nối mất sau commit, key cũ trả cùng kết quả. Cùng key khác payload → conflict; key mới với quote/generation cũ cũng không tạo thêm đơn.

**Lỗi:** hết một nguyên liệu/quota/bucket → rollback tất cả, trả reason và quote mới; deadlock/serialization retry giới hạn ở server với cùng command; hết hạn quote → không tự tăng tiền; giữ lô không đủ tuổi thọ → tìm lô khác hoặc từ chối. **Nghiệm thu:** TC-008–022,025–026,077–080,120–122. Tồn không âm, capacity không vượt và giữ không nhân đôi.

## 8. UC-08 — Thanh toán, callback và kết quả không rõ

**Tác nhân:** khách, payment adapter, tài chính. **Đầu vào:** orderId, paymentAttemptId, providerEvent; không nhận “paid=true” từ browser làm bằng chứng.

1. Kiểm E và số còn phải thu, phương thức được phép; tạo attempt có merchant reference duy nhất trước khi gọi adapter ngoài transaction. Ghi mode FAKE/SANDBOX/LIVE rõ trên giao diện/báo cáo.
2. Timeout không đồng nghĩa thất bại: chuyển UNKNOWN, giữ inquiry job và chặn tự tạo khoản thu thay thế đến khi có quyết định/tra soát phù hợp. Cho người dùng xem trạng thái và tải lại, không bấm lặp mù.
3. Callback được kiểm chữ ký, merchant, reference, currency/amount theo hợp đồng đối tác đã xác minh. Lưu inbox unique event/transaction, phản hồi theo protocol; browser return chỉ phục vụ điều hướng.
4. Ghi Receipt một lần; khóa order để tính R/E/H và quyết định đủ tiền. Nếu đơn đã hủy/không còn khả năng phục vụ, ghi tiền thực nhận rồi tạo hồ sơ khoản dư/hoàn; không tự mở lại đơn đã hủy.
5. Payment thành công còn phải qua gate nhận đơn và thời hạn/ETA. Tiền trễ không tạo thêm giữ hàng hoặc tự pha nếu tài nguyên đã được giải phóng.

**Lỗi:** sai chữ ký/tiền → không credit, lưu dấu tra soát không lộ secret; callback trễ/lặp/sai thứ tự → trạng thái không lùi; thu hai lần hợp lệ → hai receipt thật, xử lý phần dư, không giấu receipt thứ hai. **Nghiệm thu:** TC-027–033,084–087,143,147; fake phải có fixture lỗi tương tự, không được gọi là đã tích hợp sandbox thật.

## 9. UC-09 — Bán tại quầy, khách vãng lai và chứng từ

**Tác nhân:** thu ngân đúng cơ sở (gắn ca khi bật P1), khách có/không có tài khoản. **Đầu vào:** menu cơ sở, cấu hình ly, mode, tiền đưa, membership nếu khách chủ động cung cấp và được xác minh theo chính sách.

1. Thu ngân dùng cùng pricing/reservation engine; không nhập giá tùy ý. Override giảm/hoàn phải theo hạn mức và lý do, có approver khi cần.
2. Chốt đơn và ghi khoản thu bằng lệnh riêng có idempotency; paid amount bằng số phải thu, tender/change lưu riêng. FX-06: cần thu 67.200đ, nhận 100.000đ, thối 32.800đ; Receipt tăng 67.200đ.
3. In/hiện biên nhận chứa orderCode, cơ sở, giờ, items, khoản giảm, tổng, phương thức và trạng thái. In lại có nhãn bản in lại, không tạo Order/Receipt mới.
4. Đơn khách vãng lai giữ customerId rỗng; nhân viên có thể mở hậu mãi sau xác minh biên nhận/giao dịch. Ghi phương thức xác minh và contact consent; không buộc tạo tài khoản.
5. Khách có tài khoản mới không tự nhận đơn cũ chỉ vì cùng số điện thoại. Chuyển quyền sở hữu nếu tương lai cần phải là quy trình riêng có chứng cứ, chưa nằm P0/P1.

**Lỗi:** tiền đưa thiếu → chưa ghi đã thu đủ; khi bật P1, ca đóng → mở ca hợp lệ/ủy quyền theo quy trình, không sửa ca cũ; in lỗi sau thu → in lại; ảnh hóa đơn không tự đủ quyền refund. **Nghiệm thu:** TC-081–084,097–098,118,142.

## 10. UC-10 — Nhận/từ chối đơn và xin đổi ETA

**Tác nhân:** nhân viên nhận đơn, quản lý, khách. **Tiền đề:** đơn chưa hủy, điều kiện thanh toán theo mode đạt, tài nguyên còn hợp lệ. Order version bắt buộc.

1. Xem hạn nhận, promisedReadyAt, nguyên liệu và queue; nhận đơn bằng command, không sửa status tùy chọn. Nếu cần từ chối, chọn reason và phương án tiền/giữ hàng đúng trạng thái.
2. Quá hạn nhận: job khóa đơn, kiểm lại trạng thái; chỉ giải phóng phần chưa tiêu hao và tạo nghĩa vụ hoàn nếu đã thu. Đồng thời bấm nhận và job expiry chỉ một kết quả hợp lệ.
3. ETA thay đổi trên 5 phút demo cần ETAProposal lưu old/new, reason, expiresAt 5 phút, affected order version. Gửi thông báo nhưng dữ liệu proposal ở DB là nguồn thật.
4. Khách đồng ý khi proposal còn hạn → cập nhật lịch/capacity theo transaction, giữ nguyên E. Từ chối/hết hạn → dừng trước pha, xử lý hủy/hoàn và giữ hàng theo chính sách; không coi im lặng là đồng ý.
5. Nếu đã pha mới có sự cố, đưa NEEDS_REVIEW, quản lý xác nhận cách cứu đơn/chất lượng; không dùng proposal để giấu đồ đã quá hạn. Thu thêm ngoài E là ngoài P0/P1.

**Nghiệm thu:** TC-020–022,085–087,121–124; thông báo lỗi không làm mất proposal, nhận trả lời lặp không đổi trạng thái hai lần.

## 11. UC-11 — Nhận phiếu, bắt đầu pha, hoàn tất và làm lại

**Tác nhân:** pha chế đúng cơ sở; quản lý khi recovery. **Đầu vào:** ticketId/version, claim, kết quả từng unit, reason nếu remake.

1. Queue REST trả snapshot và event cursor; WS chỉ báo thay đổi. Claim trước pha có lease demo 2 phút; hết lease có thể nhận lại nếu chưa start.
2. Start khóa ticket/unit/reservations; kiểm claim/quyền, lô chưa bị recall/hết hạn, recipe snapshot và tiền/gate order. Tiêu hao physical cùng kết thúc reservation allocations một lần.
3. In nhãn theo OrderUnit: món/tùy chỉnh, orderCode, unitCode, attempt; không in điện thoại/địa chỉ đầy đủ trên ly nếu không cần. Reprint dùng cùng unitCode và có nhãn lần in.
4. Đánh dấu READY từng unit khi kiểm thành phẩm; order READY khi mọi unit còn nghĩa vụ phục vụ đã ready. Unit đã VOID không làm queue chờ mãi.
5. Sai ly: ghi waste thành phẩm, tạo remake ticket attempt mới liên kết unit và nguồn complaint; reserve/consume nguyên liệu mới. Không cộng nguyên liệu của ly hỏng về kho và không tiêu hao raw lần nữa khi ghi waste.
6. App crash sau START: ticket vẫn PREPARING; quản lý kiểm thực tế rồi quyết định ready/waste/remake. Hết lease không tự trở về WAITING khi đã tiêu hao.

**Nghiệm thu:** TC-018,022,041–043,088–093,144; một unit chỉ có một active ticket; hai người start đồng thời không trừ hai lần.

## 12. UC-12 — Pickup và phục vụ tại chỗ

**Tác nhân:** người nhận, nhân viên bàn giao. **Đầu vào:** mã nhận gắn đơn, đối chiếu thông tin tối thiểu, unit/handover command.

1. Backend xác minh branch, trạng thái, payment coverage và units đã sẵn sàng. Không chỉ dựa ảnh màn hình mã đơn của khách.
2. Đối chiếu số ly/tùy chỉnh; một lần bàn giao theo chính sách đơn. P0 không cho tự phát tách nhiều lần nhận; partial cancellation đã được xử lý trước bàn giao.
3. Ghi Handover event, fulfilledAt trên units và COMPLETED khi đủ nghĩa vụ; ghi điểm theo điều kiện completed+paid. Hai thu ngân xác nhận cùng mã chỉ một handover có hiệu lực.
4. P1 tại chỗ lưu số bàn/điểm phục vụ dạng định danh cơ sở; thu trước, không mở tab nợ nhiều lượt. Bao bì recipe theo mode, không trừ ly mang đi nếu phục vụ bằng dụng cụ tái sử dụng.
5. No-show hoặc chất lượng quá thời gian demo đưa cần xử lý, ghi người quyết định waste/remake/hủy; không tự ghi đã nhận chỉ để đóng queue.

**Nghiệm thu:** TC-043–045,081,096,099; không cho nhận sau hủy, không nhận đơn cơ sở khác.

## 13. UC-13 — Hủy một phần, hoàn và làm lại sau bán

**Tác nhân:** khách, CSKH, quản lý/duyệt tiền. **Đầu vào:** orderUnitIds, reason, evidence assetIds, phương án; không chỉ nhận lineId+quantity mơ hồ.

1. Kiểm owner hoặc delegated support, phạm vi branch, unit chưa vượt quyền xử lý, policy snapshot lúc mua và thời gian thực tế. Ghi yêu cầu không đồng nghĩa đã hoàn.
2. Khóa order/units/refund obligations, phân biệt chưa thu, đã thu, chưa pha, đang pha và đã giao. Hủy unit chưa phục vụ giảm E bằng Adjustment; refund là dòng tiền H riêng.
3. Tính số tối đa từ net paid allocation từng unit và tổng R−H−pendingRefund; không hoàn theo giá niêm yết. Duplicate collection refund dùng nghĩa vụ khoản dư riêng, không trừ cap hoàn hàng hay điểm thêm lần nữa.
4. Duyệt bằng quyền/hạn mức; tạo RefundIntent với approver, reference và idempotency. Gọi provider ngoài transaction; UNKNOWN cần inquiry. Hoàn tiền mặt cần ca/người chi/bằng chứng; thành công mới tăng H.
5. Remake sau COMPLETED là hồ sơ phục vụ bổ sung liên kết complaint; không lùi order về PREPARING. Mỗi phương án có nghĩa vụ riêng; nếu kết hợp hoàn một phần và làm lại phải ghi rõ được duyệt, không tự cho cả hai toàn phần.
6. Điểm/voucher điều chỉnh theo entitlement/order ledger; raw đã tiêu hao không trở lại kho. Đóng case khi nghĩa vụ tiền và phục vụ đã xong, không vì người xử lý bấm “đã phản hồi”.

**Nghiệm thu:** TC-033–040,081–084,098,118,142–143; FX-01/02/06/07 đối chiếu tới từng đồng.

## 14. UC-14 — Giao nội bộ, giao lại, trách nhiệm hàng và COD

**Tác nhân:** điều phối, tài xế, khách, thu ngân nhận COD. **Phạm vi:** P1 giao nội bộ; external courier P2.

1. Quote kiểm vùng/địa chỉ/phí; sau order, đổi địa chỉ cần điều phối kiểm lại không làm tăng E P1. Địa chỉ ngoài vùng có phương án đã được khách chấp thuận hoặc hủy/hoàn.
2. Tạo một DeliveryTask cho đơn, một active DeliveryAttempt; assign tài xế có scope và khả dụng. Trước pickup có thể reassign có audit; sau pickup phải CustodyEvent có xác nhận giao/nhận hoặc supervisor xử lý thiếu bên.
3. Pickup liên kết READY units và thời hạn chất lượng; tài xế thấy tối thiểu địa chỉ/contact phục vụ nhiệm vụ. Người không được giao không đọc PII của chuyến.
4. Giao thành công lưu proof, time và số COD thực thu; Receipt cash và CashCustody theo source unique. Thực giao nhưng thiếu COD lưu proof và collectionException, order NEEDS_REVIEW; không giả DELIVERY_FAILED để yêu cầu giao lại.
5. Giao thất bại lưu reason/contact attempt; retry chỉ sau khách đồng ý và chất lượng còn hợp lệ. Attempt mới không reset thời gian pha. Hết chất lượng → remake có nguồn mới hoặc quyết định hủy/hoàn.
6. Nộp COD là chuyển quyền giữ tiền, không thu khách lần hai. Đối chiếu task/attempt/driver/amount, ghi chênh lệch và owner. Đơn hoàn thành vẫn có thể còn COD chưa nộp.

**Nghiệm thu:** TC-049–051,131–133; tài xế đổi sau pickup không làm mất người đang giữ hàng/tiền.

## 15. UC-15 — Đặt mua và nhận nguyên liệu từng phần

**Tác nhân:** nhân viên kho, quản lý/duyệt mua. **Đầu vào:** supplier, purchase lines, unit conversion, receipt quantities, lot/expiry, chứng từ và đơn giá tham khảo.

1. Tạo purchase order và duyệt theo hạn mức; quantity ordered không tăng stock. Chỉnh sau duyệt tạo version/approval mới nếu vượt thẩm quyền.
2. Khi hàng đến, phân biệt received-at-door, accepted và rejected-at-door. Kiểm định lượng/đơn vị/hạn/tình trạng; chỉ accepted tạo receipt lot và stock movement.
3. Nhận từng phần: outstanding = ordered − accepted − phần đóng thiếu được duyệt; không coi rejected-at-door là đã nhập rồi tự hoàn. Mỗi chứng từ có reference/idempotency chống nhập lại.
4. Cho phép đóng phần còn thiếu có reason và approver; receipt đã post không sửa số trực tiếp. Sai chứng từ dùng corrective movement có liên kết, kiểm tồn/đơn đã dùng trước khi đảo.

**Nghiệm thu:** TC-125,129; 10kg đặt, nhận 6kg đạt +1kg bị từ chối thì stock tăng6kg, còn4kg chờ hoặc được đóng thiếu có lý do.

## 16. UC-16 — Trả nhà cung cấp và tham chiếu điều chỉnh tiền mua

**Tác nhân:** kho, quản lý, tài chính. **Đầu vào:** receipt/lot, lượng trả, reason, bằng chứng và supplier response.

1. Chọn đúng lô đã nhận; tính lượng có thể trả sau tiêu hao, chuyển và các lần trả trước. Đưa phần dự kiến trả vào quarantine, không còn sellable.
2. Nếu đang giữ cho order, hệ thống liệt kê affected orders và yêu cầu đổi allocation/hủy xử lý trước khi duyệt xuất trả. Không tự lấy nguyên liệu đã reserve gây món đang nhận thiếu hàng.
3. Duyệt → xuất trả giảm physical một lần → ghi supplier accepted/disputed/partially accepted. Hàng đã dùng không thể tạo xuất trả vật lý; tranh chấp chất lượng của phần đã dùng là hồ sơ khác.
4. Ghi credit reference/amount và đối chiếu chứng từ nhà cung cấp; đây là tham chiếu quản trị, chưa là phân hệ công nợ kế toán đầy đủ. Không sửa cost snapshot của ly đã bán.

**Nghiệm thu:** TC-126–127; request lặp không xuất hai lần; supplier chấp nhận ít hơn không tự tăng lại lượng chưa thực nhận về.

## 17. UC-17 — Mẻ sơ chế, yield, mở bao và an toàn lô

**Tác nhân:** pha chế/kho. **Đầu vào:** recipe sơ chế version, source lot allocations, lượng thực dùng, output yield, thời điểm làm/mở, hạn sử dụng theo policy được duyệt.

1. Reserve/consume nguồn một lần, ghi PrepBatch và output lot theo yield thực đo. Chênh lệch lý thuyết/thực tế có reason và người duyệt nếu vượt tolerance.
2. Bán món dùng output ingredient không tiêu hao lại nguồn raw của batch. Không quy đổi kg↔ml nếu chưa có conversion/density được xác nhận cho nguyên liệu đó.
3. Mở bao/tách lô ghi parent lot và lượng; hạn con là giới hạn sớm hơn giữa hạn nhà cung cấp và hạn sau mở/chế biến theo policy. Không gia hạn lô bằng thao tác chuyển kho hoặc tạo batch lại.
4. Recall/khóa lô chặn phân bổ và start mới; tra ngược batch parents và đơn đã consume để phân công xử lý. Không xóa lịch sử lô đã dùng.

**Nghiệm thu:** TC-090,128–129. Các số phút/ngày trong seed chỉ minh họa; vận hành phải có quy trình thực phẩm được thẩm định.

## 18. UC-18 — Chuyển kho, kiểm kê và hao hụt

**Tác nhân:** kho nguồn/kho đích/quản lý. **Đầu vào:** transfer lines/lots, dispatch/receive quantities, count snapshot và thời điểm cutoff.

1. Transfer được duyệt và xuất: giảm nguồn, tăng in-transit. Nhận từng phần ở đích tăng đúng lượng thực nhận; phần thiếu ghi transit loss/dispute, không giảm nguồn lần nữa.
2. Đích nhận lô giữ nguồn gốc/hạn, kiểm condition. Không tự nhận đủ bằng quantity kế hoạch. Hủy chỉ phần chưa xuất; hàng đã đi cần chứng từ xử lý ngược riêng.
3. P1 chọn kiểm kê có khóa khu vực/nguyên liệu trong thời gian ngắn: stop mới reserve/start/receive/transfer trên tập đã khóa; đơn đã pha ngoài tập vẫn chạy. Ghi cutoff ledger sequence, lý thuyết và thực đếm trong cùng epoch.
4. Không cho post movement vào tập kiểm kê khi đang đếm; nếu bắt buộc mở lại khẩn cấp, hủy phiên đếm/chốt lại cutoff và đếm lại. P2 mới thiết kế kiểm kê động có quy tắc bù movement.
5. Quản lý duyệt variance; ghi adjustment một lần; không ghi đè balance trực tiếp. Waste raw/finished/transit là ba loại; finished waste không trừ raw đã consume lần hai.

**Nghiệm thu:** TC-023–024,089,130; FX-03/05. Repost chứng từ/kiểm kê cùng key không tạo movement thứ hai.

## 19. UC-19 — Bánh, combo và fulfillment hỗn hợp

**Tác nhân:** quản trị menu, khách, quầy. **Phạm vi:** P1.

1. Bánh là stocked item theo lô/hạn; đồ uống là prepared item. Combo có version thành phần, quantity, lựa chọn được phép và giá bán, không chỉ là dòng mô tả.
2. Pricing phân bổ combo theo trọng số giá tham chiếu bằng largest remainder; lưu allocation trên từng unit, tie-break ổn định. Không dùng floating-point tiền.
3. Tạo nghĩa vụ picking bánh và pha đồ uống; chỉ READY khi mọi unit còn nghĩa vụ đạt điều kiện. Hết bánh thì combo không mua được dù trà còn đủ nguyên liệu.
4. Trả một thành phần theo net allocation đã chốt, không định giá lại món giữ. Bao bì theo mode và thành phần được tính rõ; không tiêu hao trùng bao combo và bao riêng nếu recipe không yêu cầu.

**Nghiệm thu:** TC-094–096.846đ +bánh21.154đ =55.000đ; hoàn bánh đúng21.154đ.

## 20. UC-20 — Voucher, quota và phân bổ giảm giá

**Tác nhân:** marketing có quyền, khách, checkout. **Đầu vào:** thời hạn, phạm vi cơ sở/món/mode, threshold, mức giảm/trần, quota user/global, budget và luật cộng dồn.

1. Validate promotion version: thời gian hợp lệ, không âm, phạm vi tồn tại, có quy tắc khi trùng. P1 một mã voucher đơn; không tự tối ưu nhiều mã nếu chưa có luật.
2. Quote giải thích đủ/thiếu điều kiện và giảm dự kiến. Commit checkout khóa campaign/user redemption và giữ quota/budget cùng order; quote đơn thuần không giữ lượt.
3. Phân bổ giảm lên eligible units bằng số nguyên và largest remainder; lưu nguồn từng khoản. Tổng allocations bằng discount, net không âm. Phí giao có policy riêng, không mặc định chịu giảm món.
4. Hoàn/hủy giải phóng hoặc đánh dấu sử dụng theo policy snapshot; refund một phần không tự trả toàn bộ quota. Mã hết hạn không được hồi sinh bằng retry.

**Nghiệm thu:** TC-012,037–038,134,136; hai người tranh quota/budget cuối chỉ một người được giữ.

## 21. UC-21 — Điểm, đổi ưu đãi và điều chỉnh sau hoàn

**Tác nhân:** thành viên, loyalty job, CSKH có quyền. **Đầu vào:** order receipt/fulfillment facts; reward catalog version; point lots.

1. Điểm chỉ ghi khi completed+paid theo net eligible money; floor theo toàn đơn, không làm tròn từng ly rồi cộng. Unique source tránh WS/callback lặp phát điểm lại.
2. Đổi thưởng khóa tài khoản điểm, dùng lot FEFO chưa hết hạn, tạo redemption và voucher cùng transaction. Hai tab không chi được cùng số điểm.
3. Refund tính entitlement mới của toàn đơn, ghi delta reversal. Thứ tự xử lý phần điểm còn lại/đã hết hạn/đã tiêu dùng theo BR-31; điểm đã hết hạn không bị thu hồi lần hai thành nợ.
4. Voucher đổi từ điểm có lifecycle riêng. Hủy được hoàn điểm hay cấp voucher thay thế tùy nguyên nhân/policy snapshot; voucher thay thế có liên kết nguồn duy nhất và thời hạn rõ.
5. Điểm điều chỉnh thủ công cần lý do/approver và entry mới; không sửa balance bằng form. Khách xem ledger giải thích nguồn và hạn.

**Nghiệm thu:** TC-039–040,102–103,135–136; FX-01 từ105.000đ về67.200đ thì entitlement10→6, không dựa mỗi refund làm tròn độc lập.

## 22. UC-22 — Mở cơ sở, mở/đóng ca và bàn giao ngoại lệ

**Tác nhân:** quản lý, thu ngân, người nhận ca. **Đầu vào:** checklist, cash float, cash movements, thực đếm và danh sách việc mở.

1. Kiểm thiết bị, nhân sự, lô/menu/mode, khu vực sự cố trước bật nhận đơn. Giờ lịch không thay hành động khôi phục cơ sở đã bị pause vì incident.
2. Mở CashShift với đầu ca đã xác nhận; mọi thu/chi/hoàn/nộp có source, actor, amount và chứng từ. Tender/change không làm doanh thu tăng quá khoản phải thu.
3. Khi đóng, lấy cutoff transactions, tính expected = opening+receipts−refunds−expenses−deposits, nhập actual riêng. Chênh lệch không bị che bằng sửa receipt; tạo case với owner.
4. Liệt kê đơn chờ, hàng đã pha, delivery/COD chưa nộp, refund/complaint đang mở. Bàn giao từng việc cho actor/ca tiếp, giữ deadline; không ép tất cả đơn COMPLETED để đóng ca.
5. Sự cố đóng cửa đột ngột tạo BranchIncident, dừng nhận mới, xử lý các đơn theo đã/chưa tiêu hao và thông báo. Kết thúc incident cần kiểm khả năng phục vụ lại.

**Nghiệm thu:** TC-073–074,123–124,142. Thu hôm qua hoàn hôm nay xuất hiện ở đúng ca/ngày thực chi, vẫn liên kết đơn gốc.

## 23. UC-23 — Hỗ trợ, đánh giá, kiểm duyệt và SLA

**Tác nhân:** khách/khách vãng lai thông qua nhân viên, CSKH, quản lý duyệt. **Đầu vào:** category, description, order/unit nếu có, evidence assets và contact consent.

1. Tạo case, phân loại, ưu tiên và owner/deadline; gửi acknowledgment. Ảnh riêng gắn purpose CASE_EVIDENCE, chỉ đọc qua proxy kiểm quyền mỗi lần.
2. Nhân viên yêu cầu thêm thông tin hoặc đề xuất resolution; ghi history và hạn phản hồi. Quyền trả lời không tự bao gồm quyền hoàn tiền vượt hạn mức.
3. Review sau mua chỉ từ owner có unit/order đủ điều kiện; unique review subject theo policy, cho edit có version/history. Nội dung tiêu cực không tự là vi phạm.
4. Report review → moderator xem lý do/bằng chứng → giữ/ẩn/gỡ có reason → thông báo và đường khiếu nại. Giữ lịch sử nghiệp vụ, không xóa đơn vì review bị gỡ.
5. Đóng case khi nghĩa vụ hoàn/làm lại/thông báo đã xong; overdue job chuyển mức hoặc nhắc owner, không tự chấp nhận hoàn tiền.

**Nghiệm thu:** TC-033–040,053–054,061–062,100–101,118,137,139,146. URL asset bị đoán không đọc được ảnh người khác.

## 24. UC-24 — Nội dung, tìm kiếm và thông báo

**Tác nhân:** content editor, khách, notification worker. **Đầu vào:** nội dung, slug, asset, publishAt/unpublishAt; notification preferences.

1. CMS có draft/preview/published/archived, version và quyền publish. Preview không mở công khai bằng URL dễ đoán. Nội dung rich text phải sanitization theo allowlist, không dùng escape giả rồi render raw.
2. Tìm kiếm menu theo tên/từ khóa tiếng Việt, filter cơ sở/mode/khả dụng; phân trang/sort ổn định. Không tuyên bố tìm kiếm vector hoặc cá nhân hóa nếu chưa thuộc scope.
3. Scheduled publish/unpublish xét thời gian tại query để không lộ nháp nếu job trễ; cache có version/invalidation. Link món ngừng bán vẫn có trạng thái giải thích.
4. Thông báo giao dịch dùng outbox+template, dedup theo event/channel/recipient. Marketing cần preference/consent tách; bỏ marketing không chặn thông báo cần cho đơn đang xử lý.
5. Email/push lỗi không rollback order đã commit; retry có giới hạn, xem delivery status. WS không phải nơi duy nhất chứa thông báo.

**Nghiệm thu:** TC-063,068,076,113,138–139,147; không gửi một event hai lần chỉ vì worker restart.

## 25. UC-25 — Import có xem trước và commit có phiên bản

**Tác nhân:** quản trị menu/kho được cấp quyền theo loại import. **Đầu vào:** file giới hạn, mapping cột, scope branch, operation key.

1. P1 nhận CSV UTF-8 tối đa500 dòng demo, không macro; kiểm size trước parse, header/type/unique/reference từng dòng. Ingredient import chỉ master, không balance. Giá import tạo version mới.
2. Lưu ImportBatch owner/scope/fileHash và preview: số thêm/sửa/bỏ, lỗi row/field, target versions. Không cập nhật bất cứ dòng dữ liệu nghiệp vụ nào ở bước preview.
3. Confirm yêu cầu mọi dòng hợp lệ và version không đổi. Một lỗi hoặc target bị chỉnh sau preview → reject cả batch, cần preview lại; không commit nửa file.
4. Transaction nhỏ commit toàn bộ; unique batch/operation không nhân bản khi retry. Cùng file ở operation khác phải cảnh báo nhưng cho phép có chủ đích nếu nội dung/version hợp lệ, không dùng fileHash toàn hệ làm cấm vĩnh viễn.
5. Báo cáo lỗi CSV chống spreadsheet formula injection. Media dùng assetId đã thuộc owner/purpose; không fetch URL nhập từ file. Batch lớn hơn giới hạn là P2 job riêng.

**Nghiệm thu:** TC-140–141; không có đường import order paid, role, stock balance hoặc ledger trực tiếp.

## 26. UC-26 — Báo cáo, đối soát và khóa kỳ

**Tác nhân:** quản lý cơ sở, tài chính chuỗi. **Đầu vào:** khoảng ngày, cơ sở, timezone, ngày đơn/ngày thu/ngày hoàn, provider statement.

1. Chọn rõ trục thời gian và chỉ số: gross/discount/net obligation/collected/refunded/COD held/expenses. Không gộp tất cả thành một “doanh thu”. Hiện dataAsOf/filter/metricVersion.
2. Đối chiếu Receipt/Refund/ProviderEvent/statement theo external reference, amount, currency và ngày; import lặp không nhân bản. Thiếu/thừa tạo discrepancy có owner, không sửa ledger để ép khớp.
3. Khóa kỳ tạo snapshot và người duyệt; refund đến sau chốt là entry kỳ sau liên kết kỳ/đơn gốc. Reports cohort đơn và cash-flow ngày có thể khác nhau nhưng phải giải thích được.
4. Export chỉ scope được phép, giới hạn khối lượng, audit download và expiry. Tổng trên màn hình phải khớp tổng cùng filter trong file; PII tối thiểu.

**Nghiệm thu:** TC-052,064,072–075,106,127,142–145; báo cáo quản trị chưa thay sổ kế toán hay hóa đơn hợp pháp.

## 27. UC-27 — Quyền đặc biệt, MFA, dữ liệu cá nhân

**Tác nhân:** quản trị quyền, tài khoản đặc quyền, người yêu cầu dữ liệu. **Đầu vào:** membership/role, MFA enrollment/recovery, data request và căn cứ hold.

1. Cấp quyền theo role+branch+operation+limit; cấm tự duyệt khoản mình đề nghị vượt chính sách. Đổi quyền tăng authVersion, thu hồi/cập nhật session và WS.
2. P1 MFA cho tài khoản có khả năng thay quyền/duyệt tiền trước pilot tiền thật; enrollment cần re-auth, recovery codes lưu hash dùng một lần. Reset MFA có identity verification/audit, không chỉ một email yêu cầu.
3. Yêu cầu export/delete cần xác minh người yêu cầu, scope dữ liệu và trạng thái tranh chấp/retention hold. Tách dữ liệu có thể xóa/ẩn danh với ledger/chứng từ còn cần giữ.
4. Worker chỉ thực thi plan đã duyệt, có preview impact và audit. Media private đang giữ bằng chứng không bị orphan cleanup xóa. Không hứa xóa mọi dòng khi pháp lý/chứng từ còn ràng buộc chưa được xác nhận.

**Nghiệm thu:** TC-048,053–060,098,104–105,145–146; không xuất dữ liệu khách khác hoặc token/secret qua audit/export.

## 28. UC-28 — Job, retry, sự cố và phục hồi

**Tác nhân:** scheduler/worker, vận hành được quyền. **Đầu vào:** durable job/outbox/inbox, backup, release artifact và incidentId.

1. Mọi event được ghi cùng transaction với dữ liệu nguồn. Worker claim có lease, xử lý idempotent theo source key, đánh dấu sau kết quả; restart giữa chừng có thể nhận lại nhưng không tạo tác động kép.
2. Phân loại retryable/nonretryable/UNKNOWN financial; exponential backoff có trần và DLQ. Replay phải giữ business idempotency, chỉ reset trạng thái giao event, không xóa unique receipt/movement.
3. Theo dõi orders stuck, reservation/capacity overdue, payment UNKNOWN, DLQ, COD lệch, complaint SLA, asset orphan. Alert gắn runbook và người nhận, không chỉ ghi log.
4. Sự cố DB/provider → dừng nhận mới khi không thể bảo đảm commit; hiện trạng thái không chắc thay vì báo thành công. Read-only snapshot có nhãn stale, không cho ghi dựa vào số tồn cache.
5. Restore thử từ backup trên môi trường tách, kiểm ảnh cần thiết, migrations, invariants, ledger và provider events sau điểm khôi phục. Tra soát trước resume tránh thu/giao lại đơn đã thực hiện ngoài hệ thống.
6. Release có manifest, migration tương thích và rollback app; rollback schema phá dữ liệu không tự chạy. Demo dựng sạch theo README, không cần dữ liệu máy cá nhân.

**Nghiệm thu:** TC-020–021,033,066–070,107–108,147–148. Đây là yêu cầu kiểm thử tương lai; bộ hồ sơ hiện tại chưa có hệ thống để diễn tập thực tế.

## 29. UC-29 — Quản lý in ấn POS, hàng đợi Spooler và xử lý sự cố kẹt giấy
**Tác nhân:** Thu ngân, Hệ thống Spooler POS, Quản lý cơ sở.  
**Đầu vào:** Đơn hàng đã thanh toán `PAID`, cấu hình thiết bị in POS nhiệt K80/K58.  
**Tiền đề:** Máy in bill và máy in tem ly đã kết nối mạng LAN/USB của cửa hàng.
1. Thanh toán thành công, hệ thống tạo bản ghi `PrintJob(status=PENDING)` đẩy vào hàng đợi `PrintQueue`.
2. POS Spooler gửi gói tin ESC/POS thăm dò trạng thái máy in (`DLE EOT n`).
3. Máy in phản hồi Ready: Spooler đẩy dữ liệu in qua TCP port 9100; máy in in hóa đơn và tự động cắt giấy.
4. Cập nhật `PrintJob.status = COMPLETED`.
**Nhánh lỗi:**
- Máy in hết giấy/kẹt giấy: Spooler chuyển `RETRYING`, phát âm thanh cảnh báo trên POS. Thu ngân thay cuộn giấy K80 mới -> Máy in báo Ready -> Spooler tự động đẩy lệnh in thành công.
- Máy in hỏng quá 3 lần retry: Pop-up cho phép chuyển sang máy in phụ của Quầy 2 (Failover) hoặc xuất mã QR E-receipt cho khách quét.
**Đầu ra:** Hóa đơn in thành công hoặc E-receipt; log ghi nhận `HardwareAuditLog`.  
**Nghiệm thu:** TC-149, TC-150, TC-151, TC-156.

## 30. UC-30 — In lại hóa đơn thanh toán (Bill Reprint) có bảo vệ PIN Quản lý
**Tác nhân:** Thu ngân, Quản lý ca (Supervisor).  
**Đầu vào:** `orderId` đơn hàng đã thanh toán, mã PIN Quản lý ca, mã lý do in lại.  
**Tiền đề:** Hóa đơn gốc đã được in lần đầu khi hoàn tất thanh toán.
1. Thu ngân tìm đơn hàng trong lịch sử ca làm việc, bấm nút "In lại hóa đơn".
2. Màn hình POS khóa lại, hiển thị hộp thoại yêu cầu: "Xác thực Quản lý ca để in bản sao".
3. Quản lý ca nhập mã PIN 6 số cá nhân và chọn lý do in lại từ danh mục (Khách xin lại bill, Kẹt giấy rách bill, Đối soát).
4. Hệ thống xác thực PIN thành công, tăng `Order.reprintCount` lên 1 và ghi nhận vào `BillReprintLog`.
5. Máy in in hóa đơn có tiêu đề cực lớn `*** BẢN SAO / REPRINT - LẦN N ***` kèm thông tin người duyệt và thời gian in.
**Nhánh lỗi:**
- Nhập sai PIN quá 3 lần: Khóa tính năng duyệt trong 15 phút.
- Tài khoản thu ngân in lại quá 3 lần/ca: Tự động khóa quyền in lại, gửi cảnh báo bảo mật thời gian thực đến Store Manager.
**Đầu ra:** Bản sao hóa đơn có watermark rõ ràng; nhật ký kiểm toán lưu vết.  
**Nghiệm thu:** TC-154, TC-155.

## 31. UC-31 — Quản lý sơ đồ bàn, phục vụ tại chỗ, chuyển bàn, gộp bàn và tách hóa đơn
**Tác nhân:** Nhân viên phục vụ, Thu ngân, Barista, Quản lý ca.  
**Đầu vào:** Sơ đồ khu vực bàn `TableZone`, mã bàn, đơn hàng phục vụ tại chỗ `ON_PREMISE`.  
**Tiền đề:** Cơ sở đã thiết lập danh mục bàn ăn.
1. Phục vụ chọn bàn trống màu xanh (`AVAILABLE`) trên tablet -> Gán đơn hàng mới -> Bàn đổi sang màu đỏ (`OCCUPIED`).
2. Khách yêu cầu tính tiền: Thu ngân in phiếu tạm tính -> Bàn đổi màu vàng (`BILL_PRINTED`).
3. Khách thanh toán hoàn tất -> Bàn tự động chuyển sang màu xám (`CLEANING`).
4. Nhân viên phục vụ dọn dẹp xong bấm "Đã dọn xong" -> Bàn chuyển về màu xanh (`AVAILABLE`).
**Nhánh lỗi:**
- Chuyển bàn: Khách tại Bàn A muốn chuyển sang Bàn B (đang `AVAILABLE`). Khóa bàn B, cập nhật `Order.tableId = B`, bàn A chuyển `CLEANING`. Bắn tin WebSocket sang KDS Barista: "Đơn Bàn A chuyển sang Bàn B".
- Gộp bàn: Gộp Đơn 2 vào Đơn 1. Hủy voucher Đơn 2 hoàn ví khách, tính lại voucher Đơn 1 theo tổng tiền mới. Đơn 2 chuyển `MERGED_VOID`, bàn phụ giải phóng.
- Tách bàn / Tách hóa đơn: Tách theo món: tạo đơn con mới (hủy voucher đơn gốc nếu giảm dưới Min Spend). Tách chia đều Dutch Treat: chia thành $N$ biên lai thanh toán riêng theo thuật toán đồng dư lớn nhất.
**Đầu ra:** Trạng thái bàn thời gian thực khớp 100% thực địa; doanh thu và nguyên liệu không thất thoát.  
**Nghiệm thu:** TC-157, TC-158, TC-159, TC-160, TC-161, TC-162, FX-11.

## 32. UC-32 — Đặt bàn trước, quản lý tiền cọc và tự động giải phóng bàn No-show
**Tác nhân:** Khách hàng, Lễ tân, Hệ thống Scheduler, Kế toán.  
**Đầu vào:** Thông tin khách, số người, giờ hẹn $T$, khoản tiền đặt cọc giữ bàn.  
**Tiền đề:** Khách đặt bàn trước qua Web/Hotline có thanh toán cọc thành công.
1. Khách đặt bàn lúc giờ $T$, thanh toán cọc -> Hệ thống tạo `TableReservation(CONFIRMED)`.
2. Trước giờ hẹn 30 phút ($T-30m$), hệ thống tự động đổi trạng thái bàn sang `RESERVED`.
3. Khách đến đúng giờ: Lễ tân bấm "Check-in" -> Bàn chuyển `OCCUPIED`, tiền cọc được khấu trừ trực tiếp vào hóa đơn bàn.
**Nhánh lỗi:**
- Khách đến muộn trong thời gian ân hạn 15 phút ($T+15m$): Bàn vẫn được giữ nguyên vẹn.
- Khách vắng mặt quá 15 phút (No-show): Quá $T+15m$, Background Job tự động chuyển bàn về `AVAILABLE` cho khách vãng lai ngồi. Đơn cọc chuyển `NO_SHOW_FORFEITED`. Kế toán tự động tạo bút toán tịch thu cọc 100% vào Thu nhập khác TK 711.
- Khách báo hủy trước $\ge 2$ giờ: Hoàn cọc 100% qua cổng thanh toán hoặc quy đổi voucher.
**Đầu ra:** Bàn được khai thác tối đa giờ cao điểm; tiền cọc được hạch toán minh bạch.  
**Nghiệm thu:** TC-163, TC-164.

## 33. UC-33 — Vận hành ca làm việc xuyên ngày (Overnight Shift) và Rút tiền giữa ca (Cash Drop)
**Tác nhân:** Thu ngân, Quản lý ca.  
**Đầu vào:** Bắt đầu ca đêm (22:00), tiền đầu ca float, các giao dịch trong ca.  
**Tiền đề:** Cửa hàng mở cửa phục vụ ca đêm vắt qua nửa đêm.
1. Thu ngân mở ca đêm lúc 22:00 ngày D -> Khởi tạo `CashierShift` với `businessDate = D`.
2. Mọi đơn hàng, phiếu thu tiền mặt và tiêu hao kho phát sinh trong ca (kể cả lúc 02:00 sáng ngày D+1) đều gắn chặt với `businessDate = D`.
3. Két tiền duy trì trạng thái `OPEN` liên tục qua nửa đêm, không bị reset doanh thu lúc 00:00.
4. Bàn giao ca liên tục lúc 06:00 sáng ngày D+1 cho ca sáng.
**Nhánh lỗi:**
- Rút tiền giữa ca (Cash Drop): Tiền mặt trong két vượt 5.000.000đ, POS cảnh báo vàng. Thu ngân và Quản lý xác thực kép, rút bớt 3.000.000đ bỏ phong bì niêm phong bỏ khe két sắt an toàn Drop Safe. In 2 liên biên nhận; hệ thống trừ expected cash trong két.
**Đầu ra:** Doanh thu ca đêm tổng hợp trọn vẹn; rủi ro tiền mặt tại quầy được kiểm soát an toàn.  
**Nghiệm thu:** TC-165, TC-166, TC-170, FX-09.

## 34. UC-34 — Kiểm tiền mù, xử lý chênh lệch tiền két và đóng ca khẩn cấp do sự cố
**Tác nhân:** Thu ngân, Quản lý ca, Store Manager.  
**Đầu vào:** Bảng kê đếm tiền mặt thực tế theo mệnh giá (500k..1k).  
**Tiền đề:** Ca làm việc kết thúc thời gian phục vụ.
1. Thu ngân bấm "Đóng ca làm việc". Màn hình POS ẩn hoàn toàn số tiền sổ sách hệ thống.
2. Thu ngân đếm tiền mặt và nhập số lượng từng tờ tiền theo bảng kê mệnh giá.
3. Hệ thống tính chênh lệch $\Delta = Actual - Expected$.
4. Nếu $|\Delta| \le 20.000	ext{đ}$ (Dung sai Cấp 1): Tự động hạch toán làm tròn TK 642/711, hoàn tất đóng ca bình thường.
**Nhánh lỗi:**
- Chênh lệch Cấp 2 ($20	ext{k} - 100	ext{k}$): Đếm lại lần 2; nếu vẫn lệch bắt buộc nhập giải trình và Quản lý ca nhập PIN duyệt đóng ca.
- Chênh lệch Cấp 3 ($> 100	ext{k}$): Khóa đóng ca thường. Quản lý cửa hàng cùng kiểm đếm, lập Biên bản kiểm quỹ bất thường điện tử (`CashDiscrepancyReport`) có chữ ký hai bên. Khoản thiếu trừ lương thu ngân.
- Đóng ca khẩn cấp do mất điện/thiên tai: Quản lý kích hoạt `Emergency Force Close`. Giao dịch commit được đóng băng; đơn dở dang chuyển `INCIDENT_ABORTED` và tự động hoàn tiền online; tiền két niêm phong thủ công bằng văn bản giấy.
**Đầu ra:** Ca chuyển `CLOSED` hoặc `FORCED_CLOSED`; chênh lệch tiền mặt có hồ sơ giải trình minh bạch.  
**Nghiệm thu:** TC-167, TC-168, TC-169, TC-171, FX-09.

## 35. UC-35 — Áp dụng Voucher Sinh Nhật KYC và Ma trận xếp chồng ưu đãi đa cấp
**Tác nhân:** Khách hàng thành viên, Thu ngân, Hệ thống Pricing Engine.  
**Đầu vào:** Mã Voucher Sinh Nhật, ngày sinh KYC của khách hàng, giỏ hàng checkout.  
**Tiền đề:** Khách đã đăng ký ngày sinh trên hồ sơ thành viên trước ngày sinh $\ge 30$ ngày; trong tháng sinh nhật.
1. Khách chọn đồ uống và áp dụng Voucher Sinh Nhật.
2. Pricing Engine áp dụng Ma trận xếp chồng 4 cấp: Cấp 1 (Item) -> Cấp 2 (Order trên phần nguyên giá) -> Cấp 3 (Shipping) -> Cấp 4 (Loyalty Points trên số tiền còn lại).
3. Kiểm tra ràng buộc Giá sàn: Tổng chiết khấu không vượt quá 80% giá gốc; thực thu tối thiểu $\ge 5.000	ext{đ}$.
4. Tại quầy POS: Màn hình bắt buộc thu ngân đối chiếu CCCD/VNeID trùng khớp tên và ngày sinh -> Tích chọn xác nhận -> Hóa đơn giảm giá hợp lệ.
**Nhánh lỗi:**
- Khách đổi ngày sinh lần 2 để trục lợi: Hệ thống chặn cập nhật, yêu cầu liên hệ CSKH kèm CCCD.
- Áp dụng đồng thời 2 voucher cấp đơn: Hệ thống từ chối voucher thứ 2 theo quy tắc không cộng dồn cùng cấp.
**Đầu ra:** Khách hưởng đúng ưu đãi sinh nhật chính đáng; biên lợi nhuận giá vốn được bảo vệ an toàn.  
**Nghiệm thu:** TC-172, TC-173, TC-174.

## 36. UC-36 — Khóa giữ Voucher TTL 15 phút trong phiên thanh toán và Hoàn trả ưu đãi
**Tác nhân:** Khách hàng, Cổng thanh toán, Hệ thống Scheduler, CSKH.  
**Đầu vào:** Phiên checkout đơn hàng có áp dụng Voucher hợp lệ.  
**Tiền đề:** Voucher đang ở trạng thái `ACTIVE` hợp lệ tại thời điểm bắt đầu thanh toán.
1. Khách nhấn "Tiến hành thanh toán", hệ thống chuyển voucher sang `RESERVED` với TTL 15 phút.
2. Khách chuyển sang app MoMo/VNPAY xác thực. Ưu đãi được bảo lưu trọn vẹn kể cả khi đồng hồ chạy qua hạn chót chiến dịch.
3. Cổng thanh toán gửi Webhook xác nhận `PAID` trong 15 phút -> Voucher chuyển sang `COMMITTED` (Đã sử dụng).
**Nhánh lỗi:**
- Quá hạn 15 phút không thanh toán: Background Job tự động chuyển voucher từ `RESERVED` về `RELEASED` (hoặc `EXPIRED` nếu đã qua chiến dịch).
- Hủy đơn sau thanh toán: Hoàn 100% tiền thực trả, hoàn 100% điểm đã tiêu và khôi phục voucher về `ACTIVE` (tự động gia hạn thêm 24h nếu voucher hết hạn trong lúc chờ).
**Đầu ra:** Voucher không bị tranh chấp trùng lặp; quyền lợi khuyến mãi của khách được bảo vệ tuyệt đối.  
**Nghiệm thu:** TC-175, TC-176, TC-177, TC-178.

## 37. UC-37 — Giám sát nhiệt độ kho lạnh, cảnh báo sự cố và tự động cách ly lô (QUARANTINED)
**Tác nhân:** Cảm biến nhiệt độ IoT / Nhân viên kho, Hệ thống Cảnh báo, Quản lý cơ sở.  
**Đầu vào:** Dữ liệu nhiệt độ tủ mát/tủ đông, ngưỡng an toàn $2^\circ	ext{C} - 6^\circ	ext{C}$ (ngưỡng cảnh báo $> 8^\circ	ext{C}$).  
**Tiền đề:** Tủ mát lưu trữ các nguyên liệu nhạy cảm lạnh (`isPerishableCold = TRUE`).
1. Cảm biến IoT gửi dữ liệu nhiệt độ định kỳ 30 phút vào `StorageTemperatureLog`. Trạng thái bình thường `NORMAL`.
**Nhánh lỗi:**
- Nhiệt độ vượt $> 8^\circ	ext{C}$ liên tục quá 120 phút do hỏng tủ mát hoặc mất điện kéo dài:
  1. POS phát còi báo động đỏ, gửi tin nhắn cảnh báo khẩn cấp đến Quản lý cơ sở.
  2. Toàn bộ các lô sữa tươi, kem béo trong tủ đó tự động chuyển sang trạng thái `QUARANTINED` (Cách ly kiểm định).
  3. Quét menu: Tự động chuyển các món dùng nguyên liệu này (Latte, Cappuccino, Trà sữa tươi) sang `OUT_OF_STOCK` trên Web và POS.
**Đầu ra:** Ngăn chặn triệt để nguy cơ ngộ độc thực phẩm do nguyên liệu ôi thiu; bảo vệ uy tín thương hiệu.  
**Nghiệm thu:** TC-179, TC-180.

## 38. UC-38 — Lập phiếu xuất hủy nguyên liệu khẩn cấp có 2 ảnh hiện trường và duyệt đa cấp
**Tác nhân:** Quản lý kho, Quản lý cơ sở, Giám đốc Vận hành (OM), Kế toán.  
**Đầu vào:** Lô nguyên liệu bị hỏng sau cách ly kiểm định, đơn giá vốn nhập nguyên thủy.  
**Tiền đề:** Nguyên liệu được xác nhận đã bị hỏng hóc, biến chất do sự cố.
1. Quản lý kho tạo phiếu `InventoryDisposalVoucher`, chọn số lô, số lượng và lý do: `TEMP_BREACH_SPOILED`.
2. Ứng dụng bắt buộc mở camera chụp trực tiếp 2 ảnh: Ảnh 1 (Cận cảnh tem lô và hạn dùng); Ảnh 2 (Toàn cảnh đổ bỏ vào bồn rửa/thùng rác trước mặt Quản lý).
3. Hệ thống tính tổng tổn thất = $\sum(Quantity 	imes LotPurchaseCost)$.
4. Phê duyệt theo 3 hạn mức: $\le 300	ext{k}$ do Quản lý ca duyệt; $300	ext{k} - 2	ext{tr}$ do Quản lý cửa hàng duyệt; $> 2	ext{tr}$ do Giám đốc OM duyệt điện tử.
5. Sau khi duyệt: Giảm trừ tồn kho theo lô trong `IngredientLot`; Kế toán tự động định khoản vào Chi phí khác TK 811 (không đưa vào COGS TK 632).
**Nhánh lỗi:**
- Ảnh không hợp lệ hoặc thiếu ảnh: Hệ thống khóa nút gửi duyệt.
**Đầu ra:** Tồn kho sổ sách khớp tồn kho vật lý; tổn thất hạch toán minh bạch, ngăn chặn thất thoát.  
**Nghiệm thu:** TC-181, TC-182, TC-183, FX-10.

## 39. UC-39 — Xử lý hủy món trong quá trình pha chế, tái phân bổ ly và Hủy giao dịch (Void)
**Tác nhân:** Thu ngân, Barista, Quản lý ca, Khách hàng.  
**Đầu vào:** Yêu cầu hủy món hoặc đổi trả hàng sau thanh toán.  
**Tiền đề:** Đơn hàng đã được thanh toán thành công.
1. Thu ngân kiểm tra trạng thái vé pha chế:
   - Chưa pha (`QUEUED`): Hủy hoàn tiền 100%, giải phóng nguyên liệu giữ.
   - Đang pha (`IN_PROGRESS`): Dừng pha. Lỗi quán hoàn 100%; khách đổi ý thu ngân xin PIN Quản lý ca duyệt hủy thiện chí.
   - Đã pha xong (`READY`): Barista kiểm tra hàng đợi pha chế. Nếu có đơn hàng sau gọi đúng món (cùng size, đường, đá, topping), Barista bấm `REASSIGN_CUP` để chuyển ly nước sang phục vụ ngay cho đơn sau! Quán không bị đổ bỏ ly nước. Nếu không có đơn sau, đổ bỏ và ghi sổ `DrinkWasteLog`.
**Nhánh lỗi:**
- Hủy giao dịch nhanh (Void trong 10 phút): Áp dụng khi đồ chưa pha, đảo giao dịch không mất phí cổng; hủy đơn hoàn toàn.
- Đổi trả hàng sau thanh toán: Hàng hóa đóng gói bán lẻ (ly giữ nhiệt, bình nước) nguyên seal được phép `RESTOCK_AVAILABLE` (Nhập lại kho bán lẻ); Đồ uống tươi pha chế cấm tuyệt đối nhập kho, ghi nhận xuất hủy chất lượng. Thu hồi điểm; thiếu điểm ghi nợ `PointsDebt`.
**Đầu ra:** Giảm thiểu lãng phí đồ uống; kiểm soát chặt chẽ vệ sinh an toàn thực phẩm.  
**Nghiệm thu:** TC-184, TC-185, TC-186, TC-187.

## 40. UC-40 — Vận hành chế độ POS Ngoại tuyến (Offline Mode) và Đồng bộ giải quyết xung đột
**Tác nhân:** Thu ngân, Ứng dụng POS Client, Hệ thống Server UTECoffe.  
**Đầu vào:** Mất kết nối mạng Internet tại cửa hàng, đơn hàng thanh toán tiền mặt tại quầy.  
**Tiền đề:** Cáp quang Internet bị đứt hoặc mất tín hiệu modem.
1. POS Client phát hiện mất mạng, tự động chuyển sang chế độ Offline Mode.
2. Thu ngân bán hàng tại quầy: Nhập món, in tạm tính, in KOT qua mạng LAN nội bộ, thanh toán TIỀN MẶT.
3. Đơn hàng lưu SQLite cục bộ có mã `[Branch]-POS01-OFF-[Seq]` và ký số điện tử HMAC SHA-256 bằng secret key phần cứng.
4. Hạn mức ngoại tuyến: Tối đa 500 đơn hoặc 30 triệu đồng/phiên.
5. Khi có Internet trở lại: POS Agent kích hoạt Background Sync đẩy đơn FIFO lên server.
**Nhánh lỗi:**
- Xung đột hết hàng giữa Đơn Quầy Offline và Đơn Web Online: Ưu tiên Đơn Quầy vật lý được ghi nhận vào sổ kho; Đơn Web online bị đánh dấu xung đột `STOCK_OUT_CONFLICT_REJECTED`, tự động hoàn tiền 100% kèm voucher đền bù 20%.
**Đầu ra:** Cửa hàng không bị gián đoạn bán hàng khi mất mạng; toàn bộ dữ liệu hợp nhất an toàn, không có giao dịch giả mạo.  
**Nghiệm thu:** TC-188, TC-189.

## 41. UC-41 — Thanh toán kết hợp nhiều hình thức (Split Payment) và Xử lý sự cố dở dang
**Tác nhân:** Thu ngân, Khách hàng, Cổng thanh toán (MoMo/VNPAY/Thẻ POS).  
**Đầu vào:** Hóa đơn thanh toán, danh sách phương thức và số tiền tương ứng.  
**Tiền đề:** Khách hàng có nhu cầu thanh toán đơn hàng bằng nhiều nguồn tiền khác nhau.
1. Đơn hàng 650.000đ. Thu ngân mở màn hình "Thanh toán kết hợp (Split Payment)".
2. Bước 1: Trừ nguồn tiền nội bộ: Nhập 50.000 Điểm thành viên -> Balance còn 600.000đ.
3. Bước 2: Thanh toán điện tử: Quét mã MoMo 200.000đ thành công -> Balance còn 400.000đ.
4. Bước 3: Quẹt thẻ ngân hàng: Nhập 200.000đ cà thẻ POS ngân hàng thành công -> Balance còn 200.000đ.
5. Bước 4: Thu tiền mặt: Nhận 200.000đ tiền mặt -> Balance = 0.
6. Đơn hàng tự động chuyển sang `PAID`, in hóa đơn liệt kê chi tiết từng phương thức thanh toán.
**Nhánh lỗi:**
- Thất bại dở dang ở bước giữa (ví dụ quẹt thẻ bị từ chối và khách không còn tiền mặt): Thu ngân bấm nút "Hủy giao dịch dở dang": Hệ thống tự động gọi API Refund hoàn 200.000đ về ví MoMo và hoàn 50.000 điểm về tài khoản khách, hủy đơn an toàn không lệch sổ quỹ.
**Đầu ra:** Thanh toán đa phương thức linh hoạt; bất biến số học dòng tiền bảo toàn 100%.  
**Nghiệm thu:** TC-190, TC-191, FX-12.
