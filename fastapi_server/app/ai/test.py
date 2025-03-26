import json
import random

from service.recommend import recommend
from service.train_recommender import train_recommender

with open('data/groups.json', 'r', encoding='utf-8') as json_file:
    groups = json.load(json_file)

with open('data/users.json', 'r', encoding='utf-8') as json_file:
    users = json.load(json_file)

with open('data/interactions_merged.json', 'r', encoding='utf-8') as json_file:
    interactions = json.load(json_file)

# train_recommender(users, groups, interactions, 'test_model')

# for _ in range(5):
#     user = users[random.randint(0, len(users) - 1)]
#     print(user)
#     recommendeds = recommend(user, groups, 'test_model')
#     for recommended in recommendeds:
#         print('score', recommended['score'], 'description', recommended['description'])

for _ in range(1):
    user = users[1]
    print(user)
    recommendeds = recommend(user, groups, 'test_model')
    for recommended in recommendeds:
        print('score', recommended['score'], 'description', recommended['description'])

# don't run it
