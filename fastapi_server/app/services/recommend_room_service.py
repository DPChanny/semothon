from models.user import User, user_to_descriptable
from models.room import Room, room_to_descriptable

from sqlalchemy.orm import Session
from fastapi import HTTPException

from ai.service.recommend import recommend
from models.user_room_recommendation import UserRoomRecommendation
from custom_descripable_encoder import user_descriptable_encoder

def process_db(db: Session, results):
    for result in results:
        existing = db.query(UserRoomRecommendation).filter_by(
            user_id=result['target_descriptable'].id,
            room_id=result["descriptable"].id
        ).first()

        if existing:
            existing.score = result["score"]
        else:
            new_entry = UserRoomRecommendation(
                user_id=result['target_descriptable'].id,
                room_id=result['descriptable'].id,
                score=result["score"],
                activity_score=result["score"]
            )
            db.add(new_entry)

    db.commit()

def recommend_room_by_user_service(request, db: Session):
    user = db.query(User).filter(User.user_id == request.user_id).first()
    rooms = db.query(Room).all()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    process_db(db, recommend([user_to_descriptable(user)], 
                             [room_to_descriptable(room) for room in rooms],
                             target_desscriptable_encoder=user_descriptable_encoder))

    return {
        "success": True,
        "message": "recommend score successfully processed to all rooms"
    }


def recommend_room_by_room_service(request, db: Session):
    users = db.query(User).filter(User.intro_text.isnot(None)).all()
    room = db.query(Room).filter(Room.room_id == request.room_id).first()

    if not room:
        raise HTTPException(status_code=404, detail="Room not found")
    
    process_db(db, recommend([user_to_descriptable(user) for user in users], 
                             [room_to_descriptable(room)],
                             target_desscriptable_encoder=user_descriptable_encoder))

    return {
        "success": True,
        "message": "recommend score successfully processed to all users"
    }
