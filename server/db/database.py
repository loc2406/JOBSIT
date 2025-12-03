# server/db/database.py
from pymongo import MongoClient
import os

MONGO_URI = "mongodb+srv://admin:Nguyen24062003..@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority"

client = MongoClient(MONGO_URI)

# Tạo database tên là "jobsit_db"
db = client.jobsit_db

# Tạo collection (giống bảng/table) tên là "candidates"
candidate_collection = db.candidates

# Hàm hỗ trợ chuyển đổi dữ liệu từ Mongo về Python dict chuẩn
def candidate_helper(candidate) -> dict:
    return {
        "id": candidate["id"],
        "email": candidate["email"],
        "firstName": candidate["firstName"],
        "lastName": candidate["lastName"],
        "isMale": candidate["isMale"],
        "birthdate": candidate["birthdate"],
        "phone": candidate["phone"],
        "avatar": candidate["avatar"],
        "location": candidate["location"],
        "mailReceive": candidate["mailReceive"],
        "searchable": candidate["searchable"],
        "university": candidate["university"],
        "cv": candidate["cv"],
        "positionDTOs": candidate["positionDTOs"],
        "majorDTOs": candidate["majorDTOs"],
        "scheduleDTOs": candidate["scheduleDTOs"],
        "desiredJob": candidate["desiredJob"],
        "referenceLetter": candidate["referenceLetter"],
        "desiredWorkingProvince": candidate["desiredWorkingProvince"],
        "isActive": candidate.get("isActive", False),
    }