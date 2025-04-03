from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db, engine, Base
from models.crawling import Crawling
from sevices.crawling_service import get_activities

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
            new_crawling = Crawling(
                title=activity.get("title", "제목 없음"),
                url=activity.get("url", "URL 없음"),
                image_url=activity.get("image_url", "이미지 없음"),
                description=activity.get("description", "상세 내용 없음")
            )
            db.add(new_crawling)
        db.commit()
    except Exception as e:
        db.rollback()
        logging.error("DB 저장 에러: %s", e)
        raise HTTPException(status_code=500, detail=f"DB 저장 중 오류 발생: {e}")
    return activities



@crawling_router.get("/crawlings", response_model=List[dict])
def read_crawlings(db: Session = Depends(get_db)):
    crawlings = db.query(Crawling).all()
    return [{
        "crawling_id": crawling.crawling_id,
        "title": crawling.title,
        "url": crawling.url,
        "image_url": crawling.image_url,
        "description": crawling.description
    } for crawling in crawlings]

@crawling_router.post("/wevity/test-insert")
def insert_dummy_crawling_data(db: Session = Depends(get_db)):
    dummy_data = [
        {
            "title": "테스트 공모전 A",
            "url": "https://www.wevity.com/test/a",
            "image_url": "https://www.wevity.com/images/a.jpg",
            "description": "이것은 테스트용 공모전 A의 설명입니다."
        },
        {
            "title": "테스트 공모전 B",
            "url": "https://www.wevity.com/test/b",
            "image_url": "https://www.wevity.com/images/b.jpg",
            "description": "이것은 테스트용 공모전 B의 설명입니다."
        },
        {
            "title": "테스트 공모전 C",
            "url": "https://www.wevity.com/test/c",
            "image_url": "https://www.wevity.com/images/c.jpg",
            "description": "이것은 테스트용 공모전 C의 설명입니다."
        }
    ]

    result = []
    for item in dummy_data:
        # 중복 방지: URL 기준
        existing = db.query(Crawling).filter(Crawling.url == item["url"]).first()
        if existing:
            continue

        crawling = Crawling(
            title=item["title"],
            url=item["url"],
            image_url=item["image_url"],
            description=item["description"]
        )
        db.add(crawling)
        result.append(item)

    try:
        db.commit()
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"DB 저장 중 오류 발생: {e}")

    return {"success": True, "inserted": result}
