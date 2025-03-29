import torch

from ai import model, descriptable_encoder

def recommend(target_descriptables, descriptables,
              target_desscriptable_encoder=descriptable_encoder, 
              descriptable_encoder = descriptable_encoder):
    model.eval()

    results = []

    with torch.no_grad():
        for target_descriptable in target_descriptables:
            for descriptable in descriptables:
                descriptable_vec = descriptable_encoder.encode(descriptable)
                target_discriptable_vec = target_desscriptable_encoder.encode(target_descriptable)

                input_tensor = torch.cat([target_discriptable_vec, descriptable_vec]).unsqueeze(0)

                results.append({"target_descriptable": target_descriptable,
                                "descriptable": descriptable,
                                "score": model(input_tensor).item()})

    return results
