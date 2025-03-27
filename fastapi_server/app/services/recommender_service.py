from models.user import User, user_to_dict
from models.group import Group, group_to_dict

from fastapi import HTTPException

from ai.service.recommend import recommend

def recommend_service(request, db):
    user = db.query(User).filter(User.user_id == request.user_id).first()
    groups = db.query(Group).all()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    return recommend(user_to_dict(user), [group_to_dict(group) for group in groups])