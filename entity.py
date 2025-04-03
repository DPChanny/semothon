from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime

class Crawling(Base):
    __tablename__ = "crawling"

    crawling_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    title = Column(String(255), nullable=False)
    url = Column(String(500), nullable=False)
    image_url = Column(String, nullable=True)
    description = Column(Text, nullable=False)
    crawled_at = Column(DateTime, default=datetime.utcnow)

    user_crawling_recommendations = relationship("UserCrawlingRecommendation", cascade="all, delete-orphan")

def crawling_to_descriptable(crawling: Crawling) -> dict:
    return {
        "id": crawling.crawling_id,
        "title": crawling.title,
        "url": crawling.url,
        "image_url": crawling.image_url,
        "description": crawling.description,
        "crawled_at": crawling.crawled_at
    }
