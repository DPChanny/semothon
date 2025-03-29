import torch

from ai.descripable import Descriptable

class DescriptableEncoder:
    def __init__(self, sbert):
        self.sbert = sbert

    def encode(self, descriptable: Descriptable) -> torch.Tensor:
        return self.sbert.encode(descriptable.description, convert_to_tensor=True)