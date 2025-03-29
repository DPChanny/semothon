from sqlalchemy import Column, String, Date, DateTime, Enum, Text, UniqueConstraint
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
from database import Base

class GenderEnum(str, enum.Enum):
    MALE = "MALE"
    FEMALE = "FEMALE"

class User(Base):
    __tablename__ = "users"

    user_id = Column(String, primary_key=True)
    department = Column(String(100))
    student_id = Column(String(30))
    birthdate = Column(Date)
    gender = Column(Enum(GenderEnum), nullable=True)
    intro_text = Column(Text)

    user_interests = relationship("UserInterest", cascade="all, delete-orphan")

def user_to_dict(user):
    gender_map = {
        "MALE": "남자",
        "FEMALE": "여자"
    }

    return {
        "intro": user.intro_text,
        "departments": user.department.split(",") if user.department else [],
        "yob": user.birthdate.year if user.birthdate else None,
        "student_id": int(user.student_id[:4]) if user.student_id and len(user.student_id) >= 4 else None,
        "gender": gender_map.get(user.gender.value if user.gender else None),
        "user_id": user.user_id
    }