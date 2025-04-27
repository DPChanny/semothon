# not used but neccesary
import ai
import custom_descripable_encoder

import models 

from fastapi import FastAPI
from routers.interest_router import interest_router
from routers.intro_router import intro_router
from routers.recommend_router import recommend_router
from routers.crawling_router import crawling_router
import database

app = FastAPI()

@app.on_event("startup")
def on_startup():
    database.init_engine()

app.include_router(recommend_router, prefix="/api")
app.include_router(intro_router, prefix="/api")
app.include_router(interest_router, prefix="/api")
app.include_router(crawling_router, prefix='/api')
