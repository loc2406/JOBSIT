# server/db/database.py
from pymongo import MongoClient
import os

MONGO_URI = "mongodb+srv://loc24062003:Nguyen24062003..@cluster0.hmir5fn.mongodb.net/?appName=Cluster0"

client = MongoClient(MONGO_URI)

# Send a ping to confirm a successful connection
try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)

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