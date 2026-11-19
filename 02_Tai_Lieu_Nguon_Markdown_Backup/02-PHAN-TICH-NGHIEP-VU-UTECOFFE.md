# 02. Phân tích nghiệp vụ chi tiết UTECoffe

**Phiên bản 1.3 — rà soát & bổ sung kịch bản biên F&B 19/11/2026.** Các thời hạn, giới hạn, công thức và giá trong tài liệu là **đề xuất/dữ liệu demo**, cần người phụ trách kinh doanh duyệt trước khi dùng thật. Mã BR là quy tắc; mã F là chức năng; P0/P1/P2 được định nghĩa trong README. Bản này có 65 quy tắc nghiệp vụ (BR-01 đến BR-65) và 158 chức năng (F-001 đến F-158: 90 P0, 62 P1, 6 P2). Tài liệu 07 đối chiếu đề; 08 đặc tả luồng; 09 chốt hợp đồng dữ liệu, lệnh và tác vụ; 10 truy vết từng chức năng.

## 1. Bài toán kinh doanh và đích bàn giao

Chuỗi có nhiều cơ sở dùng chung thương hiệu/menu chuẩn nhưng khác giờ hoạt động, nguyên liệu còn lại, mức tải, giá hoặc phạm vi giao. Khách cần biết nơi nào có món mình muốn và khi nào nhận được. Nhân viên cần phiếu pha rõ đến từng ly. Quản lý cần biết đã bán gì, nguyên liệu đã đi đâu, thực nhận bao nhiêu tiền và ai sửa dữ liệu.

Sản phẩm chia thành bốn khu vực: **website khách hàng**, **quầy bán và pha chế**, **quản lý cơ sở**, **quản trị toàn chuỗi**. Bản P0 chạy được tại ít nhất hai cơ sở trong dữ liệu nghiệm thu, không chỉ làm một cửa hàng rồi thêm trường branchId cho có.

| Mục tiêu | Bằng chứng bàn giao |
|---|---|
| Khách mua đúng ly đã chọn | Chi tiết đơn và phiếu pha trùng size, đường, đá, topping, ghi chú |
| Không nhận đơn vượt khả năng phục vụ | Kiểm nguyên liệu và sức chứa khi xác nhận, thử đồng thời được |
| Nhân viên đúng cơ sở mới xử lý đơn | Kiểm quyền cả HTTP và WebSocket |
| Không thu/hoàn/tiêu hao hai lần | Khóa chống lặp, ledger và lịch sử thao tác |
| Quản lý truy nguyên được | Từ mã đơn đi đến giá, công thức, lô, payment, người pha và hậu mãi |

## 2. Phạm vi và ranh giới

| Nội dung | P0 bắt buộc | P1 hoàn thiện | P2 sau đồ án |
|---|---|---|---|
| Kênh bán | Website nhận tại quầy; thu ngân tạo đơn vãng lai mang đi | Giao nội bộ; phục vụ tại chỗ do thu ngân tạo | App native, aggregator, POS ngoại tuyến, QR đặt tại bàn |
| Sản phẩm | Cà phê, trà, topping; tùy chọn và công thức | Combo/bánh đóng gói với tồn theo đơn vị | Hàng bán lẻ, subscription |
| Thanh toán | Trả tại quầy; sandbox online; hoàn giả lập có sổ | Đối soát/import bảng kê, quy trình refund đầy đủ | Hợp đồng tiền thật, hóa đơn điện tử tích hợp |
| Kho | Nguyên liệu, lô/hạn, nhập cơ bản, giữ/tiêu hao/hủy | Mua hàng, chuyển cơ sở, kiểm kê | Dự báo mua, nhà máy/bếp trung tâm phức tạp |
| Khách hàng | Tài khoản, đơn, phản hồi | Voucher, điểm, đánh giá, hỗ trợ | Phân nhóm marketing, giới thiệu, hạng nâng cao |
| Vận hành | Queue, thông báo realtime, audit, báo cáo ngày | Ca tiền mặt, SLA, thống kê chuỗi | Điều phối tài xế tự động, nhiều vùng triển khai |

Không nằm trong đề tài: mạng xã hội cộng đồng; sàn nhiều shop; quản trị nhân sự/chấm công/lương; sổ kế toán chuẩn pháp định hoàn chỉnh; đặt phòng/bàn phức tạp. Khi cần tích hợp những hệ thống này, dùng hợp đồng dữ liệu thay vì mở rộng vô hạn module bán hàng.

## 3. Vai trò và phân quyền

| Vai trò | Phạm vi dữ liệu | Được làm | Không được tự làm |
|---|---|---|---|
| Khách vãng lai | Nội dung công khai | Xem menu, tìm cơ sở, tùy chỉnh giỏ | Đọc đơn bằng mã dễ đoán |
| Thành viên | Hồ sơ và đơn của mình | Đặt, trả tiền, yêu cầu hủy, phản hồi, xem điểm | Tự đánh dấu đã thanh toán |
| Thu ngân | Cơ sở được phân công; yêu cầu ca mở khi bật P1 | Tạo đơn quầy, thu tiền, xác nhận bàn giao | Sửa giá tự do, hoàn vượt quyền |
| Pha chế | Phiếu cơ sở được phân công | Nhận phiếu, bắt đầu, hoàn tất, báo thiếu/sai | Xem báo cáo tiền/PII không cần thiết |
| Giao hàng nội bộ | Chuyến được giao | Nhận hàng, cập nhật giao, ghi COD | Duyệt hoàn, truy cập mọi khách |
| Quản lý cơ sở | Một hoặc nhiều cơ sở được cấp | Giờ/tải bán, duyệt ngoại lệ, kho, ca, báo cáo | Sửa chính sách toàn chuỗi hoặc cơ sở khác |
| Nhân viên kho | Kho/cơ sở được giao | Nhập, xuất, kiểm kê, đề nghị điều chuyển | Tự sửa cân đối không có chứng từ |
| Marketing | Nội dung/chương trình được giao | Banner, menu nội dung, đề nghị voucher | Hoàn tiền hoặc cấp quyền nhân viên |
| CSKH | Hồ sơ được phân công | Liên hệ, xử lý phản hồi, đề nghị hoàn/làm lại | Xóa dấu vết khiếu nại |
| Tài chính | Sổ thu/chi, đối soát | Kiểm tra chênh lệch, xác nhận hoàn, chốt kỳ | Sửa dòng tiền đã khóa |
| Quản trị chuỗi | Toàn chuỗi | Cơ sở, vai trò, giá/công thức chuẩn, chính sách | Xóa lịch sử giao dịch để sửa sai |

Một người có thể mang nhiều vai trò, mỗi quyền có phạm vi cơ sở và thời gian hiệu lực. Dữ liệu demo có thể dùng ít tài khoản kiêm nhiệm, nhưng quyền nghiệp vụ vẫn tách. Với thí điểm thật, người đề nghị và người duyệt điều chỉnh tiền lớn phải khác nhau theo ngưỡng cấu hình.

## 4. Từ điển nghiệp vụ

| Thuật ngữ | Nghĩa thống nhất |
|---|---|
| Món | Thực thể menu như “Trà sữa ô long” |
| Biến thể | Kích cỡ/kiểu phục vụ có giá và công thức nền, ví dụ M lạnh |
| Tùy chọn | Đường, đá, sữa thay thế; có lựa chọn bắt buộc và tổ hợp bị cấm |
| Topping | Phần thêm có giá, lượng và công thức tiêu hao |
| Cấu hình ly | Biến thể + tập tùy chọn + topping + ghi chú |
| Công thức phiên bản | Định lượng nguyên liệu cho cấu hình, lưu theo thời gian hiệu lực |
| Khả dụng | Tồn có thể bán sau khi trừ giữ, hạn, cách ly và tồn an toàn |
| Giữ nguyên liệu | Cam kết tạm cho đơn, chưa phải tiêu hao thực tế |
| Phiếu pha | Công việc để tạo một ly hoặc nhóm ly giống nhau |
| Báo giá | Kết quả tính của server có hạn, chưa bảo đảm giữ nguyên liệu |
| Đơn | Một yêu cầu phục vụ tại một cơ sở, có nhiều dòng/ly |
| Thu tiền | Khoản đã được chứng minh là nhận thành công, không phải chỉ tạo QR |
| Hoàn tiền | Giao dịch ngược có giới hạn theo khoản đã thu |
| Làm lại | Pha ly thay thế; phát sinh tiêu hao mới, không nhất thiết phát sinh thu |
| Hủy hao hụt | Loại bỏ nguyên liệu/ly không còn bán được, có lý do |
| Kỳ/ca | Khoảng đối soát được chốt; sửa sau chốt bằng chứng từ điều chỉnh |

## 5. Quy tắc nghiệp vụ bắt buộc

### BR-01. Một đơn, một cơ sở

Giỏ trực tuyến đang hoạt động gắn một cơ sở. Khi đổi cơ sở, backend dựng lại giỏ dự kiến và chỉ áp dụng sau khi khách xác nhận khác biệt. Đơn đã tạo giữ nguyên cơ sở. Nếu cần phục vụ nơi khác: hủy/hoàn hoặc giải quyết đơn gốc, tạo đơn liên kết mới với sự đồng ý của khách; không sửa branchId trực tiếp.

### BR-02. Giờ bán, kênh nhận và sức chứa

Giờ mở cửa khác giờ nhận đơn cuối. Cấu hình lịch tuần, ngày nghỉ, đóng đột xuất, cutoff theo kênh. Đề xuất demo: đóng cửa 22:00, dừng nhận pickup 21:30; giao có cutoff riêng. Cơ sở có sức chứa theo cửa sổ 5 phút, quy đổi mỗi món ra đơn vị công việc. Quote chỉ ước lượng; đặt đơn phải giữ được suất phục vụ cùng giao dịch giữ nguyên liệu. P0 chỉ đặt sớm nhất có thể, chưa hẹn ngày khác. Từ chối định vị vẫn chọn cơ sở bằng tên/quận được.

### BR-03. Menu và giá theo cơ sở

Món phải đang xuất bản, nằm trong thời gian bán, được bật tại cơ sở, có biến thể hợp lệ và nguyên liệu khả dụng. Cờ “tạm hết” do quản lý đặt có thể chặn bán ngay cả khi hệ thống tính còn. Giá cơ sở ghi đè giá chuẩn theo khoảng hiệu lực không chồng lấn. Giỏ không khóa giá vĩnh viễn; đơn lưu giá đã xác nhận.

### BR-04. Tùy chỉnh hợp lệ

Mỗi nhóm khai báo bắt buộc/tùy chọn, min/max số lựa chọn, số phần tối đa, phụ thu và danh sách món được dùng. Ví dụ demo: đồ nóng không chọn đá; trân châu chỉ áp dụng món được bật; tối đa hai loại topping, mỗi loại tối đa hai phần. “Không đường” là lựa chọn trong công thức, không chỉ một ghi chú. Ghi chú không được thay thế tùy chọn có thu tiền. Thông tin dị ứng được mô tả, không hứa an toàn dị ứng nếu cơ sở không có quy trình xác nhận.

### BR-05. Đồng nhất cấu hình và snapshot

Chỉ gộp giỏ khi cùng cơ sở, biến thể, tùy chọn, số phần topping và ghi chú đã chuẩn hóa. Hai ly khác mức đường hoặc tên nhãn phải là dòng khác hoặc có cấu hình từng ly riêng. Dòng đơn chụp tên, ảnh tham chiếu, giá nền/phụ thu, lựa chọn, recipeVersion, định lượng đã tính, chính sách giảm, thuế/phí hiển thị và kênh. Đổi menu không sửa đơn cũ.

### BR-06. Giá và làm tròn

Giá tiền cuối dùng số nguyên VND. Giá dòng trước giảm = số ly × (giá biến thể + phụ thu tùy chọn + topping). Thứ tự P1: giá hiệu lực → giảm cấp món → voucher cấp đơn được phép → ưu đãi phí giao. Tổng thu = tổng dòng sau giảm + phí giao sau giảm + khoản phí đã công bố. Không thêm phụ phí ở bước cuối mà khách chưa xác nhận. Giá demo là giá hiển thị trọn gói; thông số thuế thực tế phải được tài chính chốt, không tự hardcode thuế suất.

Giảm cấp đơn phân bổ theo tỷ trọng giá trị đủ điều kiện, làm tròn xuống từng dòng rồi chia số đồng dư theo phần lẻ lớn nhất, hòa thì theo ID dòng ổn định. Snapshot phần phân bổ là căn cứ hoàn; không tính lại voucher theo chương trình hôm nay. Không có dòng âm, tổng giảm không vượt giá trị áp dụng.

### BR-07. Voucher

Voucher có kênh, cơ sở, thời gian theo múi giờ, đối tượng, món, ngưỡng, mức giảm/trần, tổng lượt và lượt/người. P1 mặc định một voucher cấp đơn; không cộng với ưu đãi khác trừ khi cấu hình cho phép. Kiểm ngưỡng trên tiền món đủ điều kiện sau giảm cấp món, chưa cộng giao. Giữ lượt khi đặt, tiêu dùng khi đơn được nhận theo chính sách; hủy trước pha trả lượt nếu còn thời hạn. Hủy sau pha/hoàn một phần không tự cấp voucher mới. Các lần giữ và giải phóng phải chống lặp.

### BR-08. Giữ nguyên liệu và chống bán vượt

Thêm giỏ không giữ hàng. Quote demo có hiệu lực 5 phút nhưng vẫn phải kiểm lại. Khi đặt, trong một giao dịch kiểm phiên bản báo giá, khóa cân đối nguyên liệu theo thứ tự cơ sở–nguyên liệu, chọn lô FEFO đủ hạn, giữ capacity, ghi đơn và reservation. Thiếu bất kỳ thành phần bắt buộc thì toàn đơn không được tạo dang dở; trả dòng/topping không mua được và đề nghị quote mới. Không tự bỏ món hay thu phần còn lại khi khách chưa đồng ý.

Đơn online chờ trả tiền giữ tối đa 10 phút. Khi ghi nhận đã thu hợp lệ trước hạn, chuyển sang hạn chờ cơ sở nhận tối đa 5 phút và chuyển hạn giữ trong cùng giao dịch. Đơn trả quầy có hạn chờ nhận 5 phút ngay từ khi tạo. Khi ACCEPTED, chuyển sang hạn phục vụ; không còn bị job hết hạn thanh toán xử lý. Quá hạn chờ nhận sau khi đã thu phải đóng phần phục vụ, giải phóng phần chưa dùng và tạo nghĩa vụ hoàn; không để tiền đã thu rơi khỏi danh sách theo dõi. Chi tiết thứ tự xử lý tại BR-27.

### BR-09. Công thức, lô và hạn dùng

Đơn vị chuẩn: gram, milliliter, cái; số lượng dùng Decimal, chuyển đổi mua vào theo hệ số đã duyệt. Không quy đổi g sang ml nếu không có hệ số riêng của nguyên liệu. Công thức gồm nền, điều chỉnh theo size/nhiệt độ/đường/đá và topping, cả bao bì. P0 phải theo dõi nguyên liệu chính và bao bì; nguyên liệu không theo dõi tồn phải được khai báo rõ, không mặc định vô hạn.

Lô còn hạn tại thời điểm dự kiến dùng mới được giữ. Topping nấu sẵn P1 có mẻ và hạn sử dụng sau chế biến/mở bao; P0 có thể nhập lô topping đã chuẩn bị, vẫn có hạn. FEFO ưu tiên hết hạn trước. Nguyên liệu cách ly, thu hồi hoặc quá hạn không bán được. Nếu lô hết hạn trong lúc chờ, chuyển giữ sang lô hợp lệ trong giao dịch; không đủ thì mở ngoại lệ, dừng pha và liên hệ khách.

### BR-10. Nhập, chuyển và kiểm kê

Nhập kho ghi người, nhà cung cấp nếu có, lô, số lượng, đơn vị, giá vốn tham chiếu, hạn. Sửa chứng từ đã ghi sổ bằng phiếu đảo/điều chỉnh, không xóa movement. Chuyển cơ sở có xuất → đang vận chuyển → nhận; cơ sở nhận chỉ tăng số thực nhận; chênh lệch phải giải quyết riêng. Kiểm kê đối chiếu lượng vật lý, lượng giữ và lượng khả dụng, chênh lệch cần lý do/duyệt. Không cho điều chỉnh làm tồn vật lý nhỏ hơn phần đã giữ mà không mở quy trình xử lý đơn liên quan.

### BR-11. Thanh toán và chống lặp

Mỗi lần khách xác nhận có khóa idempotency và dấu vân tay nội dung. Gửi lại cùng khóa/nội dung trả cùng đơn; cùng khóa khác nội dung trả lỗi xung đột. Phương thức P0: trả tại quầy và cổng giả lập/sandbox. Chỉ xác nhận paid khi có ghi nhận thu quầy hợp lệ hoặc phản hồi đối tác đã xác minh chữ ký, mã đơn, tiền và loại tiền. Trang redirect thành công, ảnh chuyển khoản hoặc thông báo phía trình duyệt không phải bằng chứng thu.

Callback trễ sau khi đơn hết hạn/hủy không tự hồi sinh đơn; ghi khoản thu cần xử lý, mở yêu cầu hoàn hoặc xử lý có kiểm soát. Nếu cổng thu hai lần do hai attempt khác nhau, mỗi khoản thu đều phải được ghi nhận, khoản dư được hoàn; không bỏ qua tiền thật chỉ vì đơn đã paid. Với mỗi receipt, tổng hoàn thành công cộng số tiền đang giữ cho refund chưa kết thúc không vượt giá trị receipt; một refund mới phải nằm trong phần còn lại. Ngoài hạn mức tiền, hoàn chất lượng theo dòng còn có hạn mức thực trả của dòng, riêng hoàn thu trùng không tiêu dùng hạn mức số ly.

### BR-12. Tiếp nhận và hàng đợi pha

Cơ sở xác nhận đơn khi còn mở nhận, còn capacity và điều kiện tiền thỏa. Đơn trả quầy có thể được pha trước thu trong giới hạn rủi ro do quản lý cấu hình; demo tối đa 200.000đ, không có nợ no-show chưa xử lý. Đơn trên ngưỡng yêu cầu trả trước. Quầy xếp theo thời gian nhận/cam kết, có cờ ưu tiên do quản lý đặt kèm lý do; không ưu tiên bí mật theo người thao tác.

Nhân viên nhận phiếu bằng thao tác chiếm quyền có version. Bắt đầu pha mới chuyển lượng giữ tương ứng thành tiêu hao vật lý, đúng một lần cho mỗi phiếu. Hoàn tất phiếu không tiêu hao lần nữa. Đơn chỉ READY khi mọi đơn vị vẫn còn nghĩa vụ giao đều có phiếu READY. Đơn vị bị hủy có quyết định điều chỉnh riêng theo BR-26; phiếu làm lại phải hoàn tất trước khi thay thế nghĩa vụ của phiếu gốc. Không dùng cờ “đã xử lý ngoại lệ” để bỏ qua một ly vẫn phải giao.

### BR-13. Hủy, hết hạn và làm lại

Trước khi pha: khách được gửi hủy; backend kiểm trạng thái và giải phóng giữ/capacity/voucher trong giao dịch. Nếu thu tiền, tạo refund riêng. Pha chế bắt đầu cùng lúc khách hủy phải có một bên thắng theo khóa; bên còn lại nhận trạng thái mới.

Sau khi có phiếu đã pha: không hủy tự phục vụ. CSKH/quản lý xử lý theo từng ly: chưa pha có thể giải phóng; đã pha ghi tổn thất thành phẩm/làm lại và quyết định hoàn. Nguyên liệu đã được trừ lúc bắt đầu không bị trừ lần nữa khi bỏ ly. Không cộng nguyên liệu đã dùng về tồn bán được. Làm lại có phiếu liên kết ly gốc, nguyên nhân, người duyệt, recipe và tiêu hao mới. Không tạo doanh thu mới nếu chuỗi chịu lỗi.

### BR-14. Nhận tại quầy và no-show

Khi READY, gửi thông báo và mã nhận không thể suy ra từ số thứ tự. Nhân viên xác minh mã, trạng thái và khoản phải thu trước bàn giao. Mã không chứa PII; giới hạn thử sai. Bàn giao một lần. Bảng gọi công khai chỉ hiện số thứ tự rút gọn và trạng thái.

Demo dùng thời hạn chất lượng nhận quầy 30 phút sau READY, nhưng đây là cấu hình thử, cần kiểm chứng theo món thực tế. Hết hạn chuyển NEEDS_REVIEW, không tự đánh dấu đã giao/đã thu. Nhân viên ghi liên hệ, quyết định no-show, làm lại hoặc hoàn; prepaid không mặc nhiên bị tịch thu. P0 không tự động cấm tài khoản chỉ dựa trên một lần vắng mặt.

### BR-15. Giao hàng nội bộ

P1 xác minh tọa độ/địa chỉ và vùng phục vụ, giới hạn đơn/khung giờ. Khoảng cách đường thẳng chỉ là ước lượng demo, phải ghi rõ; không giả làm quãng đường giao thực tế. Phí là cấu hình vùng có phiên bản. Đơn được giao tài xế, xác nhận nhận kiện, giao thành công/thất bại và COD. Giao thất bại giữ hồ sơ tiền và đồ uống riêng; không tự nhập ly về kho bán lại. Chỉ cho COD trong giới hạn rủi ro và khi có quy trình nộp tiền.

### BR-16. Tiền mặt, COD và đối soát

Đơn hoàn tất không đồng nghĩa đã nộp tiền về quỹ. Thu quầy, tài xế thu, gateway xác nhận, tiền về ngân hàng là các mốc khác nhau. Phiên ca có tiền đầu, thu, hoàn, chi, nộp, kiểm đếm và chênh lệch. Đóng ca chênh lệch phải ghi lý do, người duyệt. Import cùng bảng kê không nhân đôi dòng; khớp theo mã đối tác/giao dịch, không dựa riêng vào tổng/ngày. Kỳ đã khóa dùng bút toán điều chỉnh mới.

### BR-17. Khiếu nại, hoàn và đánh giá

Khách chọn đơn/dòng, lý do sai món, sai tùy chọn, thiếu, đổ, chất lượng; gửi mô tả và ảnh tùy trường hợp. Bằng chứng riêng tư. Mỗi quyết định xác định số ly, phần tiền hoàn, phí giao có hoàn không và có làm lại không. Giá trị hoàn dựa trên **thực trả đã phân bổ**, trừ các lần hoàn trước; refund request đang chờ cũng chiếm hạn mức để ngăn hai nhân viên cùng duyệt quá tiền. Khiếu nại có hạn xử lý và đường chuyển quản lý.

Chỉ khách có dòng hoàn tất được đánh giá; một đánh giá hiện hành cho dòng mua, có lịch sử sửa. Kiểm duyệt nội dung theo chính sách công bố, không xóa phản hồi tiêu cực chỉ vì điểm thấp. Không biến phản hồi chất lượng thành lời khuyên sức khỏe.

### BR-18. Điểm thành viên

P1 tích điểm khi đơn vừa COMPLETED vừa đủ paid. Đề xuất demo: mỗi 10.000đ tiền món thực trả được 1 điểm, làm tròn xuống trên toàn đơn; không tính phí giao. Điểm có ledger, thời điểm khả dụng, hạn và nguyên nhân. Đổi điểm lấy voucher qua giao dịch chống lặp; không sửa trực tiếp số dư. Hoàn một phần tính lại điểm xứng đáng của toàn đơn rồi ghi chênh lệch; không làm tròn độc lập từng lần hoàn. Nếu điểm đã dùng, ghi khoản điểm cần bù và chặn đổi tiếp khi khả dụng không dương; không làm thất bại nghĩa vụ hoàn tiền.

### BR-19. Quyền, tài khoản và thông tin cá nhân

Backend xác định chủ thể từ phiên đã xác thực; không tin role/userId/branchId do browser gửi. Mọi đối tượng đơn, phiếu, kho và báo cáo kiểm quyền theo cơ sở hoặc chủ sở hữu. Đổi quyền, khóa tài khoản, đổi mật khẩu phải thu hồi phiên phù hợp. Xác minh email P0; số điện thoại nhận đơn được lưu/kiểm định dạng, không coi là đã OTP nếu chưa tích hợp. Marketing cần lựa chọn đồng ý riêng, không buộc khi mua.

### BR-20. Thông báo và realtime

DB là nguồn sự thật. Sự kiện chỉ phát sau commit qua outbox. Mất WebSocket không làm mất đơn; màn hình báo mất kết nối và truy vấn lại snapshot khi nối lại. Message có eventId, aggregateId, version, timestamp; khách bỏ bản cũ/trùng. Người dùng không tự gửi message để đổi trạng thái giao dịch: lệnh nghiệp vụ đi qua API có kiểm quyền. Thông báo email lỗi được retry, không rollback đơn đã nhận.

### BR-21. Nội dung và ảnh

Ảnh món/banner công khai; ảnh khiếu nại và tài liệu nội bộ riêng tư. Upload có chữ ký không có nghĩa tự động riêng tư. Chỉ vai trò hợp lệ được gắn ảnh vào menu; ảnh gắn với asset owner/purpose. Xóa mềm món đã có đơn, giữ snapshot. Nội dung nhập bởi người dùng được escape/lọc, không cho HTML tùy ý chạy trong JSP.

### BR-22. Lịch sử và sửa sai

Thay đổi giá, recipe, quyền, tồn, tiền, trạng thái ngoại lệ phải ghi actor, thời điểm, đối tượng, trước/sau, lý do và correlationId. Không lưu mật khẩu, JWT hoặc số liệu bí mật trong log. Ngày giờ lưu UTC, hiển thị Asia/Ho_Chi_Minh; báo cáo ngày kinh doanh theo múi giờ và cutoff được chọn thống nhất.

### BR-23. Trạng thái ngừng bán và xóa dữ liệu

Ngừng món/cơ sở không xóa giao dịch lịch sử. Cơ sở đóng đột xuất dừng đơn mới, liệt kê đơn đang xử lý để quản lý quyết định từng đơn. Yêu cầu xóa tài khoản phải xử lý dữ liệu cá nhân và nghĩa vụ lưu hồ sơ theo chính sách được xác nhận khi vận hành; không xóa ledger làm mất đối soát. Thời hạn lưu từng nhóm phải được phê duyệt, không mặc định “lưu vĩnh viễn”.

### BR-24. Báo cáo nhất quán

Tách giá trị đơn đặt, doanh số món đã hoàn tất, tiền thu, tiền hoàn, phí gateway, hao hụt và giá vốn ước tính. Đơn hủy không thành doanh số chỉ vì đã thu; khoản thu đang chờ hoàn vẫn hiện trong tiền. Báo cáo tổng chuỗi bằng tổng các cơ sở theo cùng định nghĩa, cùng khoảng thời gian. Đây là báo cáo quản trị, không tự thay thế sổ kế toán/hóa đơn pháp định.

### BR-25. Giỏ vãng lai, nhiều thiết bị và quyền dùng báo giá

Giỏ vãng lai dùng mã ngẫu nhiên trong cookie và chỉ có quyền trên giỏ đó. Đăng nhập không âm thầm cộng giỏ khác cơ sở: server lập bản xem trước, khách chọn giữ giỏ tài khoản, dùng giỏ vãng lai hoặc gộp khi cùng cơ sở/mode. Gộp một lần, kiểm lại options/giới hạn và tăng cartVersion. Không gán đơn quầy vãng lai vào tài khoản chỉ vì trùng số điện thoại; gắn thành viên phải có xác minh phù hợp trước khi chốt.

Mỗi quote chỉ được tiêu dùng bởi **một order**, kể cả client đổi Idempotency-Key. Quote lưu checkoutGeneration của giỏ; khi tạo order, đánh dấu generation đã dùng và bắt đầu giỏ/generation mới. Các quote cũ cùng generation không tạo đơn thứ hai. Hai tab sửa đồng thời phải kiểm version; tab cũ tải lại dữ liệu. Retry tạo đơn được trả order đã có; tạo payment attempt mới vẫn thuộc order đó. “Đặt lại” là hành động chủ động tạo giỏ/quote mới, không tái dùng quote đã tiêu dùng.

### BR-26. Hủy một phần, nghĩa vụ giao và số tiền còn phải thu

Theo dõi từng đơn vị bán bằng OrderUnit: tên/cấu hình, phần giá và giảm được phân bổ, nghĩa vụ giao, kết quả thực hiện. Tách **hủy trước giao**, **hoàn tiền chất lượng sau giao** và **làm lại**. Refund sau giao không làm số ly đã giao thành chưa giao; remake không tăng số lượng khách mua. Snapshot giá gốc bất biến, mọi giảm nghĩa vụ tiền đi qua OrderAdjustment liên kết quyết định được duyệt.

P0 không tự thay món/size sau đặt. Khi thiếu, quản lý đề nghị khách nhận phần còn lại hoặc hủy; lưu cách xác nhận và lý do. Nếu nhận một phần, những đơn vị hủy được VOID, phần còn lại tiếp tục; order kết thúc COMPLETED với fulfillmentOutcome=PARTIAL khi phần còn phải giao đã bàn giao. Nếu không giao đơn vị nào, kết thúc CANCELLED. Hoàn chất lượng sau COMPLETED không đổi fulfillmentOutcome cũ.

Gọi G là số phải trả gốc, C là tổng điều chỉnh giảm đã duyệt, E=G−C là số phải trả hiệu lực, R là tổng đã thu, H là tổng đã hoàn thành công. Số còn phải thu=max(0,E−(R−H)); số đang thừa=max(0,R−H−E). Refund pending không làm H tăng trước khi xác nhận. Báo cáo phải hiện cả nghĩa vụ giảm đã duyệt và khoản hoàn đang chờ. Không thu lại phần đã được giảm chỉ vì refund chưa chạy xong. P0 chưa nhận chia một hóa đơn thành nhiều phương thức chủ động; nhiều receipt vẫn được lưu để xử lý thu trùng/sai thực tế.

Hoàn chất lượng không vượt thực trả từng đơn vị, kể cả nhiều hồ sơ. Nếu muốn bồi thường thêm ngoài tiền món/phí, đó là khoản chi riêng có duyệt, không nới hạn mức refund. Thu thừa/trùng được hoàn về receipt nguồn, không trừ vào hạn hoàn của ly. Ly miễn phí có hạn hoàn bằng 0 nhưng vẫn có thể được làm lại khi lỗi. Refund thất bại không hủy nghĩa vụ E đã giảm; phải xử lý lại hoặc ghi khoản hoàn khác có chứng từ.

### BR-27. Đồng hồ và thứ tự sự kiện

Phân biệt paymentDueAt, acceptDueAt, promisedReadyAt, holdReviewAt và pickupQualityDueAt. Tại biên thời gian, lấy thời gian và trạng thái được kiểm trong transaction; không chỉ dựa vào client hoặc thời điểm thông báo đối tác tự khai. Callback đến sau deadline dù job expiry chưa chạy vẫn được phân loại tiền về trễ; không tự gia hạn bằng cách trì hoãn job. Nếu thời điểm thu ở đối tác trước hạn nhưng notification đến muộn, phải inquiry/review trước khi quyết định phục vụ hoặc hoàn.

Payment hợp lệ trước hạn chỉ chuyển hold và tạo acceptDueAt khi slot phục vụ vẫn khả thi. Nếu ETA phải thay đổi đáng kể, yêu cầu khách xác nhận ETA mới hoặc hoàn, không hứa slot đã trôi qua. Khi bắt đầu pha chậm, kiểm lại hạn lô và tải. Callback fail/cancel đến sau success không được hạ trạng thái receipt thành chưa thu. Provider events phải chuyển qua state machine và xác minh nghiệp vụ, không áp “event nào đến sau thì ghi đè”.

### BR-28. Bánh, combo và dùng tại chỗ

P1 có hai loại đơn vị bán: PREPARED_DRINK và PACKAGED_FOOD. Bánh đóng gói theo SKU, lô, hạn và đơn vị cái, có picking ticket; lúc nhân viên bắt đầu lấy/đóng gói mới tiêu hao phần đã giữ. Nếu hủy, chỉ nhập lại bằng phiếu đảo được duyệt sau kiểm nguyên trạng/hạn; không tự restock. Quy tắc đồ uống đã pha không được suy sang bánh chưa mở, và ngược lại.

Combo là bundle có phiên bản gồm các slot món và lựa chọn được phép. Giá combo phân bổ xuống từng đơn vị theo giá bán lẻ tham chiếu tại lúc mua, dùng thuật toán đồng dư BR-06; voucher chỉ cộng khi rule cho phép. Tồn/capacity kiểm từng thành phần. Thiếu một thành phần thì không bán combo đó; không tự giao thiếu rồi giữ nguyên giá. Hoàn một thành phần do lỗi chuỗi dùng giá đã phân bổ, không thu hồi ưu đãi từ phần khách giữ. Chính sách đổi ý của khách nếu có phải công bố riêng, không tự tính lại hồi tố. Giới hạn P1: combo cố định 2–3 slot, không bundle lồng nhau.

Phân biệt channel=WEB/COUNTER với serviceMode=PICKUP/DELIVERY/ON_PREMISE. ON_PREMISE P1 do thu ngân tạo, có số bàn/nhãn vị trí tùy chọn, thu trước khi phục vụ; không mở tab nợ/tách gộp bàn. Bao bì tiêu hao khác mang đi: không trừ ly giấy nếu dùng cốc tái sử dụng. Bàn được xác nhận bởi nhân viên, không dùng số bàn làm chứng cứ paid. QR khách tự đặt, đổi bàn, tách hóa đơn và quản lý bàn toàn diện thuộc P2.

### BR-29. Khả dụng, thu hồi lô và hao hụt

Tại một thời điểm dùng dự kiến, khả dụng nguyên liệu = max(0, tổng lượng vật lý của các lô đủ điều kiện − lượng đang giữ trên chính các lô đó − tồn an toàn áp một lần cho cơ sở/nguyên liệu). Tồn vật lý tổng vẫn bao gồm lô cách ly cho đến khi xuất hủy, nhưng phần đó không khả dụng. Không trừ hai lần reservation của lô đã bị loại khỏi tập hợp. Nguyên liệu bị khóa lô làm các phiếu đang giữ chuyển HOLD_REVIEW; phải chuyển lô/đổi phương án trước pha. Khi xuất bản menu, tính khả dụng chỉ là thông tin tại thời điểm đọc; transaction checkout vẫn kiểm lại.

P1 thu hồi lô truy theo movement/reservation đến cơ sở, phiếu và đơn: chặn dùng mới → dừng phiếu chưa pha → liệt kê đơn đã dùng để người có quyền xử lý/liên hệ → ghi quyết định. Không tự xóa đơn hoặc gửi thông báo marketing cho khách. Sự cố chất lượng thực phẩm phải được cơ sở đánh giá; phần mềm hỗ trợ truy nguyên và ghi nhận, không tự kết luận mức độ an toàn.

Tách RAW_WASTE (nguyên liệu chưa tiêu hao, có movement giảm), FINISHED_WASTE (ly đã consume, chỉ phân loại lại tổn thất/giá vốn tham chiếu), TRANSIT_LOSS (đã xuất, giảm lượng đang đi). Mẻ sơ chế chuyển nguyên liệu vào thành phẩm topping; không vừa tiêu hao toàn bộ công thức trà sữa vừa tiêu hao thêm nguyên liệu đầu vào của topping đã được nhập mẻ.

### BR-30. Khôi phục thao tác quầy và kiểm soát xuất bản

Claim chưa start có lease demo 2 phút; nhân viên có thể gia hạn và quản lý có thể thu hồi/giao lại với lý do. Lease hết không có nghĩa đồ uống chưa được pha thật: nếu state PREPARING hoặc kết quả lệnh start không rõ, phải tải snapshot và xác minh trước khi giao lại. Không tự reset PREPARING về WAITING. Refresh/reconnect giữ nguyên tác vụ đã commit. In lại nhãn đánh dấu “Bản in lại”, không tạo ticket/consume mới.

Chỉ xuất bản món khi có variant, giá đúng hiệu lực, nhóm tùy chọn không mâu thuẫn, recipe đầy đủ cho cấu hình bán, phân loại tracked/untracked, ảnh hoặc fallback, kênh/cơ sở và thông tin thành phần cần thiết. Dry-run chỉ ra lỗi và món/cơ sở ảnh hưởng. Thay recipe/giá/options hàng loạt cần version và xem trước, không cập nhật nửa chừng khiến món mua được nhưng không pha được.

### BR-31. Quỹ, phê duyệt và vòng đời điểm/voucher

Tiền mặt ghi riêng tiền khách đưa, tiền trả lại và tiền thu ròng. Ví dụ đơn 105.000đ, khách đưa 200.000đ, trả 95.000đ: receipt/cash sales là 105.000đ. In lại biên nhận không tạo thu mới. Refund tiền mặt ghi người nhận/chứng từ và ca hiện tại, không mở sửa ca bán đã khóa. Nếu gateway còn UNKNOWN, không tự chuyển sang thu mặt mà bỏ attempt cũ; cần thao tác có duyệt và theo dõi khả năng thu trùng.

Ma trận phê duyệt có operation, branch, amountLimit, dailyLimit và hiệu lực; người đề nghị không tự duyệt khoản yêu cầu hai người. P0 demo có hai tài khoản để chứng minh cơ chế; ngưỡng demo quản lý cơ sở tối đa 200.000đ/quyết định, vượt chuyển tài chính/admin được phân công. Không cộng quyền nhiều vai trò để vượt giới hạn; yêu cầu sửa tiền/quyền có xác thực còn mới. MFA nhân viên đặc quyền là P1 và là gate trước dùng tiền thật.

Voucher đổi điểm có reward policy riêng. Đề xuất P1: trừ điểm khi cấp voucher; voucher chưa sử dụng hết hạn không tự trả điểm. Nếu chuỗi hủy đơn trước pha, giải phóng lượt giữ; nếu voucher đã hết hạn do chờ lỗi của chuỗi, CSKH có thể cấp voucher thay thế tương đương với liên kết và thời hạn demo 7 ngày, một lần. Voucher đã dùng không đồng thời được hoàn điểm và cấp lại. Hoàn giao dịch mua hàng đảo điểm kiếm được của đơn; khác với khôi phục điểm đã dùng đổi voucher. Điểm hết hạn được ghi ledger, không xóa earn entry; các job và reversal có business key.

Khi đảo điểm kiếm được, phân bổ số cần thu hồi vào điểm còn khả dụng của earn lot trước, rồi phần đã hết hạn chưa từng được đảo, sau cùng phần đã chi tiêu chưa được đảo. Điểm đã hết hạn được đánh dấu giảm quyền hưởng nhưng không trừ số dư lần nữa; chỉ phần đã chi tiêu mới tạo khoản cần bù khi không còn khả dụng. Lưu cả entitlementDelta và balanceDelta/allocations. Ví dụ10 điểm đã hết hạn toàn bộ rồi refund làm giảm quyền hưởng4 điểm: số dư vẫn0, không tạo nợ 4 điểm. Hoàn khoản thu trùng không giảm giá trị món khách mua, nên không đảo điểm kiếm được lần nữa.

### BR-32. Vòng đời dữ liệu và vận hành tối thiểu

Mỗi nhóm dữ liệu có owner, mục đích, quyền đọc, thời hạn lưu đề xuất, điều kiện giữ vì tranh chấp và phương án xóa/ẩn danh. Hồ sơ yêu cầu tải/xóa dữ liệu phải xác minh chủ thể, giới hạn phạm vi và kiểm lại quyền lúc tải; link xuất có hạn, không lưu công khai. Đơn, audit và sổ tiền chỉ ẩn danh phần có thể ẩn theo chính sách được xác nhận, không phá đối soát. Legal hold chặn job xóa liên quan và có người được quyền gỡ; đây là cơ chế vận hành dự kiến, không thay kết luận pháp lý.

Trang quản lý ảnh riêng phải kiểm quyền mỗi lần đọc; không hứa thu hồi được bản ảnh người nhận đã tải xuống. Log redaction, hạn giữ ảnh tạm, giới hạn tải/export và khóa ký rotation là phần vận hành. Chính sách retention cụ thể và nghĩa vụ thông báo/pháp lý cần người phụ trách xác nhận trước mở bán. Các dữ liệu demo có thể xóa theo bộ fixture đã xác định trong môi trường thử.

### BR-33. Khách vãng lai tại quầy và hỗ trợ sau mua

Đơn quầy được tạo không có userId vẫn phải có biên nhận, mã đơn, cơ sở, thời điểm, dòng mua và khoản thu. Trong P0, khách xuất trình biên nhận/mã nhận để nhân viên được phân quyền mở hồ sơ hỗ trợ; CSKH đối chiếu thêm thông tin giao dịch cần thiết, không dùng một số điện thoại làm bằng chứng sở hữu. Không công khai lịch sử đơn quầy bằng URL chỉ có mã tăng dần. Hoàn tiền về nguồn đã thu hoặc bằng chứng nhận tiền mặt được duyệt; không chuyển tùy ý sang người tự nhận là chủ đơn.

Khách online có thể gửi phản hồi trong tài khoản; khách quầy không bị bắt tạo tài khoản mới để được xử lý lỗi. Nhân viên ghi hồ sơ behalf-of với người tiếp nhận, cách xác minh, thông tin liên hệ nếu khách đồng ý và kênh trả kết quả. Không tự gán đơn vãng lai vào tài khoản mới chỉ vì trùng email/điện thoại. Tra cứu tự phục vụ bằng token biên nhận và guest checkout online để P2, có thiết kế bảo mật riêng trước khi bật.

### BR-34. Mua nguyên liệu và trả nhà cung cấp

Đơn mua gồm số đặt, số đã nhận được chấp nhận, số bị từ chối tại cửa, số còn chờ và số đóng thiếu có lý do. Chỉ phần nhận được chấp nhận mới tăng tồn. Nhà cung cấp/đơn mua không mặc nhiên là công nợ phải trả đã hạch toán: P1 chỉ ghi số tiền mua tham chiếu và trạng thái đối chiếu chứng từ, chưa thay kế toán mua hàng.

Trả nhà cung cấp sau nhập là SupplierReturn: chọn receipt/lot gốc → cách ly phần cần trả → kiểm phần đang giữ cho đơn → duyệt → xuất trả → xác nhận nhận/tranh chấp. Số trả không vượt phần đã nhận còn hợp lệ sau các lần trả trước. Hàng đã tiêu hao không được xuất trả giả. Hoàn/giảm tiền từ nhà cung cấp ghi tham chiếu credit note riêng, không sửa giá vốn lịch sử của ly đã bán. Nếu nhập sai, dùng correction/đảo chứng từ có kiểm tồn và ảnh hưởng đơn; không lấy SupplierReturn để che thao tác sửa sổ sai.

### BR-35. Giao lại, đổi tài xế và thất bại thu tiền

Một order có một DeliveryTask ở bản đầu, nhưng task có nhiều DeliveryAttempt lịch sử; tối đa một attempt hoạt động. Đổi tài xế trước nhận kiện cập nhật assignment có audit. Sau nhận kiện phải có bàn giao custody hai phía hoặc quản lý xác minh ngoại lệ; không chỉ sửa driverId rồi làm mất dấu người đang giữ đồ/COD.

DELIVERY_FAILED chỉ có thể thử lại sau khi CSKH xác nhận địa chỉ, khách đồng ý và đồ uống còn đạt điều kiện theo policy. Nếu quá hạn chất lượng, tạo remake có tiêu hao mới hoặc hủy/hoàn; không kéo dài hạn bằng cách tạo attempt mới. Phí giao lại chỉ phát sinh nếu chính sách công bố và khách xác nhận quote bổ sung; P1 mặc định chuỗi chịu phí trong lỗi của chuỗi, không tự thu thêm sau đặt.

Khi đồ đã giao thực tế nhưng COD chưa thu, ghi fulfilledAt/POD thật, đưa đơn NEEDS_REVIEW với collectionException; không giả là chưa giao để quay lại phát ly thứ hai. Quản lý xử lý nghĩa vụ phải thu hoặc điều chỉnh có duyệt. Driver event lặp không thu/giao hai lần. P1 không hỗ trợ khách chia đơn thành nhiều chuyến giao tùy ý.

### BR-36. Mở cửa, giao ca và đóng cửa cơ sở

Giờ hoạt động, trạng thái nhận online và ca tiền mặt là ba dữ liệu riêng. Đầu ngày quản lý xác nhận nhân sự/quầy sẵn sàng, lô sắp hết hạn, mức tồn món chủ lực và phương thức nhận đang bật. Không tự mở online chỉ vì đồng hồ vừa tới giờ nếu cơ sở đang tạm dừng vì sự cố.

Cuối ngày: dừng nhận mới theo cutoff → kiểm toàn bộ đơn đang pha/ready/giao/refund → phân người tiếp nhận việc chưa xong → kiểm quỹ/đóng ca → xác nhận các lô cần bảo quản/hủy theo policy → ghi checklist. Không bắt đổi đơn đang giao thành COMPLETED để được đóng ca. Ca được đóng khi số liệu tiền có người nhận trách nhiệm; đơn, refund và COD chưa nộp tiếp tục tồn tại, có danh sách chuyển ca. Cơ sở đóng đột xuất phải có mã Incident, ảnh hưởng đơn và người phụ trách; không batch-cancel đơn đang pha mà bỏ qua hậu quả tiền/nguyên liệu.

### BR-37. Món yêu thích và mẫu tùy chỉnh

Thành viên P1 lưu món hoặc cấu hình đồ uống với tên gợi nhớ. Favorite trỏ món/cấu hình tham chiếu, không giữ nguyên liệu, không khóa giá và không tạo ưu đãi. Khi mua từ favorite hoặc đặt lại, server kiểm menu cơ sở hiện chọn, rule và giá hiện hành; nếu topping/size không còn hợp lệ phải đề nghị sửa rõ, không thay âm thầm. Favorite ngừng bán vẫn xem tên đã lưu và trạng thái, không có nút mua giả. Xóa favorite không xóa order; chỉ chủ sở hữu đọc/sửa.

### BR-38. Phiên truy cập, thay đổi hồ sơ và chống giữ hàng lạm dụng

P1 khách xem danh sách phiên theo thông tin thiết bị/thời gian đã giản lược và thu hồi từng phiên hoặc tất cả. Thay email phải xác minh email mới, xác thực lại thao tác và thông báo email cũ; không đổi userId/chủ sở hữu đơn. Đổi số điện thoại không tự coi là đã xác minh OTP nếu P0 chỉ có email verification. Mất phiên khi checkout không mất đơn đã commit.

P0 đề xuất tối đa hai order đang AWAITING_PAYMENT/AWAITING_ACCEPTANCE cho một tài khoản tại một thời điểm, kiểm atomic; giới hạn tổng số ly trong hold và tốc độ tạo quote/attempt. Đơn nhiều máy/đổi key không vượt giới hạn nhờ dữ liệu server. Từ chối phải nêu đơn đang chờ để khách xử lý; không khóa tài khoản tự động chỉ vì dùng mạng chung hoặc retry do lỗi. Rate limit phối hợp user/IP/operation, không dùng IP làm định danh chủ sở hữu. Đặt quầy có hạn mức riêng cho nhân viên, mọi override phải có quyền/lý do.

### BR-39. Nhập dữ liệu hàng loạt

P1 hỗ trợ mẫu import menu/giá/nguyên liệu riêng, không import trực tiếp tiền, role, stock balance hoặc order vào bảng lõi. Quy trình: upload tệp có giới hạn → parse và kiểm tất cả dòng → preview lỗi/trùng/mã tham chiếu → người có quyền xác nhận kế hoạch áp dụng → xử lý → báo kết quả theo dòng. Chốt policy rõ: bản đầu chọn **toàn bộ hợp lệ mới commit một lô nhỏ**, demo tối đa500 dòng; lô lớn là P2 có thiết kế job riêng. Khi một version đã đổi sau preview, hủy lần commit và yêu cầu preview lại, không overwrite âm thầm.

Nhập giá tạo phiên bản mới đúng hiệu lực; nhập nguyên liệu chỉ master data, tồn phải qua chứng từ nhận/điều chỉnh. Request/fileHash+operation key chống ghi hai lần; idempotency không cho người khác đọc kết quả import ngoài quyền. Export mẫu không phát tán công thức spreadsheet nguy hiểm từ input khách; ảnh dùng assetId được kiểm quyền, không cho server tải URL bất kỳ trong CSV.

### BR-40. Sức chứa, ETA và đồng ý thay đổi

Capacity dùng workUnits của từng đơn vị món theo recipe/operation, không lấy số order làm đại diện: một order20 ly nặng hơn order1 ly. Đề xuất P0 cấp toàn bộ workUnits vào một bucket5 phút; nếu vượt capacity tối đa một bucket thì chuyển đặt đoàn qua liên hệ, không giữ rải bucket khi chưa có thuật toán. Tìm bucket gần nhất còn đủ trong giờ nhận, snapshot promisedReadyAt. Tổng reserved+used≤maxUnits; hủy chỉ nhả reserved chưa dùng. Giảm capacity giữa ca không làm mất các cam kết đã có: khóa nhận mới, xử lý các đơn ảnh hưởng có người phụ trách.

Quote hiển thị ETA dự kiến cùng điều kiện chờ trả/nhận; tạo order giữ slot, payment được xác minh phải kiểm slot còn khả thi. Nếu slot đã trôi hoặc đổi ETA vượt ngưỡng demo5 phút, tạo đề nghị ETA mới có hạn chờ xác nhận demo5 phút. Chưa đồng ý không được tự bắt đầu pha; quá hạn phải giải quyết order/hoàn và nhả tài nguyên thích hợp. Đây là ngoại lệ có trạng thái lưu bền, không chỉ popup trên browser. Toàn bộ thay đổi làm tăng số phải trả ngoài đơn gốc cần order bổ sung có xác nhận ở P2; P0/P1 không tự tăng E của đơn đã chốt.

### BR-41. Bất đồng bộ hóa giao dịch thanh toán và tác vụ in ấn POS
Giao dịch thanh toán tài chính (Payment Transaction) và Tác vụ in ấn (Print Job) phải được phân tách độc lập tuyệt đối. Trạng thái thanh toán của đơn hàng chuyển sang `PAID` ngay khi cổng thanh toán hoặc tiền mặt được xác nhận thành công, cấm rollback đơn hàng vì lý do máy in lỗi. Driver POS thăm dò trạng thái máy in qua lệnh ESC/POS `DLE EOT n`. Nếu phát hiện Paper-Out hoặc Jam, hệ thống chuyển PrintJob sang `RETRYING`, tự động thử lại tối đa 3 lần (backoff 3s - 5s - 10s). Sau 3 lần thất bại, cho phép Thu ngân failover sang máy in phụ hoặc xuất mã QR E-receipt cho khách. Mọi sự cố máy in quá 5 phút ghi nhận vào `HardwareAuditLog`.

### BR-42. Phân định KOT/Tem nhãn ly vs Hóa đơn khách hàng
Phân định rõ 3 luồng in: Đồ uống (`DRINK`) gửi đến Máy in Barista / Máy in tem dán ly (Cup Sticker 50x30mm không in giá tiền); Đồ ăn (`FOOD`, `BAKERY_HOT`) gửi đến Máy in Bếp; Hóa đơn tài chính giao khách gửi đến Máy in Bill tại quầy thu ngân. Khi một đơn hàng đang mở được bổ sung món lần thứ $k \ge 2$, hệ thống chỉ sinh phiếu KOT vi sai cho các món mới gọi thêm kèm tiêu đề `*** PHIẾU BỔ SUNG MÓN (LẦN k) ***`. Tuyệt đối cấm in lại món cũ để tránh Barista pha trùng gây lãng phí nguyên liệu.

### BR-43. Kiểm soát in lại hóa đơn (Bill Reprint) & Watermark BẢN SAO
Hóa đơn thanh toán gốc chỉ được in tự động DUY NHẤT 1 LẦN khi hoàn tất thanh toán. Mọi lần in thứ hai trở đi của cùng một đơn hàng bắt buộc phải có tiêu đề in hoa to đậm `*** BẢN SAO / REPRINT - LẦN N ***`, tăng trường `Order.reprintCount` và in kèm dòng chữ: *"Hóa đơn in lại đối soát nội bộ - Không có giá trị thanh toán lại"*. Bắt buộc Quản lý ca nhập mã PIN 6 số và chọn lý do (Kẹt giấy, Khách xin lại, Đối soát). Nếu một tài khoản thu ngân in lại hóa đơn quá 3 lần trong 1 ca, hệ thống tự động khóa quyền in lại và gửi cảnh báo bảo mật thời gian thực đến Store Manager.

### BR-44. Phục hồi in dở dang và tiêu hủy chứng từ rách
Khi máy in phát hiện tín hiệu hết giấy (Paper End) hoặc kẹt giấy giữa trang in hóa đơn, tác vụ in dở dang lập tức bị đánh dấu là `ABORTED_PARTIAL`. Sau khi nạp cuộn giấy mới, hệ thống in lại TOÀN BỘ một hóa đơn thay thế hoàn chỉnh có gắn nhãn: `BẢN IN THAY THẾ (DO LỖI GIẤY IN DỞ DANG)`. Thu ngân bắt buộc phải thu hồi mẩu giấy in rách trước đó, dùng bút dạ gạch chéo chữ "HỦY DO KẸT GIẤY" và lưu vào túi chứng từ hủy cuối ca để đối soát hao phí giấy nhiệt.

### BR-45. Vòng đời và máy trạng thái quản lý bàn thời gian thực
Mỗi bàn phục vụ tại chỗ chỉ thuộc một trong 6 trạng thái tại một thời điểm: `AVAILABLE` (bàn trống), `RESERVED` (đã đặt trước, tự động khóa trước giờ hẹn 30 phút), `OCCUPIED` (đang có khách, gắn với 1 Order mở), `BILL_PRINTED` (đã in tạm tính), `CLEANING` (chờ dọn dẹp sau khi khách thanh toán), `OUT_OF_SERVICE` (hỏng hóc/bảo trì). Đơn hàng chuyển `COMPLETED` tự động chuyển bàn sang `CLEANING`. Phục vụ dọn dẹp sạch sẽ bấm "Đã dọn xong" bàn mới chuyển về `AVAILABLE`. Cấm xếp khách mới vào bàn đang dọn hoặc bàn đặt trước.

### BR-46. Chuyển bàn nguyên tử (Atomic Table Move) & Đồng bộ KDS Barista
Nghiệp vụ chuyển bàn đòi hỏi bàn nguồn phải ở trạng thái `OCCUPIED` và bàn đích bắt buộc phải ở trạng thái `AVAILABLE`. Hệ thống áp dụng khóa `SELECT FOR UPDATE` trên bàn đích trong cùng 1 transaction: cập nhật `Order.tableId` sang bàn đích, chuyển bàn đích sang `OCCUPIED`, chuyển bàn nguồn sang `CLEANING` (hoặc `AVAILABLE` nếu khách vừa ngồi dưới 2 phút). Tự động đẩy sự kiện WebSocket `TABLE_MOVED` đến màn hình KDS Barista để nhân viên phục vụ mang đúng đồ uống đến bàn mới.

### BR-47. Gộp bàn, hợp nhất đơn hàng và xử lý cọc/voucher
Khi 2 nhóm gộp chung bàn, Thu ngân chọn Master Order (Đơn 1) và Slave Order (Đơn 2). Toàn bộ dòng món (`OrderItems`) và tiền cọc của Đơn 2 được kết chuyển sang Đơn 1. Voucher của Đơn 2 bị hủy và hoàn trả về tài khoản khách hàng sở hữu; Voucher Đơn 1 được tính toán lại theo ngưỡng tổng tiền mới của hóa đơn gộp. Đơn 2 chuyển trạng thái `MERGED_VOID` lưu tham chiếu `mergedIntoOrderId = Order1.id`. Bàn phụ được giải phóng về `CLEANING`. Bắt buộc Quản lý ca phê duyệt.

### BR-48. Tách bàn và tách hóa đơn (Theo món / Chia đều Dutch Treat)
- *Tách theo món*: Thu ngân chọn các món từ đơn gốc tạo Đơn con mới. Đơn gốc giảm trừ tiền và số lượng tương ứng. Nếu việc tách món khiến giá trị Đơn gốc giảm xuống dưới Min Spend của voucher đã áp dụng, hệ thống BẮT BUỘC TỰ ĐỘNG HỦY VOUCHER trên đơn gốc và tính lại giá chuẩn.
- *Tách chia đều (Dutch Treat)*: Giữ nguyên 1 Order, chia tổng tiền thành $N$ biên lai thanh toán bằng nhau theo thuật toán đồng dư lớn nhất (Largest Remainder). Đơn chỉ chuyển `COMPLETED` khi tổng tiền thu từ các biên lai bằng đúng 100% tổng tiền đơn gốc.

### BR-49. Thời gian ân hạn đặt bàn và tịch thu cọc No-show
Bàn đặt trước được tự động chuyển sang `RESERVED` trước giờ hẹn 30 phút ($T-30m$). Thời gian ân hạn giữ bàn tối đa là **15 phút** sau giờ hẹn ($T+15m$). Hệ thống gửi SMS/Zalo nhắc hẹn lúc $T-15m$ và $T$. Quá $T+15m$ khách không check-in (No-show): Background Job tự động chuyển bàn về `AVAILABLE` đón khách vãng lai, đơn đặt chuyển `NO_SHOW_FORFEITED`. Kế toán tự động tạo bút toán tịch thu 100% tiền cọc vào tài khoản Thu nhập khác TK 711. Hủy trước $\ge 2$ giờ hoàn 100% cọc.

### BR-50. Ca làm việc xuyên ngày và phân định Ngày kinh doanh (businessDate)
Ca đêm vận hành từ 22:00 hôm trước đến 06:00 sáng hôm sau được gắn chặt với trường `businessDate = D` (Ngày kinh doanh) thống nhất cho toàn bộ ca. Mọi đơn hàng, phiếu thu tiền mặt và phiếu trừ kho phát sinh trong ca (kể cả sau mốc nửa đêm 00:00 của ngày D+1) đều mang `businessDate = D`. Két tiền duy trì duy nhất 1 ca `OPEN` qua nửa đêm, tuyệt đối không bị reset doanh thu lúc 00:00. Bàn giao ca liên tục lúc 06:00 sáng giữa ca đêm và ca sáng.

### BR-51. Chốt sổ doanh thu kép (Midnight Snapshot) cuối tháng
Để phục vụ báo cáo tài chính pháp định cuối tháng vắt qua 2 kỳ kế toán (đêm 31/10 sang 01/11), hệ thống áp dụng cơ chế chốt sổ kép: Báo cáo nội bộ vận hành theo `shiftId` và `businessDate`; Báo cáo tài chính pháp định tự động tách các đơn phát sinh trước 23:59:59 vào tháng cũ và sau 00:00:01 vào tháng mới mà không làm gián đoạn ca làm việc vật lý của thu ngân. Tồn kho nguyên vật liệu trừ tức thì theo lô FEFO khi bắt đầu pha chế.

### BR-52. Kiểm tiền mù và 3 cấp độ dung sai chênh lệch tiền két
Khi đóng ca, màn hình POS ẩn hoàn toàn số tiền mặt sổ sách hệ thống ghi nhận. Thu ngân bắt buộc đếm tiền thực tế theo bảng kê mệnh giá (500k, 200k... 1k). Hệ thống tính chênh lệch $\Delta = Actual - Expected$:
- *Cấp 1 ($|\Delta| \le 20.000	ext{đ}$)*: Do làm tròn tiền lẻ thối khách, tự động hạch toán vào TK 642/711, đóng ca bình thường.
- *Cấp 2 ($20.000	ext{đ} < |\Delta| \le 100.000	ext{đ}$)*: Đếm lại lần 2; nếu vẫn lệch bắt buộc nhập giải trình và Quản lý ca nhập PIN duyệt đóng ca.
- *Cấp 3 ($|\Delta| > 100.000	ext{đ}$)*: Khóa tiến trình đóng ca thông thường. Bắt buộc Quản lý cửa hàng cùng đếm tiền, lập Biên bản kiểm quỹ bất thường điện tử (`CashDiscrepancyReport`) có chữ ký hai bên; khoản thiếu trừ trực tiếp vào lương thu ngân.

### BR-53. Rút tiền giữa ca về két an toàn (Cash Drop)
Khi lượng tiền mặt trong két thu ngân vượt hạn mức an toàn (mặc định $5.000.000	ext{đ}$), POS cảnh báo màu vàng yêu cầu rút tiền nộp két an toàn. Nghiệp vụ Cash Drop bắt buộc có sự hiện diện và xác thực kép của cả **Thu ngân** và **Quản lý cửa hàng**. Tiền rút ra bỏ vào phong bì chuyên dụng ghi mã niêm phong `EnvelopeBarcode`, bỏ vào khe két an toàn Drop Safe. Máy in in 2 liên phiếu rút tiền (1 bỏ phong bì, 1 giữ trong hộc két để trừ expected cash khi đóng ca).

### BR-54. Đóng ca khẩn cấp (Emergency Force Close) do sự cố
Khi cửa hàng đột ngột mất điện toàn phần, ngập lụt, cháy hoặc đứt cáp viễn thông, Quản lý kích hoạt chức năng cưỡng chế đóng ca `FORCED_CLOSED` trên ứng dụng quản trị. Toàn bộ giao dịch đã commit được đóng băng. Tất cả các đơn hàng đang dở dang (`QUEUED`, `IN_PROGRESS`) tự động chuyển sang `INCIDENT_ABORTED` và tự động kích hoạt API hoàn tiền 100% cho khách online. Tiền mặt trong két được niêm phong thủ công bằng văn bản giấy có chữ ký hai bên.

### BR-55. Quy chế Voucher Sinh Nhật và xác minh KYC chống trục lợi
Khách hàng phải đăng ký ngày sinh trên hồ sơ thành viên trước ngày sinh nhật ít nhất **30 ngày** mới đủ điều kiện nhận Voucher Sinh Nhật của năm đó. Ngày sinh chỉ được chỉnh sửa tối đa **1 lần duy nhất** trong đời tài khoản (sửa lần 2 bắt buộc xuất trình CCCD cho CSKH). Voucher có giá trị trong tháng sinh ($01/M$ đến cuối tháng $M$). Tại quầy POS, áp dụng voucher sinh nhật giá trị cao bắt buộc thu ngân đối chiếu CCCD/VNeID trùng khớp tên và ngày sinh mới được giảm giá. Voucher không thể chuyển nhượng.

### BR-56. Ma trận xếp chồng ưu đãi 4 cấp và Giá sàn bảo vệ giá vốn 80%
Thứ tự áp dụng ưu đãi: Cấp 1 (`ITEM_DISCOUNT` - giảm giá từng món) $ightarrow$ Cấp 2 (`ORDER_DISCOUNT` - voucher giảm giá hóa đơn, chỉ tính trên phần nguyên giá) $ightarrow$ Cấp 3 (`SHIPPING_DISCOUNT` - mã giảm ship) $ightarrow$ Cấp 4 (`LOYALTY_POINTS` - điểm thành viên trừ trên số tiền còn lại sau Cấp 1, 2, 3). Cùng cấp không cộng dồn (chỉ 1 voucher đơn + 1 mã ship). **Ràng buộc Giá sàn**: Tổng chiết khấu không vượt quá **80%** giá trị đơn ban đầu; số tiền thực thu tối thiểu của đơn giao thành công không nhỏ hơn $5.000	ext{đ}$.

### BR-57. Khóa giữ Voucher trong phiên thanh toán (TTL 15 phút)
Khi khách nhấn "Tiến hành thanh toán", hệ thống chuyển voucher sang `RESERVED` với TTL chính xác **15 phút**. Ưu đãi được bảo lưu trọn vẹn trong suốt 15 phút kể cả khi đồng hồ hệ thống chạy qua hạn chót của chiến dịch marketing. Nếu cổng thanh toán trả về `PAID` trong 15 phút, voucher chuyển sang `COMMITTED`. Nếu khách hủy hoặc quá 15 phút không thanh toán, Background Job tự động chuyển voucher về `RELEASED`.

### BR-58. Tích điểm theo số tiền thực chi và hoàn trả điểm/voucher
Điểm thành viên chỉ được tích lũy dựa trên số tiền thực tế khách hàng tự bỏ tiền túi ra thanh toán (`Net Out-of-pocket Amount` = Tiền mặt, Thẻ, Ví điện tử). Tiền giảm từ voucher và phần thanh toán bằng điểm cũ TUYỆT ĐỐI KHÔNG ĐƯỢC TÍCH ĐIỂM TIẾP. Khi hủy đơn toàn bộ: hoàn 100% tiền thực trả, hoàn 100% điểm đã tiêu và khôi phục voucher về `ACTIVE` (tự động gia hạn thêm 24h nếu voucher hết hạn trong lúc chờ). Hoàn tiền một phần: bóc tách hoàn tiền và điểm theo tỷ lệ snapshot đóng góp.

### BR-59. Cảnh báo nhiệt độ tủ mát & Tự động cách ly lô (QUARANTINED)
Tủ mát bảo quản nguyên liệu nhạy cảm lạnh ($2^\circ	ext{C} - 6^\circ	ext{C}$) có ngưỡng cảnh báo $> 8^\circ	ext{C}$. Nếu nhiệt độ vượt $> 8^\circ	ext{C}$ liên tục quá 120 phút (hoặc mất điện kéo dài $> 2$ giờ): Hệ thống phát còi báo động đỏ trên POS và tự động chuyển toàn bộ các lô nguyên liệu nhạy cảm lạnh trong tủ đó sang trạng thái `QUARANTINED` (Cách ly kiểm định). Đồng thời, hệ thống tự động chuyển toàn bộ các món menu có dùng nguyên liệu này sang trạng thái `OUT_OF_STOCK` trên cả Website và POS quầy.

### BR-60. Quy trình xuất hủy nguyên liệu khẩn cấp có 2 ảnh hiện trường
Mọi hao hụt bất thường do sự cố nhiệt độ/mất điện bắt buộc phải lập `InventoryDisposalVoucher` ghi rõ lô và số lượng. Ứng dụng bắt buộc nhân viên mở camera chụp trực tiếp 2 ảnh: Ảnh 1 (Cận cảnh tem lô và hạn dùng); Ảnh 2 (Toàn cảnh đổ bỏ nguyên liệu vào bồn rửa/thùng rác trước mặt Quản lý). Phân quyền duyệt: $\le 300	ext{k}$ do Quản lý ca duyệt; $300	ext{k} - 2	ext{tr}$ do Quản lý cửa hàng duyệt; $> 2	ext{tr}$ bắt buộc Giám đốc Vận hành khu vực (OM) duyệt điện tử.

### BR-61. Định khoản chi phí tổn thất bất thường vs Giá vốn hàng bán
Hao hụt chế biến bình thường trong định mức được phân bổ vào Giá vốn hàng bán (COGS - TK 632). Hỏng hóc nguyên liệu do hỏng tủ mát, mất điện bắt buộc hạch toán riêng vào **Chi phí tổn thất bất thường / Chi phí khác** (TK 811 hoặc TK 642 - Chi phí quản lý sự cố), trừ tồn kho chính xác theo lô nhập FEFO nguyên thủy ($LossValue = Quantity 	imes LotPurchaseCost$). Tuyệt đối không đưa vào TK 632 để bảo vệ tỷ lệ Food Cost % quầy bar phản ánh đúng thực tế vận hành.

### BR-62. Xử lý hủy món trong pha chế & Tái phân bổ ly nước (Reassign Cup)
- *Chưa pha (`QUEUED`)*: Hủy hoàn tiền 100%, giải phóng nguyên liệu.
- *Đang pha (`IN_PROGRESS`)*: Dừng pha. Lỗi quán hoàn 100%; khách đổi ý trừ phí hoặc duyệt PIN Quản lý ca hủy thiện chí.
- *Đã pha xong (`READY`)*: Barista kiểm tra hàng đợi pha chế. Nếu có đơn hàng sau gọi đúng món (cùng size, đường, đá, topping), Barista bấm `REASSIGN_CUP` để chuyển ly nước sang phục vụ ngay cho đơn sau! Cửa hàng không bị đổ bỏ ly nước. Nếu không có đơn sau, đổ bỏ và ghi nhận vào sổ theo dõi lãng phí `DrinkWasteLog`.

### BR-63. Phân định Void trong 10 phút vs Phân loại nhập kho hoàn trả
`POST_PAYMENT_VOID` áp dụng trong vòng **10 phút** kể từ lúc thanh toán khi đồ chưa pha, đảo giao dịch thanh toán gốc không mất phí cổng, hủy đơn hoàn toàn. Với trường hợp đổi trả hàng sau thanh toán: Hàng hóa đóng gói bán lẻ (ly giữ nhiệt, bình nước, cà phê gói) nguyên seal niêm phong được phép `RESTOCK_AVAILABLE` (Nhập lại kho bán lẻ); Đồ uống tươi pha chế và bánh tươi bóc vỏ **TUYỆT ĐỐI CẤM NHẬP LẠI KHO**, ghi nhận xuất hủy chất lượng. Thu hồi điểm tích lũy; nếu thiếu điểm ghi nợ điểm `PointsDebt`.

### BR-64. Chế độ POS Ngoại tuyến (Offline Mode) & Ưu tiên tại quầy
Khi đứt mạng Internet cáp quang, POS tự động chuyển sang Offline Mode: cho phép bán hàng tiền mặt, in hóa đơn/KOT mạng LAN nội bộ, tối đa 500 đơn hoặc 30 triệu đồng/phiên. Đơn hàng lưu SQLite cục bộ có mã `[Branch]-POS01-OFF-[Seq]` và ký số điện tử HMAC SHA-256 bằng secret key phần cứng. Khi có mạng lại, POS Agent đồng bộ FIFO lên server. Xung đột hết hàng với đơn Web: **ƯU TIÊN ĐƠN QUẦY**, đơn Web online bị đánh dấu xung đột `STOCK_OUT_CONFLICT_REJECTED`, tự động hoàn tiền 100% kèm voucher đền bù 20%.

### BR-65. Sổ cái thanh toán kết hợp nhiều hình thức (Split Payment)
Một đơn hàng được phép thanh toán bằng nhiều nguồn tiền theo trình tự: Điểm/Voucher $ightarrow$ Cổng ví MoMo/VNPAY $ightarrow$ Quẹt thẻ ngân hàng $ightarrow$ Tiền mặt thu cuối cùng. Mỗi nguồn tiền sinh 1 bản ghi `PaymentTransaction` độc lập. Đơn hàng chỉ chuyển `PAID` khi `remainingBalance == 0`. Nếu thanh toán dở dang thất bại (ví dụ quẹt thẻ lỗi), thu ngân bấm "Hủy giao dịch dở dang": hệ thống tự động gọi API Refund hoàn tiền các cổng đã trừ và hoàn điểm về ví khách, hủy đơn an toàn.

## 6. Máy trạng thái

### 6.1 Đơn và phục vụ

| Từ | Sang | Ai/điều kiện | Tác động |
|---|---|---|---|
| Mới xác nhận checkout | AWAITING_PAYMENT | Phương thức trả trước | Tạo đơn, giữ nguyên liệu/capacity có hạn |
| Mới xác nhận checkout | AWAITING_ACCEPTANCE | Trả tại quầy/COD được phép | Giữ, chờ cơ sở |
| AWAITING_PAYMENT | AWAITING_ACCEPTANCE | Khoản thu hợp lệ, hold còn hợp lệ | Không giữ thêm lần nữa |
| AWAITING_ACCEPTANCE | ACCEPTED | Cơ sở nhận | Cố định cam kết phục vụ, chuyển hạn giữ |
| ACCEPTED | PREPARING | Phiếu đầu bắt đầu | Tiêu hao phần phiếu đó |
| PREPARING | READY | Tất cả phiếu hợp lệ xong | Lưu readyAt, thông báo |
| READY | COMPLETED | Bàn giao pickup/tại chỗ + đủ điều kiện tiền | Lưu người nhận/bàn giao, xét điểm |
| READY | OUT_FOR_DELIVERY | Tài xế nhận | Lưu custody, không mặc định COD đã thu |
| OUT_FOR_DELIVERY | COMPLETED | Chứng cứ giao và xác nhận thu theo phương thức | Ghi mốc giao và payment riêng |
| OUT_FOR_DELIVERY | NEEDS_REVIEW | Đã giao thực tế nhưng thiếu thu tiền hoặc có ngoại lệ custody | Giữ POD/fulfilledAt, collectionException; không tự giao lại |
| OUT_FOR_DELIVERY | DELIVERY_FAILED | Không giao được | Mở xử lý đồ uống và tiền |
| Chưa có phiếu bắt đầu | CANCELLED/EXPIRED | Hủy hợp lệ/hết deadline | Release hold, refund nếu đã thu |
| ACCEPTED/PREPARING/READY/DELIVERY_FAILED | NEEDS_REVIEW | Thiếu hàng, no-show, lỗi chất lượng | Dừng tự động; quản lý giải quyết |
| NEEDS_REVIEW | Trạng thái được phép/CANCELLED | Quyết định có lý do và hành động đi kèm | Lưu history; không tự hồi tồn đã dùng |

NEEDS_REVIEW lưu trạng thái trước đó và các phiếu đang tồn tại. Khôi phục chỉ theo hành động được phép, không cho chọn tùy ý từ dropdown. Cancellation sau pha chỉ được đánh dấu sau khi ghi đủ hao hụt và nghĩa vụ hoàn, dù refund có thể còn PENDING.

Mọi chuyển COMPLETED kiểm số phải thu hiệu lực theo BR-26, không so cứng với tổng gốc. Với đơn nhận một phần, các unit VOID có quyết định riêng; COMPLETED/PARTIAL không có nghĩa đã giao mọi unit ban đầu. Không tạo PAID giả để vượt kiểm bàn giao khi nghĩa vụ tiền đã về 0; tình trạng SETTLED_NO_PAYMENT thể hiện đơn được giảm về 0 mà chưa từng thu. Trạng thái vận hành không thay trạng thái hoàn.

### 6.2 Các trạng thái độc lập

| Đối tượng | Trạng thái |
|---|---|
| Phiếu ly | WAITING → CLAIMED → PREPARING → READY → HANDED_OVER; nhánh VOID_BEFORE_PREP, WASTED, REMAKE_LINKED |
| Payment attempt | CREATED → PENDING → SUCCEEDED / FAILED / EXPIRED; UNKNOWN cần inquiry |
| Tình trạng tiền suy ra của đơn | UNPAID, PARTIALLY_PAID, PAID, SETTLED_NO_PAYMENT, PARTIALLY_REFUNDED, REFUNDED, OVERPAID_NEEDS_REVIEW; đối chiếu số phải thu hiệu lực và nghĩa vụ refund riêng |
| Refund | REQUESTED → APPROVED → PROCESSING → SUCCEEDED / UNKNOWN / FAILED_RETRYABLE; REJECTED chỉ trước khi gửi; UNKNOWN phải inquiry |
| Reservation | ACTIVE → CONSUMED / RELEASED / EXPIRED; tiêu hao từng phần có dòng chi tiết |
| Khiếu nại | OPEN → ASSIGNED → NEED_INFO / PROPOSED → RESOLVED → CLOSED; có REOPENED |
| Ca | OPEN → COUNTING → SUBMITTED → CLOSED; chênh lệch WAITING_APPROVAL |

Không gộp paid, delivered và completed thành một cờ boolean. Hai thanh toán cùng thành công có thể tồn tại thật; hệ thống phải thể hiện khoản thừa và xử lý.

## 7. Kịch bản tổng quan và liên kết luồng chi tiết

Bản1.2 đổi nhãn14 kịch bản tóm tắt cũ từ UC sang SC để tránh trùng với28 luồng chi tiết tại tài liệu08. Đối chiếu: SC01/03→UC03; SC02→UC05; SC04→UC07; SC05→UC08; SC06→UC10/11; SC07→UC12; SC08/09/10→UC13; SC11→UC18; SC12→UC22; SC13→UC14; SC14→UC28.

| Mã | Tác nhân và đầu vào | Luồng chính | Ngoại lệ và điều kiện đạt |
|---|---|---|---|
| SC-01 Chọn cơ sở | Khách; khu vực hoặc định vị | Liệt kê → chọn → chọn pickup → nạp menu đúng nơi | Từ chối GPS vẫn chọn được; cơ sở đóng không nhận checkout |
| SC-02 Chọn ly | Khách; món/size/options | Hiện lựa chọn hợp lệ → tính giá server → thêm giỏ | Chặn topping cấm; hai ly khác đường không bị gộp |
| SC-03 Đổi cơ sở | Khách có giỏ | So sánh giỏ mới → nêu món/giá đổi → xác nhận | Từ chối thì giữ giỏ cũ; không âm thầm bỏ món |
| SC-04 Đặt pickup | Thành viên; quote còn hạn | Kiểm lại → giữ nguyên liệu/capacity → tạo đơn → chọn trả tiền | Double click một đơn; thiếu nguyên liệu không tạo nửa đơn |
| SC-05 Thanh toán | Khách/gateway; attempt | Tạo giao dịch → xác minh kết quả → ghi thu → chờ nhận | Trễ sau hủy đưa hoàn; redirect giả không paid |
| SC-06 Nhận và pha | Thu ngân/barista | Nhận đơn → claim phiếu → bắt đầu → hoàn từng ly | Hai người claim một phiếu chỉ một thắng; thiếu lô mở review |
| SC-07 Bàn giao | Thu ngân/khách | Xác minh mã → thu còn thiếu → giao → completed | Không giao hai lần; mã đoán sai bị giới hạn |
| SC-08 Hủy khi đua pha | Khách/barista | Cùng kiểm lock/version → nhánh thắng được commit | Nếu đã pha, yêu cầu CSKH; không trả lại nguyên liệu đã dùng |
| SC-09 Làm lại | CSKH/quản lý | Xác nhận lỗi → duyệt → phiếu thay thế → tiêu hao mới → bàn giao | Giữ liên kết ly gốc, không tăng doanh số nếu chuỗi chịu lỗi |
| SC-10 Hoàn một phần | Quản lý/tài chính | Tính hạn mức → duyệt → gửi hoàn → xác minh → điều chỉnh điểm | Hai hoàn đồng thời không vượt đã trả; gọi lại an toàn |
| SC-11 Chuyển kho | Kho A/kho B | Đề nghị → duyệt → xuất → nhận thực tế → xử lý thiếu | Xuất không làm B khả dụng trước khi nhận; không ghi nhận hai lần |
| SC-12 Đóng ca | Thu ngân/quản lý | Tính expected → đếm → nộp → duyệt chênh → khóa | Không sửa dòng gốc sau khóa; không cộng tiền gateway vào quỹ mặt |
| SC-13 Giao thất bại | Tài xế/CSKH | Ghi lý do/liên hệ → phân loại đồ uống → xử lý tiền | Không restock ly; COD chưa thu vẫn chưa paid |
| SC-14 Mất realtime | Nhân viên/khách | Mất kết nối → báo trạng thái → reconnect → tải snapshot | Không phát sinh đơn mới; không áp event cũ đè trạng thái mới |

## 8. Danh mục chức năng để tạo backlog

Mỗi hàng là một chức năng có tiêu chí nhận biết hoàn thành. Chi tiết giao dịch phải tuân thủ BR và UC, không chỉ làm giao diện CRUD.

### 8.1 Tài khoản và quyền

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-001 | Đăng ký/xác minh email | P0 | Token một lần, có hạn, gửi lại giới hạn |
| F-002 | Đăng nhập/đăng xuất | P0 | Thất bại không lộ tài khoản; logout thu hồi phiên |
| F-003 | Quên/đổi mật khẩu | P0 | Reset không dùng lại, phiên cũ bị xử lý |
| F-004 | JWT và refresh rotation | P0 | Token hết hạn không dùng tiếp; replay refresh bị phát hiện |
| F-005 | Hồ sơ và địa chỉ | P0 | Chỉ chủ sở hữu sửa; snapshot đơn không đổi theo hồ sơ |
| F-006 | Gán vai trò theo cơ sở | P0 | Quyền có scope; đổi cơ sở trên URL không vượt quyền |
| F-007 | Khóa tài khoản/thu hồi quyền | P0 | HTTP/WS bị vô hiệu trong giới hạn đã định |
| F-008 | Đồng ý marketing và quyền riêng tư | P1 | Có lịch sử chọn/rút, không buộc khi mua |

### 8.2 Cơ sở và phục vụ

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-009 | Danh sách/chi tiết cơ sở | P0 | Địa chỉ, giờ, trạng thái nhận rõ |
| F-010 | Tìm bằng vị trí hoặc thủ công | P0 | GPS bị từ chối không chặn mua |
| F-011 | Lịch tuần và ngày ngoại lệ | P0 | Ngày nghỉ ghi đè lịch thường |
| F-012 | Tạm dừng nhận đơn | P0 | Chặn đơn mới, giữ màn hình xử lý đơn đang có |
| F-013 | Capacity và ETA | P0 | Slot kiểm lại lúc đặt; queue thay đổi có thông báo |
| F-014 | Kênh pickup/giao/quầy | P0 | Pickup/quầy chạy; giao chỉ bật khi P1 đủ điều kiện |
| F-015 | Vùng và phí giao | P1 | Ngoài vùng bị từ chối trước thu |
| F-016 | Hẹn giờ nhận | P2 | Có mô hình giữ công suất/nguyên liệu phù hợp thời gian |

### 8.3 Menu và nội dung sản phẩm

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-017 | Danh mục/món và tìm kiếm | P0 | Lọc theo menu cơ sở, phân trang |
| F-018 | Biến thể size/nóng lạnh | P0 | Tổ hợp hợp lệ duy nhất, giá rõ |
| F-019 | Nhóm tùy chọn đường/đá/sữa | P0 | Ràng buộc min/max ở server |
| F-020 | Topping/số phần/phụ thu | P0 | Có tồn và recipe cho phần thêm |
| F-021 | Công bố thành phần/cảnh báo | P0 | Không để khách nhầm thông tin dinh dưỡng đã xác minh |
| F-022 | Giá chuẩn/giá cơ sở | P0 | Hiệu lực không chồng, đơn cũ không đổi |
| F-023 | Tạm hết/ngừng bán/mùa vụ | P0 | Không xóa snapshot đã bán |
| F-024 | Ảnh menu Cloudinary | P0 | Vai trò, loại tệp, dung lượng, ảnh dự phòng |

### 8.4 Công thức và tồn

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-025 | Nguyên liệu/đơn vị/chuyển đổi | P0 | Không trộn đơn vị không tương thích |
| F-026 | Recipe có phiên bản | P0 | Kích cỡ/modifier tạo định lượng xác định |
| F-027 | Lô/hạn/cách ly | P0 | Lô hết hạn không được cấp cho phiếu mới |
| F-028 | Nhập kho cơ bản | P0 | Chứng từ tạo movement truy vết được |
| F-029 | Tính khả dụng | P0 | Dùng chung sữa giữa món vẫn trừ cùng cân đối |
| F-030 | Giữ/giải phóng/tiêu hao | P0 | Mỗi nguồn ghi đúng một lần |
| F-031 | Cảnh báo sắp hết/hết hạn | P1 | Có danh sách ảnh hưởng menu và đơn |
| F-032 | Mẻ sơ chế topping | P1 | Theo dõi đầu vào, đầu ra, yield và hạn mẻ |

### 8.5 Mua hàng và kho vận

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-033 | Nhà cung cấp/đơn mua | P1 | Tách đặt mua và nhận thực tế |
| F-034 | Nhận một phần đơn mua | P1 | Không tăng tồn phần chưa nhận |
| F-035 | Chuyển giữa cơ sở | P1 | Hai phía có chứng từ và hàng đang đi |
| F-036 | Kiểm kê | P1 | So sánh sổ/vật lý, có thời điểm chốt kiểm |
| F-037 | Duyệt chênh lệch | P1 | Không sửa số dư trực tiếp |
| F-038 | Hủy hao hụt/thu hồi | P0 | Lý do, lô, người, số lượng đầy đủ |
| F-039 | Sổ biến động nguyên liệu | P0 | Truy từ movement sang đơn/phiếu nhập |
| F-040 | Giá vốn ước tính theo lô | P1 | Ghi rõ phương pháp, không nhầm lợi nhuận kế toán |

### 8.6 Giỏ và tính giá

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-041 | Thêm/cập nhật/xóa dòng | P0 | Kiểm qty và cấu hình ở server |
| F-042 | Gộp dòng đúng cấu hình | P0 | Khác note/đường không gộp sai |
| F-043 | Chuyển cơ sở/kiểu nhận | P0 | So sánh và xác nhận thay đổi |
| F-044 | Tính quote có hạn | P0 | Tổng, cơ sở, ETA, điều kiện rõ |
| F-045 | Kiểm lại quote lúc chốt | P0 | Thay đổi trả quote mới cần khách đồng ý |
| F-046 | Ghi chú và người nhận | P0 | Giới hạn độ dài, escape, không biến note thành topping miễn phí |
| F-047 | Phân bổ giảm giá | P1 | Tổng dòng bằng tổng đơn đến từng đồng |
| F-048 | Đặt lại từ lịch sử | P1 | Tính lại menu/giá, không sao paid/hold cũ |

### 8.7 Đơn và thanh toán

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-049 | Tạo đơn atomic/idempotent | P0 | Một lỗi rollback toàn giữ/đơn |
| F-050 | Lịch sử/chi tiết/tracking | P0 | Chỉ chủ sở hữu hoặc nhân viên đúng quyền |
| F-051 | Trả tại quầy | P0 | Ghi receipt theo cơ sở, thu ngân, phương thức; liên kết ca khi bật P1 |
| F-052 | Gateway sandbox/giả lập | P0 | Tái hiện success/fail/late/duplicate |
| F-053 | Xác minh callback/inquiry | P0 | Chữ ký/số tiền/currency/attempt đúng |
| F-054 | Hết hạn hold | P0 | Job chạy lại không release hai lần |
| F-055 | Hủy trước pha | P0 | Đua với start prep an toàn |
| F-056 | Thu thừa/tiền chưa rõ | P0 | Có hàng chờ xử lý, không mất sự kiện |

### 8.8 Quầy và pha chế

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-057 | Tạo đơn khách vãng lai | P0 | Cùng engine giá/tồn với website |
| F-058 | Tiếp nhận/từ chối | P0 | Lý do, hạn nhận, hoàn nếu cần |
| F-059 | Bảng queue theo cơ sở | P0 | Hiện kênh, tuổi đơn, deadline, cấu hình |
| F-060 | Claim phiếu/bắt đầu pha | P0 | Một người claim, tiêu hao đúng một lần |
| F-061 | Hoàn từng ly/đủ đơn | P0 | Một ly xong không báo cả đơn xong |
| F-062 | Nhãn ly/phiếu in từ trình duyệt | P1 | Mã, tùy chỉnh, không dư PII |
| F-063 | Bàn giao bằng mã | P0 | Kiểm tiền, chống nhận lại |
| F-064 | No-show/làm lại | P0 | Review có quyết định và movement |

### 8.9 Giao hàng

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-065 | Kiểm địa chỉ/vùng giao | P1 | Không chỉ kiểm tỉnh/thành bằng text |
| F-066 | Phí và cam kết giao | P1 | Snapshot phí, ETA chỉ là ước lượng có căn cứ |
| F-067 | Phân công chuyến | P1 | Tài xế chỉ thấy chuyến được giao |
| F-068 | Nhận hàng tại cơ sở | P1 | Có người, thời điểm, số kiện/ly |
| F-069 | Xác nhận giao thành công | P1 | Bằng chứng tối thiểu và thông tin cần thiết |
| F-070 | Giao thất bại/liên hệ | P1 | Tách tiền và tình trạng đồ uống |
| F-071 | Thu/nộp COD | P1 | Tiền đang do tài xế giữ được đối chiếu |
| F-072 | Tích hợp hãng giao thật | P2 | Hợp đồng, sandbox, SLA và webhook được nghiệm thu |

### 8.10 Ưu đãi và thành viên

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-073 | Voucher có phạm vi/hạn/ngân sách | P1 | Chặn dùng ngoài cơ sở/kênh |
| F-074 | Giữ lượt/tiêu dùng/trả lượt | P1 | Đồng thời không vượt tổng lượt |
| F-075 | Tích điểm có điều kiện | P1 | Chỉ completed và paid, retry không cộng thêm |
| F-076 | Lịch sử/số dư điểm | P1 | Ledger khớp số dư và hạn |
| F-077 | Đổi điểm lấy voucher | P1 | Atomic trừ điểm/cấp voucher |
| F-078 | Hoàn/đảo điểm | P1 | Hoàn nhiều lần không sai làm tròn |
| F-079 | Hạng thành viên | P2 | Chi tiêu xét hạng và điểm đổi tách biệt |
| F-080 | Referral/quà sinh nhật | P2 | Điều kiện chống lạm dụng, có ngân sách |

### 8.11 Hậu mãi và nội dung

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-081 | Mở phản hồi theo đơn/ly | P0 | Chỉ đơn mình, có phân loại |
| F-082 | Ảnh bằng chứng riêng | P0 | Người khác không đọc URL công khai |
| F-083 | Phân công/SLA/trao đổi | P1 | Có người chịu trách nhiệm và quá hạn |
| F-084 | Duyệt refund/làm lại | P0 | Có hạn mức và quyền, giải quyết được lỗi mẫu |
| F-085 | Refund adapter và kết quả | P0 | Demo/sandbox, trạng thái pending không giả success |
| F-086 | Đánh giá sau mua/kiểm duyệt | P1 | Chống đánh giá giả theo đơn không sở hữu |
| F-087 | Banner/tin/FAQ/chính sách | P1 | Draft/published, thời hạn và nội dung an toàn |
| F-088 | Chat CSKH realtime | P2 | Lưu lịch sử, quyền phòng và phân công trước khi bật |

### 8.12 Tiền, báo cáo và quản trị

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-089 | Báo cáo ngày theo cơ sở | P0 | Tách doanh số/thu/hoàn, dữ liệu giả kiểm được |
| F-090 | Mở/thu/chi/đóng ca | P1 | Chênh lệch không tự mất |
| F-091 | Import/khớp bảng kê | P1 | Lặp không nhân dòng, có unmatched |
| F-092 | Khóa kỳ/điều chỉnh | P1 | Không sửa entry đã chốt |
| F-093 | Món bán/chậm/hao hụt | P1 | Bộ lọc và định nghĩa chỉ số công khai |
| F-094 | Xuất báo cáo có quyền | P1 | Giới hạn dữ liệu, chống formula injection CSV |
| F-095 | Audit và tra cứu sự cố | P0 | Từ mã đơn tìm request/event/movement |
| F-096 | Dashboard toàn chuỗi | P1 | Tổng bằng cộng các cơ sở cùng tiêu chí |

### 8.13 Nền tảng và vận hành

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-097 | SiteMesh layout khách/nhân viên/admin | P0 | Không decorate JSON/WS, không lồng layout |
| F-098 | WebSocket trạng thái/queue | P0 | Phân quyền subscribe, khôi phục snapshot |
| F-099 | Outbox/job retry/dead letter | P0 | Restart không mất việc; lỗi có hàng chờ xử lý |
| F-100 | Thông báo trong web/email | P0 | Có trạng thái gửi và retry giới hạn |
| F-101 | Cấu hình có phiên bản | P0 | Thay đổi ngưỡng/thời hạn có người và audit |
| F-102 | Sao lưu/phục hồi thử | P0 | Có biên bản khôi phục staging |
| F-103 | Theo dõi lỗi/sức khỏe | P0 | Biết queue kẹt, job lỗi, DB mất kết nối |
| F-104 | Mở rộng nhiều instance | P2 | Broker/lock/job/session được kiểm lại trước khi nhân bản |

### 8.14 Chức năng bổ sung sau rà soát

Các chức năng này làm rõ phần còn thiếu của phạm vi đã chọn; không thay thế F-001–104. P2 vẫn được giữ ngoài lịch triển khai bản đầu.

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-105 | Hợp nhất giỏ khi đăng nhập/nhiều thiết bị | P0 | Preview khác cơ sở, gộp một lần, version bảo vệ tab cũ |
| F-106 | Tiêu dùng quote/checkoutGeneration một lần | P0 | Đổi idempotency key vẫn không tạo trùng từ cùng quote/generation |
| F-107 | Nghĩa vụ tiền và điều chỉnh theo đơn vị | P0 | Tổng gốc, giảm đã duyệt, thu/hoàn và còn phải thu phân biệt |
| F-108 | Đơn phục vụ một phần | P0 | Unit VOID có duyệt; phần còn lại giao được với số phải thu đúng |
| F-109 | Deadline từng giai đoạn và callback sai thứ tự | P0 | Paid trước hạn chuyển hạn nhận; callback trễ không hồi đơn |
| F-110 | Bánh đóng gói và picking ticket | P1 | Lô/hạn, tiêu hao khi lấy, restock phải kiểm/duyệt |
| F-111 | Combo có phân bổ theo thành phần | P1 | Kiểm tồn từng phần, snapshot giá, refund không mất đồng dư |
| F-112 | Thu hồi lô và danh sách đơn ảnh hưởng | P1 | Trace lô đến ticket/order, chặn giữ mới và review giữ cũ |
| F-113 | Claim lease/giao lại phiếu an toàn | P0 | Phiếu đang pha không tự reset; không consume thêm khi retry; nhãn in lại thuộc F-062 P1 |
| F-114 | Tiền khách đưa/trả lại/biên nhận | P0 | Receipt chỉ ghi thu ròng; in lại không thêm giao dịch |
| F-115 | Điểm hết hạn/voucher đổi điểm và cấp bù | P1 | Không vừa trả điểm vừa cấp bù cùng sự kiện |
| F-116 | Yêu cầu dữ liệu cá nhân/retention/hold | P1 | Xác minh chủ thể, giữ hồ sơ tranh chấp, audit việc xóa/ẩn danh |
| F-117 | MFA/khôi phục tài khoản đặc quyền | P1 | MFA trước tiền thật; recovery có xác minh, thu hồi phiên và audit |
| F-118 | Bán tại chỗ cơ bản | P1 | Kênh quầy, trả trước, bao bì đúng mode; không mở nợ bàn |
| F-119 | Kiểm tra đủ điều kiện xuất bản menu | P0 | Recipe/giá/option không hợp lệ thì không publish |
| F-120 | Phê duyệt theo hạn mức/tách người thực hiện | P0 | Không tự duyệt khoản đòi hai người; vượt ngưỡng chuyển đúng vai trò |

### 8.15 Bổ sung vận hành và trải nghiệm theo định hướng mở rộng đề

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-121 | Hậu mãi cho khách vãng lai tại quầy | P0 | Nhân viên xác minh biên nhận, mở hồ sơ behalf-of; không bắt khách tạo tài khoản |
| F-122 | Món yêu thích/mẫu tùy chỉnh | P1 | Tính lại options/giá/tồn trước mua, owner-only |
| F-123 | Trả nguyên liệu nhà cung cấp | P1 | Receipt/lot gốc, số còn được trả, cách ly/điều chuyển hold và chứng từ xuất |
| F-124 | Giao lại và chuyển custody | P1 | Một attempt active, giữ lịch sử tài xế/COD; kiểm hạn chất lượng |
| F-125 | Checklist mở/đóng và bàn giao cơ sở | P1 | Đơn/refund/COD chưa xong có người tiếp nhận, không ép completed |
| F-126 | Quản lý phiên và đổi email có xác minh | P1 | Thu hồi theo session, không chuyển chủ đơn khi đổi email |
| F-127 | Giới hạn đơn chờ/giữ nguyên liệu | P0 | Atomic cap theo user/operation; retry không bị coi đơn mới |
| F-128 | Import dữ liệu có preview và version | P1 | Không nhập trực tiếp số dư kho/tiền/quyền; lỗi không commit nửa lô |

### 8.16 Bổ sung kịch bản biên và nghiệp vụ F&B thực tế (F-129 đến F-158)

| Mã | Chức năng | Mức | Tiêu chí |
|---|---|---|---|
| F-129 | Quản lý danh mục máy in POS | P1 | Khai báo thiết bị in (IP, port, USB, vai trò Bill/KOT/Tem ly, giấy K80/K58, máy in dự phòng) |
| F-130 | Hàng đợi in Spooler & Retry Failover | P0 | Quản lý tác vụ in bất đồng bộ, tự động thử lại 3 lần khi lỗi và điều hướng sang máy in phụ |
| F-131 | In KOT vi sai & Tem dán ly Barcode | P0 | Phân loại in bếp/bar và chỉ in món gọi thêm lần k; in tem nhãn ly kích thước chuẩn kèm mã vạch |
| F-132 | In lại hóa đơn có Watermark & PIN Quản lý | P0 | Cho phép in bản sao hóa đơn, bắt buộc nhập PIN Quản lý ca, ghi nhận lý do và watermark BẢN SAO |
| F-133 | Phục hồi in dở dang khi sự cố giấy | P0 | Tự động hủy tác vụ in rách/kẹt giữa trang, in lại toàn bộ bản thay thế và ghi log thu hồi mẩu rách |
| F-134 | Sơ đồ bàn trực quan & FSM trạng thái | P1 | Hiển thị bản đồ bàn theo tầng/khu vực với 6 màu trạng thái; tự động chuyển trạng thái theo đơn hàng |
| F-135 | Thao tác Chuyển bàn nguyên tử | P1 | Chuyển đơn hàng từ bàn nguồn sang bàn đích trống và bắn thông báo WebSocket sang màn hình KDS Barista |
| F-136 | Thao tác Gộp bàn & Hợp nhất đơn | P1 | Hợp nhất 2 đơn hàng tại 2 bàn vào 1 Master Order, kết chuyển cọc và hoàn trả voucher đơn phụ |
| F-137 | Thao tác Tách bàn & Tách hóa đơn | P1 | Tách đơn thành nhiều đơn con theo món hoặc chia đều số tiền (Dutch Treat) thành N biên lai |
| F-138 | Đặt bàn, quản lý cọc & Hủy No-show | P1 | Nhận đặt bàn có tiền cọc, tự động gửi tin nhắc giờ, tự động giải phóng bàn sau 15 phút ân hạn và tịch thu cọc |
| F-139 | Mở và quản lý ca đêm xuyên ngày | P0 | Mở ca làm việc vắt qua mốc nửa đêm (22:00 - 06:00) gắn toàn bộ doanh thu với businessDate thống nhất |
| F-140 | Báo cáo chốt doanh thu kép Midnight Snapshot | P1 | Cung cấp 2 góc nhìn đối soát: Sổ ca nội bộ theo shiftId và Sổ tài chính pháp định cắt lát lúc 23:59:59 cuối tháng |
| F-141 | Kiểm tiền mù cuối ca & Phân loại dung sai | P0 | Thu ngân nhập bảng kê đếm tiền mặt mà không thấy số dư sổ sách; hệ thống phân loại 3 cấp độ dung sai |
| F-142 | Lập biên bản kiểm quỹ bất thường điện tử | P1 | Tạo biên bản giải trình chênh lệch tiền mặt Cấp 3, ghi nhận chữ ký điện tử hai bên và chế tài bồi hoàn |
| F-143 | Rút tiền mặt giữa ca (Cash Drop) | P0 | Cảnh báo két tiền > 5 triệu; thực hiện rút tiền xác thực kép Quản lý + Thu ngân, in 2 liên biên nhận |
| F-144 | Cưỡng chế đóng ca khẩn cấp do sự cố | P0 | Chức năng đóng ca khẩn cấp FORCED_CLOSED khi mất điện/thiên tai, tự động hủy và hoàn tiền đơn dở dang |
| F-145 | Quản lý và áp dụng Voucher Sinh Nhật | P1 | Khóa ngày sinh KYC, kiểm tra điều kiện đăng ký >= 30 ngày, yêu cầu kiểm tra CCCD tại quầy POS |
| F-146 | Bộ tính toán ma trận xếp chồng ưu đãi 4 cấp | P0 | Áp dụng ưu đãi theo thứ tự Item -> Order -> Shipping -> Points; kiểm soát giá sàn 80% |
| F-147 | Khóa giữ Voucher có thời hạn (TTL 15 phút) | P0 | Khóa voucher ở trạng thái RESERVED trong 15 phút của phiên thanh toán online, bảo lưu ưu đãi |
| F-148 | Tích điểm Net chi tiêu & Thuật toán hoàn trả | P1 | Tích điểm dựa trên số tiền thực trả bằng tiền túi; tự động hoàn trả điểm và voucher khi hủy đơn hoặc hoàn 1 phần |
| F-149 | Giám sát nhiệt độ kho lạnh & Cảnh báo vượt ngưỡng | P1 | Ghi nhận nhiệt độ tủ mát/tủ đông, cảnh báo khi > 8°C quá 120 phút và tự động đổi lô sang QUARANTINED |
| F-150 | Khóa bán tự động trên Menu khi nguyên liệu cách ly | P0 | Quét công thức món, tự động chuyển các món dùng nguyên liệu trong lô bị QUARANTINED sang OUT_OF_STOCK |
| F-151 | Lập phiếu xuất hủy nguyên liệu khẩn cấp có 2 ảnh | P0 | Tạo phiếu hủy kho, bắt buộc chụp 2 ảnh hiện trường từ camera (tem lô và đổ bỏ) và phê duyệt đa cấp theo hạn mức |
| F-152 | Hạch toán chi phí tổn thất kho bất thường | P1 | Ghi nhận chi phí xuất hủy do hỏng tủ mát vào Chi phí khác TK 811 thay vì COGS; trừ tồn chính xác theo lô |
| F-153 | Xử lý hủy món đang pha & Tái phân bổ ly nước | P0 | Hủy đơn theo 3 giai đoạn pha chế; chức năng REASSIGN_CUP chuyển ly nước đã pha sẵn cho đơn sau cùng cấu hình |
| F-154 | Hủy giao dịch (Void 10 phút) & Phân loại nhập kho | P0 | Hủy nhanh đảo giao dịch trong 10 phút; phân loại hàng hóa đóng gói được nhập kho vs đồ uống cấm nhập kho |
| F-155 | Vận hành POS Ngoại tuyến (Offline Mode) | P1 | Cho phép bán hàng tiền mặt khi đứt mạng Internet, lưu trữ IndexedDB/SQLite có ký số HMAC SHA-256 |
| F-156 | Đồng bộ đơn hàng ngoại tuyến & Ưu tiên quầy | P1 | Tiến trình đồng bộ nền FIFO khi có mạng lại; giải quyết xung đột hết hàng: ưu tiên đơn quầy, hủy hoàn tiền đơn Web |
| F-157 | Thanh toán kết hợp nhiều hình thức (Split Payment) | P0 | Cho phép thanh toán 1 đơn hàng bằng nhiều nguồn (Điểm + MoMo + Thẻ + Tiền mặt) đến khi số dư còn lại bằng 0 |
| F-158 | Hủy giao dịch thanh toán kết hợp dở dang | P0 | Nút hủy giao dịch khi thanh toán dở dang thất bại; tự động gọi API hoàn tiền các cổng đã trừ và hoàn trả điểm |

## 9. Mục tiêu phi chức năng đề xuất

| Nhóm | Mục tiêu để kiểm thử | Phạm vi đo |
|---|---|---|
| Đúng dữ liệu | Không âm tồn, không vượt refund, không lặp tiền/đơn | Ca đồng thời và fault injection |
| Hiệu năng | p95 menu dưới 800ms; quote dưới 1s; tạo đơn dưới 2s | Staging có cấu hình ghi rõ, 50 người đồng thời, loại trừ chờ bên thứ ba |
| Realtime | 95% cập nhật trong 2s sau commit | Cùng mạng thử, ghi end-to-end latency |
| Điện thoại | Hoàn tất mua ở 390px; không mất thao tác ở 320px | Chrome Android/Safari iOS khi có thiết bị |
| Trợ năng | Bàn phím, focus, label, lỗi bằng chữ, tương phản được kiểm | Luồng chọn món/checkout/quầy |
| Dữ liệu | Tác vụ restart an toàn, khôi phục đã diễn tập | PostgreSQL thật và ảnh cần thiết |
| Bảo mật | Không vượt quyền đối tượng/cơ sở, không lộ token | HTTP/WS/upload/export và log |

Đây là tiêu chí đặt ra, không phải kết quả đã đo. Khi môi trường yếu hơn hoặc dữ liệu lớn hơn, phải ghi lại cấu hình và kết quả thay vì đổi số để tuyên bố đạt.

## 10. Những chính sách cần duyệt trước khi mở bán

Người phụ trách kinh doanh cần chốt menu/công thức, giá/thuế, vùng giao, ngưỡng trả sau, giờ nhận cuối, hạn chất lượng từng nhóm món, phí khi giao lại, điều kiện refund/no-show, SLA hỗ trợ và chương trình điểm. Người vận hành chốt phân quyền, ngưỡng phê duyệt, người giữ tiền, quy trình đầu/cuối ca. Người phụ trách dữ liệu chốt thời hạn lưu, nội dung đồng ý và quyền xem ảnh riêng. Các công việc này là điều kiện mở bán thực tế, không cản trở dùng dữ liệu demo để học và xây dựng đồ án theo kế hoạch.

## 11. Cấu hình mẫu và các giới hạn cần đặt rõ

| Tham số | Giá trị đề xuất cho demo | Khi hết hạn/vượt giới hạn |
|---|---|---|
| Báo giá | 5 phút | Tính lại, khách xác nhận thay đổi |
| Chờ trả trước | 10 phút | Expire nếu chưa thu; tiền về trễ đưa review |
| Chờ cơ sở nhận | 5 phút từ lúc tạo với trả quầy; từ lúc thu hợp lệ với trả trước | Expire/release khi chưa pha, tạo nghĩa vụ hoàn nếu đã thu |
| Giữ sau khi ACCEPTED | Đến promisedReadyAt +15 phút | Đưa NEEDS_REVIEW; không job release mù khi đã có phiếu pha |
| Chất lượng nhận tại quầy | Demo 30 phút từ READY | Review/no-show theo BR-14, cần xác nhận thực tế theo món |
| Slot capacity | 5 phút | Nếu hết, đề nghị slot/ETA mới để khách xác nhận |
| Đơn trả sau không có bảo đảm | Tối đa 200.000đ | Yêu cầu trả trước; áp dụng theo lịch sử và policy version |
| Số ly mỗi dòng/đơn | Tối đa 10/20 trong demo | Đơn lớn liên hệ cơ sở, không nhận vô hạn |
| Số đơn chờ/ly đang giữ mỗi tài khoản | Tối đa2 đơn chờ nhận/trả và30 ly đang giữ | Khóa guard theo account, hiện đơn chờ để khách xử lý; không đếm retry thành đơn mới |
| Thay đổi ETA cần đồng ý | Chênh trên5 phút; đề nghị hiệu lực5 phút demo | Không pha trước consent; hết hạn đi nhánh hủy/review/hoàn theo trạng thái |
| Ghi chú | 300 ký tự | Báo lỗi field, escape đầu ra |
| Ảnh bằng chứng | Tối đa 5 ảnh, 5MB/ảnh; JPEG/PNG/WebP | Kiểm file thực, từ chối hoặc yêu cầu giảm kích thước |
| SLA phản hồi hỗ trợ | Demo 4 giờ làm việc | Cảnh báo/chuyển người phụ trách; không giả là SLA đã cam kết |
| Idempotency record | Đề xuất lưu 30 ngày | Business unique keys của tiền/kho vẫn tồn tại lâu dài |

Giới hạn quy mô đơn, ảnh và SLA có thể thay đổi bằng cấu hình đã duyệt. Capacity của slot đã bắt đầu phục vụ được ghi thành lượng sử dụng; chỉ giải phóng phần chưa sử dụng khi hủy. Lưu lịch sử để tính tải thực, không giải phóng mọi capacity ngay khi pha xong rồi bán thêm vào một slot quá khứ.

P0 ghi nhận tiền mặt bằng receipt có cơ sở, thu ngân và thời gian; chức năng mở/đóng ca đầy đủ thuộc P1. Không tuyên bố đối soát quỹ thực tế hoàn chỉnh nếu chỉ có receipt P0.

## 12. Danh sách quyết định còn mở, có người chịu trách nhiệm

| Mã | Điều cần xác nhận | Mặc định để làm đồ án | Người chốt trước thực tế | Gate |
|---|---|---|---|---|
| D-01 | Hạn nộp và số giờ/tuần | Một người, lịch24 tuần+2–4 dự phòng theo bản1.2 | Chủ đề tài/giảng viên | Trước cam kết lịch |
| D-02 | Menu, recipe, hạn dùng, thành phần | Fixture hư cấu, không dùng để bán | Quản lý sản phẩm/vận hành | Trước nạp dữ liệu thật |
| D-03 | Phương thức tiền, refund và đối soát | Fake + sandbox, không thu thật | Tài chính/đối tác | Trước bật production |
| D-04 | Thuế, hóa đơn, thông tin doanh nghiệp | Giá demo trọn gói, biên nhận ghi rõ | Tài chính/người phụ trách pháp lý | Trước mở bán |
| D-05 | Vùng giao, cutoff, phí/no-show | Vùng thử và quy tắc BR | Quản lý cơ sở | Trước P1 UAT thực địa |
| D-06 | Retention và yêu cầu dữ liệu | Tách dữ liệu demo khỏi thật | Người phụ trách dữ liệu | Trước dùng dữ liệu khách thật |
| D-07 | Hạn mức/kiêm nhiệm và MFA | Hai tài khoản demo tách người duyệt | Quản trị chuỗi/tài chính | Trước P1/pilot |
| D-08 | RPO/RTO và ngân sách hạ tầng | Mục tiêu thử trong tài liệu 05 | Chủ vận hành | Trước nhận đơn thật |

Không cần chờ D-02–08 để thiết kế/code bằng fixture; nhưng không được trình bày mặc định đồ án như chính sách đã được doanh nghiệp phê duyệt.
