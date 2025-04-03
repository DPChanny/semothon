from sentence_transformers import util
import torch

from ai import sbert, descriptable_encoder

def interest(descriptables, interests, threshold=0.5, max_results=5):
    encoded_interests = sbert.encode(
        [interest['name'] for interest in interests],
        convert_to_tensor=True
    )

    results = []

    encoded_descriptables = [
        descriptable_encoder.encode(descriptable)
        for descriptable in descriptables
    ]

    for encoded_descriptable in encoded_descriptables:
        cosine_scores = util.cos_sim(encoded_descriptable, encoded_interests)[0]

        filtered = []
        for i, score in enumerate(cosine_scores):
            score_value = score.item()
            if score_value >= threshold:
                filtered.append({
                    'score': score_value,
                    'interest_id': interests[i]['interest_id']
                })

        # 점수 높은 순 정렬 후 상위 max_results개 자르기
        filtered = sorted(filtered, key=lambda x: -x['score'])[:max_results]

        results.append(filtered)

    return results
