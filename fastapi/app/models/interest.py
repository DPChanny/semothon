from sqlalchemy import Column, Integer, String
from database import Base

class Interest(Base):
    __tablename__ = "interests"

    interest_id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=False)

def interest_to_dict(interest: Interest) -> dict:
    return {
        "interest_id": str(interest.interest_id),
        "name": interest.name
    }
