import time
from typing import List
import re

from bs4 import BeautifulSoup
import requests

import logging

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
        print("get_activities error: %s", e)
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

