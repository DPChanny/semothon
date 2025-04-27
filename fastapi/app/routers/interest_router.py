from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from dto.interest_dto import InterestResponseDTO, InterestRoomRequestDTO, InterestUserRequestDTO
from database import get_db
from services.interest_service import user_interest_service, room_interest_service

interest_router = APIRouter()

@interest_router.post("/ai/interest/user", response_model=InterestResponseDTO)
def recommend_room_by_room_route(
    request: InterestUserRequestDTO,
    db: Session = Depends(get_db)):
        return user_interest_service(request, db)

@interest_router.post("/ai/interest/room", response_model=InterestResponseDTO)
def recommend_room_by_user_route(
    request: InterestRoomRequestDTO,
    db: Session = Depends(get_db)):
        return room_interest_service(request, db)