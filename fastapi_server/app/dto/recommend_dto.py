from pydantic import BaseModel

class RecommendRoomByUserRequestDTO(BaseModel):
    user_id: str

class RecommendRoomByRoomRequestDTO(BaseModel):
    room_id: str

class RecommendCrawlingByUserRequestDTO(BaseModel):
    user_id: str

class RecommendResponseDTO(BaseModel):
    success: bool
    message: str
