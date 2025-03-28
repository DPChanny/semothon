import torch
from sentence_transformers import SentenceTransformer

class UserEncoder:
    def __init__(self, sbert):
        self.sbert = sbert

    def encode_only_intro(self, user: dict) -> torch.Tensor:
        return self.sbert.encode(user["intro"], convert_to_tensor=True)

    def encode(self, user: dict) -> torch.Tensor:
        intro_vec = self.sbert.encode(user["intro"], convert_to_tensor=True)

        dept_text = ", ".join(user["departments"])
        dept_vec = self.sbert.encode(dept_text, convert_to_tensor=True)

        age_norm = (user["yob"] - 2000) / 100
        gender_val = 0.0 if user["gender"] == "M" else 1.0
        year_norm = (user["student_id"] - user["yob"]) / 50

        metadata = torch.tensor([age_norm, gender_val, year_norm])

        return torch.cat([intro_vec, dept_vec, metadata])

class DescriptionObjectEncoder:
    def __init__(self, sbert):
        self.sbert = sbert

    def encode(self, description_object: dict) -> torch.Tensor:
        return self.sbert.encode(description_object["description"], convert_to_tensor=True)