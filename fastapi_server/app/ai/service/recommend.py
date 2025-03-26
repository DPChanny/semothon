import torch
from ai.models.recommender import RecommenderMLP
from ai.preprocessors.encoder import UserEncoder, GroupEncoder


def recommend(user, groups, path):
    user_encoder = UserEncoder()
    group_encoder = GroupEncoder()

    user_vec = user_encoder.encode(user)

    input_dim = len(user_vec) + len(group_encoder.encode(groups[0]))
    model = RecommenderMLP(input_dim)
    model.load_state_dict(torch.load(path, map_location="cpu"))
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
