from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dto.recommender_dto import RecommendRequestDTO
from database import get_db
from models.user import User
from models.group import Group
import logging

logger = logging.getLogger(__name__)
router = APIRouter()

@router.post("/ai/recommend")
def recommend_groups(
    request: RecommendRequestDTO,
    db: Session = Depends(get_db)):

    logger.info(f"Received user_id: {request.user_id}")

    user = db.query(User).filter(User.user_id == request.user_id).first()
    groups = db.query(Group).all()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    return {"status": "ok"}