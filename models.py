from sqlalchemy import Column, Integer, Text, String
from sqlalchemy.orm import relationship
from database import Base
from custom_descriptable import CrawlingDescriptable  # 필요 없다면 이 부분과 관련 함수 제거 가능

class Crawling(Base):
    __tablename__ = "crawling"

    crawling_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    title = Column(String, nullable=False)
    url = Column(String, nullable=False)
    image_url = Column(String, nullable=False)
    description = Column(Text, nullable=False)



def crawling_to_descriptable(crawling: Crawling) -> dict:
    return CrawlingDescriptable(crawling.description, crawling.crawling_id)
