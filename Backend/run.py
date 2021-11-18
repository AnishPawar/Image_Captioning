from tensorflow import keras
from tensorflow.keras.applications.inception_v3 import InceptionV3
from tensorflow.keras.models import Model
from tensorflow.keras.models import load_model

import pickle
import numpy as np
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.inception_v3 import preprocess_input
import matplotlib.pyplot as plt
from tensorflow.keras.preprocessing import sequence
import time



modelInception = InceptionV3(weights='imagenet')
model_new = Model(modelInception.input, modelInception.layers[-2].output)

caption_model = load_model('caption_model.h5')

with open('pickle/vocab.pkl', 'rb') as f:
        vocab = pickle.load(f)
with open('pickle/ixtoword.pkl', 'rb') as f:
        ixtoword = pickle.load(f)
with open('pickle/wordtoix.pkl', 'rb') as f:
        wordtoix = pickle.load(f)

print(len(vocab))
print(len(ixtoword))
print(len(wordtoix))
max_length = 34
vocab_size = 1652
embedding_dim = 200

def preprocess(image_path):
    img = image.load_img(image_path, target_size=(299, 299))
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)
    return x

def encode(image):
    image = preprocess(image)
    fea_vec = model_new.predict(image)
    print(fea_vec.shape)
    fea_vec = np.reshape(fea_vec, fea_vec.shape[1])
    return fea_vec

def beam_search_predictions(photo, index = 3):
    start = [wordtoix['startseq']]
    
    start_word = [[start, 0.0]]
    
    while len(start_word[0][0]) < max_length:
        temp = []
        for s in start_word:
            par_caps = sequence.pad_sequences([s[0]], maxlen=max_length, padding='post')
            preds = caption_model.predict([photo, np.array(par_caps)])
            
            word_preds = np.argsort(preds[0])[-index:]

            for w in word_preds:
                next_cap, prob = s[0][:], s[1]
                next_cap.append(w)
                prob += preds[0][w]
                temp.append([next_cap, prob])
                    
        start_word = temp
        start_word = sorted(start_word, reverse=False, key=lambda l: l[1])
        start_word = start_word[-index:]
    
    start_word = start_word[-1][0]
    intermediate_caption = [ixtoword[i] for i in start_word]

    final_caption = []
    
    for i in intermediate_caption:
        if i != 'endseq':
            final_caption.append(i)
        else:
            break
    
    final_caption = ' '.join(final_caption[1:])
    return final_caption

image_path = "istockphoto-1252455620-170667a.jpg"
img = plt.imread(image_path)

start = time.time()
encoded_image = encode(image_path)
encoded_image = encoded_image.reshape((1,2048)) 
caption = beam_search_predictions(encoded_image, index = 3)
diff = time.time() - start 
print(caption,diff)

plt.imshow(img)
plt.show()