@echo off
echo ======= KHOI DONG FASTAPI BACKEND =======
@REM cd /d "C:\Users\ADMIN\AndroidStudioProjects\jobsit_mobile\lib"
@REM echo ---- Cai thu vien ----
@REM pip install fastapi uvicorn
echo ---- Chay server ----
@REM Cho phép truy cập từ mọi địa chỉ IP
uvicorn main:app --host 0.0.0.0 --port 8000
echo ======= KET THUC =======