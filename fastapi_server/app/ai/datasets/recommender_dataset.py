import torch
from torch.utils.data import Dataset

from ai import descriptable_encoder

class RecommenderDataset(Dataset):
    def __init__(self, target_descriptables, descriptables, interactions,
                 target_descriptable_encoder = descriptable_encoder, 
                 descriptable_encoder = descriptable_encoder):
        self.interactions = interactions
        self.target_discriptables = target_descriptables
        self.descriptables = descriptables
        self.target_discriptable_encoder = target_descriptable_encoder
        self.descriptable_encoder = descriptable_encoder

    def __len__(self):
        return len(self.interactions)

    def __getitem__(self, idx):
        input_vec = torch.cat([self.target_discriptable_encoder.encode(self.target_discriptables[idx]),
                               self.descriptable_encoder.encode(self.descriptables[idx])])
        label = torch.tensor(self.interactions[idx]["score"], dtype=torch.float32)
        return input_vec, label