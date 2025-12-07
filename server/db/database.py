# server/db/database.py
from pymongo import MongoClient
import os
from dotenv import load_dotenv

load_dotenv()

MONGO_URI = os.getenv("MONGO_URI")

client = MongoClient(MONGO_URI)

db = client.jobsit_db

candidate_collection = db.candidates

def candidate_helper(candidate) -> dict:
    return {
        "id": candidate["id"],
        "email": candidate["email"],
        "firstName": candidate["firstName"],
        "lastName": candidate["lastName"],
        "isMale": candidate.get("isMale", False),
        "birthdate": candidate["birthdate"],
        "phone": candidate["phone"],
        "avatar": candidate["avatar"],
        "location": candidate["location"],
        "mailReceive": candidate.get("mailReceive", False),
        "searchable": candidate.get("searchable", True),
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