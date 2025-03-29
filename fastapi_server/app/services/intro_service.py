from requests import Session

from models.user import User
from ai.service.intro import intro

def intro_service(request, db: Session):
    user: User = db.query(User).filter(User.user_id == request.user_id).first()

    interests = [user_interest.interest.name for user_interest in user.user_interests]

    return {
        "success": True,
        "message": "intro successfully generated",
        "intro": intro(interests)
    }
