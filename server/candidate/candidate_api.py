from datetime import datetime, timedelta
import json
import os
from fastapi import APIRouter, HTTPException, Response, status
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
from jose import jwt

router = APIRouter()

# ==========================================
# DATA MODELS (PYDANTIC)
# ==========================================

# --- CẤU HÌNH TOKEN ---
SECRET_KEY = "0691e8f1cdc9001f3b200fd7628480ac000169dfaa61d9b2e46ac3780405c53d"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 5  # Token chỉ sống 5 phút

class University(BaseModel):
    id: int
    name: str

class Candidate(BaseModel):
    id: int
    email: str
    password: str
    firstName: str
    lastName: str
    gender: bool = False
    birthDay: Optional[str] = None
    phone: str
    avatar: Optional[str] = None
    location: Optional[str] = None
    mailReceive: bool = False
    searchable: bool = False
    university: Optional[University] = None
    cv: Optional[str] = None
    # Dùng List[Dict] vì trong Flutter là List<Map<String, dynamic>>
    positionDTOs: Optional[List[Dict[str, Any]]] = [] 
    majorDTOs: Optional[List[Dict[str, Any]]] = []
    scheduleDTOs: Optional[List[Dict[str, Any]]] = []
    desiredJob: Optional[str] = None
    referenceLetter: Optional[str] = None
    desiredWorkingProvince: Optional[str] = None
    
# --- RESPONSE ---
class LoginResponse(BaseModel):
    statusCode: int
    message: str
    idCandidate: Optional[int] = None # Có thể null nếu đăng nhập lỗi
    token: Optional[str] = None

# --- REQUEST ---

class LoginRequest(BaseModel):
    email: str
    password: str

class RegisterRequest(BaseModel):
    email: str
    password: str
    firstName: str
    lastName: str
    phone: str

# ==========================================
# HÀM HỖ TRỢ
# ==========================================

def create_access_token(data: dict, expires_delta: timedelta):
    to_encode = data.copy()
    expire = datetime.utcnow() + expires_delta
    # Thêm thời gian hết hạn vào token
    to_encode.update({"exp": expire}) 
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def load_candidates_from_json():
    file_path = os.path.join("server", "candidate", "candidates.json")
    if not os.path.exists(file_path):
        return []
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return []

# ==========================================
# CÁC API ENDPOINTS
# ==========================================

@router.get("/candidates", response_model=List[Candidate])
def get_all_candidates():
    candidates = load_candidates_from_json()
    return candidates

@router.post("/auth/login", response_model=LoginResponse)
def login(data: LoginRequest, response: Response): # Thêm tham số response để set HTTP status
    candidates = load_candidates_from_json()
    candidate = next((c for c in candidates if c["email"] == data.email), None)

    # 1. Check User tồn tại
    if not candidate:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="Tài khoản không tồn tại!"
        )

    # 2. Check Password
    if str(candidate["password"]) != data.password:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, 
            detail="Mật khẩu không chính xác!"
        )

    # 3. Thành công
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": candidate["email"], "id": candidate["id"]},
        expires_delta=access_token_expires
    )
    
    return LoginResponse(
        statusCode=200,
        message="Đăng nhập thành công!",
        idCandidate=candidate["id"],
        token=access_token
    )

@router.get("/candidates/{candidate_id}", response_model=Candidate)
def get_candidate_detail(candidate_id: int):
    # 1. Load danh sách
    candidates = load_candidates_from_json()
    
    # 2. Tìm candidate có id trùng khớp
    # Hàm next() sẽ trả về phần tử đầu tiên thỏa điều kiện
    candidate = next((c for c in candidates if c["id"] == candidate_id), None)
    
    # 3. Nếu không tìm thấy -> Trả về lỗi 404
    if not candidate:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="Không tìm thấy ứng viên có ID: {candidate_id}!"
        )
    
    return candidate