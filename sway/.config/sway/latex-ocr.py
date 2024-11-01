import os
import sys

# comment these when running the script for the first time
# to download the model from hf
os.environ["HF_DATASETS_OFFLINE"] = "1"
os.environ["HF_HUB_OFFLINE"] = "1"

from texify.inference import batch_inference
from texify.model.model import load_model
from texify.model.processor import load_processor
from PIL import Image
from contextlib import redirect_stdout
import io


try:
    image_data = sys.stdin.buffer.read()
    image_file = io.BytesIO(image_data)
    img = Image.open(image_file)
except:
    exit(1)

# silence the output
with redirect_stdout(io.StringIO()):
    model = load_model()
    processor = load_processor()

result = batch_inference([img], model, processor)[0]
print(result)
