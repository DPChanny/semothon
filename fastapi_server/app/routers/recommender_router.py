from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from dto.recommend_room_dto import RecommendRoomRequestDTO
from database import get_db
from services.recommender_service import recommend_service

router = APIRouter()

@router.post("/ai/recommend")
def recommend_route(
    request: RecommendRoomRequestDTO,
    db: Session = Depends(get_db)):
        return recommend_service(request, db)

# @router.post("/ai/train_recommender")
# def train_recommender_route(db: Session = Depends(get_db)):
#     user = db.query(User).filter(User.user_id == request.user_id).first()
#     rooms = db.query(Room).all()

#     if not user:
#         raise HTTPException(status_code=404, detail="User not found")

#     train_recommender(user_to_dict(user), [room_to_dict(room) for room in rooms], )

# not used currently