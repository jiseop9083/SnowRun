from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import Optional
import databases
import sqlalchemy
from passlib.context import CryptContext
from sqlalchemy import select
from starlette.config import Config

# 데이터베이스 관련 모듈
import mysql.connector
import httpx

config = Config(".env")
DB_USERNAME = config("DB_USERNAME")
DB_PASSWORD = config("DB_PASSWORD")
DB_HOST = config("DB_HOST")
DB_PORT = config("DB_PORT")
DB_NAME = config("DB_NAME")

# FastAPI 앱 인스턴스 생성
app = FastAPI(host='192.249.19.234', port=80)

@app.get("/")
def read_root():
    return {"Hello":"World"}

# 데이터베이스 설정
DATABASE_URL = f"mysql+pymysql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
database = databases.Database(DATABASE_URL)
metadata = sqlalchemy.MetaData()

# 테이블 정의
users = sqlalchemy.Table(
    "users",
    metadata,
    sqlalchemy.Column("user_index", sqlalchemy.Integer, primary_key=True, autoincrement=True),
    sqlalchemy.Column("user_id", sqlalchemy.String(50), unique=True),
    sqlalchemy.Column("hashed_password", sqlalchemy.Text),
)
#ddfdf

max_scores = sqlalchemy.Table(
    "max_scores",
    metadata,
    sqlalchemy.Column("user_index", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("max_score", sqlalchemy.Integer),
)

# SQLAlchemy 엔진 생성 및 테이블 생성
engine = sqlalchemy.create_engine(DATABASE_URL)
metadata.create_all(engine)


# 패스워드 해싱을 위한 컨텍스트
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# # 모델 정의
# class UserCreate(BaseModel):
#     user_id: str
#     password: str

# class UserLogin(BaseModel):
#     user_id: str
#     password: str

# class ScoreUpdate(BaseModel):
#     user_index: int
#     score: int

@app.on_event("startup")
async def startup():
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()

# 1. 회원가입
@app.get("/users/")
async def create_user(user_id: str, password: str):
    hashed_password = pwd_context.hash(password)
    query = users.insert().values(user_id=user_id, hashed_password=hashed_password)
    await database.execute(query)
    return {"user_id": user_id, "password": password}

# 2. 로그인
@app.get("/login/")
async def login(user_id: str, password: str):
    query = select([users.c.user_index]).where(users.c.user_id == user_id)
    user_index = await database.fetch_one(query)
    if not user_index:
        raise HTTPException(status_code=404, detail="User not found")
    return {"user_index": user_index[0]}

# 3. 점수 업데이트
@app.get("/update-score/")
async def update_score(user_index: int, score: int):
    query = select([max_scores.c.max_score]).where(max_scores.c.user_index == user_index)
    current_max_score = await database.fetch_one(query)
    if current_max_score is None or score > current_max_score[0]:
        update_query = max_scores.update().where(max_scores.c.user_index == user_index).values(max_score=score)
        await database.execute(update_query)
        return {"user_index": user_index, "new_max_score": score}