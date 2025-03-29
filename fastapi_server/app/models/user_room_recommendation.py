from sqlalchemy import Column, Float, ForeignKey, Integer, UniqueConstraint
from sqlalchemy.orm import relationship
from database import Base

class UserRoomRecommendation(Base):
    __tablename__ = "user_room_recommendations"
    __table_args__ = (
        UniqueConstraint("user_id", "room_id", name="uq_user_room"),
    )

    user_room_rec_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)
    room_id = Column(Integer, ForeignKey("rooms.room_id"), nullable=False)
    score = Column(Float, nullable=False)
    activity_score = Column(Float, nullable=False)

    user = relationship("User")
    room = relationship("Room")