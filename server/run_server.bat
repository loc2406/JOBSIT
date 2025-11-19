@echo off
echo ======= KHOI DONG FASTAPI BACKEND =======
@REM cd /d "C:\Users\ADMIN\AndroidStudioProjects\jobsit_mobile\lib"
@REM echo ---- Cai thu vien ----
@REM 1) FastAPI:
@REM call pip install fastapi uvicorn
@REM 2) Tạo token:
@REM call pip install python-jose
@REM call pip install python-jose passlib
echo ---- Chay server ----
@REM Cho phép truy cập từ mọi địa chỉ IP
call uvicorn server.main:app --reload --host 0.0.0.0 --port 8000
echo ======= KET THUC =======
pause