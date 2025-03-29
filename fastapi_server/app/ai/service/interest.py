from sentence_transformers import util
import torch

from ai import sbert, descriptable_encoder

def interest(descriptables, interests, top_k=10):
    encoded_interests = sbert.encode([interest['name'] for interest in interests], convert_to_tensor=True)

    results = []

    encoded_descriptables = [descriptable_encoder.encode(descriptable) 
                                    for descriptable in descriptables]

    for encoded_descriptable in encoded_descriptables:
        cosine_scores = util.cos_sim(encoded_descriptable, encoded_interests)[0]

        top_results = torch.topk(cosine_scores, k=top_k)
        
        result = []

        for score, idx in zip(top_results.values, top_results.indices):
            result.append({'score': score, 'interest_id': interests[idx]['interest_id']})

        results.append(result)

    return results