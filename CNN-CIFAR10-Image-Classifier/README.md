# 🖼️ CNN Image Classifier — CIFAR-10

A Convolutional Neural Network that classifies photos into 10 everyday categories, trained on the CIFAR-10 dataset and deployed as a Streamlit app.

## Overview

CIFAR-10 contains 60,000 real-world color photos evenly split across 10 categories: airplane, automobile, bird, cat, deer, dog, frog, horse, ship, and truck. The goal is to take a raw photo as input and predict which category it belongs to. Unlike a tabular-data ANN, this project works on unstructured image data, using convolution, ReLU, and pooling layers to extract spatial visual features before handing off to dense layers for final classification.

## Dataset

- 50,000 training images / 10,000 test images, 32×32 pixels, 3 color channels
- Perfectly balanced — 5,000 training images per class
- Loaded directly from Keras (`tensorflow.keras.datasets.cifar10`)

## Preprocessing

- Pixel values scaled from `0–255` down to `0–1`
- Labels one-hot encoded (e.g. label 8 / "ship" → `[0,0,0,0,0,0,0,0,1,0]`)

## Model Architecture

| Layer | Output Shape | Params |
|---|---|---|
| Conv2D (32 filters, 3×3, ReLU) | (30, 30, 32) | 896 |
| MaxPooling2D (2×2) | (15, 15, 32) | 0 |
| Conv2D (64 filters, 3×3, ReLU) | (13, 13, 64) | 18,496 |
| MaxPooling2D (2×2) | (6, 6, 64) | 0 |
| Flatten | (2304,) | 0 |
| Dense (64, ReLU) | (64,) | 147,520 |
| Dense (10, Softmax) | (10,) | 650 |

**Total trainable parameters:** 167,562
Optimizer: `adam` · Loss: `categorical_crossentropy` · Epochs: 10 · Batch size: 64

## Results

**Test accuracy: 69.6%**

| Category | Precision | Recall | F1-score |
|---|---|---|---|
| airplane | 0.70 | 0.77 | 0.74 |
| automobile | 0.89 | 0.72 | 0.80 |
| bird | 0.72 | 0.47 | 0.57 |
| cat | 0.58 | 0.43 | 0.49 |
| deer | 0.68 | 0.62 | 0.65 |
| dog | 0.53 | 0.74 | 0.62 |
| frog | 0.73 | 0.80 | 0.76 |
| horse | 0.82 | 0.69 | 0.75 |
| ship | 0.74 | 0.86 | 0.80 |
| truck | 0.67 | 0.86 | 0.75 |

Strongest on vehicle categories (ship, truck, automobile); weakest on visually similar animal categories (cat, bird) — likely due to fine texture detail being lost once images are shrunk to 32×32.

## Real-World Stress Test

The deployed app was tested on photos *outside* the CIFAR-10 dataset to probe its limits:

| Test Image | Prediction | Confidence | Correct? |
|---|---|---|---|
| Stylized illustration (person on bicycle) | frog | 57.2% | No — not a real CIFAR-10 category |
| Real airplane photo (close-up, clouds) | ship | 63.8% | No |
| Real cruise ship photo | automobile | 95.4% | No — confidently wrong |
| Real bird photo (hummingbird, wings spread) | airplane | 45.3% | No — low confidence |
| Real horse photo (running, dark background) | dog | 31.6% | No — low confidence |

## Limitations

- Moderate overall accuracy (~70%), reflecting a shallow architecture (two conv+pool blocks) compared to modern deep networks like ResNet or VGG.
- The model can be **confidently wrong** — e.g. a cruise ship classified as "automobile" at 95% confidence — showing high confidence doesn't guarantee correctness.
- Confuses categories that share color/background patterns (airplane vs. ship, both often shot against blue sky) rather than true object understanding.
- Mild overfitting observed — validation accuracy plateaued/dipped in later epochs while training accuracy kept climbing.
- Every input is downscaled to 32×32 before prediction, discarding detail from typical modern photos.

## Running the app

```bash
pip install streamlit tensorflow pillow numpy
streamlit run app.py
```

## Files

| File | Description |
|---|---|
| `CNN_CIFAR10_Image_Classifier.ipynb` | Full notebook: data loading, EDA, model build, training, evaluation |
| `app.py` | Streamlit app — upload a photo, get a predicted category + confidence |
| `cifar10_cnn_model.h5` | Trained Keras model |
| `CNN_CIFAR10_Project_Documentation.docx` / `.pdf` | Detailed project write-up |
| `sample_images/` | One sample test photo per CIFAR-10 category, for trying the app |
