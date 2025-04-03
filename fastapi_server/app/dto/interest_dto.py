from pydantic import BaseModel

class InterestUserRequestDTO(BaseModel):
    user_id: str

class InterestRoomRequestDTO(BaseModel):
    room_id: str

class InterestResponseDTO(BaseModel):
    success: bool
    message: str
