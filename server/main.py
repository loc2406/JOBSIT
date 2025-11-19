from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from server.candidate import candidate_api
from server.job import job_api

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Gắn các router vào app chính
app.include_router(candidate_api.router)
app.include_router(job_api.router)

@app.get("/")
def root():
    return {"message": "Server đang chạy!"}