import pickle
from bertopic import BERTopic

MODEL_PATH = "saved_model/bertopic_model.pkl"

# 모델 로드
with open(MODEL_PATH, "rb") as f:
    topic_model: BERTopic = pickle.load(f)

def set_user_topic(users):
    topics, probs = topic_model.transform([user['intro'] for user in users])

    for i in range(len(users)):
        users[i]['topics'] = []
        print(f"\n📘 {users[i]}")
        print(f"  → Topic: {topics[i]}, 확률: {probs[i]:.2f}")
        if probs[i] > 0.5:
            users[i]['topics'].append(topics[i])
        if topics[i] == -1 or probs[i] < 0.3:
            print("  ⚠️ 이 문장은 이상치로 간주됨 (low confidence or outlier)")

    return users