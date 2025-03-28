from sqlalchemy import Column, DateTime, Integer, String, Text, UniqueConstraint
from sqlalchemy.orm import relationship
from database import Base

class CrawlingData(Base):
    __tablename__ = "crawling_data"
    __table_args__ = (
        UniqueConstraint("url", name="uq_crawling_url"),
    )

    crawling_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    title = Column(String(255), nullable=False)
    url = Column(String(500), nullable=False)
    image_url = Column(String, nullable=True)
    description = Column(Text, nullable=False)
    published_at = Column(DateTime, nullable=True)
    crawled_at = Column(DateTime, nullable=True)

    user_crawling_recommendations = relationship("UserCrawlingRecommendation")

def crawling_to_dict(crawling: CrawlingData) -> dict:
    return {
        "room_id": str(crawling.crawling_id),
        "description": crawling.description
    }
