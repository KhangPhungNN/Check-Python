@echo off
setlocal enabledelayedexpansion

REM Kiểm tra sự tồn tại của Python bằng cách chạy lệnh "python --version"
python --version >nul 2>&1
if !errorlevel! neq 0 (
    REM Nếu lệnh trên báo lỗi (errorlevel khác 0), thì thông báo cho người dùng và mở trang web tải Python
    echo Python is not installed on this computer.
    echo Please download and install Python from https://www.python.org/downloads/
    start "" "https://www.python.org/downloads/"
    goto :eof
)

REM Khai báo danh sách các thư viện cần kiểm tra
set "libraries=[LIB]"

REM Tạo một file tạm thời chứa danh sách các thư viện cần cài đặt
set "temp_file=%temp%\missing_libraries.txt"
if exist "!temp_file!" del "!temp_file!"

REM Duyệt qua từng thư viện trong danh sách
for %%a in (%libraries%) do (
    REM Kiểm tra sự tồn tại của thư viện bằng cách chạy đoạn code Python "import [tên thư viện]"
    python -c "import %%a" >nul 2>&1
    REM Nếu lệnh trên báo lỗi (errorlevel khác 0), thì thêm tên thư viện vào file tạm thời
    if !errorlevel! neq 0 (
        echo %%a>>"!temp_file!"
    )
)

REM Nếu file tạm thời không tồn tại hoặc rỗng, thì không cần cài đặt thêm thư viện nào
if not exist "!temp_file!" goto :skip_install_libraries

REM Cài đặt các thư viện được liệt kê trong file tạm thời
echo Installing missing libraries...
python -m pip install -r "!temp_file!"

:skip_install_libraries
REM Xóa file tạm thời
if exist "!temp_file!" del "!temp_file!"

REM Mở file FlappyPlane.py trong thư mục Scripts tại đường dẫn hiện tại
start "" "%cd%\[File.*]"
