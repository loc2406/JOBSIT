@echo off

echo ======= CLEAN APP =======
call flutter clean

echo ======= DOWNLOAD DEPENDENCIES =======
call flutter pub get

echo ======= KHOI DONG APP =======
call flutter run

pause
