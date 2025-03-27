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
    nickname = Column(String(50), unique=True)
    department = Column(String(100))
    student_id = Column(String(30))
    birthdate = Column(Date)
    gender = Column(Enum(GenderEnum), nullable=True)
    profile_image_url = Column(String, default="https://semothon.s3.ap-northeast-2.amazonaws.com/profile-images/default.png")
    social_provider = Column(String(50), nullable=False)
    social_id = Column(String(100), nullable=False)
    intro_text = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    hosted_groups = relationship("Group", back_populates="host", cascade="all, delete-orphan")

    __table_args__ = (
        UniqueConstraint('nickname'),
        UniqueConstraint('social_provider', 'social_id'),
    )

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