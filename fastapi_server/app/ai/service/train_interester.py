# from bertopic import BERTopic
# from hdbscan import HDBSCAN
# from sentence_transformers import SentenceTransformer
# import pickle
# from umap import UMAP

# def train_set_topic(users, rooms, path):
#     embedding_model = SentenceTransformer("all-MiniLM-L6-v2")
#     data = [user['intro'] for user in users]
#     data += [room['description'] for room in rooms]

#     print(2)

#     umap_model = UMAP(n_neighbors=5, n_components=10, min_dist=0.5, metric='cosine')
#     hdbscan_model = HDBSCAN(min_cluster_size=5, min_samples=1, metric='euclidean')

#     topic_model = BERTopic(embedding_model=embedding_model,
#                            umap_model=umap_model,
#                            hdbscan_model=hdbscan_model,
#                            verbose=True)
#     topic_model.fit(data)

#     print(3)

#     topic_model.get_topic_info().to_json('result.json', orient='index', indent=4, force_ascii=False)

#     with open(path, "wb") as f:
#         pickle.dump(topic_model, f)

# not used currently