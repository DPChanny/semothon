import torch
from models.recommender import RecommenderMLP
from preprocessors.encoder import UserEncoder, GroupEncoder


def recommend(user, groups):
    user_encoder = UserEncoder()
    group_encoder = GroupEncoder()

    user_vec = user_encoder.encode(user)
    user_tensor = torch.tensor(user_vec, dtype=torch.float32)

    input_dim = len(user_vec) + 384
    model = RecommenderMLP(input_dim)
    model.load_state_dict(torch.load("recommender_model.pt", map_location="cpu"))
    model.eval()

    results = []

    with torch.no_grad():
        for group in groups:
            group_vec = group_encoder.encode(group)
            group_tensor = torch.tensor(group_vec, dtype=torch.float32)

            input_tensor = torch.cat([user_tensor, group_tensor]).unsqueeze(0)  # shape: (1, dim)
            similarity = model(input_tensor).item()

            results.append({
                "group_id": group["id"],
                "group_desc": group["description"],
                "similarity": similarity
            })

    return results.sort(key=lambda x: x["similarity"], reverse=True)
