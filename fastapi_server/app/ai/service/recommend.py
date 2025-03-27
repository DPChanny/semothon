import torch

from ai import model, user_encoder, group_encoder

def recommend(user, groups):
    user_vec = user_encoder.encode(user)

    model.eval()

    results = []

    with torch.no_grad():
        for group in groups:
            group_vec = group_encoder.encode(group)

            input_tensor = torch.cat([user_vec, group_vec]).unsqueeze(0)  # shape: (1, dim)
            similarity = model(input_tensor).item()

            results.append({
                "group_id": group["group_id"],
                "description": group["description"],
                "score": similarity
            })

    results.sort(key=lambda x: x["score"], reverse=True)

    return results
