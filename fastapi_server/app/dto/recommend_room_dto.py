from pydantic import BaseModel

class RecommendRoomRequestDTO(BaseModel):
    user_id: str
