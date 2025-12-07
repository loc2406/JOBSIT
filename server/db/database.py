# server/db/database.py
from pymongo import MongoClient
import os

MONGO_URI = "mongodb+srv://loc24062003:Nguyen24062003..@cluster0.hmir5fn.mongodb.net/?appName=Cluster0"

client = MongoClient(MONGO_URI)

db = client.jobsit_db

candidate_collection = db.candidates

def candidate_helper(candidate) -> dict:
    return {
        "id": candidate["id"],
        "email": candidate["email"],
        "password": candidate["password"],
        "firstName": candidate["firstName"],
        "lastName": candidate["lastName"],
        "isMale": candidate.get("isMale", False),
        "birthdate": candidate["birthdate"],
        "phone": candidate["phone"],
        "avatar": candidate["avatar"],
        "location": candidate["location"],
        "mailReceive": candidate["mailReceive"],
        "searchable": candidate.get("mailReceive", False),
        "searchable": candidate.get("searchable", True),
        "cv": candidate["cv"],
        "positionDTOs": candidate["positionDTOs"],
        "majorDTOs": candidate["majorDTOs"],
        "scheduleDTOs": candidate["scheduleDTOs"],
        "desiredJob": candidate["desiredJob"],
        "referenceLetter": candidate["referenceLetter"],
        "desiredWorkingProvince": candidate["desiredWorkingProvince"],
        "isActive": candidate.get("isActive", False),
    }