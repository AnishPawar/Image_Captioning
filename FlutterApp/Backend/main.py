# Imports
from flask import Flask,render_template,request, redirect, url_for, Response,jsonify

# from flask_ngrok import run_with_ngrok


from joblib import load
from flask import send_file
#import base64
from io import BytesIO
import os

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
from process import encode,preprocess,beam_search_predictions



def getPredictions(path):
    # image_path = "/Users/anishpawar/College_Stuff/TY_Online/Sem_V/DLFL/repo/DLFL_Miniproject/WebApp/TestApp/images/istockphoto-1252455620-170667a.jpg"
    img = plt.imread(path)

    start = time.time()
    encoded_image = encode(path,modelInception)
    encoded_image = encoded_image.reshape((1,2048)) 
    caption = beam_search_predictions(encoded_image,max_length,ixtoword,wordtoix,caption_model, index = 3)
    diff = time.time() - start 
    print(caption,diff)
    return caption
    

app = Flask(__name__)

  

@app.route('/api',methods=["POST"])
def home():
  f = request.files['images']
  print(f)
  f.save("received_images/"+f.filename)
  caption = getPredictions("received_images/"+f.filename)


  returndict = {'caption':caption}

  print(returndict)

  return jsonify(returndict)

  # return "OK GETS"




if __name__ == '__main__':
  # Model Loading
  modelInception = InceptionV3(weights='imagenet')
  modelInception = Model(modelInception.input, modelInception.layers[-2].output)
  caption_model = load_model('/Users/anishpawar/College_Stuff/TY_Online/Sem_V/DLFL/repo/DLFL_Miniproject/WebApp/TestApp/models/caption_model.h5')
  # Vocab Loading
  with open('/Users/anishpawar/College_Stuff/TY_Online/Sem_V/DLFL/repo/DLFL_Miniproject/WebApp/TestApp/pickle/vocab.pkl', 'rb') as f:
        vocab = pickle.load(f)
  with open('/Users/anishpawar/College_Stuff/TY_Online/Sem_V/DLFL/repo/DLFL_Miniproject/WebApp/TestApp/pickle/ixtoword.pkl', 'rb') as f:
          ixtoword = pickle.load(f)
  with open('/Users/anishpawar/College_Stuff/TY_Online/Sem_V/DLFL/repo/DLFL_Miniproject/WebApp/TestApp/pickle/wordtoix.pkl', 'rb') as f:
          wordtoix = pickle.load(f)
  max_length = 34
  vocab_size = 1652
  embedding_dim = 200
#   run_with_ngrok(app)
  app.run()