from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from dto.recommender_dto import RecommendRequestDTO
from database import get_db
from services.recommender_service import recommend_service

router = APIRouter()

@router.post("/ai/recommend")
def recommend_route(
    request: RecommendRequestDTO,
    db: Session = Depends(get_db)):
        return recommend_service(request, db)

# @router.post("/ai/train_recommender")
# def train_recommender_route(db: Session = Depends(get_db)):
#     user = db.query(User).filter(User.user_id == request.user_id).first()
#     groups = db.query(Group).all()

#     if not user:
#         raise HTTPException(status_code=404, detail="User not found")

#     train_recommender(user_to_dict(user), [group_to_dict(group) for group in groups], )

# not used currently