from fastapi import FastAPI
from routers.test_router import router
from database import engine
from sqlalchemy import text

app = FastAPI()

app.include_router(router, prefix="/api")

print("hi")

@app.on_event("startup")
def startup_event():
    print("✅ DB 연결 성공 1 (startup에서)")
    with engine.connect() as conn:
        conn.execute(text("SELECT 1"))
    print("✅ DB 연결 성공 2 (startup에서)")
