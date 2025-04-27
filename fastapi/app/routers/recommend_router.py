from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from dto.recommend_dto import RecommendCrawlingByUserRequestDTO, RecommendRoomByRoomRequestDTO, RecommendRoomByUserRequestDTO, RecommendResponseDTO
from database import get_db
from services.recommend_room_service import recommend_room_by_user_service, recommend_room_by_room_service
from services.recommend_crawling_service import recommend_crawling_by_user_service

recommend_router = APIRouter()

@recommend_router.post("/ai/recommend/room/by-user", response_model=RecommendResponseDTO)
def recommend_room_by_user_route(
    request: RecommendRoomByUserRequestDTO,
    db: Session = Depends(get_db)):
        return recommend_room_by_user_service(request, db)

@recommend_router.post("/ai/recommend/room/by-room", response_model=RecommendResponseDTO)
def recommend_room_by_room_route(
    request: RecommendRoomByRoomRequestDTO,
    db: Session = Depends(get_db)):
        return recommend_room_by_room_service(request, db)

@recommend_router.post("/ai/recommend/crawling/by-user", response_model=RecommendResponseDTO)
def recommend_crawling_by_user_route(
    request: RecommendCrawlingByUserRequestDTO,
    db: Session = Depends(get_db)):
        return recommend_crawling_by_user_service(request, db)