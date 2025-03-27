from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dto.recommender_dto import RecommendRequestDTO
from database import get_db
from ai.service.train_recommender import train_recommender
from models.user import User
from models.group import Group
from ai.service.recommend import recommend

router = APIRouter()

def user_to_dict(user):
    gender_map = {
        "MALE": "남자",
        "FEMALE": "여자"
    }

    return {
        "intro": user.intro_text,
        "departments": user.department.split(",") if user.department else [],
        "yob": user.birthdate.year if user.birthdate else None,
        "student_id": int(user.student_id[:4]) if user.student_id and len(user.student_id) >= 4 else None,
        "gender": gender_map.get(user.gender.value if user.gender else None),
        "user_id": user.user_id
    }

def group_to_dict(group: Group) -> dict:
    return {
        "group_id": str(group.room_id),
        "description": group.description
    }

@router.post("/ai/recommend")
def recommend_route(
    request: RecommendRequestDTO,
    db: Session = Depends(get_db)):

    user = db.query(User).filter(User.user_id == request.user_id).first()
    groups = db.query(Group).all()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    return recommend(user_to_dict(user), [group_to_dict(group) for group in groups])

# @router.post("/ai/train_recommender")
# def train_recommender_route(db: Session = Depends(get_db)):
#     user = db.query(User).filter(User.user_id == request.user_id).first()
#     groups = db.query(Group).all()

#     if not user:
#         raise HTTPException(status_code=404, detail="User not found")

#     train_recommender(user_to_dict(user), [group_to_dict(group) for group in groups], )

# not used currently