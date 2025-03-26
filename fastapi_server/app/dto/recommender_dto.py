from pydantic import BaseModel

class RecommendRequestDTO(BaseModel):
    user_id: str
