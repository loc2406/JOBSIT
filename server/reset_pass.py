from core.security import get_password_hash

# Tạo hash mới chuẩn chỉ từ chính thư viện của dự án
new_hash = get_password_hash("123456")
print("Copy chuỗi này vào file JSON:")
print(new_hash)