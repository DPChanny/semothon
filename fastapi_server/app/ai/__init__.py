from sentence_transformers import SentenceTransformer
import torch
import os
from ai.preprocessors.encoder import DescriptionObjectEncoder, UserEncoder
from ai.models.recommender import RecommenderMLP

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_MODEL_PATH = os.path.join(BASE_DIR, "models", "default_recommender.plt")
MODEL_PATH = os.path.join(BASE_DIR, "models", "recommender.plt")
MODEL_HISTORY_PATH = os.path.join(BASE_DIR, "history")

sbert = SentenceTransformer('all-MiniLM-L12-v2')

user_encoder = UserEncoder(sbert)
description_object_encoder = DescriptionObjectEncoder(sbert)

model = RecommenderMLP(1155)
if os.path.isfile(MODEL_PATH):
    model.load_state_dict(torch.load(MODEL_PATH, map_location="cpu"))
else:    
    model.load_state_dict(torch.load(DEFAULT_MODEL_PATH, map_location="cpu"))
    