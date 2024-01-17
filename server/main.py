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

# 0. 회원가입 시 가입 안 된 user_id인지 확인
@app.get("/new_user/")
async def check_newUser(user_id: str):
    # 데이터베이스에서 user_id가 존재하는지 확인합니다.
    query = users.select().where(users.c.user_id == user_id)
    existing_user = await database.fetch_one(query)
    # 이미 존재하는 user_id라면 False를 반환하고 회원가입을 중단합니다.
    if existing_user:
        return False
    else: return True

# 1. 회원가입
@app.get("/users/")
async def create_user(user_id: str, password: str):
    hashed_password = pwd_context.hash(password)
    query = users.insert().values(user_id=user_id, hashed_password=hashed_password)
    # 데이터베이스에 사용자를 추가합니다.
    await database.execute(query)

     # 삽입된 자동 증가된 user_index를 얻기 위해 별도의 쿼리를 실행합니다.
    select_query = users.select().where(users.c.user_id == user_id)
    user = await database.fetch_one(select_query)

    return {"user_index": user[0]}

# 2. 로그인
@app.get("/login/")
async def login(user_id: str, password: str):
    # hashed_password = pwd_context.hash(password)
    # query = select([users.c.user_index]).where(users.c.user_id == user_id)
    # user_index = await database.fetch_one(query)
    # print("user_index:")
    # print(user_index)
    # if not user_index:
    #     # raise HTTPException(status_code=404, detail="User not found")
    #     return False
    # elif user_index[2] == hashed_password :

    #     return {"user_index": user_index[0]}
    # else : return False
    # 사용자 정보를 데이터베이스에서 검색합니다.
    query = select([users]).where(users.c.user_id == user_id)
    user = await database.fetch_one(query)

    # 사용자가 존재하지 않는 경우
    if not user:
        return False

    # 데이터베이스에 저장된 해시된 비밀번호를 가져옵니다.
    stored_hashed_password = user["hashed_password"]

    # 입력된 비밀번호와 데이터베이스에 저장된 해시된 비밀번호를 비교합니다.
    if pwd_context.verify(password, stored_hashed_password):
        # 비밀번호가 일치하면 user_index를 반환합니다.
        return {"user_index": user["user_index"]}
    else:
        # 비밀번호가 일치하지 않으면 False를 반환합니다.
        return False

# 3. 점수 업데이트
@app.get("/update-score/")
async def update_score(user_index: int, score: int):
    query = select([max_scores.c.max_score]).where(max_scores.c.user_index == user_index)
    current_max_score = await database.fetch_one(query)
    if current_max_score is None or score > current_max_score[0]:
        update_query = max_scores.update().where(max_scores.c.user_index == user_index).values(max_score=score)
        await database.execute(update_query)
    # 업데이트된 점수 또는 현재 점수를 반환합니다.
    return {"score": score}

# 4. 전체 기록
@app.get("/get-scores/")
async def get_scores():
    query = max_scores.select().with_only_columns([max_scores.c.user_id, max_scores.c.hashed_password])
    results = await database.fetch_all(query)
    return [(result["user_id"], result["hashed_password"]) for result in results]
