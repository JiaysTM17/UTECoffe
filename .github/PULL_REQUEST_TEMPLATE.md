## Tổng Quan Về Thay Đổi (PR Overview)

### Liên Kết Vấn Đề Liên Quan
Closes # (issue number)

### Loại Thay Đổi
- [ ] 🐛 Sửa lỗi (Bug fix không gây breaking changes)
- [ ] ✨ Tính năng mới (New feature không gây breaking changes)
- [ ] ⚡ Tối ưu thuật toán / hiệu năng (Algorithm / Performance improvement)
- [ ] ♻️ Tái cấu trúc mã nguồn (Refactoring không đổi nghiệp vụ)
- [ ] 📝 Cập nhật tài liệu (Documentation update)
- [ ] 🚨 Thay đổi có khả năng gây lỗi tương thích ngược (Breaking change)

---

### Mô Tả Chi Tiết Thay Đổi
Tóm tắt ngắn gọn các module hoặc file đã được chỉnh sửa và mục đích kỹ thuật.

### Danh Mục Kiểm Tra (Checklist)
- [ ] Mã nguồn tuân thủ quy chuẩn Clean Code & kiến trúc layered của dự án.
- [ ] Đã chạy kiểm thử tự động nội bộ và toàn bộ test case đều vượt qua (`[PASS]`).
- [ ] Không có cảnh báo hoặc lỗi biên dịch mới.
- [ ] Đã cập nhật tài liệu `README.md` nếu có bổ sung API hoặc thuật toán mới.
- [ ] Các migration cơ sở dữ liệu (nếu có) tương thích với cả PostgreSQL và H2.
