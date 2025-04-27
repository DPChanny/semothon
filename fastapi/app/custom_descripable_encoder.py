import torch
from custom_descriptable import UserDescriptable
from ai.preprocessors.descriptable_encoder import DescriptableEncoder
from ai import sbert

class UserDescriptableEncoder(DescriptableEncoder):
    def __init__(self, sbert):
        super().__init__(sbert)

    def encode(self, user: UserDescriptable) -> torch.Tensor:
        intro_vec = self.sbert.encode(user.intro, convert_to_tensor=True)
        dept_vec = self.sbert.encode(", ".join(user.departments), convert_to_tensor=True)

        age_norm = (user.yob - 2000) / 100
        gender_val = 0.0 if user.gender == "M" else 1.0
        year_norm = (user.student_id - user.yob) / 50

        metadata = torch.tensor([age_norm, gender_val, year_norm])

        return torch.cat([intro_vec, dept_vec, metadata])

user_descriptable_encoder = UserDescriptableEncoder(sbert)