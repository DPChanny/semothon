from typing import List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models.crawling import Crawling
from services.crawling_service import get_activities
import logging
from datetime import datetime
from services.interest_service import crawling_interest_service
from services.recommend_crawling_service import recommend_crawling_by_crawling_service

crawling_router = APIRouter()

@crawling_router.get("/wevity/{page}")
def get_wevity_data(page: int, db: Session = Depends(get_db)):
    base_url = 'https://www.wevity.com/?c=find&s=1&gub=1'
    url = f"{base_url}&spage={page}"
    activities = get_activities(url)
    if not activities:
        raise HTTPException(status_code=404, detail="크롤링된 데이터가 없습니다.")

    logging.info("크롤링된 데이터: %s", activities)

    try:
        for activity in activities:
            if db.query(Crawling).filter(Crawling.url == activity.get("url", "URL 없음")).first() is not None:
                continue
            new_crawling = Crawling(
                crawled_at=datetime.now(),
                title=activity.get("title", "제목 없음"),
                url=activity.get("url", "URL 없음"),
                image_url=activity.get("image_url", "이미지 없음"),
                description=activity.get("description", "상세 내용 없음")
            )
            db.add(new_crawling)

            db.commit()
            db.refresh(new_crawling)

            print(new_crawling.crawling_id)

            crawling_interest_service(new_crawling.crawling_id, db)
            recommend_crawling_by_crawling_service(new_crawling.crawling_id, db)

    except Exception as e:
        db.rollback()
        logging.error("DB 저장 에러: %s", e)
        raise HTTPException(status_code=500, detail=f"DB 저장 중 오류 발생: {e}")