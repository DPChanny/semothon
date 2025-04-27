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

@crawling_router.get("/api/wevity")
def get_wevity_data(db: Session = Depends(get_db)):
    base_url = 'https://www.wevity.com/?c=find&s=1&gub=1'
    success_count = 0  # 성공적으로 저장된 활동 수

    try:
        for page in range(2, 10):  # 2~9 페이지까지
            url = f"{base_url}&gp={page}"
            activities = get_activities(url)

            if not activities:
                logging.info("페이지 %d에 크롤링 데이터가 없습니다.", page)
                continue

            logging.info("페이지 %d에서 %d개의 활동 수집", page, len(activities))

            for activity in activities:
                title = activity.get("title")
                url_val = activity.get("url")
                image_url = activity.get("image_url")
                description = activity.get("description")

                if not all([title, url_val, image_url, description]):
                    logging.warning("필수 정보 누락된 activity 스킵: %s", activity)
                    continue

                if db.query(Crawling).filter(Crawling.url == url_val).first():
                    logging.info("이미 존재하는 URL입니다: %s", url_val)
                    continue

                new_crawling = Crawling(
                    crawled_at=datetime.now(),
                    title=title,
                    url=url_val,
                    image_url=image_url,
                    description=description
                )
                db.add(new_crawling)
                db.commit()
                db.refresh(new_crawling)
                success_count += 1

                # 관심사 태깅 & 추천 로직 실행
                crawling_interest_service(new_crawling.crawling_id, db)
                recommend_crawling_by_crawling_service(new_crawling.crawling_id, db)

        return {"message": f"2~9페이지 크롤링 및 저장 완료 (총 {success_count}건 저장됨)"}

    except Exception as e:
        db.rollback()
        logging.error("DB 저장 에러: %s", e)
        raise HTTPException(status_code=500, detail=f"DB 저장 중 오류 발생: {e}")