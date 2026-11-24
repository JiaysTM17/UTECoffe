# 🌐 HƯỚNG DẪN TRIỂN KHAI WEBSITE UTECOFFE CHẠY 24/7 TRÊN INTERNET
> **Tên miền chính thức:** `https://utecoffe.io.vn`  
> **Nền tảng Cloud khuyến nghị:** Render.com (Có gói Free vĩnh viễn, Tích hợp sẵn PostgreSQL, Tự động cấp SSL HTTPS)  
> **Kho mã nguồn:** [https://github.com/JiaysTM17/UTECoffe](https://github.com/JiaysTM17/UTECoffe)

---

## 🎯 Lợi ích của việc chạy trên Cloud 24/7
1. **Hoạt động liên tục:** Bạn tắt máy tính, gập laptop, đi ngủ hay mất điện thì website vẫn chạy bình thường 24/24.
2. **Tự động cập nhật (CI/CD):** Mỗi khi bạn đẩy code mới lên GitHub (`git push origin main`), máy chủ Cloud sẽ tự động tải về, build lại và cập nhật website sau 1-2 phút.
3. **Chứng chỉ bảo mật SSL miễn phí:** Tự động kích hoạt ổ khóa xanh `https://utecoffe.io.vn` uy tín.
4. **Cơ sở dữ liệu đám mây độc lập:** Dữ liệu sản phẩm, đơn hàng, người dùng được lưu trữ an toàn trên dịch vụ Cloud Database.

---

## 🚀 HƯỚNG DẪN 4 BƯỚC TRIỂN KHAI NHANH TRÊN RENDER (3 PHÚT)

### BƯỚC 1: Đăng nhập Render bằng GitHub
1. Truy cập vào trang chủ Render: **[https://render.com](https://render.com)**.
2. Bấm vào nút **Sign In** (hoặc **Get Started**).
3. Chọn đăng nhập bằng **GitHub** (sử dụng tài khoản GitHub `JiaysTM17` của bạn).

---

### BƯỚC 2: Khởi tạo hệ thống từ Blueprint tự động (`render.yaml`)
Trong mã nguồn của dự án đã có sẵn file cấu hình chuẩn **`render.yaml`**. Render sẽ tự động đọc file này để tạo trọn bộ Web + Database chỉ với 1 cú click:
1. Tại màn hình Dashboard của Render, bấm vào nút **New +** (góc trên bên phải) > Chọn **Blueprint**.
2. Tìm và chọn repository **`UTECoffe`** (hoặc `JiaysTM17/UTECoffe`) > Bấm **Connect**.
3. Render sẽ phân tích file `render.yaml` và hiển thị 2 dịch vụ sẽ được tạo tự động:
   - 🐘 **`utecoffe-db`**: Máy chủ cơ sở dữ liệu PostgreSQL 16 (Gói Free).
   - ☕ **`utecoffe-platform`**: Máy chủ web Spring Boot Java 21 chạy qua Dockerfile (Gói Free).
4. Bấm nút **Apply**.
5. Render sẽ tự động:
   - Khởi tạo Database PostgreSQL.
   - Build mã nguồn Spring Boot bằng Dockerfile tối ưu.
   - Kết nối Database với Web.
   - Khởi chạy ứng dụng và tự động gieo dữ liệu mẫu (thực đơn, cửa hàng, tài khoản admin).
*(Thời gian build lần đầu khoảng 3 – 5 phút, bạn có thể xem trực tiếp nhật ký log trên màn hình).*

---

### BƯỚC 3: Gắn tên miền chính thức `utecoffe.io.vn`
Sau khi Web Service `utecoffe-platform` báo trạng thái **Live** (màu xanh lá):
1. Bấm vào dịch vụ **`utecoffe-platform`** trên Render Dashboard.
2. Ở cột menu bên trái, chọn mục **Settings**.
3. Kéo xuống phần **Custom Domains** > Bấm **Add Custom Domain**.
4. Nhập tên miền của bạn:
   - Nhập `utecoffe.io.vn` > Bấm **Save**.
   - Bấm tiếp **Add Custom Domain** > Nhập `www.utecoffe.io.vn` > Bấm **Save**.
5. Render sẽ hiển thị hướng dẫn cấu hình DNS (ví dụ: Bản ghi CNAME trỏ về `utecoffe-platform.onrender.com` hoặc địa chỉ IP của Render).

---

### BƯỚC 4: Trỏ bản ghi DNS tại nơi bạn mua tên miền
1. Đăng nhập vào trang quản trị nơi bạn đã mua tên miền `utecoffe.io.vn` (như iNET, Mắt Bão, Tenten, PA Việt Nam,...).
2. Vào mục **Quản lý tên miền** > **Cấu hình DNS / Bản ghi DNS**.
3. Thêm các bản ghi theo đúng giá trị Render vừa cung cấp:
   - **Bản ghi 1 (Cho tên miền chính):**
     - Loại (Type): `A` hoặc `CNAME`
     - Tên (Host): `@`
     - Giá trị (Value): Theo Render hướng dẫn (hoặc IP Render cấp)
   - **Bản ghi 2 (Cho www):**
     - Loại (Type): `CNAME`
     - Tên (Host): `www`
     - Giá trị (Value): `utecoffe-platform.onrender.com`
4. Bấm **Lưu**.

---

## 🔒 Kiểm tra hoàn tất
Sau khi DNS cập nhật (thường từ 5 – 15 phút):
- Render sẽ tự động xác minh và kích hoạt chứng chỉ **SSL HTTPS** cho bạn.
- Bạn có thể mở điện thoại hoặc bất kỳ máy tính nào gõ:  
  👉 **`https://utecoffe.io.vn`**  
  Website sẽ luôn luôn sáng đèn 24/7 kể cả khi máy tính cá nhân của bạn đã tắt!
