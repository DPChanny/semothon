from models.user import User, user_to_dict
from models.room import Room, room_to_dict

from sqlalchemy.orm import Session
from fastapi import HTTPException

from ai.service.recommend import recommend
from models.user_room_recommendation import UserRoomRecommendation

def process_db(db: Session, recommendations):
    for recommend in recommendations:
        existing = db.query(UserRoomRecommendation).filter_by(
            user_id=recommend["user_id"],
            room_id=recommend["room_id"]
        ).first()

        if existing:
            existing.score = recommend["score"]
        else:
            new_entry = UserRoomRecommendation(
                user_id=recommend["user_id"],
                room_id=recommend["room_id"],
                score=recommend["score"],
                activity_score=recommend["score"]
            )
            db.add(new_entry)

    db.commit()

def recommend_room_by_user_service(request, db: Session):
    user = db.query(User).filter(User.user_id == request.user_id).first()
    rooms = db.query(Room).all()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    process_db(db, recommend([user_to_dict(user)], 
                             [room_to_dict(room) for room in rooms]))

    return {
        "success": True,
        "message": "recommend score successfully processed to all rooms"
    }


def recommend_room_by_room_service(request, db: Session):
    users = db.query(User).all()
    room = db.query(Room).filter(Room.room_id == request.room_id).first()

    if not room:
        raise HTTPException(status_code=404, detail="Room not found")
    
    process_db(db, recommend([user_to_dict(user) for user in users], 
                             [room_to_dict(room)]))

    return {
        "success": True,
        "message": "recommend score successfully processed to all users"
    }
