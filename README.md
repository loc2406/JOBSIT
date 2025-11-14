lib/
│
├── main.dart                     # Entry point
│
├── app/                          # Cấu hình app, router, theme
│   ├── router.dart                # Quản lý routes
│   └── theme.dart                 # Theme, style chung
│
├── core/                         # Các tiện ích dùng chung
│   ├── constants/                 # Hằng số, enums
│   ├── utils/                     # Hàm tiện ích, helper
│   ├── network/                   # HTTP client, API service
│   └── error/                     # Xử lý lỗi, exception
│
├── data/                         # Lớp liên quan đến dữ liệu
│   ├── models/                    # Các model (User, Job,...)
│   ├── repositories/              # Repository: abstraction giữa Cubit và DataSource
│   └── datasources/               # API, local DB, shared prefs
│
├── features/                     # Các tính năng riêng biệt
│   ├── feature1/
│   │   ├── cubit/                 # Cubit và State của feature
│   │   │   ├── feature1_cubit.dart
│   │   │   └── feature1_state.dart
│   │   ├── views/                 # UI widget riêng của feature
│   │   │   ├── feature1_screen.dart
│   │   │   └── widgets/           # Widget con
│   │   └── repository/            # Repository riêng nếu cần
│   │
│   └── feature2/                  # Tương tự feature1
│       ├── cubit/
│       ├── views/
│       └── repository/
│
└── shared/                        # Widget dùng chung
    ├── widgets/                   # Button, TextField, Card,...
    └── extensions/                # Extension methods, theme extensions
