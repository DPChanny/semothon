from sqlalchemy.orm import Session
from models.crawling import Crawling, crawling_to_descriptable
from models.crawling_interest import CrawlingInterest
from models.room import Room, room_to_descriptable
from models.room_interest import RoomInterest
from models.user import User, user_to_descriptable
from models.user_interest import UserInterest
from models.interest import Interest, interest_to_dict
from ai.service.interest import interest

def user_interest_service(request, db: Session):
    user: User = db.query(User).filter(User.user_id == request.user_id).first()
    if not user:
        return {"success": False, "message": "User not found"}

    interests = db.query(Interest).all()
    recommended = interest([user_to_descriptable(user)], 
                           [interest_to_dict(i) for i in interests])[0]
    existing_ids = {ui.interest_id for ui in user.user_interests}

    for item in recommended:
        if item["interest_id"] not in existing_ids:
            user.user_interests.append(
                UserInterest(user_id=user.user_id, interest_id=item["interest_id"])
            )

    db.commit()

    return {"success": True, "message": "Interests successfully generated"}

def room_interest_service(request, db: Session):
    room: Room = db.query(Room).filter(Room.room_id == request.room_id).first()
    if not room:
        return {"success": False, "message": "Room not found"}

    interests = db.query(Interest).all()
    recommended = interest([room_to_descriptable(room)], 
                           [interest_to_dict(i) for i in interests])[0]
    existing_ids = {ri.interest_id for ri in room.room_interests}

    for item in recommended:
        if item["interest_id"] not in existing_ids:
            room.room_interests.append(
                RoomInterest(room_id=room.room_id, interest_id=item["interest_id"])
            )

    db.commit()
    return {"success": True, "message": "Interests successfully generated"}

def crawling_interest_service(crawling_id, db: Session):
    crawling: Crawling = db.query(Crawling).filter(
        Crawling.crawling_id == crawling_id
    ).first()
    if not crawling:
        return {"success": False, "message": "Crawling data not found"}

    interests = db.query(Interest).all()
    recommended = interest([crawling_to_descriptable(crawling)], 
                           [interest_to_dict(i) for i in interests])[0]
    existing_ids = {ci.interest_id for ci in crawling.crawling_interests}

    for item in recommended:
        if item["interest_id"] not in existing_ids:
            crawling.crawling_interests.append(
                CrawlingInterest(crawling_id=crawling.crawling_id, interest_id=item["interest_id"])
            )

    db.commit()
    return {"success": True, "message": "Interests successfully generated"}
