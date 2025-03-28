from fastapi import FastAPI
from routers.recommend_router import router
import database
import models #database model init
import ai #ai model init

app = FastAPI()

@app.on_event("startup")
def on_startup():
    database.init_engine()

app.include_router(router, prefix="/api")
