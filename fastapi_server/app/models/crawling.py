from sqlalchemy import Column, Integer, Text, String
from sqlalchemy.orm import relationship
from database import Base
from custom_descriptable import CrawlingDescriptable

class Crawling(Base):
    __tablename__ = "crawling"

    crawling_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    title = Column(String(255), nullable=False)
    url = Column(String(500), nullable=False)
    image_url = Column(String(500), nullable=True)
    description = Column(Text, nullable=False)

    user_crawling_recommendations = relationship("UserCrawlingRecommendation", cascade="all, delete-orphan")

def crawling_to_descriptable(crawling: Crawling) -> dict:
    return CrawlingDescriptable(crawling.description, crawling.crawling_id)
