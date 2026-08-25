# 🛡️ Network Intrusion Detection — ANN

An Artificial Neural Network that classifies network connections as **NORMAL** or **ATTACK**, trained on the NSL-KDD cybersecurity benchmark dataset.

## Overview

Given 41 measurements of a network connection — duration, protocol, bytes sent, failed logins, and more — the model predicts whether that connection is genuine traffic or malicious (Denial of Service, Probe, unauthorized access, etc.). Intrusion Detection Systems are an active industry area (used by companies like Darktrace and CrowdStrike), and NSL-KDD is a well-established benchmark for demonstrating this kind of hybrid networking + ML skill set.

## Dataset

**NSL-KDD** (an improved, deduplicated version of the original KDD Cup 1999 dataset):

| | |
|---|---|
| Training records | 125,973 |
| Test records | 22,544 |
| Original features | 41 (+ label + difficulty_level) |
| Features after one-hot encoding | 122 |
| Task | Binary classification (Normal vs Attack) |

## Pipeline

1. Load `KDDTrain+.txt` / `KDDTest+.txt` and attach the 43 official column names
2. EDA — shape, label balance, dtypes, missing values
3. Collapse 23 original labels (normal + 22 attack types) into a binary `normal` / `attack` label
4. One-hot encode categorical columns (`protocol_type`, `service`, `flag`) → ~84 new columns
5. Scale numeric columns with `StandardScaler` (fit on train only, to avoid data leakage)
6. Train a 2-hidden-layer ANN (64 → 32 → 1, ReLU / ReLU / Sigmoid)
7. Evaluate, then add Dropout regularization and compare

## Model

| Layer | Neurons | Activation |
|---|---|---|
| Hidden 1 | 64 | ReLU |
| Hidden 2 | 32 | ReLU |
| Output | 1 | Sigmoid |

Optimizer: `adam` · Loss: `binary_crossentropy` · Epochs: 10 · Batch size: 32

## Results

| Metric | Baseline | With Dropout (0.3) |
|---|---|---|
| Training accuracy | 99.65% | — |
| Validation accuracy | 99.61% | — |
| **Test accuracy** | 78% | **81%** |
| Attack recall | 66% | 69% |
| Normal recall | 92% | 95% |
| False alarms | 735 | 449 |
| Missed attacks | 4,315 | 3,916 |

Test accuracy is meaningfully lower than training accuracy (99.6%) by design, not by error: NSL-KDD's test set deliberately includes attack patterns that never appear in training, to measure whether a model generalizes to genuinely new attacks rather than memorizing known ones — a realistic reflection of how attackers constantly evolve new techniques.

## Limitations

- **Generalization gap on novel attacks** — the test set intentionally contains attack types never seen during training.
- **Severe class imbalance** for rare attack types (some with only 2–4 records), which is why this project uses binary classification rather than predicting the exact attack type.
- **False negatives are the costliest error** — even with dropout, the model still misses roughly 31% of real attacks; a production system would need threshold tuning, class weighting, or a more complex architecture.
- **Dataset age** — NSL-KDD is based on 1999-era traffic patterns; modern network traffic and attack techniques may differ substantially.

## Files

| File | Description |
|---|---|
| `ANN_Network_Intrusion_Detection.ipynb` | Full notebook: data loading, EDA, preprocessing, model training, evaluation |
| `ANN_Network_Intrusion_Detection_Doc.docx` | Detailed project write-up |
