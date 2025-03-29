from sentence_transformers import SentenceTransformer, util
import torch

from ai import sbert, description_object_encoder

def interest(user, description_objects, interests, top_k=10):
    encoded_interests = sbert.encode(interests, convert_to_tensor=True)

    recommended = []
    
    if user is not None:
        encoded_user = sbert.encode(user["intro"], convert_to_tensor=True)

        cosine_scores = util.cos_sim(encoded_user, encoded_interests)[0]

        top_results = torch.topk(cosine_scores, k=top_k)

        for score, idx in zip(top_results.values, top_results.indices):
            recommended.append({
                'user_id': user['user_id'],
                'interest_id': interests[idx]["interest_id"],
                'name': interests[idx]["name"],
                'score': round(score.item(), 4)
            })

    if description_objects is not None:
        encoded_description_objects = [description_object_encoder.encode(description_object) 
                                       for description_object in description_objects]

        for encoded_description_object in encoded_description_objects:
            cosine_scores = util.cos_sim(encoded_description_object, encoded_interests)[0]

            top_results = torch.topk(cosine_scores, k=top_k)

            for score, idx, description_object in zip(top_results.values, top_results.indices, description_objects):
                recommended.append({
                    **description_object,
                    'interest_id': interests[idx]["interest_id"],
                    'name': interests[idx]["name"],
                    'score': round(score.item(), 4)
                })
            
    return recommended