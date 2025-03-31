import openai

from ai.config import OPEN_AI_API_KEY

client = openai.OpenAI(api_key=OPEN_AI_API_KEY)

def query(user_input, model='gpt-4o-mini', temperature=0.5, top_p=0.25):
    response = client.chat.completions.create(
        model=model,
        temperature=temperature,
        top_p=top_p,
        messages=[
            {"role": "system", "content": "be creative but rational"},
            {"role": "user", "content": user_input}
        ]
    )

    return response.choices[0].message.content

prompt = '''
task: 키워드 기반 자기소개 생성
input example:
자전거, 컴퓨터공학, 운동, 알고리즘 스터디
output example(최대 3문장, 50단어):
안녕하세요 저는 컴퓨터 공학과 다닌는 학생입니다. 운동을 좋아하고 보통 자전거를 타요. 알고리즘 스터디도 하고 싶습니다!
comment:
위의 입력과 출력은 예시일 뿐이니까 출력의 형태를 최대한 다양하게 해봐
input:
'''

def intro(user_interests):
    return query(prompt + ",".join(user_interests))