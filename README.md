# JobSIT Mobile - Ứng Dụng Tìm Việc Làm

Ứng dụng mobile được xây dựng với **Flutter** cho phép người dùng tìm kiếm, xem chi tiết, ứng tuyển và lưu các công việc. Kết hợp với backend **FastAPI**, ứng dụng cung cấp trải nghiệm tìm việc hiện đại và tiện lợi.

## 📋 Mục lục

- [Giới thiệu](#giới-thiệu)
- [Tính năng chính](#tính-năng-chính)
- [Công nghệ sử dụng](#công-nghệ-sử-dụng)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Hướng dẫn cài đặt](#hướng-dẫn-cài-đặt)
- [Cách chạy ứng dụng](#cách-chạy-ứng-dụng)
- [Kiến trúc ứng dụng](#kiến-trúc-ứng-dụng)
- [API Endpoints](#api-endpoints)

## 🎯 Giới thiệu

**JobSIT Mobile** là một nền tảng tìm kiếm việc làm hiện đại giúp ứng viên kết nối với các cơ hội việc làm phù hợp. Ứng dụng được thiết kế với giao diện thân thiện, hỗ trợ đa ngôn ngữ (Tiếng Anh & Tiếng Việt), và tối ưu hóa cho trải nghiệm người dùng.

## ✨ Tính năng chính

- 🔐 **Đăng nhập/Đăng ký**: Quản lý tài khoản ứng viên
- 🔍 **Tìm kiếm việc làm**: Duyệt các công việc với bộ lọc chi tiết
- 📄 **Xem chi tiết công việc**: Thông tin chi tiết, mô tả vị trí, yêu cầu
- ✅ **Ứng tuyển**: Nộp hồ sơ cho các công việc mong muốn
- ❤️ **Lưu việc làm**: Lưu công việc yêu thích để xem lại sau
- 📝 **Quản lý ứng tuyển**: Xem danh sách những công việc đã ứng tuyển
- 🌍 **Đa ngôn ngữ**: Hỗ trợ Tiếng Anh và Tiếng Việt

## 🛠️ Công nghệ sử dụng

### Frontend

- **Flutter 3.4.1+**: Framework UI đa nền tảng
- **Dart**: Ngôn ngữ lập trình
- **BLoC/Cubit**: Quản lý trạng thái
- **Go Router**: Điều hướng và routing

### Backend

- **FastAPI**: Framework web Python hiệu suất cao
- **Python 3.8+**: Ngôn ngữ lập trình backend

### Libraries & Packages

**Flutter:**

- `flutter_bloc` (^9.0.0): Quản lý trạng thái
- `dio` (^4.0.6): HTTP client
- `go_router` (^17.0.0): Routing
- `easy_localization` (^3.0.8): Đa ngôn ngữ
- `shared_preferences` (^2.5.2): Lưu trữ dữ liệu cục bộ
- `image_picker` (^1.0.4): Chọn ảnh
- `file_picker` (^9.0.2): Chọn file
- `flutter_pdfview` (^1.2.7): Xem PDF
- `jwt_decoder` (^2.0.1): Giải mã JWT tokens
- `flutter_svg` (^2.0.17): Hỗ trợ SVG
- `flutter_secure_storage` (^9.2.4): Lưu trữ an toàn

**Backend:**

- `FastAPI`: Web framework
- `Uvicorn`: ASGI server

## 📁 Cấu trúc dự án

```
jobsit_mobile/
│
├── lib/
│   ├── core/                           # Các thành phần dùng chung (Shared Kernel)
│   │   ├── constants/                  # Hằng số (API Url, Asset path)
│   │   ├── error/                      # Định nghĩa Failure và Exception chung
│   │   ├── network/                    # Cấu hình Dio, NetworkInfo
│   │   ├── usecases/                   # Class UseCase cơ sở (Base UseCase)
│   │   ├── utils/                      # Helper, Extensions, Validations
│   │   └── services/                   # Service độc lập (Storage, Firebase...)
│   │
│   ├── features/                       
│   │   ├── auth/                       # Ví dụ tính năng Auth
│   │   │   ├── data/                   # LAYER DỮ LIỆU
│   │   │   │   ├── datasources/        # Gọi API hoặc Local DB (Remote/Local)
│   │   │   │   ├── models/             # DTO (Data Transfer Object) - extends Entity
│   │   │   │   └── repositories/       # Triển khai (Implement) Repository của Domain
│   │   │   │
│   │   │   ├── domain/                 
│   │   │   │   ├── entities/           # Object thuần túy (Enterprise Business Rules)
│   │   │   │   ├── repositories/       # Interface (Hợp đồng) Repository
│   │   │   │   └── usecases/           # Logic nghiệp vụ cụ thể (Login, Logout...)
│   │   │   │
│   │   │   └── presentation/           
│   │   │       ├── cubit/              # Quản lý State (AuthCubit)
│   │   │       ├── pages/              # Màn hình (Screen)
│   │   │       └── widgets/            # Widget con của màn hình này
│   │   │
│   │   └── home/                       # Tính năng Home (Cấu trúc tương tự Auth)
│   │
│   ├── config/                         # Cấu hình App (Theme, Router)
│   ├── injection_container.dart        # Setup Dependency Injection (GetIt)
│   └── main.dart                       # Entry point
│
├── server/                        # Backend FastAPI
│   ├── main.py                    # Entry point backend
│   ├── candidate/                 # Module quản lý ứng viên
│   │   └── candidate_api.py
│   ├── job/                       # Module quản lý công việc
│   │   └── job_api.py
│   ├── run_server.bat             # Script chạy server
│   └── run_app.bat                # Script chạy app
│
├── assets/                        # Tài nguyên
│   ├── images/                    # Hình ảnh, icon
│   └── translations/              # File dịch ngôn ngữ
│
├── android/                       # Native Android code
├── ios/                           # Native iOS code
├── windows/                       # Native Windows code
├── web/                           # Web version
│
├── pubspec.yaml                   # Flutter dependencies
├── analysis_options.yaml          # Lint rules
└── README.md                      # File này
```

## 🚀 Hướng dẫn cài đặt

### Yêu cầu hệ thống

**Frontend:**

- Flutter SDK 3.4.1 trở lên
- Dart 3.4.1+
- Android SDK hoặc Xcode (tùy nền tảng)
- Device hoặc emulator

**Backend:**

- Python 3.8+
- pip (package manager Python)

### Cài đặt Frontend

1. **Clone repository:**

```bash
git clone <repository-url>
cd jobsit_mobile
```

2. **Cài đặt dependencies:**

```bash
flutter pub get
```

3. **Kiểm tra cài đặt:**

```bash
flutter doctor
```

## 🎮 Cách chạy ứng dụng

### Chạy Backend

**Option 1: Sử dụng script Windows**

```bash
cd server
run_server.bat
```

**Option 2: Chạy trực tiếp**

```bash
cd server
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Backend sẽ chạy tại: `http://localhost:8000`

### Chạy Frontend

**Option 1: Trên Android Emulator/Device**

```bash
flutter run -d <device-id>
```

**Option 2: Trên iOS Simulator (macOS)**

```bash
flutter run -d iphone
```

**Option 3: Trên Web**

```bash
flutter run -d chrome
```

**Option 4: Trên Windows**

```bash
flutter run -d windows
```

**Listing các devices sẵn có:**

```bash
flutter devices
```

## 🏗️ Kiến trúc ứng dụng

### Kiến trúc Clean Architecture với BLoC/Cubit

Ứng dụng tuân theo nguyên tắc Clean Architecture:

```
Presentation Layer (UI)
    ↓
Business Logic Layer (Cubit/BLoC)
    ↓
Domain Layer (Repository)
    ↓
Data Layer (DataSource)
    ↓
External Layer (API/Database)
```

### Luồng dữ liệu

1. **UI Layer**: Hiển thị dữ liệu và nhận input từ người dùng
2. **Cubit/BLoC**: Xử lý business logic, quản lý trạng thái
3. **Repository**: Abstraction, kết hợp data từ nhiều source
4. **DataSource**: Gọi API, lấy dữ liệu từ storage
5. **External Services**: FastAPI backend, local storage

### State Management

Ứng dụng sử dụng **BLoC/Cubit** pattern:

- **CandidateCubit**: Quản lý thông tin ứng viên, đăng nhập
- **JobCubit**: Quản lý danh sách công việc
- **SavedJobCubit**: Quản lý công việc đã lưu
- **AppliedJobCubit**: Quản lý đơn ứng tuyển

## 📡 API Endpoints

### Backend FastAPI Endpoints

**Candidate (Ứng viên)**

```
GET    /candidates              - Lấy danh sách ứng viên
POST   /candidates              - Tạo ứng viên mới
GET    /candidates/{id}         - Lấy chi tiết ứng viên
PUT    /candidates/{id}         - Cập nhật thông tin ứng viên
```

**Job (Công việc)**

```
GET    /jobs                    - Lấy danh sách công việc
POST   /jobs                    - Tạo công việc mới
GET    /jobs/{id}               - Lấy chi tiết công việc
```

**Base URL:** `http://localhost:8000`

## 📝 Các features chính

### 1. Authentication (Auth Feature)

- Đăng nhập, đăng ký với email/password
- Lưu JWT token
- Xác thực request API

### 2. Jobs Discovery (Jobs Feature)

- Danh sách công việc với phân trang
- Tìm kiếm công việc
- Lọc theo tiêu chí (nơi làm việc, vị trí công việc, hình thức công việc, chuyên ngành)
- Xem chi tiết công việc

### 3. Saved Jobs (Saved Jobs Feature)

- Lưu công việc yêu thích
- Xem danh sách công việc đã lưu
- Xóa công việc từ danh sách yêu thích

### 4. Applied Jobs (Applied Jobs Feature)

- Ứng tuyển công việc
- Xem danh sách công việc đã ứng tuyển
- Thay đổi trạng thái ứng tuyển

## 🌐 Đa ngôn ngữ (i18n)

Ứng dụng hỗ trợ:

- 🇻🇳 Tiếng Việt (vi)
- 🇺🇸 Tiếng Anh (en)

Các file dịch được lưu trong: `assets/translations/`

## 🔒 Bảo mật

- JWT token authentication
- Secure storage cho sensitive data
- CORS policy trên backend
- Input validation

## 📦 Build & Release

### APK (Android)

```bash
flutter build apk --release
```

**Version**: 1.0.0  
**Last Updated**: November 2025  
**Status**: Active Development 🚀
