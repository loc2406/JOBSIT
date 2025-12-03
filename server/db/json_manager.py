import json
import os

CANDIDATE_FILE = "candidates.json"
CANDIDATE_PATH = os.path.join("server", "data", CANDIDATE_FILE)

def read_candidates():
    """Đọc danh sách user từ file JSON"""
    if not os.path.exists(CANDIDATE_PATH):
        # Nếu file chưa tồn tại, tạo file rỗng và trả về list rỗng
        with open(CANDIDATE_PATH, 'w', encoding="utf-8") as f:
            json.dump([], f)
        return []
    
    try:
        with open(CANDIDATE_PATH, 'r', encoding="utf-8") as f:
            return json.load(f)
    except json.JSONDecodeError:
        return []

def save_candidates(users_list):
    """Ghi đè danh sách user vào file JSON"""
    with open(CANDIDATE_PATH, 'w', encoding="utf-8") as f:
        json.dump(users_list, f, indent=4) # indent=4 để file json đẹp, dễ đọc