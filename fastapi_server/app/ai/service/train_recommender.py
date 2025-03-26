import os

import torch
from torch.utils.data import DataLoader
from ai.models.recommender import RecommenderMLP
from ai.datasets.recommender_dataset import RecommenderDataset
from ai.preprocessors.encoder import UserEncoder, GroupEncoder
import random

BATCH_SIZE = 32
EPOCHS = 100
LR = 0.000025

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

def train_one_epoch(model, dataloader, optimizer, loss_fn):
    model.train()
    total_loss = 0
    for inputs, targets in dataloader:
        inputs, targets = inputs.to(device), targets.to(device)

        optimizer.zero_grad()
        outputs = model(inputs)
        loss = loss_fn(outputs, targets)
        loss.backward()
        optimizer.step()

        total_loss += loss.item()
    return total_loss / len(dataloader)

def train_recommender(users, groups, interactions, path):
    random.shuffle(interactions)

    user_encoder = UserEncoder()
    group_encoder = GroupEncoder()

    dataset = RecommenderDataset(users, groups, interactions, user_encoder, group_encoder)
    sample_input, _ = dataset[0]
    input_dim = sample_input.shape[0]

    dataloader = DataLoader(dataset, batch_size=BATCH_SIZE, shuffle=True)

    model = RecommenderMLP(input_dim).to(device)
    if os.path.isfile(path):
        model.load_state_dict(torch.load(path, map_location="cpu"))
    optimizer = torch.optim.Adam(model.parameters(), lr=LR)
    loss_fn = torch.nn.MSELoss()

    for epoch in range(EPOCHS):
        loss = train_one_epoch(model, dataloader, optimizer, loss_fn)
        print(f"Epoch {epoch+1}/{EPOCHS} - Loss: {loss:.4f}")

    torch.save(model.state_dict(), path)
