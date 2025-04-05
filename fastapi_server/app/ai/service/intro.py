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
AI의 분석 결과 사용자님은 평소 운동 중 하나인 자전거를 즐깁니다. 또한 컴퓨터 공학을 전공하고 계시며 알고리즘 스터디를 진행하기를 원하십니다.
comment:
위의 입력과 출력은 예시일 뿐이니까 출력의 형태를 최대한 다양하게 해봐
input:
'''

def intro(user_interests):
    return query(prompt + ",".join(user_interests))