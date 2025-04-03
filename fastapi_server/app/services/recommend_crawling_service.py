from models.user import User, user_to_descriptable
from models.crawling import Crawling, crawling_to_descriptable

from sqlalchemy.orm import Session
from fastapi import HTTPException

from ai.service.recommend import recommend
from models.user_crawling_recommendation import UserCrawlingRecommendation
from custom_descripable_encoder import user_descriptable_encoder

def process_db(db: Session, results):
    for result in results:
        existing = db.query(UserCrawlingRecommendation).filter_by(
            user_id=result['target_descriptable'].id,
            crawling_id=result['descriptable'].id
        ).first()

        if existing:
            existing.score = result['score']
        else:
            new_entry = UserCrawlingRecommendation(
                user_id=result['target_descriptable'].id,
                crawling_id=result['descriptable'].id,
                score=result["score"],
                activity_score=result["score"]
            )
            db.add(new_entry)

    db.commit()

def recommend_crawling_by_user_service(request, db: Session):
    user = db.query(User).filter(User.user_id == request.user_id).first()
    crawlings = db.query(Crawling).all()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    process_db(db, recommend([user_to_descriptable(user)], 
                             [crawling_to_descriptable(crawling) for crawling in crawlings],
                             target_desscriptable_encoder=user_descriptable_encoder))

    return {
        "success": True,
        "message": "recommend score successfully processed to all crawlings"
    }


def recommend_crawling_by_crawling_service(crawling_id, db: Session):
    users = db.query(User).filter(User.intro_text.isnot(None)).all()
    crawling = db.query(Crawling).filter(Crawling.crawling_id == crawling_id).first()

    if not crawling:
        raise HTTPException(status_code=404, detail="Crawling not found")
    
    process_db(db, recommend([user_to_descriptable(user) for user in users], 
                             [crawling_to_descriptable(crawling)],
                             target_desscriptable_encoder=user_descriptable_encoder))

    return {
        "success": True,
        "message": "recommend score successfully processed to all users"
    }
