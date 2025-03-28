import torch

from ai import model, user_encoder, description_object_encoder

def recommend(users, description_objects):
    model.eval()

    results = []

    with torch.no_grad():
        for description_object in description_objects:
            for user in users:
                description_vec = description_object_encoder.encode(description_object)
                user_vec = user_encoder.encode(user)

                input_tensor = torch.cat([user_vec, description_vec]).unsqueeze(0)  # shape: (1, dim)
                similarity = model(input_tensor).item()

                results.append({
                    "user_id": user["user_id"],
                    "score": similarity,
                    **description_object
                })

    results.sort(key=lambda x: x["score"], reverse=True)

    return results
