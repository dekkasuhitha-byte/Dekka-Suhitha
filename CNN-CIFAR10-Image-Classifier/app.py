import streamlit as st
import numpy as np
from tensorflow.keras.models import load_model
from PIL import Image

model=load_model('cifar10_cnn_model.h5')

class_names = ['airplane', 'automobile', 'bird', 'cat', 'deer',
               'dog', 'frog', 'horse', 'ship', 'truck']

st.title("CNN Image Classifier - CIFAR-10")
st.write("Upload a photo of an airplane,car, bird, cat, deer, dog, frog, horse, ship, or truck.")

uploaded_file = st.file_uploader("Choose an image", type=["jpg" ,"jpeg", "png"])

if uploaded_file is not None:
    image = Image.open(uploaded_file).convert('RGB')
    st.image(image, caption='Uploaded photo', width='stretch')

    image_resized = image.resize((32, 32))
    image_array = np.array(image_resized) / 255.0
    image_array = np.expand_dims(image_array, axis=0)

    prediction = model.predict(image_array)
    predicted_class = class_names[np.argmax(prediction)]
    confidence = np.max(prediction) * 100

    st.write(f"Prediction: **{predicted_class}**")
    st.write(f"Confidence: {confidence:.2f}%")