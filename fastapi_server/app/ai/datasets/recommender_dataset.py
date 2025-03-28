import torch
from torch.utils.data import Dataset

class RecommenderDataset(Dataset):
    def __init__(self, users, rooms, interactions, user_encoder, room_encoder):
        self.interactions = interactions

        self.encoded_users = {user['user_id']: user_encoder.encode(user) for user in users}
        self.encoded_rooms = {room['room_id']: room_encoder.encode(room) for room in rooms}

    def __len__(self):
        return len(self.interactions)

    def __getitem__(self, idx):
        item = self.interactions[idx]
        input_vec = torch.cat([self.encoded_users[item['user_id']], self.encoded_rooms[item['room_id']]])
        label = torch.tensor(item["score"], dtype=torch.float32)
        return input_vec, label