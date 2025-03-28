import torch
import os
from ai.preprocessors.encoder import RoomEncoder, UserEncoder
from ai.models.recommender import RecommenderMLP

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_MODEL_PATH = os.path.join(BASE_DIR, "models", "default_recommender.plt")
MODEL_PATH = os.path.join(BASE_DIR, "models", "recommender.plt")
MODEL_HISTORY_PATH = os.path.join(BASE_DIR, "history")

user_encoder = UserEncoder()
room_encoder = RoomEncoder()

model = RecommenderMLP(1155)
if os.path.isfile(MODEL_PATH):
    model.load_state_dict(torch.load(MODEL_PATH, map_location="cpu"))
else:    
    model.load_state_dict(torch.load(DEFAULT_MODEL_PATH, map_location="cpu"))
    