from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from dto.intro_dto import IntroRequestDTO, IntroResponseDTO
from services.intro_service import intro_service

intro_router = APIRouter()

@intro_router.post("/ai/intro", response_model=IntroResponseDTO)
def recommend_room_by_user_route(
    request: IntroRequestDTO,
    db: Session = Depends(get_db)):
        return intro_service(request, db)