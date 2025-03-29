from fastapi import FastAPI
from routers.interest_router import interest_router 
from routers.intro_router import intro_router
from routers.recommend_router import recommend_router
import database
import models #database model init
import ai #ai model init

app = FastAPI()

@app.on_event("startup")
def on_startup():
    database.init_engine()

app.include_router(recommend_router, prefix="/api")
app.include_router(intro_router, prefix="/api")
app.include_router(interest_router, prefix="/api")
