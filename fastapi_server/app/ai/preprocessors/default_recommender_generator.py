import json
import random

from ai import DEFAULT_MODEL_PATH

from ai.service.train_recommender import train_recommender

with open('../data/rooms.json', 'r', encoding='utf-8') as json_file:
    rooms = json.load(json_file)

with open('../data/users.json', 'r', encoding='utf-8') as json_file:
    users = json.load(json_file)

with open('../data/interactions.json', 'r', encoding='utf-8') as json_file:
    interactions = json.load(json_file)

train_recommender(users, rooms, interactions, history=False, model_path=DEFAULT_MODEL_PATH)