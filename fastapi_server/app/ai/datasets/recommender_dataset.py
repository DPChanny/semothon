import torch
from torch.utils.data import Dataset

from ai import user_encoder, description_object_encoder

class RecommenderDataset(Dataset):
    def __init__(self, users, description_objects, interactions):
        self.interactions = interactions
        self.users = users
        self.description_objects = description_objects

    def __len__(self):
        return len(self.interactions)

    def __getitem__(self, idx):
        user_vec = user_encoder.encode(self.users[idx])
        description_object_vec = description_object_encoder.encode(self.description_objects[idx])
        input_vec = torch.cat([user_vec, description_object_vec])
        label = torch.tensor(self.interactions[idx]["score"], dtype=torch.float32)
        return input_vec, label