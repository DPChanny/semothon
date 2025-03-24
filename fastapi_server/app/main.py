from fastapi import FastAPI
from routers.test_router import router

app = FastAPI()

app.include_router(router, prefix="/api")
