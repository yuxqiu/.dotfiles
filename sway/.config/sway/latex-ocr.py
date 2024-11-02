import os
import sys

# comment these when running the script for the first time
# to download the model from hf
os.environ["HF_DATASETS_OFFLINE"] = "1"
os.environ["HF_HUB_OFFLINE"] = "1"

from texify.inference import batch_inference
from texify.model.model import load_model
from texify.model.processor import load_processor
from PIL import Image, ImageOps
from contextlib import redirect_stdout
import io

import numpy as np


def is_dark_background(image, threshold=128):
    # Convert image to grayscale and resize to a smaller size to speed up processing
    grayscale_image = image.convert("L").resize((50, 50))
    # Calculate the mean brightness
    brightness = np.mean(np.array(grayscale_image))
    # If brightness is less than the threshold, consider it a dark background
    return brightness < threshold


def invert_image(image):
    # Invert the colors of the image
    return ImageOps.invert(image)


try:
    image_data = sys.stdin.buffer.read()
    image_file = io.BytesIO(image_data)
    img = Image.open(image_file)
except:
    exit(1)

# the model is bad at dealing with image of dark background
if is_dark_background(img):
    img = invert_image(img)

# silence the output
with redirect_stdout(io.StringIO()):
    model = load_model()
    processor = load_processor()

result = batch_inference([img], model, processor)[0]
print(result)
