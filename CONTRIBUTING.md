# Quy Chuẩn Đóng Góp Mã Nguồn (Contributing Guidelines)

Chào mừng bạn tham gia phát triển hệ sinh thái **UTECoffe Specialty Coffee & Omnichannel Platform**! Tài liệu này định nghĩa quy chuẩn phát triển phần mềm, quy tắc đặt tên nhánh, commit và quy trình kiểm duyệt (Code Review).

---

## 1. Quy Trình Làm Việc Với Git (Git Workflow)

Dự án áp dụng mô hình **Git Feature Branching**:
- Nhánh `main`: Chứa mã nguồn ổn định nhất, sẵn sàng triển khai môi trường sản xuất (Production).
- Nhánh `develop`: Nhánh tích hợp các tính năng mới trước khi phát hành phiên bản.
- Nhánh tính năng: Tạo từ `develop` theo quy tắc đặt tên:
  - `feat/<tên-tính-năng>` (ví dụ: `feat/taste-profile-matcher`)
  - `fix/<tên-lỗi>` (ví dụ: `fix/kds-timer-leak`)
  - `refactor/<tên-module>` (ví dụ: `refactor/security-filter-chain`)
  - `docs/<tên-tài-liệu>` (ví dụ: `docs/readme-algorithms`)

---

## 2. Quy Chuẩn Commit (Conventional Commits)

Mỗi commit message phải tuân thủ định dạng chuẩn quốc tế:
```
<loại>(<phạm-vi-nếu-có>): <mô tả ngắn bằng tiếng Anh hoặc tiếng Việt rõ ràng>
```

Các loại commit hợp lệ:
- `feat`: Thêm tính năng, thuật toán hoặc endpoint mới.
- `fix`: Sửa lỗi phần mềm.
- `docs`: Cập nhật tài liệu, README, JavaDoc.
- `style`: Định dạng mã nguồn, thụt đầu dòng (không đổi logic nghiệp vụ).
- `refactor`: Tái cấu trúc mã nguồn để tối ưu hiệu năng hoặc độ sạch.
- `perf`: Cải thiện tốc độ thực thi của thuật toán.
- `test`: Thêm hoặc cập nhật test cases tự động.
- `chore`: Nâng cấp dependency, cấu hình build Maven/Docker.

---

## 3. Kiến Trúc Mã Nguồn (Architecture & Clean Code)

Dự án tuân theo chuẩn kiến trúc **Layered Domain-Driven Architecture**:
1. `controller.api`: RESTful Controller trả về định dạng `ApiResponse<T>`.
2. `controller.mvc`: MVC Controller phục vụ giao diện JSP kèm SiteMesh layout.
3. `service`: Interface định nghĩa nghiệp vụ và các thuật toán toán học.
4. `service.impl`: Triển khai nghiệp vụ với Transactional boundaries (`@Transactional`).
5. `repository`: Spring Data JPA Repositories.
6. `entity`: Hibernate JPA Entities với các quan hệ quan sát kỹ lưỡng.
7. `aspect`: Cross-cutting concerns (Audit Log AOP, Idempotency, Rate Limiting).
8. `dto`: Request/Response Data Transfer Objects tách biệt khỏi Entity.

---

## 4. Kiểm Thử Trước Khi Tạo Pull Request

Trước khi gửi PR lên `main` hoặc `develop`, đảm bảo:
```powershell
mvn clean test
```
Toàn bộ các bài kiểm thử thuật toán và bảo mật phải đạt trạng thái **BUILD SUCCESS**.
