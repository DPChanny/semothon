import json
import random
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity

# 파일 경로
USER_PATH = "../data/users.json"
GROUP_PATH = "../data/rooms.json"
OUTPUT_PATH = "../data/interactions_generated.json"

# 로드
with open(USER_PATH, "r", encoding="utf-8") as f:
    users = json.load(f)

with open(GROUP_PATH, "r", encoding="utf-8") as f:
    rooms = json.load(f)

# 텍스트 추출
user_texts = [(u["user_id"], u["intro"]) for u in users if "intro" in u]
room_texts = [(g["room_id"], g["description"]) for g in rooms if "description" in g]

user_ids, user_intros = zip(*user_texts)
room_ids, room_descs = zip(*room_texts)

# SBERT 임베딩
model = SentenceTransformer("sentence-transformers/all-MiniLM-L12-v2")
user_embeddings = model.encode(user_intros, convert_to_tensor=False, show_progress_bar=True)
room_embeddings = model.encode(room_descs, convert_to_tensor=False, show_progress_bar=True)

# 유사도 계산
sims = cosine_similarity(user_embeddings, room_embeddings)

# 쌍 생성 (user_id, room_id, similarity)
pairs = []
for i, uid in enumerate(user_ids):
    for j, gid in enumerate(room_ids):
        pairs.append((uid, gid, sims[i][j]))

# 유사도 기준 상위 2000개 중복 없이
pairs.sort(key=lambda x: x[2], reverse=True)
seen = set()
unique_pairs = []

for u, g, s in pairs:
    key = (u, g)
    if key not in seen:
        seen.add(key)
        unique_pairs.append((u, g, s))
    if len(unique_pairs) >= 2000:
        break

def similarity_to_score(sim):
    if sim >= 0.85:
        score = 1.0
    elif sim >= 0.75:
        score = 0.5
    elif sim >= 0.6:
        score = 0.25
    else:
        score = -0.5
    return score


generated = []
for u, g, sim in unique_pairs:
    generated.append({
        "user_id": u,
        "room_id": g,
        "score": round(similarity_to_score(sim), 2)
    })

# 저장
with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
    json.dump(generated, f, indent=2, ensure_ascii=False)

print(f"✅ 생성 완료: {OUTPUT_PATH} (총 {len(generated)}개)")