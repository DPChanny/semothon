from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models.crawling import Crawling
import requests, time, re
from bs4 import BeautifulSoup

crawling_router = APIRouter()

def get_activities(url):
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
        raise HTTPException(status_code=500, detail=f"크롤링 중 오류 발생: {e}")


def get_image_url(url):
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
    except requests.exceptions.RequestException:
        return "이미지 없음"


def get_description(url):
    try:
        response = requests.get(url, headers={"User-Agent": "Mozilla/5.0"})
        response.raise_for_status()
        soup = BeautifulSoup(response.content, 'html.parser')
        sections = [
            '.content-txt', '.view-cont', '.cont-box', '.view-box', '.info',
            '.desc', '.detail', '.text-box', '.article', '.entry-content',
            '.contest-detail', '.description', '.contest-info', '.paragraph', '.context'
        ]
        description_texts = []
        for selector in sections:
            section = soup.select_one(selector)
            if section:
                description_texts.append(re.sub(r'\s+', ' ', section.get_text(separator='\n', strip=True)))

        if description_texts:
            description = ' '.join(description_texts)
            return description[:250] + ('...' if len(description) > 300 else '')
        return "상세 내용 없음"
    except requests.exceptions.RequestException:
        return "상세 내용 없음"


@crawling_router.get("/wevity/{page}")
def crawl_wevity(page: int, db: Session = Depends(get_db)):
    url = f"https://www.wevity.com/?c=find&s=1&gub=1&spage={page}"
    activities = get_activities(url)
    if not activities:
        raise HTTPException(status_code=404, detail="크롤링된 데이터가 없습니다.")

    result = []
    for item in activities:
        crawling = Crawling(
            title=item.get("title", "제목 없음"),
            url=item.get("url", "URL 없음"),
            image_url=item.get("image_url", "이미지 없음"),
            description=item.get("description", "상세 내용 없음")
        )
        db.add(crawling)
        result.append(item)

    db.commit()
    return result


@crawling_router.get("/crawlings")
def read_crawlings(db: Session = Depends(get_db)):
    crawlings = db.query(Crawling).all()
    return [
        {
            "crawling_id": c.crawling_id,
            "title": c.title,
            "url": c.url,
            "image_url": c.image_url,
            "description": c.description
        } for c in crawlings
    ]
