import os
import torch
from torch.utils.data import DataLoader
import random
from datetime import datetime

from ai.datasets.recommender_dataset import RecommenderDataset
from ai import model, MODEL_PATH, MODEL_HISTORY_PATH
from ai import descriptable_encoder

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

def train_recommender(target_descriptables, descriptables, interactions,
                      target_descriptable_encoder=descriptable_encoder, 
                      descriptable_encoder=descriptable_encoder,
                      history = True, model_path = MODEL_PATH, model_history_path = MODEL_HISTORY_PATH):
    if history:
        torch.save(model.state_dict(), os.path.join(model_history_path, datetime.now() + ".plt"))

    random.shuffle(interactions)

    dataset = RecommenderDataset(target_descriptables, descriptables, interactions,
                                 target_descriptable_encoder=target_descriptable_encoder,
                                 descriptable_encoder=descriptable_encoder)

    dataloader = DataLoader(dataset, batch_size=BATCH_SIZE, shuffle=True)

    optimizer = torch.optim.Adam(model.parameters(), lr=LR)
    loss_fn = torch.nn.MSELoss()

    for epoch in range(EPOCHS):
        loss = train_one_epoch(model, dataloader, optimizer, loss_fn)
        print(f"Epoch {epoch+1}/{EPOCHS} - Loss: {loss:.4f}")

    torch.save(model.state_dict(), model_path)
