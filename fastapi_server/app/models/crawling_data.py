from sqlalchemy import Column, DateTime, Integer, String, Text, UniqueConstraint
from sqlalchemy.orm import relationship
from database import Base

class CrawlingData(Base):
    __tablename__ = "crawling_data"
    __table_args__ = (
        UniqueConstraint("url", name="uq_crawling_url"),
    )

    crawling_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    description = Column(Text, nullable=False)

    user_crawling_recommendations = relationship("UserCrawlingRecommendation", cascade="all, delete-orphan")

def crawling_to_dict(crawling: CrawlingData) -> dict:
    return {
        "crawling_id": str(crawling.crawling_id),
        "description": crawling.description
    }
