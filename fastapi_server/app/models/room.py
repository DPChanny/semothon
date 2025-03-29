from sqlalchemy import Column, Integer, Text
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base
from custom_descriptable import RoomDescriptable

class Room(Base):
    __tablename__ = "rooms"

    room_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    description = Column(Text)

    room_interests = relationship("RoomInterest", cascade="all, delete-orphan")

def room_to_descriptable(room: Room) -> RoomDescriptable:
    return RoomDescriptable(room.description, room.room_id)
