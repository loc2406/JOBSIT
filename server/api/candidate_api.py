from datetime import datetime, timedelta
import json
import os
import re
from fastapi import APIRouter, Depends, HTTPException, Response, status
from pydantic import BaseModel, Field, field_validator
from typing import List, Optional, Dict, Any
from jose import jwt

from server.core.security import get_current_user, get_password_hash, verify_password
from server.db.database import candidate_collection, university_collection,candidate_helper
from dotenv import load_dotenv

load_dotenv()

router = APIRouter()

# ==========================================
# DATA MODELS (PYDANTIC)
# ==========================================

# --- CẤU HÌNH TOKEN ---
SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES"))

class University(BaseModel):
    id: str
    name: str
    code: str
    city: str

    class Config:
        # Cho phép Pydantic làm việc với kiểu dữ liệu không phải dict (như Object từ MongoDB)
        populate_by_name = True

class Candidate(BaseModel):
    id: int
    email: str
    firstName: str
    lastName: str
    isMale: bool = False
    birthdate: Optional[str] = None
    phone: str
    avatar: Optional[str] = None
    location: Optional[str] = None
    mailReceive: bool = False
    searchable: bool = False
    university: Optional[University] = None
    cv: Optional[str] = None
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
    firstName: str
    lastName: str
    phone: str
    isActive: bool

# --- REQUEST ---

class LoginRequest(BaseModel):
    email: str
    password: str

class RegisterRequest(BaseModel):
    email: str = Field(
        ..., 
        min_length=6, 
        max_length=256,
        pattern=r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
        description="Email người dùng"
    )

    password: str = Field(..., min_length=6, max_length=32)

    firstName: str = Field(..., min_length=2, max_length=32)

    lastName: str = Field(..., min_length=2, max_length=32)

    phone: str = Field(
        ..., 
        min_length=8, 
        max_length=13,
        pattern=r"^(84|0[35789])\d{6,11}$"
    )

    @field_validator('password')
    @classmethod
    def validate_password_complexity(cls, v: str) -> str:
        
        if not re.search(r'[A-Z]', v):
            raise ValueError('Mật khẩu nên chứa ít nhất 1 ký tự in hoa!')
        
        if not re.search(r'[0-9]', v):
            raise ValueError('Mật khẩu nên chứa ít nhất 1 chữ số!')
        
        return v

    @field_validator('firstName', 'lastName')
    @classmethod
    def validate_no_trailing_space(cls, v: str) -> str:
        if v.endswith(' '):
                raise ValueError('Tên không được kết thúc bằng dấu cách!')
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

@router.get("/candidates/{candidateId}", response_model=Candidate)
def get_candidate_detail(candidateId: int, current_user: dict = Depends(get_current_user)):
    if current_user["id"] != candidateId:
        raise HTTPException(status_code=403, detail="Bạn không có quyền xem hồ sơ người khác")
    
    candidate = candidate_collection.find_one({"id": candidateId})
    
    if not candidate:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="Không tìm thấy ứng viên có ID: {candidate_id}!"
        )
    
    return candidate_helper(candidate)

@router.post("/auth/login", response_model=LoginResponse)
def login(data: LoginRequest):
    candidate = candidate_collection.find_one({"email": data.email})

    if not candidate:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="Tài khoản không tồn tại!"
        )

    is_password_correct = False

    try:
        is_password_correct = verify_password(data.password, candidate["password"])
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
    
    if candidate.get("isActive") is False:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email!"
        )

    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": candidate["email"], "id": candidate["id"]},
        expires_delta=access_token_expires
    )
    
    return LoginResponse(
        token=access_token,
        data=candidate_helper(candidate)
    )

@router.post("/auth/register", response_model=RegisterResponse, status_code=201)
def register(candidate: RegisterRequest):

    if candidate_collection.find_one({"email": candidate.email}):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email này đã được sử dụng!"
        )
    
    if candidate_collection.find_one({"phone": candidate.phone}):
            raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Số điện thoại này đã được sử dụng!"
        )

    hashed_password = get_password_hash(candidate.password)

    last_candidate = candidate_collection.find_one(sort=[("id", -1)])
    new_id = 1
    if last_candidate:
        new_id = last_candidate["id"] + 1
    
    new_candidate_dict = candidate.model_dump(by_alias=True)
    
    new_candidate_dict['id'] = new_id
    new_candidate_dict['password'] = hashed_password
    new_candidate_dict['isActive'] = False

    new_candidate_dict['isMale'] = False
    new_candidate_dict['mailReceive'] = False
    new_candidate_dict['searchable'] = False

    new_candidate_dict['birthDay'] = None   
    new_candidate_dict['avatar'] = None
    new_candidate_dict['location'] = None   
    new_candidate_dict['university'] = None
    new_candidate_dict['cv'] = None
    new_candidate_dict['desiredJob'] = None
    new_candidate_dict['referenceLetter'] = None
    new_candidate_dict['desiredWorkingProvince'] = None

    new_candidate_dict['positionDTOs'] = []
    new_candidate_dict['majorDTOs'] = []
    new_candidate_dict['scheduleDTOs'] = []

    candidate_collection.insert_one(new_candidate_dict)

    return RegisterResponse(
        id= new_candidate_dict['id'],
        email=new_candidate_dict['email'],
        firstName=new_candidate_dict['firstName'],
        lastName=new_candidate_dict['lastName'],
        phone=new_candidate_dict['phone'],
        isActive=new_candidate_dict['isActive']
    )

@router.get("/universities", response_model=List[University])
def get_universities(current_user: dict = Depends(get_current_user)):
    universities = list(
        university_collection.find({}, {"_id": 0}).limit(100)
    )
    return universities