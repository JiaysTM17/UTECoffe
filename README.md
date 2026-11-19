<p align="center">
  <img src="03_Thiet_Ke_Thuong_Hieu_Logo/logo_chinh_ngang.png" alt="UTECoffe Master Logo" width="620"/>
</p>

<p align="center">
  <strong>Hệ Thống Website Thương Mại Điện Tử Chuỗi Bán Trà & Cà Phê Đặc Sản UTECoffe</strong>
</p>

<p align="center">
  <a href="#-công-nghệ-sử-dụng"><img src="https://img.shields.io/badge/Java-17%2B-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white" alt="Java 17"/></a>
  <a href="#-công-nghệ-sử-dụng"><img src="https://img.shields.io/badge/Spring_Boot-3.x-6DB33F?style=for-the-badge&logo=springboot&logoColor=white" alt="Spring Boot 3"/></a>
  <a href="#-công-nghệ-sử-dụng"><img src="https://img.shields.io/badge/Spring_Security-JWT-6DB33F?style=for-the-badge&logo=springsecurity&logoColor=white" alt="Security"/></a>
  <a href="#-công-nghệ-sử-dụng"><img src="https://img.shields.io/badge/PostgreSQL-16-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL"/></a>
  <a href="#-công-nghệ-sử-dụng"><img src="https://img.shields.io/badge/WebSocket-STOMP-010101?style=for-the-badge&logo=socketdotio&logoColor=white" alt="WebSocket"/></a>
  <a href="#-công-nghệ-sử-dụng"><img src="https://img.shields.io/badge/SiteMesh-3.0-FF6F00?style=for-the-badge" alt="SiteMesh 3"/></a>
  <a href="#-công-nghệ-sử-dụng"><img src="https://img.shields.io/badge/Bootstrap-5.3-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white" alt="Bootstrap 5"/></a>
  <a href="#-công-nghệ-sử-dụng"><img src="https://img.shields.io/badge/Cloudinary-Media_API-3448C5?style=for-the-badge&logo=cloudinary&logoColor=white" alt="Cloudinary"/></a>
</p>

---

## 📌 Giới Thiệu Đề Tài

**UTECOFFE** là nền tảng thương mại điện tử chuyên biệt phục vụ chuỗi cửa hàng bán lẻ trà và cà phê đặc sản kết hợp mô hình OMO (*Online-Merge-Offline / Bán hàng đa kênh*). Dự án được xây dựng nhằm đáp ứng toàn diện bài toán vận hành thực tế ngành F&B: từ trải nghiệm mua sắm trực tuyến của khách hàng, màn hình quầy pha chế thời gian thực (KDS - Kitchen Display System) cho Barista, quản lý tồn kho đa chi nhánh, đến phân tích kinh doanh tự động cho ban quản trị.

- **Đơn vị đào tạo:** Trường Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)
- **Học phần:** Đồ án Lập trình Web / Thương mại điện tử
- **Ngôn ngữ & Nền tảng:** Java Spring Boot, JSP/JSTL, Sitemesh Decorator, Bootstrap, JPA/Hibernate, PostgreSQL, JWT, WebSocket, Cloudinary.

---

## 🎯 Điểm Nổi Bật & Nghiệp Vụ Cốt Lõi

```
+---------------------------------------------------------------------------------------+
|                                HỆ SINH THÁI UTECOFFE                                 |
+--------------------------+----------------------------+-------------------------------+
|    Khách Hàng (Web/App)  |   Quầy Pha Chế (Barista)   |    Ban Quản Trị & Cửa Hàng    |
| • Đặt món Delivery/Pickup| • Màn hình KDS Realtime    | • Quản lý tồn kho chi nhánh   |
| • Tùy biến size/đường/đá | • WebSocket nhận đơn tức thì| • Định lượng công thức (BOM)  |
| • Đặt bàn trước & gọi món| • Xếp hàng pha chế FIFO    | • Báo cáo doanh thu Chart.js  |
| • Tích điểm hội viên     | • Bắn tiến trình về khách  | • Phân quyền RBAC 5 cấp       |
+--------------------------+----------------------------+-------------------------------+
```

### 1. Tùy Biến Đồ Uống & Công Thức Pha Chế Chuyên Sâu (Recipe Customization)
- Tùy chỉnh chi tiết kích cỡ: **Size S (350ml), M (500ml), L (700ml)**.
- Mức ngọt linh hoạt: **0%, 30%, 50%, 70%, 100% hoặc đường ăn kiêng Isomalt**.
- Mức độ đá: **Nóng, Không đá, 30% đá, 50% đá, 100% đá, Đá để riêng**.
- Nhóm Topping đa dạng: Trân châu hoàng kim, thạch đào, kem phô mai cheese foam, pudding trứng, hạt sen.
- Cà phê hạt rang mộc: Chọn độ rang (*Light/Medium/Dark Roast*) và cỡ xay (*Nguyên hạt, pha Phin, pha máy Espresso, Cold Brew, French Press*).
- Bán kèm đồ ăn nhẹ (Cross-sell): Bánh ngọt, Croissant trứng muối, Tiramisu.

### 2. Mô Hình Đa Chi Nhánh & Đa Phương Thức Nhận Hàng (Omnichannel Fulfillment)
- **Giao hàng tận nơi (Delivery):** Tự động xác định chi nhánh gần nhất theo tọa độ địa lý, tính toán phí vận chuyển chính xác theo khoảng cách (km).
- **Nhận tại quán (Takeaway Pickup):** Khách hàng chủ động chọn chi nhánh và đặt giờ hẹn lấy đồ uống; hệ thống phát hành mã QR nhận món tại quầy.
- **Quản lý tồn kho theo chi nhánh:** Kiểm soát nguyên liệu độc lập tại từng điểm bán; tự động chuyển trạng thái "Tạm hết món" tại cơ sở thiếu nguyên liệu mà không ảnh hưởng tới toàn chuỗi.

### 3. Màn Hình Pha Chế Thời Gian Thực (KDS Barista qua WebSocket STOMP)
- Hệ thống đẩy thông báo đơn hàng mới tức thì kèm âm thanh cảnh báo tới màn hình Barista của chi nhánh được chỉ định.
- Quản lý quy trình pha chế 1-chạm (*Tiếp nhận -> Đang pha -> Pha xong*).
- Cập nhật tiến độ đơn hàng thời gian thực về giao diện theo dõi của khách hàng (Tracking Stepper) mà không cần tải lại trang.

### 4. Hệ Thống Hội Viên & Điểm Thưởng (Loyalty & Gamification)
- Tích lũy điểm thưởng: **10.000 VNĐ = 1 Coffee Bean**.
- 4 phân hạng thành viên tự động: **Đồng (Bronze) -> Bạc (Silver) -> Vàng (Gold - Giảm 5%) -> Kim Cương (Diamond - Giảm 10%)**.
- Ví voucher cá nhân: Đổi điểm lấy mã giảm giá, voucher miễn phí topping, ưu đãi sinh nhật.

### 5. Cổng Thanh Toán Đa Kênh & Hoàn Tiền
- Tiền mặt khi nhận hàng (COD).
- Cổng thanh toán trực tuyến: VNPay, MoMo, ZaloPay.
- **VietQR Động:** Tự động tạo mã QR chuyển khoản chứa mã đơn hàng và số tiền chính xác, tích hợp webhook đối soát thanh toán tức thì.
- Cơ chế xử lý hoàn tiền / hoàn điểm thưởng minh bạch khi có sự cố hủy đơn.

### 6. Đặt Bàn Trực Tuyến (Table Reservation)
- Chọn chi nhánh, ngày giờ đến, số lượng khách và khu vực bàn (*Máy lạnh trong nhà, Ban công, Sân vườn, Phòng họp nhóm*).
- Hỗ trợ gọi trước đồ uống kèm theo bàn để tiết kiệm thời gian chờ đợi.

---

## 🛠 Công Nghệ Sử Dụng

| Tầng Kiến Trúc | Công Nghệ & Thư Viện | Vai Trò Trong Dự Án |
| :--- | :--- | :--- |
| **Backend Core** | Java 17, Spring Boot 3.x | Xây dựng dịch vụ nghiệp vụ chính, quản lý DI/IoC container. |
| **Bảo Mật & Phân Quyền**| Spring Security 6.x, JWT | Xác thực Stateless API với JWT và Session-based cho Web Admin. Phân quyền 5 vai trò (*Admin, Manager, Barista, Shipper, Customer*). |
| **Tầng Dữ Liệu** | Spring Data JPA, Hibernate, HikariCP | Ánh xạ ORM, quản lý giao dịch (@Transactional), tối ưu Connection Pool. |
| **Cơ Sở Dữ Liệu** | PostgreSQL 16 / MySQL 8.x | Lưu trữ quan hệ 32 bảng, hỗ trợ JSONB cấu hình topping và Full-Text Search. |
| **Giao Diện Frontend** | JSP/JSTL, SiteMesh 3, Bootstrap 5.3 | Kiến trúc Decorator Pattern nhất quán Header/Footer, giao diện Responsive chuẩn mobile-first. |
| **Truyền Thông Realtime** | Spring WebSocket, STOMP over SockJS | Đẩy dữ liệu thời gian thực cho Barista KDS và Stepper giao hàng. |
| **Lưu Trữ Hình Ảnh** | Cloudinary Java SDK v1.36+ | Upload, nén ảnh thông minh, phân phối CDN cho menu đồ uống và avatar. |
| **Biểu Đồ Thống Kê** | Chart.js 4.x | Trực quan hóa doanh thu, xu hướng đặt hàng, thống kê Top đồ uống bán chạy. |
| **Build Tool** | Apache Maven 3.9+ | Quản lý phụ thuộc và đóng gói ứng dụng (.jar / .war). |

---

## 🏛 Kiến Trúc Cơ Sở Dữ Liệu (32 Bảng Chuẩn Hóa)

Cơ sở dữ liệu được thiết kế theo chuẩn dạng chuẩn 3NF, phân tách thành 6 phân hệ logic:

```
[1. Người Dùng & Phân Quyền]
  ├── users (Tài khoản, thông tin cá nhân, hạng thành viên)
  ├── roles (Vai trò hệ thống: ADMIN, STORE_MANAGER, BARISTA, SHIPPER, CUSTOMER)
  ├── user_roles (Bảng liên kết n-n)
  └── user_addresses (Sổ địa chỉ nhận hàng)

[2. Chuỗi Cửa Hàng & Tồn Kho]
  ├── stores (Thông tin chi nhánh, tọa độ Lat/Long, hotline, giờ mở cửa)
  ├── store_tables (Danh sách bàn tại quán, khu vực)
  ├── ingredients (Danh mục nguyên vật liệu: trà, cà phê hạt, sữa, siro)
  ├── store_inventory (Tồn kho nguyên liệu tại từng chi nhánh)
  └── inventory_logs (Nhật ký nhập/xuất/hao hụt nguyên liệu)

[3. Danh Mục Sản Phẩm & Định Lượng]
  ├── categories (Danh mục: Cà phê, Trà trái cây, Trà sữa, Bánh ngọt, Cà phê gói)
  ├── products (Sản phẩm đồ uống/bánh ngọt)
  ├── product_sizes (Các size S, M, L và giá chênh lệch)
  ├── toppings (Danh mục topping và đơn giá)
  ├── product_toppings (Quy định topping áp dụng cho từng món)
  └── recipes (Công thức định lượng nguyên liệu cho từng ly đồ uống)

[4. Đơn Hàng & Vận Hành]
  ├── orders (Đơn hàng: kênh đặt, phương thức nhận, trạng thái, tổng tiền)
  ├── order_items (Chi tiết từng ly: size, mức đường, mức đá, ghi chú)
  ├── order_item_toppings (Topping đi kèm từng ly)
  ├── order_trackings (Lịch sử thay đổi trạng thái đơn hàng: PENDING -> PREPARING -> COMPLETED)
  └── table_reservations (Phiếu đặt bàn trước tại cửa hàng)

[5. Khuyến Mãi & Hội Viên]
  ├── loyalty_cards (Thẻ tích điểm, số bean tích lũy)
  ├── loyalty_transactions (Lịch sử cộng/trừ điểm bean)
  ├── coupons (Mã giảm giá, chương trình khuyến mãi, Happy Hour, BOGO)
  └── user_coupons (Ví voucher riêng của khách hàng)

[6. Thanh Toán & Giám Sát]
  ├── payments (Giao dịch thanh toán: COD, VNPay, MoMo, VietQR)
  ├── refunds (Lịch sử hoàn tiền khi hủy đơn)
  ├── reviews (Đánh giá 1-5 sao, nhận xét, ảnh Cloudinary)
  └── audit_logs (Nhật ký hệ thống: IP, người thực hiện, thao tác nhạy cảm)
```

---

## 📁 Cấu Trúc Thư Mục Dự Án

```
UTECoffe/
├── 01_Tai_Lieu_Bao_Cao_Word/          # Bộ 13 tài liệu báo cáo đồ án (.docx)
│   ├── 00_Bao_Cao_Tong_Hop_Toan_Bo_Do_An_UTECOFFE.docx   # Báo cáo tổng thể toàn diện đề tài
│   ├── 01_Khao_Sat_Thuc_Te_Cac_Chuoi_FNB.docx            # Khảo sát thực tế thị trường F&B
│   ├── 02_Phan_Tich_Nghiep_Vu_Va_65_Quy_Tac_BR.docx      # 65 Quy tắc nghiệp vụ (BR-01 -> BR-65)
│   ├── 03_Thiet_Ke_Kien_Truc_CSDL_32_Bang_Va_API.docx    # Thiết kế CSDL 32 bảng & REST API
│   ├── 04_Ke_Hoach_WBS_33_Goi_Va_Tien_Do_24_Tuan.docx    # Phân rã WBS 33 gói & tiến độ 24 tuần
│   ├── 05_Ke_Hoach_Kiem_Thu_Chat_Luong_191_TC.docx       # Kế hoạch 191 Test Cases kiểm thử
│   ├── 06_Nhat_Ky_Ra_Soat_Va_Quan_Ly_Quyet_Dinh.docx     # Lịch sử quyết định kiến trúc (ADR)
│   ├── 07_Doi_Chieu_12_Tieu_Chi_De_Bai_Va_Cong_Nghe.docx # Đối chiếu 12 tiêu chí đề bài bắt buộc
│   ├── 08_Dac_Ta_Chi_Tiet_41_Luong_Nghiep_Vu_UC.docx     # Đặc tả 41 Ca sử dụng (Use Cases)
│   ├── 09_Hop_Dong_Du_Lieu_Lenh_Va_Van_Hanh_He_Thong.docx# Event payload, WebSocket topics, SLA
│   ├── 10_Ma_Tran_Truy_Vet_158_Chuc_Nang_F.docx          # Ma trận 158 chức năng chi tiết
│   ├── 11_Quy_Chuan_Logo_Va_Nhan_Dien_Thuong_Hieu.docx   # Thuyết minh ý nghĩa & quy tắc logo
│   └── 12_Bao_Cao_Giai_Phap_Nghiep_Vu_FNB_Thuc_Te.docx   # Giải pháp 6 kịch bản biên thực tế
│
├── 02_Tai_Lieu_Nguon_Markdown_Backup/ # Bộ tài liệu Markdown đồng bộ 1-1
│   ├── 01-KHAO-SAT-CHUOI-TRA-CA-PHE.md
│   ├── 02-PHAN-TICH-NGHIEP-VU-UTECOFFE.md
│   ├── ...
│   └── 12-BAO-CAO-GIAI-PHAP-NGHIEP-VU-FNB-THUC-TE.md
│
├── 03_Thiet_Ke_Thuong_Hieu_Logo/       # Bộ nhận diện logo Vector SVG & PNG
│   ├── logo_chinh_ngang.png / .svg    # Logo Master chiều ngang (Header Navbar)
│   ├── logo_chinh_doc.png / .svg      # Logo Master chiều dọc (Login / Poster)
│   ├── logo_bieu_tuong_app_icon_512.png / .svg # App Icon PWA / Mobile
│   ├── favicon.ico, favicon_*.png     # Favicon trình duyệt đa phân giải
│   ├── Ban_Phan_Tich_Y_Nghia_Logo_UTECOFFE.docx
│   └── Ban_Phan_Tich_Y_Nghia_Logo_UTECOFFE.html
│
├── README_HUONG_DAN_TRA_CUU.txt       # Sơ đồ điều hướng tổng thể
└── README.md                          # Tài liệu giới thiệu dự án trên GitHub
```

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Thử (Getting Started)

### 1. Yêu Cầu Môi Trường (Prerequisites)
- **Java Development Kit (JDK):** Version 17 hoặc 21 (Eclipse Temurin / Oracle OpenJDK).
- **Cơ sở dữ liệu:** PostgreSQL 15+ (hoặc MySQL 8.0+).
- **Build Tool:** Maven 3.8+ (hoặc dùng wrapper `mvnw`).
- **Trình duyệt khuyến nghị:** Google Chrome, Microsoft Edge, Mozilla Firefox phiên bản mới nhất.

### 2. Clone Mã Nguồn
```bash
git clone https://github.com/JiaysTM17/UTECOFFE.git
cd UTECoffe
```

### 3. Cấu Hình Biến Môi Trường (`application.yml` hoặc `application.properties`)
Tạo hoặc chỉnh sửa file `src/main/resources/application.properties`:
```properties
# Server Configuration
server.port=8080
server.servlet.context-path=/

# Database Configuration (PostgreSQL)
spring.datasource.url=jdbc:postgresql://localhost:5432/utecoffe_db
spring.datasource.username=postgres
spring.datasource.password=your_password
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect

# Cloudinary Configuration
cloudinary.cloud-name=your_cloud_name
cloudinary.api-key=your_api_key
cloudinary.api-secret=your_api_secret

# JWT Configuration
jwt.secret=9a8b7c6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a0b9c8d7e6f5a4b3c2d1e0f
jwt.expiration-ms=86400000

# VNPay Sandbox Configuration
vnpay.tmn-code=your_tmn_code
vnpay.hash-secret=your_hash_secret
vnpay.pay-url=https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
```

### 4. Khởi Chạy Ứng Dụng
```bash
# Sử dụng Maven Wrapper
./mvnw clean spring-boot:run

# Hoặc trên Windows PowerShell
.\mvnw.cmd clean spring-boot:run
```

Sau khi ứng dụng khởi chạy thành công, truy cập hệ thống tại:
- Cổng khách hàng: `http://localhost:8080/`
- Màn hình Barista KDS: `http://localhost:8080/barista/orders`
- Trang quản trị Admin: `http://localhost:8080/admin/dashboard`

---

## 🎨 Ý Nghĩa Biểu Tượng Thương Hiệu (Brand Identity)

Biểu tượng **The Golden Drop & Camellia Leaf** của UTECoffe mang thông điệp nghệ thuật và kỹ thuật:
- **Giọt tinh hoa chiết xuất (The Essence Drop):** Tượng trưng cho sự chắt lọc tinh túy qua bàn tay nghệ nhân pha chế (Barista Craft).
- **Búp trà non Camellia Sinensis (Mạn trái - Vàng Champagne `#C5A463`):** Đại diện cho hương vị thanh thuần, nguyên liệu tự nhiên của đồi chè Tây Nguyên/Bảo Lộc.
- **Hạt cà phê Arabica rang mộc (Mạn phải - Đen khói Obsidian `#181615`):** Biểu trưng cho sự đậm đà, chiều sâu, tính kiên định và phong cách thưởng thức cà phê nguyên bản.
- **Điểm giao thoa tâm điểm (Diamond Core):** Điểm nhấn hình thoi biểu trưng cho "Tỷ lệ vàng" trong công thức chiết xuất, đồng thời ẩn dụ ngòi bút tri thức kỹ thuật từ mái trường UTE.
- **Dáng chữ "U" âm bản:** Khéo léo tạo hình chữ U đại diện cho thương hiệu UTECoffe.

---

## 👥 Nhóm Thực Hiện & Bản Quyền

- **Tác giả:** Trương Gia Kiệt ([@JiaysTM17](https://github.com/JiaysTM17))
- **Đơn vị:** Khoa Công nghệ Thông tin - Trường Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)
- **Giấy phép:** [MIT License](LICENSE) - Sử dụng phục vụ nghiên cứu học tập và phát triển ứng dụng.

---

<p align="center">
  <em>Đồ án phát triển phần mềm phục vụ môn học Lập trình Web • Năm học 2026</em>
</p>
