import torch

from ai import model, user_encoder, room_encoder

def recommend_room(user, rooms):
    user_vec = user_encoder.encode(user)

    model.eval()

    results = []

    with torch.no_grad():
        for room in rooms:
            room_vec = room_encoder.encode(room)

            input_tensor = torch.cat([user_vec, room_vec]).unsqueeze(0)  # shape: (1, dim)
            similarity = model(input_tensor).item()

            results.append({
                "room_id": room["room_id"],
                "description": room["description"],
                "score": similarity
            })

    results.sort(key=lambda x: x["score"], reverse=True)

    return results
