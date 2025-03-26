from fastapi import FastAPI
from routers.recommender_router import router
import database
import models

app = FastAPI()

@app.on_event("startup")
def on_startup():
    database.init_engine()

app.include_router(router, prefix="/api")
