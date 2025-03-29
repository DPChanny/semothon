from sqlalchemy import Column, ForeignKey, Integer, UniqueConstraint
from sqlalchemy.orm import relationship
from database import Base

class RoomInterest(Base):
    __tablename__ = "room_interests"
    __table_args__ = (
        UniqueConstraint("room_id", "interest_id", name="uq_room_interest"),
    )

    room_interest_id = Column(Integer, primary_key=True, autoincrement=True)
    room_id = Column(Integer, ForeignKey("rooms.room_id"), nullable=False)
    interest_id = Column(Integer, ForeignKey("interests.interest_id"), nullable=False)

    room = relationship("Room")
    interest = relationship("Interest")