from sqlalchemy import Column, Float, ForeignKey, Integer
from sqlalchemy.orm import relationship
from database import Base

class UserGroupRecommendation(Base):
    __tablename__ = "user_room_recommendation"

    user_room_rec_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    room_id = Column(Integer, ForeignKey("room.id"), nullable=False)
    score = Column(Float, nullable=False)