from tensorflow import keras
from tensorflow.keras.applications.inception_v3 import InceptionV3
from tensorflow.keras.models import Model
from tensorflow.keras.models import load_model

import pickle
import numpy as np
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.inception_v3 import preprocess_input


modelInception = InceptionV3(weights='imagenet')
model_new = Model(modelInception.input, modelInception.layers[-2].output)

print(model_new.summary())