@echo off
chcp 65001 >nul
title UTECoffe - Khởi Chạy Website Ra Internet Toàn Cầu
cd /d "%~dp0"

echo ===============================================================================
echo            UTECOFFE ROASTERY - KẾT NỐI WEBSITE RA INTERNET TOÀN CẦU
echo ===============================================================================
echo.
echo Hệ thống đang kiểm tra dịch vụ máy chủ UTECoffe...

set PROJECT_DIR=D:\A - Học Tập\Lập Trình Web\Đ.Án
set CLOUDFLARED_EXE=%PROJECT_DIR%\tools\cloudflared.exe

if not exist "%CLOUDFLARED_EXE%" (
    echo [ERROR] Không tìm thấy công cụ cloudflared tại: %CLOUDFLARED_EXE%
    pause
    exit /b
)

echo.
echo ===============================================================================
echo BẠN MUỐN CHẠY THEO HÌNH THỨC NÀO?
echo ===============================================================================
echo  [1] Chạy NGAY LẬP TỨC ra Internet (Miễn phí, có HTTPS, xem được trên điện thoại ngay)
echo  [2] Kết nối tên miền chính thức utecoffe.io.vn qua Cloudflare Tunnel Token
echo  [3] Thoát
echo ===============================================================================
set /p opt="Vui lòng chọn (1 hoặc 2): "

if "%opt%"=="1" (
    echo.
    echo -------------------------------------------------------------------------------
    echo Đang tạo đường dẫn Internet HTTPS toàn cầu...
    echo Vui lòng đợi trong giây lát...
    echo -------------------------------------------------------------------------------
    "%CLOUDFLARED_EXE%" tunnel --url http://localhost:8080
    pause
    exit /b
)

if "%opt%"=="2" (
    echo.
    echo -------------------------------------------------------------------------------
    echo HƯỚNG DẪN KẾT NỐI TÊN MIỀN utecoffe.io.vn:
    echo 1. Vào https://dash.cloudflare.com tạo một Tunnel miễn phí tên là: utecoffe
    echo 2. Chọn Public Hostname: utecoffe.io.vn -> Trỏ vào: http://localhost:8080
    echo 3. Cloudflare sẽ cấp cho bạn một chuỗi TOKEN dài dạng: eyJh...
    echo -------------------------------------------------------------------------------
    set /p mytoken="Dán chuỗi Cloudflare Tunnel Token của bạn vào đây: "
    if not "%mytoken%"=="" (
        echo Đang kết nối tên miền utecoffe.io.vn...
        "%CLOUDFLARED_EXE%" tunnel run --token %mytoken%
    ) else (
        echo Bạn chưa nhập token!
    )
    pause
    exit /b
)

exit /b
