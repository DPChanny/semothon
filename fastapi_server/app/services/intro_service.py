from requests import Session

from models.user import User
from ai.service.intro import intro

def intro_service(request, db: Session):
    user = db.query(User).filter(User.user_id == request.user_id).first()


    interests = ["디자인학과", "강아지", "해커톤"]

    return {
        "success": True,
        "message": "intro successfully generated",
        "intro": intro(interests)
    }
