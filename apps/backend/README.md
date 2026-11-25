# UTECoffe Backend (Render Core Engine)

Hệ thống Core Backend xử lý nghiệp vụ thương mại điện tử, cơ sở dữ liệu và quản trị cho **UTECoffe Specialty Tea & Coffee Roastery**.

## 🛠️ Công nghệ sử dụng
- **Ngôn ngữ & Nền tảng:** Java 21, Spring Boot 3
- **Giao diện:** Spring MVC + JavaServer Pages (JSP) + SiteMesh 3 Decorators (được bảo tồn nguyên vẹn 100%)
- **Cơ sở dữ liệu:** PostgreSQL 16 (Render Managed Database / Supabase)
- **Bảo mật:** Spring Security, BCrypt, JWT, Session Cookie HttpOnly/SameSite/Secure
- **Môi trường triển khai:** Docker Container (Render Web Service)

## 🐳 Docker Deployment
Ứng dụng được đóng gói và nạp thông qua exploded WAR trên Java 21 Temurin runtime, khởi động cực nhanh và tối ưu RAM dưới 512MB trên Render Free tier.
