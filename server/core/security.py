from passlib.context import CryptContext
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError
from server.db.database import candidate_collection # Import DB của bạn
import os

# Cấu hình (Lấy từ .env nhé)
SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM")

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Token không hợp lệ hoặc đã hết hạn",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        # 1. Giải mã & Kiểm tra hết hạn (Expired)
        # Nếu token hết hạn, hàm jwt.decode sẽ TỰ ĐỘNG bắn lỗi ExpiredSignatureError -> nhảy xuống except
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
            
    except JWTError:
        # Bao gồm cả lỗi hết hạn, lỗi sai chữ ký, lỗi format...
        raise credentials_exception

    # 2. Kiểm tra user có tồn tại trong DB không
    user = candidate_collection.find_one({"email": email})
    if user is None:
        raise credentials_exception
        
    return user # Trả về thông tin người đang login