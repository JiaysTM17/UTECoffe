# Chính Sách Bảo Mật (Security Policy)

Hệ thống **UTECoffe Specialty Coffee & Omnichannel Platform** cam kết bảo vệ dữ liệu khách hàng, giao dịch tài chính và hạ tầng máy chủ theo các tiêu chuẩn công nghệ cao nhất.

---

## 1. Các Phiên Bản Được Hỗ Trợ (Supported Versions)

| Phiên Bản | Trạng Thái Hỗ Trợ | Java LTS | Spring Boot |
| :--- | :--- | :--- | :--- |
| `1.0.x-SNAPSHOT` | :white_check_mark: Đang hỗ trợ chính | Java 21 | 3.3.5 |
| `< 1.0.0` | :x: Không còn hỗ trợ | Java 17 | 3.x |

---

## 2. Các Biện Pháp Bảo Mật Đã Triển Khai

1. **Kiểm Soát Tần Suất Truy Cập (Token Bucket Rate Limiting):**
   - Áp dụng trên toàn bộ endpoint nhạy cảm (`/api/auth/login`, `/api/auth/register`) để chống brute-force và DDoS.
2. **Khóa Chống Trùng Lặp (Idempotency Pattern):**
   - Header `Idempotency-Key` với SHA-256 Request Payload Hash bảo vệ đơn hàng và giao dịch thanh toán.
3. **Mã Hóa Mật Khẩu (BCrypt):**
   - Toàn bộ mật khẩu người dùng được băm an toàn qua `BCryptPasswordEncoder` với salt tự động.
4. **Bảo Mật Hai Lớp (Dual Filter Chain):**
   - Stateless JWT Filter cho `/api/**` và Stateful HttpOnly Cookie Session cho `/admin/**` và `/barista/**`.
5. **Nhật Ký Kiểm Toán AOP (Audit Trail):**
   - Mọi hành động tài chính và quản trị đều được ghi vết IP, User Agent, Timestamp và thời gian thực thi.

---

## 3. Báo Cáo Lỗ Hổng Bảo Mật (Reporting a Vulnerability)

Nếu bạn phát hiện bất kỳ lỗ hổng bảo mật nào trong dự án, xin **KHÔNG** mở Issue công khai trên GitHub. Vui lòng gửi email trực tiếp đến ban kỹ thuật:
- **Email:** `security@utecoffe.vn`
- **SLA Phản Hồi:** Trong vòng 24 giờ kể từ khi tiếp nhận thông tin.
