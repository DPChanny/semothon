from sqlalchemy import Column, Float, ForeignKey, Integer, UniqueConstraint
from sqlalchemy.orm import relationship
from database import Base

class UserCrawlingRecommendation(Base):
    __tablename__ = "user_crawling_recommendations"
    __table_args__ = (
        UniqueConstraint("user_id", "crawling_id", name="uq_user_crawling"),
    )

    user_crawling_rec_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)
    crawling_id = Column(Integer, ForeignKey("crawling.crawling_id"), nullable=False)
    score = Column(Float, nullable=False)
    activity_score = Column(Float, nullable=False)

    user = relationship("User")
    crawling = relationship("Crawling")
