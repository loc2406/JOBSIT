# main.py
import math
from fastapi import FastAPI, HTTPException, Query, Response
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import json
from typing import List

app = FastAPI(title="Job API", version="1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Cho phép mọi nguồn (bạn có thể thay bằng domain Flutter)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/favicon.ico")
def ignore_favicon():
    return Response(status_code=204)  # Không log lỗi, không trả nội dung

# Model định nghĩa job (nếu muốn validate chi tiết)
class Job(BaseModel):
    id: int
    title: str
    description: str
    companyDTO: dict
    positionDTOS: List[dict]
    scheduleDTOS: List[dict]
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
    with open("data.json", "r", encoding="utf-8") as f:
        jobs_data = json.load(f)
except FileNotFoundError:
    jobs_data = []
    print("⚠️ Không tìm thấy file data.json — danh sách rỗng.")


@app.get("/")
def root():
    return {"message": "Job API is running!"}


# Lấy danh sách công việc với phân trang, "ge"= 1 là giá trị tối thiểu, "le"= 50 là giá trị tối đa
# Giá trị mặc định: page=1, size=5
@app.get("/jobs")
def get_jobs(page: int = Query(1, ge=1), limit: int = Query(5, ge=1, le=50)):
    total_jobs = len(jobs_data)
    total_pages = math.ceil(total_jobs / limit)

    if page > total_pages:
        return JSONResponse(
            status_code=404,
            content={"error": "Trang không tồn tại"}
        )

    start = (page - 1) * limit
    end = start + limit
    data = jobs_data[start:end]

    return {
        "page": page,
        "limit": limit,
        "total_jobs": total_jobs,
        "total_pages": total_pages,
        "jobs": data
    }


@app.get("/jobs/{job_id}", response_model=Job)
def get_job(job_id: int):
    """Lấy thông tin chi tiết 1 công việc theo id."""
    for job in jobs_data:
        if job["id"] == job_id:
            return job
    raise HTTPException(status_code=404, detail="Job not found")


@app.post("/jobs", response_model=Job)
def add_job(job: Job):
    """Thêm một công việc mới vào danh sách."""
    jobs_data.append(job.dict())
    with open("data.json", "w", encoding="utf-8") as f:
        json.dump(jobs_data, f, ensure_ascii=False, indent=2)
    return job
