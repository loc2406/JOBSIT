# main.py
import math
import os
from fastapi import APIRouter, HTTPException, Query, Response
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import json
from typing import List, Optional  # <-- THÊM OPTIONAL

router = APIRouter()

@router.get("/favicon.ico")
def ignore_favicon():
    return Response(status_code=204)

# Model định nghĩa job (cập nhật thêm majorDTOS)
class Job(BaseModel):
    id: int
    title: str
    description: str
    companyDTO: dict
    positionDTOS: Optional[List[dict]] = None
    scheduleDTOS: Optional[List[dict]] = None
    majorDTOS: Optional[List[dict]] = None 
    amount: int
    postingDate: str
    applicationDeadline: str
    address: str
    district: str
    city: str
    country: str
    minAllowance: float
    maxAllowance: float


# Load data từ file JSON
try:
    file_path = os.path.join("server", "job", "jobs.json")

    with open(file_path, "r", encoding="utf-8") as f:
        jobs_data = json.load(f)
except FileNotFoundError:
    jobs_data = []
    print("⚠️ Không tìm thấy file data.json — danh sách rỗng.")


# Lấy danh sách công việc với phân trang VÀ LỌC
@router.get("/jobs")
def get_jobs(
    # Tham số phân trang
    page: int = Query(1, ge=1),
    limit: int = Query(5, ge=1, le=50),
    # Tham số lọc (mới)
    keyword: Optional[str] = Query(None),
    location: Optional[str] = Query(None),
    scheduleId: Optional[int] = Query(None),
    positionId: Optional[int] = Query(None),
    majorId: Optional[int] = Query(None)
):
    
    # Bắt đầu với toàn bộ danh sách
    filtered_jobs = jobs_data

    # 1. Lọc theo keyword (title hoặc company name)
    if keyword:
        keyword_lower = keyword.lower()
        filtered_jobs = [
            job for job in filtered_jobs
            if keyword_lower in job["title"].lower() or
               keyword_lower in job["companyDTO"]["name"].lower()
        ]

    # 2. Lọc theo location (address, district, city, country)
    if location:
        location_lower = location.lower()
        filtered_jobs = [
            job for job in filtered_jobs
            if location_lower in job["address"].lower() or
               location_lower in job["district"].lower() or
               location_lower in job["city"].lower() or
               location_lower in job["country"].lower()
        ]

    # 3. Lọc theo scheduleId
    if scheduleId:
        filtered_jobs = [
            job for job in filtered_jobs
            # Dùng any() để kiểm tra xem có bất kỳ dict nào trong list có id khớp không
            # Dùng .get() để tránh lỗi nếu 'scheduleDTOS' không tồn tại
            if any(s.get("id") == scheduleId for s in job.get("scheduleDTOS", []))
        ]

    # 4. Lọc theo positionId
    if positionId:
        filtered_jobs = [
            job for job in filtered_jobs
            if any(p.get("id") == positionId for p in job.get("positionDTOS", []))
        ]

    # 5. Lọc theo majorId
    if majorId:
        filtered_jobs = [
            job for job in filtered_jobs
            # .get("majorDTOS", []) đảm bảo nó chạy ngay cả khi job cũ thiếu trường này
            if any(m.get("id") == majorId for m in job.get("majorDTOS", []))
        ]

    # --- PHÂN TRANG (trên danh sách ĐÃ LỌC) ---
    
    # Tính toán dựa trên danh sách đã lọc
    total_jobs = len(filtered_jobs)
    total_pages = math.ceil(total_jobs / limit) if total_jobs > 0 else 1

    # Kiểm tra trang hợp lệ
    if page > total_pages:
        return JSONResponse(
            status_code=404,
            content={"error": "Trang không tồn tại"}
        )

    # Cắt danh sách đã lọc theo trang
    start = (page - 1) * limit
    end = start + limit
    data = filtered_jobs[start:end]

    return {
        "page": page,
        "limit": limit,
        "total_jobs": total_jobs,
        "total_pages": total_pages,
        "jobs": data
    }


@router.get("/jobs/{job_id}", response_model=Job)
def get_job(job_id: int):
    """Lấy thông tin chi tiết 1 công việc theo id."""
    for job in jobs_data:
        if job["id"] == job_id:
            return job
    raise HTTPException(status_code=404, detail="Job not found")


@router.post("/jobs", response_model=Job)
def add_job(job: Job):
    """Thêm một công việc mới vào danh sách."""
    jobs_data.append(job.dict())
    with open("data.json", "w", encoding="utf-8") as f:
        json.dump(jobs_data, f, ensure_ascii=False, indent=2)
    return job