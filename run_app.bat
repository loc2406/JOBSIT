@echo off
echo ======= CLEAN APP =======
flutter clean
echo ======= DOWNLOAD DEPENDENCIES =======
flutter pub get
echo ======= KHOI DONG APP =======
@REM flutter devices
@REM flutter run -d 192.168.2.1:40919 --- Chạy trên thiết bị cụ thể
flutter run