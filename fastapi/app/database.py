from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from config import MYSQL_HOST, MYSQL_DATABASE, MYSQL_PASSWORD, MYSQL_PORT, MYSQL_USER
from tenacity import retry, wait_fixed, stop_after_attempt, before_log
import logging

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

MYSQL_URL = f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DATABASE}"

@retry(
    stop=stop_after_attempt(20),
    wait=wait_fixed(5),
    before=before_log(logger, logging.INFO)
)
def get_engine():
    engine = create_engine(
                MYSQL_URL,
                pool_timeout=3,
                pool_pre_ping=True,
                future=True,
                echo=True
            )
    with engine.connect() as conn:
        logger.info("connect success")
    return engine

engine = None
SessionLocal = None
Base = declarative_base()

def init_engine():
    global engine, SessionLocal
    engine = get_engine()
    SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False, future=True)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()