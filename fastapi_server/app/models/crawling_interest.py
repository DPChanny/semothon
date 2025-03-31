from sqlalchemy import Column, ForeignKey, Integer, UniqueConstraint
from sqlalchemy.orm import relationship
from database import Base

class CrawlingInterest(Base):
    __tablename__ = "crawling_interests"
    __table_args__ = (
        UniqueConstraint("crawling_id", "interest_id", name="uq_crawling_interest"),
    )

    crawling_interest_id = Column(Integer, primary_key=True, autoincrement=True)
    crawling_id = Column(Integer, ForeignKey("crawling.crawling_id"), nullable=False)
    interest_id = Column(Integer, ForeignKey("interests.interest_id"), nullable=False)

    crawling = relationship("Crawling")
    interest = relationship("Interest")