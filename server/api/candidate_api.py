from datetime import datetime, timedelta
import json
import os
import re
from fastapi import APIRouter, HTTPException, Response, status
from pydantic import BaseModel, Field, field_validator
from typing import List, Optional, Dict, Any
from jose import jwt

from server.core.security import get_password_hash, verify_password
from server.db.json_manager import read_candidates, save_candidates

router = APIRouter()

# ==========================================
# DATA MODELS (PYDANTIC)
# ==========================================

# --- CẤU HÌNH TOKEN ---
SECRET_KEY = "0691e8f1cdc9001f3b200fd7628480ac000169dfaa61d9b2e46ac3780405c53d"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

class University(BaseModel):
    id: int
    name: str

class Candidate(BaseModel):
    id: int
    email: str
    password: str
    firstName: str
    lastName: str
    isMale: bool = False
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
    isActive: bool = False
    
# --- RESPONSE ---
class LoginResponse(BaseModel):
    token: str
    data: Candidate

class RegisterResponse(BaseModel):
    id: int
    email: str
    full_name: str
    is_active: bool

# --- REQUEST ---

class LoginRequest(BaseModel):
    email: str
    password: str

class RegisterRequest(BaseModel):
    # 1. EMAIL
    # Validate: Min 6, Max 256, Regex Email chuẩn
    email: str = Field(
        ..., 
        min_length=6, 
        max_length=256,
        pattern=r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
        description="Email người dùng"
    )

    # 2. PASSWORD
    # Validate: Min 6, Max 32. Logic phức tạp (UpperCase, Number) sẽ dùng validator riêng
    password: str = Field(..., min_length=6, max_length=32)

    # 3. FIRST NAME
    # Validate: Min 2, Max 32
    first_name: str = Field(..., alias="firstName", min_length=2, max_length=32)

    # 4. LAST NAME
    # Validate: Min 2, Max 32
    last_name: str = Field(..., alias="lastName", min_length=2, max_length=32)

    # 5. PHONE
    # Validate: Min 8, Max 13, Regex VN Phone
    # Regex: Bắt đầu bằng 84 hoặc 03,05,07,08,09. Sau đó là 6-11 số.
    phone: str = Field(
        ..., 
        min_length=8, 
        max_length=13,
        pattern=r"^(84|0[35789])\d{6,11}$"
    )

    # Cấu hình để nhận JSON từ Flutter gửi lên dạng camelCase (firstName) 
    # nhưng trong Python vẫn dùng snake_case (first_name)
    class Config:
        populate_by_name = True

    @field_validator('password')
    @classmethod
    def validate_password_complexity(cls, v: str) -> str:
        # Check chữ in hoa (A-Z)
        if not re.search(r'[A-Z]', v):
            raise ValueError('Mật khẩu nên chứa ít nhất 1 ký tự in hoa.')
        
        # Check số (0-9)
        if not re.search(r'[0-9]', v):
            raise ValueError('Mật khẩu nên chứa ít nhất 1 chữ số.')
        
        return v

    @field_validator('first_name', 'last_name')
    @classmethod
    def validate_no_trailing_space(cls, v: str) -> str:
        # Check không được kết thúc bằng khoảng trắng
        if v.endswith(' '):
                raise ValueError('Tên không được kết thúc bằng dấu cách.')
        return v

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

# ==========================================
# CÁC API ENDPOINTS
# ==========================================

@router.get("/candidates", response_model=List[Candidate])
def get_all_candidates():
    candidates = read_candidates()
    return candidates

@router.get("/candidates/{candidate_id}", response_model=Candidate)
def get_candidate_detail(candidate_id: int):
    # 1. Load danh sách
    candidates = read_candidates()
    
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

@router.post("/auth/login", response_model=LoginResponse)
def login(data: LoginRequest): # Thêm tham số response để set HTTP status
    candidates = read_candidates()
    candidate = next((c for c in candidates if c["email"] == data.email), None)

    # 1. Check User tồn tại
    if not candidate:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="Tài khoản không tồn tại!"
        )

    is_password_correct = False

    print(f"Pass gửi lên:  '{data.password}' (Độ dài: {len(data.password)})")
    print(f"Hash trong DB: '{candidate['password']}'")

    try:
        is_password_correct = verify_password(data.password, candidate["password"])
        print(f"Kết quả verify_password: {is_password_correct}")
    except Exception as e:
        print(f"Lỗi thư viện mã hóa: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Lỗi server khi mã hóa mật khẩu"
        )

    if not is_password_correct:
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
        token=access_token,
        data=candidate 
    )

@router.post("/auth/register", response_model=RegisterResponse, status_code=201)
def register(candidate: RegisterRequest):
    candidates = read_candidates()

    # Duyệt qua list users xem có email nào trùng không
    for c in candidates:
        if c['email'] == candidate.email:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Email này đã được sử dụng."
            )
        
        # Nếu muốn check phone trùng thì thêm if ở đây
        if c['phone'] == candidate.phone:
             raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Số điện thoại này đã được sử dụng."
            )

    # 3. Hash Password
    hashed_password = get_password_hash(candidate.password)

    # 4. Tạo User mới (Dạng Dictionary vì JSON lưu dict)
    new_candidate_id = len(candidates) + 1 # Tự tăng ID đơn giản
    
    # Dùng by_alias=True để key trong dict là 'firstName' thay vì 'first_name'
    # Điều này giúp đồng bộ với Candidate Model và Flutter
    new_candidate_dict = candidate.model_dump(by_alias=True)
    
    # Ghi đè các trường cần xử lý server-side
    new_candidate_dict['id'] = new_candidate_id
    new_candidate_dict['password'] = hashed_password # Lưu pass đã hash, không lưu pass gốc
    new_candidate_dict['isActive'] = False

    # Các trường mặc định khác của Candidate nếu chưa có
    new_candidate_dict['isMale'] = False
    new_candidate_dict['mailReceive'] = False
    new_candidate_dict['searchable'] = False

    new_candidate_dict['birthDay'] = None   
    new_candidate_dict['avatar'] = None
    new_candidate_dict['location'] = None   
    new_candidate_dict['university'] = None
    new_candidate_dict['cv'] = None
    new_candidate_dict['desiredJob'] = None

    new_candidate_dict['positionDTOs'] = []
    new_candidate_dict['majorDTOs'] = []
    new_candidate_dict['scheduleDTOs'] = []

    new_candidate_dict['referenceLetter'] = ""
    new_candidate_dict['desiredWorkingProvince'] = ""

    # 5. Lưu vào file
    candidates.append(new_candidate_dict)
    save_candidates(candidates)

    full_name = f"{candidate.last_name} {candidate.first_name}"

    # 6. Trả về kết quả
    return RegisterResponse(
        id= new_candidate_dict['id'],
        email=new_candidate_dict['email'],
        full_name=full_name,
        is_active=new_candidate_dict['isActive']
    )