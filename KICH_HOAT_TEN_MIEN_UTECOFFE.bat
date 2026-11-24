@echo off
chcp 65001 >nul
title Kích Hoạt Tên Miền utecoffe.io.vn Trên Máy Tính

:: Kiểm tra và yêu cầu quyền Administrator tự động
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ======================================================================
    echo  YÊU CẦU QUYỀN ADMINISTRATOR ĐỂ CẤU HÌNH TÊN MIỀN utecoffe.io.vn
    echo  Hệ thống đang mở cửa sổ cấp quyền UAC, vui lòng bấm [YES] hoặc [CÓ]...
    echo ======================================================================
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ======================================================================
echo     ĐANG KÍCH HOẠT TÊN MIỀN: utecoffe.io.vn TRÊN MÁY TÍNH CỦA BẠN
echo ======================================================================
echo.

:: 1. Thêm utecoffe.io.vn vào C:\Windows\System32\drivers\etc\hosts
set HOSTS_FILE=%SystemRoot%\System32\drivers\etc\hosts
findstr /i "utecoffe.io.vn" "%HOSTS_FILE%" >nul
if %errorLevel% neq 0 (
    echo [1/3] Đang thêm bản ghi utecoffe.io.vn vào file hosts...
    echo. >> "%HOSTS_FILE%"
    echo 127.0.0.1 utecoffe.io.vn >> "%HOSTS_FILE%"
    echo 127.0.0.1 www.utecoffe.io.vn >> "%HOSTS_FILE%"
    echo       -> Đã thêm thành công!
) else (
    echo [1/3] Tên miền utecoffe.io.vn đã có sẵn trong file hosts.
)

:: 2. Cấu hình chuyển tiếp Port 80 (HTTP) -> Port 8080 (Spring Boot)
echo [2/3] Đang cấu hình chuyển tiếp Port 80 về Port 8080...
netsh interface portproxy delete v4tov4 listenport=80 listenaddress=127.0.0.1 >nul 2>&1
netsh interface portproxy add v4tov4 listenport=80 listenaddress=127.0.0.1 connectport=8080 connectaddress=127.0.0.1
echo       -> Đã cấu hình Port 80 xong! Bạn có thể truy cập không cần gõ :8080

:: 3. Làm mới bộ nhớ đệm DNS
echo [3/3] Đang làm mới bộ nhớ đệm DNS (ipconfig /flushdns)...
ipconfig /flushdns >nul
echo       -> Đã làm mới DNS thành công!

echo.
echo ======================================================================
echo    KÍCH HOẠT THÀNH CÔNG! BÂY GIỜ BẠN CÓ THỂ MỞ TRÌNH DUYỆT VÀ TRUY CẬP:
echo.
echo    -> http://utecoffe.io.vn
echo    -> http://utecoffe.io.vn:8080
echo ======================================================================
echo.
pause
