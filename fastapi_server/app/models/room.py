from sqlalchemy import Column, Integer, String, Text, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base

class Room(Base):
    __tablename__ = "rooms"

    room_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    title = Column(String(100), nullable=False)
    description = Column(Text)

    host_user_id = Column(String, ForeignKey("users.user_id"), nullable=False)
    host = relationship("User", back_populates="hosted_rooms")

    capacity = Column(Integer, nullable=False, default=30)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

def room_to_dict(room: Room) -> dict:
    return {
        "room_id": str(room.room_id),
        "description": room.description
    }
