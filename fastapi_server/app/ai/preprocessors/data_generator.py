import json
import os.path

import openai

client = openai.OpenAI(api_key="")

def query(user_input):
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        temperature=1,
        messages=[
            {"role": "system", "content": "be creative but rational"},
            {"role": "user", "content": user_input}
        ]
    )

    return response.choices[0].message.content

create_user_query  = '''
task: 유저 데이터 1개 생성
template(follow the rule of json, only print { to }):
{
    "intro": "저는 인공지능과 추천 시스템에 관심이 많습니다.",
    "departments": ["컴퓨터공학과", "AI융합학부"],
    "yob": 2002,
    "student_id": 2021,
    "gender": "남자" 
}
comment:
    위의 데이터는 예시일 뿐이고 자유롭게 전공이나 관심사를 생각해봐
    intro: 관심사, 취미, 대회, 운동, 야구, 축구, 배드민턴, 스터디, 선후배 만남 등 자유롭게 1문장 ~ 3문장
    departments: intro와 관련있거나 관련 없어도 됨, 1개 ~ 3개
    yob, student_id, gender 자연스로운 데이터 생성
'''

create_group_query = '''
task: 그룹 데이터 1개 생성
template(follow the rule of json, only print { to }):
{
  "description": "AI 기술에 관심 있는 사람들과 자유롭게 토론하는 모임입니다.",
}

comment:
    위의 데이터는 예시일 뿐이고 자유롭게 전공이나 관심사를 생각해봐
    description: 관심사, 취미, 대회 등 자유롭게 1문장 ~ 3문장
'''

def generate_user(count, file):
    users = []
    if os.path.isfile(file):
        with open(file, 'r', encoding='utf-8') as json_file:
            users = json.load(json_file)

        with open(file + ".old", 'w', encoding='utf-8') as json_file:
            json.dump(users, json_file, indent=4, ensure_ascii=False)

    for user_id in range(len(users), len(users) + count):
        created_user_str = query(create_user_query)
        print(created_user_str)
        created_user_dict: dict = json.loads(created_user_str)
        created_user_dict['id'] = user_id
        users.append(created_user_dict)

    with open(file, 'w', encoding='utf-8') as json_file:
        json.dump(users, json_file, indent=4, ensure_ascii=False)

# generate_user(5, '../datas/users.json')

def generate_group(count, file):
    groups = []
    if os.path.isfile(file):
        with open(file, 'r', encoding='utf-8') as json_file:
            groups = json.load(json_file)

        with open(file + ".old", 'w', encoding='utf-8') as json_file:
            json.dump(groups, json_file, indent=4, ensure_ascii=False)

    for group_id in range(len(groups), len(groups) + count):
        created_group_str = query(create_group_query)
        print(created_group_str)
        created_group_dict: dict = json.loads(created_group_str)
        created_group_dict['id'] = group_id
        groups.append(created_group_dict)

    with open(file, 'w', encoding='utf-8') as json_file:
        json.dump(groups, json_file, indent=4, ensure_ascii=False)

# generate_group(25, '../datas/groups.json')
