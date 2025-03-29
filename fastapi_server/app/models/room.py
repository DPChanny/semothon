from sqlalchemy import Column, Integer, String, Text, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base

class Room(Base):
    __tablename__ = "rooms"

    room_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    description = Column(Text)

    room_interests = relationship("RoomInterest", cascade="all, delete-orphan")

def room_to_dict(room: Room) -> dict:
    return {
        "room_id": str(room.room_id),
        "description": room.description
    }
