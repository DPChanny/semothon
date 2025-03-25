import torch
from sentence_transformers import SentenceTransformer

class UserEncoder:
    def __init__(self, sbert_model_name='all-MiniLM-L6-v2'):
        self.sbert = SentenceTransformer(sbert_model_name)

    def encode(self, user: dict) -> torch.Tensor:
        intro_vec = self.sbert.encode(user["intro"], convert_to_tensor=True)

        dept_text = ", ".join(user["departments"])
        dept_vec = self.sbert.encode(dept_text, convert_to_tensor=True)

        age_norm = (user["yob"] - 2000) / 100
        gender_val = 0.0 if user["gender"] == "M" else 1.0
        year_norm = (user["yoa"] - user["yob"]) / 50

        metadata = torch.tensor([age_norm, gender_val, year_norm])

        return torch.cat([intro_vec, dept_vec, metadata])

class GroupEncoder:
    def __init__(self, sbert_model_name='all-MiniLM-L6-v2'):
        self.sbert = SentenceTransformer(sbert_model_name)

    def encode(self, group: dict):
        return self.sbert.encode(group["description"])