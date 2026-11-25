# UTECoffe Frontend (Vercel Edge Layer)

Tầng Giao diện & Định tuyến Edge tốc độ cao cho hệ sinh thái **UTECoffe Specialty Tea & Coffee Roastery**.

## 🚀 Đặc điểm kỹ thuật
- **Framework:** Next.js 14 (App Router & Edge Rewrites)
- **Tối ưu hóa Vercel Global Edge CDN:** Toàn bộ tài nguyên tĩnh (`/assets/**` - CSS, JS, hình ảnh sản phẩm chất lượng cao, logo) được lưu trữ và phản hồi trực tiếp từ mạng lưới CDN Vercel tại Singapore (`sin1`) với độ trễ siêu thấp (< 15ms).
- **Vercel Cron Keep-Alive:** Tự động gửi tín hiệu "gõ cửa" đến máy chủ backend Render (`/api/keep-alive` -> `/ping`) định kỳ mỗi 10 phút, ngăn chặn hoàn toàn hiện tượng máy chủ Render ngủ đông.
- **Reverse Proxy trong suốt:** Các yêu cầu trang động và API được chuyển tiếp an toàn, trong suốt đến máy chủ Render Backend (`https://utecoffe-platform.onrender.com`), bảo toàn 100% phiên làm việc (Session), Cookie bảo mật và logic JSP.

## 📦 Triển khai lên Vercel
1. Đăng nhập vào [vercel.com](https://vercel.com).
2. Bấm **Add New** -> **Project** -> Chọn kho mã nguồn `UTECoffe`.
3. Trong phần **Project Settings**:
   - **Root Directory:** Chọn `apps/frontend`
   - **Framework Preset:** `Next.js`
4. Biến môi trường (Environment Variables):
   - `BACKEND_URL`: `https://utecoffe-platform.onrender.com`
5. Bấm **Deploy**.
6. Gắn tên miền `utecoffe.io.vn` vào mục **Settings -> Domains** trên Vercel.
