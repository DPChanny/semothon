from pydantic import BaseModel

class IntroRequestDTO(BaseModel):
    user_id: str

class IntroResponseDTO(BaseModel):
    success: bool
    intro: str
    message: str
