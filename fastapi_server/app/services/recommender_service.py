from models.user import User, user_to_dict
from models.room import Room, room_to_dict

from sqlalchemy.orm import Session
from fastapi import HTTPException

from ai.service.recommend_room import recommend_room
from models.user_room_recommendation import UserRoomRecommendation

def recommend_service(request, db: Session):
    user = db.query(User).filter(User.user_id == request.user_id).first()
    rooms = db.query(Room).all()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    db.add_all([UserRoomRecommendation(user_id=user.user_id,
                                        room_id=recommend["room_id"],
                                        score=recommend['score'])
                 for recommend in recommend_room(user_to_dict(user), 
                                                  [room_to_dict(room) for room in rooms])])
    db.commit()