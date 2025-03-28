from models.user import User, user_to_dict
from models.crawling_data import CrawlingData, crawling_to_dict

from sqlalchemy.orm import Session
from fastapi import HTTPException

from ai.service.recommend import recommend
from models.user_crawling_recommendation import UserCrawlingRecommendation

def process_db(db: Session, recommendations):
    for recommend in recommendations:
        existing = db.query(UserCrawlingRecommendation).filter_by(
            user_id=recommend["user_id"],
            crawling_id=recommend["crawling_id"]
        ).first()

        if existing:
            existing.score = recommend["score"]
        else:
            new_entry = UserCrawlingRecommendation(
                user_id=recommend["user_id"],
                crawling_id=recommend["crawling_id"],
                score=recommend["score"]
            )
            db.add(new_entry)

    db.commit()

def recommend_crawling_by_user_service(request, db: Session):
    user = db.query(User).filter(User.user_id == request.user_id).first()
    crawlings = db.query(CrawlingData).all()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    process_db(db, recommend([user_to_dict(user)], 
                             [crawling_to_dict(crawling) for crawling in crawlings]))

    return {
        "success": True,
        "message": "recommend score successfully processed to all crawlings"
    }


def recommend_crawling_by_crawling_service(request, db: Session):
    users = db.query(User).all()
    crawling = db.query(CrawlingData).filter(CrawlingData.crawling_id == request.crawling_id).first()

    if not crawling:
        raise HTTPException(status_code=404, detail="Crawling not found")
    
    process_db(db, recommend([user_to_dict(user) for user in users], 
                             [crawling_to_dict(crawling)]))

    return {
        "success": True,
        "message": "recommend score successfully processed to all users"
    }
