import json
import os.path
import random

import openai
from ai.config import OPEN_AI_API_KEY

client = openai.OpenAI(api_key=OPEN_AI_API_KEY)

def query(user_input, model, temperature):
    response = client.chat.completions.create(
        model=model,
        temperature=temperature,
        messages=[
            {"role": "system", "content": "be creative but rational"},
            {"role": "user", "content": user_input}
        ]
    )

    return response.choices[0].message.content

create_user_query  = '''
task: 유저 데이터 1개 생성
template(follow the rule of json, only print { to }, * is example):
{
    "intro": "**********",
    "departments": ["****학과", ...],
    "yob": ****,
    "student_id":  ****,
    "gender": "**" 
}
comment:
    intro: 1문장 ~ 3문장, 관심사, 취미, 하고 싶은 것 등 유저 소개 자유롭게
    departments: intro와 관련있거나 관련 없어도 됨, 1개 ~ 3개
    yob: 1990 부터 2006
    student_id: 2010 부터 2025
    gender: 남자 또는 여자
    yob student_id gender는 자연스럽게 생성
'''

create_room_query = '''
task: 그룹 데이터 1개 생성
template(follow the rule of json, only print { to }, * is example):
{
  "description": "********"
}

comment:
    description: 1문장 ~ 3문장, (특정 학술 분야의 학술적 목적)이나 (대중적으로 단순한 취미 또는 운동)를 위한 그룹의 목적 자유롭게
'''

create_interaction_query = '''
task: 추천 만족도 데이터 1개 생성
template(only print single number from -1 ~ 1 which means dissatisfaction to satisfaction):
0.25
comment:
아래 유저와 그룹 정보가 입력된다.

아래 두개 정보에 집중하기
    user -> intro 는 유저의 관심사 정보
    room -> description 은 그룹의 목적

유저의 관심사와 그룹의 소개가
    매우 밀접한 관련이 있음 -> 1
    밀접한 관련이 있음 -> 0.5
    관련이 있음 -> 0.25
    관련이 있는지 애매하지만 그룹의 예상 활동이 대중적임 -> 0
    관련이 거의 없고 그룹의 예상 활동이 대중적이지 않음 -> -0.5
    관련이 거의 없고 그룹의 예상 활동이 대중적으로 부정적임 -> -1

input:
'''

def generate_user(count, file):
    users = []
    if os.path.isfile(file):
        with open(file, 'r', encoding='utf-8') as json_file:
            users = json.load(json_file)

        with open(file + ".old", 'w', encoding='utf-8') as json_file:
            json.dump(users, json_file, indent=4, ensure_ascii=False)

    for user_id in range(len(users), len(users) + count):
        created_user_str = query(create_user_query, "gpt-4o-mini", 1)
        print(created_user_str)
        created_user_dict: dict = json.loads(created_user_str)
        created_user_dict['user_id'] = str(user_id)
        users.append(created_user_dict)

    with open(file, 'w', encoding='utf-8') as json_file:
        json.dump(users, json_file, indent=4, ensure_ascii=False)

def generate_room(count, file):
    rooms = []
    if os.path.isfile(file):
        with open(file, 'r', encoding='utf-8') as json_file:
            rooms = json.load(json_file)

        with open(file + ".old", 'w', encoding='utf-8') as json_file:
            json.dump(rooms, json_file, indent=4, ensure_ascii=False)

    for room_id in range(len(rooms), len(rooms) + count):
        created_room_str = query(create_room_query, "gpt-4o-mini", 1)
        print(created_room_str)
        created_room_dict: dict = json.loads(created_room_str)
        created_room_dict['room_id'] = str(room_id)
        rooms.append(created_room_dict)

    with open(file, 'w', encoding='utf-8') as json_file:
        json.dump(rooms, json_file, indent=4, ensure_ascii=False)

def generate_interaction(count, user_file, room_file, interaction_file):
    if os.path.isfile(room_file):
        with open(room_file, 'r', encoding='utf-8') as json_file:
            rooms = json.load(json_file)
    else:
        return

    if os.path.isfile(user_file):
        with open(user_file, 'r', encoding='utf-8') as json_file:
            users = json.load(json_file)
    else:
        return

    interactions = []
    if os.path.isfile(interaction_file):
        with open(interaction_file, 'r', encoding='utf-8') as json_file:
            interactions = json.load(json_file)

        with open(interaction_file + ".old", 'w', encoding='utf-8') as json_file:
            json.dump(interactions, json_file, indent=4, ensure_ascii=False)

    for _ in range(len(interactions), len(interactions) + count):
        rand_user = users[random.randint(0, len(users) - 1)]
        rand_room = rooms[random.randint(0, len(rooms) - 1)]

        print("user info\n" + rand_user['intro'] +
              "\nroom info\n" + rand_room['description'])

        created_interaction = float(query(create_interaction_query +
                                          "user info" + json.dumps(rand_user) +
                                          "room info" + json.dumps(rand_room),
                                          "gpt-4o", 0.25))

        print(str(created_interaction) + "\n")

        interactions.append({'user_id': rand_user['user_id'], 'room_id': rand_room['room_id'], 'score': created_interaction})

    with open(interaction_file, 'w', encoding='utf-8') as json_file:
        json.dump(interactions, json_file, indent=4, ensure_ascii=False)

# generate_room(50, '../data/rooms.json')
# generate_user(50, '../data/users.json')
for _ in range(10):
    generate_interaction(25, '../data/users.json', '../data/rooms.json', '../data/interactions.json')
