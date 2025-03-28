import json

with open("../data/interactions.json", 'r', encoding='utf-8') as file:
    interactions = json.load(file)

result = {}

ugmap = {}
same = {}

for interaction in interactions:
    if result.get(interaction['score']) is None:
        result[interaction['score']] = 1
    else:
        result[interaction['score']] += 1

    if ugmap.get(interaction['room_id']) is None:
        ugmap[interaction['room_id']] = []
        ugmap[interaction['room_id']].append(interaction['user_id'])
    else:
        if ugmap[interaction['room_id']].__contains__(interaction['user_id']):
            if same.get(interaction['score']) is None:
                same[interaction['score']] = 1
            else:
                same[interaction['score']] += 1
        else:
            ugmap[interaction['room_id']].append(interaction['user_id'])

print(len(interactions))
print(result)
print(same)

"""
500
{-0.5: 381, 0.25: 22, 1.0: 41, 0.5: 24, 0.0: 32}
{1.0: 5, -0.5: 36, 0.25: 3, 0.0: 3, 0.5: 1}
"""