from sqlalchemy import Column, Integer, Text
from sqlalchemy.orm import relationship
from database import Base
from custom_descriptable import CrawlingDescriptable

class CrawlingData(Base):
    __tablename__ = "crawling_data"

    crawling_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    description = Column(Text, nullable=False)

    user_crawling_recommendations = relationship("UserCrawlingRecommendation", cascade="all, delete-orphan")

def crawling_to_descriptable(crawling: CrawlingData) -> dict:
    return CrawlingDescriptable(crawling.description, crawling.crawling_id)
