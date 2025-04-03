from sqlalchemy import Column, String, Integer, Text, DateTime
from sqlalchemy.orm import relationship
from database import Base
from custom_descriptable import CrawlingDescriptable

class Crawling(Base):
    __tablename__ = "crawling"

    crawling_id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String(255), nullable=False)
    url = Column(String(500), nullable=False)
    image_url = Column(String, nullable=True)
    description = Column(Text, nullable=False)
    deadlined_at = Column(DateTime, nullable=True)
    crawled_at = Column(DateTime, nullable=True)

    crawling_interests = relationship("CrawlingInterest", cascade="all, delete-orphan")

    user_crawling_recommendations = relationship(
        "UserCrawlingRecommendation",
        cascade="all, delete-orphan"
    )

def crawling_to_descriptable(crawling: Crawling) -> dict:
    return CrawlingDescriptable(crawling.description, crawling.crawling_id)
