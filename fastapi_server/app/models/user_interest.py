from sqlalchemy import Column, ForeignKey, Integer, UniqueConstraint
from sqlalchemy.orm import relationship
from database import Base

class UserInterest(Base):
    __tablename__ = "user_interests"
    __table_args__ = (
        UniqueConstraint("user_id", "interest_id", name="uq_user_interest"),
    )

    user_interest_id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)
    interest_id = Column(Integer, ForeignKey("interests.interest_id"), nullable=False)

    interest = relationship("Interest")