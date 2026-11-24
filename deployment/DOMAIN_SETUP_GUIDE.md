# Hướng Dẫn Cấu Hình Tên Miền Chính Thức: utecoffe.io.vn

Tài liệu này hướng dẫn đầy đủ các bước kết nối tên miền **`utecoffe.io.vn`** vào hệ thống **UTECoffe Platform**.

---

## 1. Cấu Hình Bản Ghi DNS (Domain Name System)
Đăng nhập vào trang quản lý tên miền (nhà cung cấp tên miền hoặc Cloudflare) và thêm các bản ghi sau:

| Loại (Type) | Tên (Host / Name) | Giá Trị (Value / Points to) | TTL | Proxy Status (Cloudflare) |
|-------------|-------------------|-----------------------------|-----|---------------------------|
| **A** | `@` (hoặc `utecoffe.io.vn`) | `<IP_MÁY_CHỦ_VPS>` (Ví dụ: `103.xxx.xxx.xxx`) | Auto / 1 Hour | Proxied (Bật đám mây cam) |
| **CNAME** | `www` | `utecoffe.io.vn` | Auto / 1 Hour | Proxied (Bật đám mây cam) |

> **Khuyến nghị:** Sử dụng Cloudflare làm DNS trung gian để được cấp chứng chỉ SSL miễn phí tự động (Full/Strict SSL), chống DDoS và tăng tốc tải trang toàn cầu.

---

## 2. Cài Đặt Nginx Reverse Proxy & SSL (HTTPS)
Trên máy chủ Linux (Ubuntu/Debian), triển khai file cấu hình Nginx đã tạo tại `deployment/nginx/utecoffe.io.vn.conf`:

```bash
# 1. Cài đặt Nginx & Certbot
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx

# 2. Copy file cấu hình
sudo cp deployment/nginx/utecoffe.io.vn.conf /etc/nginx/sites-available/utecoffe.io.vn.conf
sudo ln -s /etc/nginx/sites-available/utecoffe.io.vn.conf /etc/nginx/sites-enabled/

# 3. Cấp chứng chỉ SSL Let's Encrypt tự động (miễn phí)
sudo certbot --nginx -d utecoffe.io.vn -d www.utecoffe.io.vn

# 4. Kiểm tra cấu hình & Khởi động lại Nginx
sudo nginx -t
sudo systemctl reload nginx
```

---

## 3. Khởi Chạy Ứng Dụng Spring Boot Trên Server
```bash
# Chạy Spring Boot ở chế độ nền (Production profile)
nohup java -jar target/utecoffe-platform-1.0.0-SNAPSHOT.war \
  --spring.profiles.active=prod \
  --server.port=8080 > app.log 2>&1 &
```

---

## 4. Kiểm Tra Tên Miền & Các Dịch Vụ Đi Kèm
- **Trang chủ HTTPS:** `https://utecoffe.io.vn/`
- **Tập tin Robots.txt:** `https://utecoffe.io.vn/robots.txt`
- **Sơ đồ trang web Sitemap:** `https://utecoffe.io.vn/sitemap.xml`
- **Tài liệu API Swagger:** `https://utecoffe.io.vn/swagger-ui.html`
- **Kết nối Real-Time WebSocket:** `wss://utecoffe.io.vn/ws-utecoffe`
