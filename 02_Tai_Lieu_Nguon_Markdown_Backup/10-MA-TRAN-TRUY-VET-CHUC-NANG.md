# 10. Ma trận truy vết từng chức năng UTECoffe

**Phiên bản1.2 — 18/11/2026.** Mọi dòng là kế hoạch triển khai/kiểm chứng, chưa là chức năng hoàn thành. Có128F:74P0,48P1,6P2. 122F thuộc P0/P1 có WBS và test mục tiêu;6F P2 giữ định hướng, không gán PASS hay ngày công giả.

## 1. Cách đọc và dùng khi bắt đầu code

Tên và điều kiện đạt của F lấy từ tài liệu02. UC trỏ mục cùng số trong tài liệu08; entity/màn hình là điểm vào, không phải toàn bộ schema. Hợp đồng API lõi ở03 mục8, API bổ sung ở09 mục9; trạng thái/quyền/job ở09. Cột TC liệt kê ca kiểm chính đã định danh trong05; developer phải triển khai các subcase theo điều kiện đạt F, bổ sung test thiếu khi chi tiết hóa. Một TC dùng chung không tự chứng minh toàn bộ F đã đạt.

WBS ở04 là nơi ghi actual hours/commit. Khi nghiệm thu thêm link artifact và actual result cho từng F. Các yêu cầu stack có ma trận RQ riêng ở07; không để một test chức năng thay chứng cứ JSP/JSTL/SiteMesh/Bootstrap/JPA.

## 2. Tài khoản và quyền

| F và chức năng | Mức | Actor / UC | Dữ liệu / màn hình | WBS | TC mục tiêu |
|---|---|---|---|---|---|
| F-001 — Đăng ký/xác minh email | P0 | Khách/quản trị; UC-01 | User/Session/Address; Tài khoản, hồ sơ, phiên | W04 | TC-115 |
| F-002 — Đăng nhập/đăng xuất | P0 | Khách/quản trị; UC-01 | User/Session/Address; Tài khoản, hồ sơ, phiên | W04 | TC-058, TC-060, TC-114 |
| F-003 — Quên/đổi mật khẩu | P0 | Khách/quản trị; UC-01 | User/Session/Address; Tài khoản, hồ sơ, phiên | W04 | TC-059, TC-115 |
| F-004 — JWT và refresh rotation | P0 | Khách/quản trị; UC-01 | User/Session/Address; Tài khoản, hồ sơ, phiên | W04 | TC-058, TC-059, TC-080, TC-114 |
| F-005 — Hồ sơ và địa chỉ | P0 | Khách/quản trị; UC-01 | User/Session/Address; Tài khoản, hồ sơ, phiên | W04 | TC-115 |
| F-006 — Gán vai trò theo cơ sở | P0 | Security/privacy admin; UC-27 | Membership/MFA/DataRequest; Quyền/MFA/privacy | W04 | TC-048, TC-054, TC-055, TC-098 |
| F-007 — Khóa tài khoản/thu hồi quyền | P0 | Security/privacy admin; UC-27 | Membership/MFA/DataRequest; Quyền/MFA/privacy | W04 | TC-048, TC-058, TC-117 |
| F-008 — Đồng ý marketing và quyền riêng tư | P1 | Khách/content editor; UC-24 | Content/Notification; Tìm kiếm/nội dung/thông báo | W19 | TC-139, TC-145 |

## 3. Cơ sở và menu

| F và chức năng | Mức | Actor / UC | Dữ liệu / màn hình | WBS | TC mục tiêu |
|---|---|---|---|---|---|
| F-009 — Danh sách/chi tiết cơ sở | P0 | Khách/quản lý; UC-03 | Branch/Hours/Mode; Chọn cơ sở/lịch | W05 | TC-001, TC-002, TC-003 |
| F-010 — Tìm bằng vị trí hoặc thủ công | P0 | Khách/quản lý; UC-03 | Branch/Hours/Mode; Chọn cơ sở/lịch | W05 | TC-001 |
| F-011 — Lịch tuần và ngày ngoại lệ | P0 | Khách/quản lý; UC-03 | Branch/Hours/Mode; Chọn cơ sở/lịch | W05 | TC-002, TC-003 |
| F-012 — Tạm dừng nhận đơn | P0 | Khách/quản lý; UC-03 | Branch/Hours/Mode; Chọn cơ sở/lịch | W05 | TC-002, TC-123 |
| F-013 — Capacity và ETA | P0 | Khách/quầy; UC-07 | Quote/Order/Reservation/Capacity; Checkout/đơn chờ | W05, W26 | TC-019, TC-121, TC-122 |
| F-014 — Kênh pickup/giao/quầy | P0 | Khách/quản lý; UC-03 | Branch/Hours/Mode; Chọn cơ sở/lịch | W05, W11 | TC-002, TC-044, TC-049, TC-096 |
| F-015 — Vùng và phí giao | P1 | Driver/điều phối; UC-14 | DeliveryAttempt/Custody/COD; Giao hàng/COD | W17 | TC-049 |
| F-016 — Hẹn giờ nhận | P2 | Khách/quản lý; UC-03 chỉ là điểm mở rộng | Branch/Hours/Mode; Chọn cơ sở/lịch | Chưa cam kết; ADR/gói riêng trước mở rộng | Chưa thiết kế test đầy đủ; không nghiệm thu ở P0/P1 |
| F-017 — Danh mục/món và tìm kiếm | P0 | Khách/content editor; UC-24 | Content/Notification; Tìm kiếm/nội dung/thông báo | W06 | TC-063, TC-113 |
| F-018 — Biến thể size/nóng lạnh | P0 | Catalog admin; UC-04 | Product/Variant/Price/Media; Menu, quản trị xuất bản | W06 | TC-004, TC-005, TC-091 |
| F-019 — Nhóm tùy chọn đường/đá/sữa | P0 | Khách/quầy; UC-05 | Recipe/Option/Inventory; Chi tiết/cấu hình ly | W06 | TC-004, TC-005, TC-011 |
| F-020 — Topping/số phần/phụ thu | P0 | Khách/quầy; UC-05 | Recipe/Option/Inventory; Chi tiết/cấu hình ly | W06, W07 | TC-004, TC-014, TC-015 |
| F-021 — Công bố thành phần/cảnh báo | P0 | Catalog admin; UC-04 | Product/Variant/Price/Media; Menu, quản trị xuất bản | W06 | TC-091, TC-110 |
| F-022 — Giá chuẩn/giá cơ sở | P0 | Catalog admin; UC-04 | Product/Variant/Price/Media; Menu, quản trị xuất bản | W06 | TC-008, TC-009, TC-018 |
| F-023 — Tạm hết/ngừng bán/mùa vụ | P0 | Catalog admin; UC-04 | Product/Variant/Price/Media; Menu, quản trị xuất bản | W06 | TC-007, TC-076, TC-119 |
| F-024 — Ảnh menu Cloudinary | P0 | Catalog admin; UC-04 | Product/Variant/Price/Media; Menu, quản trị xuất bản | W06 | TC-061, TC-068, TC-146 |

## 4. Nguyên liệu và kho

| F và chức năng | Mức | Actor / UC | Dữ liệu / màn hình | WBS | TC mục tiêu |
|---|---|---|---|---|---|
| F-025 — Nguyên liệu/đơn vị/chuyển đổi | P0 | Kho/pha chế; UC-17 | Ingredient/PrepBatch/Lot; Recipe/mẻ/lô/recall | W07 | TC-129 |
| F-026 — Recipe có phiên bản | P0 | Khách/quầy; UC-05 | Recipe/Option/Inventory; Chi tiết/cấu hình ly | W07 | TC-018, TC-088, TC-096 |
| F-027 — Lô/hạn/cách ly | P0 | Kho/pha chế; UC-17 | Ingredient/PrepBatch/Lot; Recipe/mẻ/lô/recall | W07 | TC-016, TC-017, TC-129 |
| F-028 — Nhập kho cơ bản | P0 | Kho/duyệt mua; UC-15 | Purchase/Receipt/Lot; Đặt mua/nhận hàng | W07 | TC-125 |
| F-029 — Tính khả dụng | P0 | Khách/quầy; UC-05 | Recipe/Option/Inventory; Chi tiết/cấu hình ly | W07 | TC-013, TC-014, TC-015 |
| F-030 — Giữ/giải phóng/tiêu hao | P0 | Khách/quầy; UC-07 | Quote/Order/Reservation/Capacity; Checkout/đơn chờ | W07, W09 | TC-013, TC-020, TC-022, TC-088 |
| F-031 — Cảnh báo sắp hết/hết hạn | P1 | Kho/pha chế; UC-17 | Ingredient/PrepBatch/Lot; Recipe/mẻ/lô/recall | W16 | TC-016, TC-090, TC-129 |
| F-032 — Mẻ sơ chế topping | P1 | Kho/pha chế; UC-17 | Ingredient/PrepBatch/Lot; Recipe/mẻ/lô/recall | W16 | TC-128 |
| F-033 — Nhà cung cấp/đơn mua | P1 | Kho/duyệt mua; UC-15 | Purchase/Receipt/Lot; Đặt mua/nhận hàng | W16 | TC-125 |
| F-034 — Nhận một phần đơn mua | P1 | Kho/duyệt mua; UC-15 | Purchase/Receipt/Lot; Đặt mua/nhận hàng | W16 | TC-125 |
| F-035 — Chuyển giữa cơ sở | P1 | Kho/quản lý; UC-18 | Transfer/Count/Movement; Chuyển/kiểm/sổ kho | W16 | TC-023 |
| F-036 — Kiểm kê | P1 | Kho/quản lý; UC-18 | Transfer/Count/Movement; Chuyển/kiểm/sổ kho | W16 | TC-024, TC-130 |
| F-037 — Duyệt chênh lệch | P1 | Kho/quản lý; UC-18 | Transfer/Count/Movement; Chuyển/kiểm/sổ kho | W16 | TC-024, TC-098, TC-130 |
| F-038 — Hủy hao hụt/thu hồi | P0 | Kho/quản lý; UC-18 | Transfer/Count/Movement; Chuyển/kiểm/sổ kho | W07, W12 | TC-036, TC-089 |
| F-039 — Sổ biến động nguyên liệu | P0 | Kho/quản lý; UC-18 | Transfer/Count/Movement; Chuyển/kiểm/sổ kho | W07 | TC-088, TC-089, TC-130 |
| F-040 — Giá vốn ước tính theo lô | P1 | Quản lý/tài chính; UC-26 | Ledger/Statement/Report; Dashboard/đối soát/export | W16, W18 | TC-127 |

## 5. Giỏ, đơn và tiền

| F và chức năng | Mức | Actor / UC | Dữ liệu / màn hình | WBS | TC mục tiêu |
|---|---|---|---|---|---|
| F-041 — Thêm/cập nhật/xóa dòng | P0 | Khách; UC-02 | Cart/CartLine; Giỏ và hợp nhất | W08 | TC-005, TC-011, TC-079, TC-080 |
| F-042 — Gộp dòng đúng cấu hình | P0 | Khách; UC-02 | Cart/CartLine; Giỏ và hợp nhất | W08 | TC-005, TC-006 |
| F-043 — Chuyển cơ sở/kiểu nhận | P0 | Khách/quản lý; UC-03 | Branch/Hours/Mode; Chọn cơ sở/lịch | W08 | TC-007, TC-049, TC-096 |
| F-044 — Tính quote có hạn | P0 | Khách/quầy; UC-07 | Quote/Order/Reservation/Capacity; Checkout/đơn chờ | W08 | TC-008, TC-009, TC-010, TC-019 |
| F-045 — Kiểm lại quote lúc chốt | P0 | Khách/quầy; UC-07 | Quote/Order/Reservation/Capacity; Checkout/đơn chờ | W09 | TC-009, TC-010, TC-077 |
| F-046 — Ghi chú và người nhận | P0 | Khách; UC-02 | Cart/CartLine; Giỏ và hợp nhất | W08 | TC-011, TC-063, TC-115 |
| F-047 — Phân bổ giảm giá | P1 | Marketing/khách; UC-20 | Campaign/Redemption/Allocation; Voucher/checkout | W15 | TC-037, TC-038, TC-136 |
| F-048 — Đặt lại từ lịch sử | P1 | Thành viên; UC-06 | Favorite/Cart; Yêu thích/mua lại | W19, W27 | TC-119 |
| F-049 — Tạo đơn atomic/idempotent | P0 | Khách/quầy; UC-07 | Quote/Order/Reservation/Capacity; Checkout/đơn chờ | W09 | TC-013, TC-015, TC-025, TC-026, TC-077, TC-078 |
| F-050 — Lịch sử/chi tiết/tracking | P0 | Khách/quầy; UC-12 | Handover/OrderUnit; Tracking/nhận/tại chỗ | W11 | TC-044, TC-046, TC-047, TC-053, TC-054, TC-099 |
| F-051 — Trả tại quầy | P0 | Thu ngân/CSKH; UC-09 | Order/Receipt/Case; Quầy/biên nhận/hậu mãi | W10, W11 | TC-081, TC-097, TC-142 |
| F-052 — Gateway sandbox/giả lập | P0 | Khách/tài chính; UC-08 | Attempt/Receipt/ProviderEvent; Kết quả trả tiền/tra soát | W10 | TC-027, TC-030, TC-031, TC-032 |
| F-053 — Xác minh callback/inquiry | P0 | Khách/tài chính; UC-08 | Attempt/Receipt/ProviderEvent; Kết quả trả tiền/tra soát | W10 | TC-027, TC-028, TC-029, TC-032, TC-087 |
| F-054 — Hết hạn hold | P0 | Ops; UC-28 | Audit/Outbox/Job/Config; Giám sát/runbook | W12, W13 | TC-020, TC-085, TC-086 |
| F-055 — Hủy trước pha | P0 | Khách/CSKH/duyệt; UC-13 | Adjustment/Refund/Resolution; Hủy/hoàn/làm lại | W12 | TC-022, TC-035, TC-081 |
| F-056 — Thu thừa/tiền chưa rõ | P0 | Khách/tài chính; UC-08 | Attempt/Receipt/ProviderEvent; Kết quả trả tiền/tra soát | W10, W12 | TC-031, TC-032, TC-084, TC-143 |

## 6. Quầy, pha chế và giao

| F và chức năng | Mức | Actor / UC | Dữ liệu / màn hình | WBS | TC mục tiêu |
|---|---|---|---|---|---|
| F-057 — Tạo đơn khách vãng lai | P0 | Thu ngân/CSKH; UC-09 | Order/Receipt/Case; Quầy/biên nhận/hậu mãi | W11 | TC-097, TC-118 |
| F-058 — Tiếp nhận/từ chối | P0 | Nhân viên/khách; UC-10 | Order/ETAProposal; Nhận đơn/đổi ETA | W11, W26 | TC-085, TC-086, TC-122 |
| F-059 — Bảng queue theo cơ sở | P0 | Pha chế; UC-11 | Unit/PrepTicket/Movement; Queue/phiếu/nhãn | W11 | TC-041, TC-043, TC-046, TC-047, TC-055 |
| F-060 — Claim phiếu/bắt đầu pha | P0 | Pha chế; UC-11 | Unit/PrepTicket/Movement; Queue/phiếu/nhãn | W11 | TC-041, TC-042, TC-088, TC-092 |
| F-061 — Hoàn từng ly/đủ đơn | P0 | Pha chế; UC-11 | Unit/PrepTicket/Movement; Queue/phiếu/nhãn | W11 | TC-042, TC-043 |
| F-062 — Nhãn ly/phiếu in từ trình duyệt | P1 | Pha chế; UC-11 | Unit/PrepTicket/Movement; Queue/phiếu/nhãn | W19 | TC-144 |
| F-063 — Bàn giao bằng mã | P0 | Khách/quầy; UC-12 | Handover/OrderUnit; Tracking/nhận/tại chỗ | W11 | TC-044, TC-099 |
| F-064 — No-show/làm lại | P0 | Pha chế; UC-11 | Unit/PrepTicket/Movement; Queue/phiếu/nhãn | W12 | TC-036, TC-045, TC-089, TC-093 |
| F-065 — Kiểm địa chỉ/vùng giao | P1 | Driver/điều phối; UC-14 | DeliveryAttempt/Custody/COD; Giao hàng/COD | W17 | TC-049 |
| F-066 — Phí và cam kết giao | P1 | Driver/điều phối; UC-14 | DeliveryAttempt/Custody/COD; Giao hàng/COD | W17 | TC-049, TC-132 |
| F-067 — Phân công chuyến | P1 | Driver/điều phối; UC-14 | DeliveryAttempt/Custody/COD; Giao hàng/COD | W17 | TC-054, TC-131 |
| F-068 — Nhận hàng tại cơ sở | P1 | Driver/điều phối; UC-14 | DeliveryAttempt/Custody/COD; Giao hàng/COD | W17 | TC-131 |
| F-069 — Xác nhận giao thành công | P1 | Driver/điều phối; UC-14 | DeliveryAttempt/Custody/COD; Giao hàng/COD | W17 | TC-133 |
| F-070 — Giao thất bại/liên hệ | P1 | Driver/điều phối; UC-14 | DeliveryAttempt/Custody/COD; Giao hàng/COD | W17 | TC-050, TC-132 |
| F-071 — Thu/nộp COD | P1 | Driver/điều phối; UC-14 | DeliveryAttempt/Custody/COD; Giao hàng/COD | W17, W18 | TC-051, TC-142 |
| F-072 — Tích hợp hãng giao thật | P2 | Driver/điều phối; UC-14 chỉ là điểm mở rộng | DeliveryAttempt/Custody/COD; Giao hàng/COD | Chưa cam kết; ADR/gói riêng trước mở rộng | Chưa thiết kế test đầy đủ; không nghiệm thu ở P0/P1 |

## 7. Ưu đãi, hỗ trợ và nội dung

| F và chức năng | Mức | Actor / UC | Dữ liệu / màn hình | WBS | TC mục tiêu |
|---|---|---|---|---|---|
| F-073 — Voucher có phạm vi/hạn/ngân sách | P1 | Marketing/khách; UC-20 | Campaign/Redemption/Allocation; Voucher/checkout | W15 | TC-012, TC-134, TC-136 |
| F-074 — Giữ lượt/tiêu dùng/trả lượt | P1 | Marketing/khách; UC-20 | Campaign/Redemption/Allocation; Voucher/checkout | W15 | TC-134, TC-136 |
| F-075 — Tích điểm có điều kiện | P1 | Thành viên; UC-21 | PointLedger/Reward; Điểm/ưu đãi | W15 | TC-039, TC-040 |
| F-076 — Lịch sử/số dư điểm | P1 | Thành viên; UC-21 | PointLedger/Reward; Điểm/ưu đãi | W15 | TC-103, TC-135 |
| F-077 — Đổi điểm lấy voucher | P1 | Thành viên; UC-21 | PointLedger/Reward; Điểm/ưu đãi | W15 | TC-102, TC-135 |
| F-078 — Hoàn/đảo điểm | P1 | Thành viên; UC-21 | PointLedger/Reward; Điểm/ưu đãi | W15 | TC-040, TC-103 |
| F-079 — Hạng thành viên | P2 | Thành viên; UC-21 chỉ là điểm mở rộng | PointLedger/Reward; Điểm/ưu đãi | Chưa cam kết; ADR/gói riêng trước mở rộng | Chưa thiết kế test đầy đủ; không nghiệm thu ở P0/P1 |
| F-080 — Referral/quà sinh nhật | P2 | Thành viên; UC-21 chỉ là điểm mở rộng | PointLedger/Reward; Điểm/ưu đãi | Chưa cam kết; ADR/gói riêng trước mở rộng | Chưa thiết kế test đầy đủ; không nghiệm thu ở P0/P1 |
| F-081 — Mở phản hồi theo đơn/ly | P0 | Khách/CSKH/moderator; UC-23 | Case/Review/Media; Hỗ trợ/đánh giá | W12 | TC-053, TC-118 |
| F-082 — Ảnh bằng chứng riêng | P0 | Khách/CSKH/moderator; UC-23 | Case/Review/Media; Hỗ trợ/đánh giá | W12 | TC-061, TC-062, TC-100, TC-101, TC-146 |
| F-083 — Phân công/SLA/trao đổi | P1 | Khách/CSKH/moderator; UC-23 | Case/Review/Media; Hỗ trợ/đánh giá | W19 | TC-139, TC-145, TC-147 |
| F-084 — Duyệt refund/làm lại | P0 | Khách/CSKH/duyệt; UC-13 | Adjustment/Refund/Resolution; Hủy/hoàn/làm lại | W12 | TC-034, TC-036, TC-098 |
| F-085 — Refund adapter và kết quả | P0 | Khách/CSKH/duyệt; UC-13 | Adjustment/Refund/Resolution; Hủy/hoàn/làm lại | W12 | TC-033, TC-082, TC-084 |
| F-086 — Đánh giá sau mua/kiểm duyệt | P1 | Khách/CSKH/moderator; UC-23 | Case/Review/Media; Hỗ trợ/đánh giá | W19 | TC-137 |
| F-087 — Banner/tin/FAQ/chính sách | P1 | Khách/content editor; UC-24 | Content/Notification; Tìm kiếm/nội dung/thông báo | W19 | TC-138 |
| F-088 — Chat CSKH realtime | P2 | Khách/CSKH/moderator; UC-23 chỉ là điểm mở rộng | Case/Review/Media; Hỗ trợ/đánh giá | Chưa cam kết; ADR/gói riêng trước mở rộng | Chưa thiết kế test đầy đủ; không nghiệm thu ở P0/P1 |

## 8. Tài chính và hạ tầng

| F và chức năng | Mức | Actor / UC | Dữ liệu / màn hình | WBS | TC mục tiêu |
|---|---|---|---|---|---|
| F-089 — Báo cáo ngày theo cơ sở | P0 | Quản lý/tài chính; UC-26 | Ledger/Statement/Report; Dashboard/đối soát/export | W14 | TC-072, TC-075, TC-106, TC-143 |
| F-090 — Mở/thu/chi/đóng ca | P1 | Thu ngân/quản lý; UC-22 | Shift/Incident/Handover; Ca/checklist/sự cố | W18 | TC-073, TC-124, TC-142 |
| F-091 — Import/khớp bảng kê | P1 | Quản lý/tài chính; UC-26 | Ledger/Statement/Report; Dashboard/đối soát/export | W18 | TC-052 |
| F-092 — Khóa kỳ/điều chỉnh | P1 | Quản lý/tài chính; UC-26 | Ledger/Statement/Report; Dashboard/đối soát/export | W18 | TC-074, TC-106 |
| F-093 — Món bán/chậm/hao hụt | P1 | Quản lý/tài chính; UC-26 | Ledger/Statement/Report; Dashboard/đối soát/export | W18 | TC-075, TC-127 |
| F-094 — Xuất báo cáo có quyền | P1 | Quản lý/tài chính; UC-26 | Ledger/Statement/Report; Dashboard/đối soát/export | W18 | TC-064, TC-145 |
| F-095 — Audit và tra cứu sự cố | P0 | Ops; UC-28 | Audit/Outbox/Job/Config; Giám sát/runbook | W13 | TC-066, TC-108, TC-145, TC-147 |
| F-096 — Dashboard toàn chuỗi | P1 | Quản lý/tài chính; UC-26 | Ledger/Statement/Report; Dashboard/đối soát/export | W18 | TC-075, TC-106 |
| F-097 — SiteMesh layout khách/nhân viên/admin | P0 | Catalog admin; UC-04 | Product/Variant/Price/Media; Menu, quản trị xuất bản | W03 | TC-065, TC-109, TC-110, TC-111 |
| F-098 — WebSocket trạng thái/queue | P0 | Pha chế; UC-11 | Unit/PrepTicket/Movement; Queue/phiếu/nhãn | W11 | TC-046, TC-047, TC-048, TC-055, TC-056, TC-057, TC-117 |
| F-099 — Outbox/job retry/dead letter | P0 | Ops; UC-28 | Audit/Outbox/Job/Config; Giám sát/runbook | W13 | TC-066, TC-108, TC-147 |
| F-100 — Thông báo trong web/email | P0 | Khách/content editor; UC-24 | Content/Notification; Tìm kiếm/nội dung/thông báo | W13, W19 | TC-068, TC-139 |
| F-101 — Cấu hình có phiên bản | P0 | Ops; UC-28 | Audit/Outbox/Job/Config; Giám sát/runbook | W13 | TC-145 |
| F-102 — Sao lưu/phục hồi thử | P0 | Ops; UC-28 | Audit/Outbox/Job/Config; Giám sát/runbook | W14, W21 | TC-069, TC-148 |
| F-103 — Theo dõi lỗi/sức khỏe | P0 | Ops; UC-28 | Audit/Outbox/Job/Config; Giám sát/runbook | W13, W21 | TC-067, TC-068, TC-070, TC-147, TC-148 |
| F-104 — Mở rộng nhiều instance | P2 | Ops; UC-28 chỉ là điểm mở rộng | Audit/Outbox/Job/Config; Giám sát/runbook | Chưa cam kết; ADR/gói riêng trước mở rộng | Chưa thiết kế test đầy đủ; không nghiệm thu ở P0/P1 |

## 9. Bổ sung rà soát lần một

| F và chức năng | Mức | Actor / UC | Dữ liệu / màn hình | WBS | TC mục tiêu |
|---|---|---|---|---|---|
| F-105 — Hợp nhất giỏ khi đăng nhập/nhiều thiết bị | P0 | Khách; UC-02 | Cart/CartLine; Giỏ và hợp nhất | W23 | TC-079, TC-080 |
| F-106 — Tiêu dùng quote/checkoutGeneration một lần | P0 | Khách/quầy; UC-07 | Quote/Order/Reservation/Capacity; Checkout/đơn chờ | W23 | TC-077, TC-078 |
| F-107 — Nghĩa vụ tiền và điều chỉnh theo đơn vị | P0 | Khách/CSKH/duyệt; UC-13 | Adjustment/Refund/Resolution; Hủy/hoàn/làm lại | W23 | TC-081, TC-082, TC-083, TC-084, TC-143 |
| F-108 — Đơn phục vụ một phần | P0 | Khách/CSKH/duyệt; UC-13 | Adjustment/Refund/Resolution; Hủy/hoàn/làm lại | W23 | TC-081, TC-082 |
| F-109 — Deadline từng giai đoạn và callback sai thứ tự | P0 | Nhân viên/khách; UC-10 | Order/ETAProposal; Nhận đơn/đổi ETA | W23, W26 | TC-085, TC-086, TC-087, TC-122 |
| F-110 — Bánh đóng gói và picking ticket | P1 | Catalog/quầy; UC-19 | Combo/Picking/Allocation; Bánh/combo/tại chỗ | W24 | TC-094, TC-095 |
| F-111 — Combo có phân bổ theo thành phần | P1 | Catalog/quầy; UC-19 | Combo/Picking/Allocation; Bánh/combo/tại chỗ | W24 | TC-095 |
| F-112 — Thu hồi lô và danh sách đơn ảnh hưởng | P1 | Kho/pha chế; UC-17 | Ingredient/PrepBatch/Lot; Recipe/mẻ/lô/recall | W16 | TC-090 |
| F-113 — Claim lease/giao lại phiếu an toàn | P0 | Pha chế; UC-11 | Unit/PrepTicket/Movement; Queue/phiếu/nhãn | W23 | TC-092, TC-093 |
| F-114 — Tiền khách đưa/trả lại/biên nhận | P0 | Thu ngân/CSKH; UC-09 | Order/Receipt/Case; Quầy/biên nhận/hậu mãi | W23 | TC-097 |
| F-115 — Điểm hết hạn/voucher đổi điểm và cấp bù | P1 | Thành viên; UC-21 | PointLedger/Reward; Điểm/ưu đãi | W15 | TC-102, TC-103, TC-135 |
| F-116 — Yêu cầu dữ liệu cá nhân/retention/hold | P1 | Security/privacy admin; UC-27 | Membership/MFA/DataRequest; Quyền/MFA/privacy | W25 | TC-104, TC-145, TC-146 |
| F-117 — MFA/khôi phục tài khoản đặc quyền | P1 | Security/privacy admin; UC-27 | Membership/MFA/DataRequest; Quyền/MFA/privacy | W25 | TC-105, TC-117 |
| F-118 — Bán tại chỗ cơ bản | P1 | Khách/quầy; UC-12 | Handover/OrderUnit; Tracking/nhận/tại chỗ | W24 | TC-096 |
| F-119 — Kiểm tra đủ điều kiện xuất bản menu | P0 | Catalog admin; UC-04 | Product/Variant/Price/Media; Menu, quản trị xuất bản | W23 | TC-091 |
| F-120 — Phê duyệt theo hạn mức/tách người thực hiện | P0 | Security/privacy admin; UC-27 | Membership/MFA/DataRequest; Quyền/MFA/privacy | W23 | TC-098 |

## 10. Bổ sung rà soát lần hai

| F và chức năng | Mức | Actor / UC | Dữ liệu / màn hình | WBS | TC mục tiêu |
|---|---|---|---|---|---|
| F-121 — Hậu mãi cho khách vãng lai tại quầy | P0 | Thu ngân/CSKH; UC-09 | Order/Receipt/Case; Quầy/biên nhận/hậu mãi | W26 | TC-118 |
| F-122 — Món yêu thích/mẫu tùy chỉnh | P1 | Thành viên; UC-06 | Favorite/Cart; Yêu thích/mua lại | W27 | TC-119 |
| F-123 — Trả nguyên liệu nhà cung cấp | P1 | Kho/tài chính; UC-16 | SupplierReturn/CreditRef; Trả nhà cung cấp | W27 | TC-126, TC-127 |
| F-124 — Giao lại và chuyển custody | P1 | Driver/điều phối; UC-14 | DeliveryAttempt/Custody/COD; Giao hàng/COD | W27 | TC-131, TC-132, TC-133 |
| F-125 — Checklist mở/đóng và bàn giao cơ sở | P1 | Thu ngân/quản lý; UC-22 | Shift/Incident/Handover; Ca/checklist/sự cố | W27 | TC-123, TC-124 |
| F-126 — Quản lý phiên và đổi email có xác minh | P1 | Khách/quản trị; UC-01 | User/Session/Address; Tài khoản, hồ sơ, phiên | W27 | TC-116, TC-117 |
| F-127 — Giới hạn đơn chờ/giữ nguyên liệu | P0 | Khách/quầy; UC-07 | Quote/Order/Reservation/Capacity; Checkout/đơn chờ | W26 | TC-120 |
| F-128 — Import dữ liệu có preview và version | P1 | Admin theo kind; UC-25 | ImportBatch/Row; Import preview | W27 | TC-140, TC-141 |

## 11. Bổ sung chức năng kịch bản biên F&B thực tế (F-129 đến F-158)

| F và chức năng | Mức | Actor / UC | Dữ liệu / màn hình | WBS | TC mục tiêu |
|---|---|---|---|---|---|
| F-129 — Quản lý danh mục máy in POS | P1 | Quản lý/IT; UC-29 | PosPrinterDevice; Cấu hình máy in POS | W28 | TC-149, TC-150 |
| F-130 — Hàng đợi in Spooler & Retry Failover | P0 | Hệ thống/Thu ngân; UC-29 | PrintJob/PrintQueue; Quầy thu ngân, Spooler | W28 | TC-149, TC-150, TC-151 |
| F-131 — In KOT vi sai & Tem dán ly Barcode | P0 | Thu ngân/Barista; UC-29 | OrderUnit/CupLabel; KDS Barista, Bếp | W28 | TC-152, TC-153 |
| F-132 — In lại hóa đơn có Watermark & PIN Quản lý | P0 | Thu ngân/Quản lý; UC-30 | BillReprintLog/Order; Lịch sử ca, Hóa đơn | W28 | TC-154, TC-155 |
| F-133 — Phục hồi in dở dang khi sự cố giấy | P0 | Thu ngân/Hệ thống; UC-29 | PrintJob/HardwareAuditLog; Quầy thu ngân | W28 | TC-156 |
| F-134 — Sơ đồ bàn trực quan & FSM trạng thái | P1 | Phục vụ/Thu ngân; UC-31 | RestaurantTable/TableZone; Sơ đồ bàn | W29 | TC-157 |
| F-135 — Thao tác Chuyển bàn nguyên tử | P1 | Phục vụ/Barista; UC-31 | Order/RestaurantTable; Sơ đồ bàn, KDS | W29 | TC-158, TC-159 |
| F-136 — Thao tác Gộp bàn & Hợp nhất đơn | P1 | Quản lý ca/Thu ngân; UC-31 | Order/OrderItem/Voucher; Sơ đồ bàn | W29 | TC-160, FX-11 |
| F-137 — Thao tác Tách bàn & Tách hóa đơn | P1 | Thu ngân/Quản lý ca; UC-31 | Order/Receipt/DutchTreat; Màn hình thanh toán | W29 | TC-161, TC-162, FX-11 |
| F-138 — Đặt bàn, quản lý cọc & Hủy No-show | P1 | Lễ tân/Quản lý; UC-32 | TableReservation/Deposit; Quản lý đặt bàn | W29 | TC-163, TC-164 |
| F-139 — Mở và quản lý ca đêm xuyên ngày | P0 | Thu ngân/Quản lý; UC-33 | CashierShift/businessDate; Quản lý ca | W30 | TC-165 |
| F-140 — Báo cáo chốt doanh thu kép Midnight Snapshot | P1 | Kế toán/Quản trị; UC-33 | FinancialReport/MidnightCutoff; Báo cáo tài chính | W30 | TC-166 |
| F-141 — Kiểm tiền mù cuối ca & Phân loại dung sai | P0 | Thu ngân/Quản lý; UC-34 | ShiftCashCountDetail; Đóng ca quầy POS | W30 | TC-167, TC-168, TC-169, FX-09 |
| F-142 — Lập biên bản kiểm quỹ bất thường điện tử | P1 | Quản lý cơ sở/Kế toán; UC-34 | CashDiscrepancyReport; Báo cáo kiểm kê | W30 | TC-169, FX-09 |
| F-143 — Rút tiền mặt giữa ca (Cash Drop) | P0 | Thu ngân/Quản lý; UC-33 | CashDropTransaction; Hộc két quầy POS | W30 | TC-170 |
| F-144 — Cưỡng chế đóng ca khẩn cấp do sự cố | P0 | Quản lý/Admin; UC-34 | CashierShift/Incident; App Quản trị di động | W30 | TC-171 |
| F-145 — Quản lý và áp dụng Voucher Sinh Nhật | P1 | Marketing/Thu ngân; UC-35 | CustomerProfile/Voucher; Hồ sơ khách, POS | W31 | TC-172, TC-173 |
| F-146 — Bộ tính toán ma trận xếp chồng ưu đãi 4 cấp | P0 | Hệ thống/Khách; UC-35 | PromotionStackingEngine; Giỏ hàng, Checkout | W31 | TC-174 |
| F-147 — Khóa giữ Voucher có thời hạn (TTL 15 phút) | P0 | Hệ thống/Khách; UC-36 | VoucherReservation/TTL; Cổng thanh toán | W31 | TC-175, TC-176 |
| F-148 — Tích điểm Net chi tiêu & Thuật toán hoàn trả | P1 | Hệ thống/CSKH; UC-36 | LoyaltyLedger/PointsReversal; Ví thành viên | W31 | TC-177, TC-178 |
| F-149 — Giám sát nhiệt độ kho lạnh & Cảnh báo vượt ngưỡng | P1 | Kho/Quản lý; UC-37 | ColdStorageUnit/TempLog; Giám sát kho lạnh | W32 | TC-179 |
| F-150 — Khóa bán tự động trên Menu khi nguyên liệu cách ly | P0 | Hệ thống/Barista; UC-37 | MenuItem/IngredientLot; Menu bán hàng | W32 | TC-180 |
| F-151 — Lập phiếu xuất hủy nguyên liệu khẩn cấp có 2 ảnh | P0 | Quản lý kho/Quản lý; UC-38 | InventoryDisposalVoucher; Quản lý kho | W32 | TC-181, TC-182 |
| F-152 — Hạch toán chi phí tổn thất kho bất thường | P1 | Kế toán/Kho; UC-38 | StockMovement/TK811; Báo cáo giá vốn | W32 | TC-183, FX-10 |
| F-153 — Xử lý hủy món đang pha & Tái phân bổ ly nước | P0 | Thu ngân/Barista; UC-39 | DrinkWasteLog/ReassignCup; KDS Barista | W33 | TC-184, TC-185 |
| F-154 — Hủy giao dịch (Void 10 phút) & Phân loại nhập kho | P0 | Thu ngân/Quản lý; UC-39 | Order/PaymentReversal; Quản lý đơn hàng | W33 | TC-186, TC-187 |
| F-155 — Vận hành POS Ngoại tuyến (Offline Mode) | P1 | Thu ngân/POS; UC-40 | SQLiteOfflineStore/HMAC; Ứng dụng POS | W33 | TC-188 |
| F-156 — Đồng bộ đơn hàng ngoại tuyến & Ưu tiên quầy | P1 | POS Agent/Hệ thống; UC-40 | SyncQueue/ConflictResolution; POS Sync | W33 | TC-189 |
| F-157 — Thanh toán kết hợp nhiều hình thức (Split Payment) | P0 | Thu ngân/Khách; UC-41 | PaymentTransaction/MultiTender; Màn hình thanh toán | W33 | TC-190, FX-12 |
| F-158 — Hủy giao dịch thanh toán kết hợp dở dang | P0 | Thu ngân/Hệ thống; UC-41 | PaymentTransaction/AutoRefund; Màn hình thanh toán | W33 | TC-191, FX-12 |

## 12. Kiểm soát độ bao phủ khi thay đổi

Không thêm F mà thiếu actor/UC, entity/API, WBS và ca kiểm mục tiêu. Không chuyển P1 sang P2 chỉ trong code; phải sửa phạm vi, timeline và biên bản với chủ đề tài. Các dòng P2 hiện tại là F-016/072/079/080/088/104; không nằm trong122 chức năng P0/P1 cam kết của bản đầy đủ.

Mỗi test cần data/steps/expected/actual, gồm quyền sai và lỗi liên quan; mã TC hiện là kịch bản nhóm, không phải chỉ một assertion. Một chức năng có thể cần thêm test ngoài148 mã sau khi chia nhỏ endpoint. Truy vết là công cụ phát hiện thiếu sót, không bảo đảm tất cả rủi ro vận hành đã được loại bỏ.
