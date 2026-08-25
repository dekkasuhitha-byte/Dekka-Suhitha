import streamlit as st
import pickle
import string
from nltk.corpus import stopwords

stop_words = set(stopwords.words('english'))

def clean_text(text):
    text = text.lower()
    text = text.translate(str.maketrans('', '', string.punctuation))
    words = text.split()
    words = [word for word in words if word not in stop_words]
    return ' '.join(words)

model = pickle.load(open('spam_model.pkl', 'rb'))
tfidf = pickle.load(open('vectorizer.pkl', 'rb'))

st.title("SMS Spam Classifier")
st.write("Type a message below to check if it is spam or not")

user_input = st.text_area("Enter your message here")

if st.button("Predict"):
    cleaned = clean_text(user_input)
    vectorized = tfidf.transform([cleaned]).toarray()
    result = model.predict(vectorized)
    if result[0] == 1:
        st.error("This is SPAM!")
    else:
        st.success("This is HAM (Not Spam)!")
                      
