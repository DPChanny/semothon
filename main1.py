from fastapi import FastAPI, Depends, HTTPException
from typing import List
import requests
from bs4 import BeautifulSoup
import re
import time
import logging
from sqlalchemy.orm import Session

# database.py에 정의된 SessionLocal, engine, Base 임포트
from database import SessionLocal, engine, Base
from models import Crawling


Base.metadata.drop_all(bind=engine)
Base.metadata.create_all(bind=engine)

app = FastAPI()
logging.basicConfig(level=logging.INFO)



def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_activities(url: str) -> List[dict]:
    try:
        response = requests.get(url, headers={"User-Agent": "Mozilla/5.0"})
        response.raise_for_status()
        soup = BeautifulSoup(response.content, 'html.parser')

        activities = []
        items = soup.select('.tit a')
        for item in items:
            title = item.text.strip()
            wevity_url = 'https://www.wevity.com' + item['href']
            image_url = get_image_url(wevity_url)
            description = get_description(wevity_url)
            activities.append({
                'title': title,
                'url': wevity_url,
                'image_url': image_url,
                'description': description
            })
            time.sleep(1)
        return activities
    except requests.exceptions.RequestException as e:
        logging.error("get_activities error: %s", e)
        return []


def get_image_url(url: str) -> str:
    try:
        response = requests.get(url, headers={"User-Agent": "Mozilla/5.0"})
        response.raise_for_status()
        soup = BeautifulSoup(response.content, 'html.parser')
        img_element = soup.select_one('.thumb img') or soup.select_one('.content-txt img')
        if img_element and 'src' in img_element.attrs:
            image_url = img_element['src'].strip()
            if image_url.startswith('/'):
                image_url = 'https://www.wevity.com' + image_url
            return image_url
        return "이미지 없음"
    except requests.exceptions.RequestException as e:
        logging.error("get_image_url error: %s", e)
        return "이미지 없음"


def get_description(url: str) -> str:
    try:
        response = requests.get(url, headers={"User-Agent": "Mozilla/5.0"})
        response.raise_for_status()
        soup = BeautifulSoup(response.content, 'html.parser')
        content_sections = [
            soup.select_one('.content-txt'),
            soup.select_one('.view-cont'),
            soup.select_one('.cont-box'),
            soup.select_one('.view-box'),
            soup.select_one('.info'),
            soup.select_one('.desc'),
            soup.select_one('.detail'),
            soup.select_one('.text-box'),
            soup.select_one('.article'),
            soup.select_one('.entry-content'),
            soup.select_one('.contest-detail'),
            soup.select_one('.description'),
            soup.select_one('.contest-info'),
            soup.select_one('.paragraph'),
            soup.select_one('.context')
        ]
        description_texts = []
        for section in content_sections:
            if section:
                description_texts.append(re.sub(r'\s+', ' ', section.get_text(separator='\n', strip=True)))
        if description_texts:
            description = ' '.join(description_texts)
            return description[:250] + ('...' if len(description) > 300 else '')
        return "상세 내용 없음"
    except requests.exceptions.RequestException as e:
        logging.error("get_description error: %s", e)
        return "상세 내용 없음"



@app.get("/wevity/{page}", response_model=List[dict])
def get_wevity_data(page: int, db: Session = Depends(get_db)):
    base_url = 'https://www.wevity.com/?c=find&s=1&gub=1'
    url = f"{base_url}&spage={page}"
    activities = get_activities(url)
    if not activities:
        raise HTTPException(status_code=404, detail="크롤링된 데이터가 없습니다.")

    logging.info("크롤링된 데이터: %s", activities)

    try:
        for activity in activities:
            new_crawling = Crawling(
                title=activity.get("title", "제목 없음"),
                url=activity.get("url", "URL 없음"),
                image_url=activity.get("image_url", "이미지 없음"),
                description=activity.get("description", "상세 내용 없음")
            )
            db.add(new_crawling)
        db.commit()
    except Exception as e:
        db.rollback()
        logging.error("DB 저장 에러: %s", e)
        raise HTTPException(status_code=500, detail=f"DB 저장 중 오류 발생: {e}")
    return activities



@app.get("/crawlings", response_model=List[dict])
def read_crawlings(db: Session = Depends(get_db)):
    crawlings = db.query(Crawling).all()
    return [{
        "crawling_id": crawling.crawling_id,
        "title": crawling.title,
        "url": crawling.url,
        "image_url": crawling.image_url,
        "description": crawling.description
    } for crawling in crawlings]
