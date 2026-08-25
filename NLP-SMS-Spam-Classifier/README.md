# 📱 SMS Spam Classifier — NLP

A Natural Language Processing app that reads an SMS message and predicts whether it's **SPAM** (unwanted) or **HAM** (genuine), deployed as a Streamlit web app.

## Overview

Trained on 5,572 real SMS messages, this project cleans and vectorizes raw text, trains a Naive Bayes classifier, and serves predictions through a simple web interface: type any message and instantly see the prediction.

**Pipeline:** Raw CSV → Clean Columns → Clean Text → TF-IDF Numbers → Train Model → Evaluate → Save → Web App

## Dataset

| | |
|---|---|
| Total messages | 5,572 |
| Ham | 4,825 (86.6%) |
| Spam | 747 (13.4%) — imbalanced, realistic for this kind of data |
| Training / test split | 4,457 (80%) / 1,115 (20%) |

## Text Cleaning

Each message is lowercased, stripped of punctuation, split into words, and filtered against a stopword list (removing words like "the", "is", "and") before being joined back into cleaned text.

## Feature Extraction — TF-IDF

Cleaned text is converted into numeric vectors using **TF-IDF** (Term Frequency × Inverse Document Frequency), keeping the top 3,000 most informative words. High scores go to words that are rare but important; common, low-information words score low.

## Model

**Multinomial Naive Bayes** — a probability-based classifier well suited to word-frequency data like TF-IDF.

## Results

**Overall accuracy: 98%**

| | Predicted Ham | Predicted Spam |
|---|---|---|
| **Actual Ham** | 965 ✅ | 0 ❌ (false positive) |
| **Actual Spam** | 24 ❌ (false negative) | 126 ✅ |

| Metric | Ham | Spam |
|---|---|---|
| Precision | 0.98 | 1.00 |
| Recall | 1.00 | 0.84 |
| F1-score | 0.99 | 0.91 |

Zero real messages were ever wrongly blocked (precision 1.00 on spam), while 24 spam messages slipped through undetected (recall 0.84) — a deliberate trade-off, since a missed spam message is far less harmful than losing a genuine one.

## Running the app

```bash
pip install streamlit scikit-learn nltk
streamlit run app.py
```

## Files

| File | Description |
|---|---|
| `spam_classifier.ipynb` | Full notebook: cleaning, TF-IDF, training, evaluation |
| `app.py` | Streamlit app — type a message, get a spam/ham prediction |
| `spam_model.pkl` | Trained Naive Bayes model |
| `vectorizer.pkl` | Fitted TF-IDF vectorizer (3,000-word vocabulary) |
| `spam.csv` | Raw dataset |
| `NLP_SMS_Spam_Classifier_Interview_Doc_v2.docx` | Detailed project write-up |
