"""A simple image resize script"""
import sys
from pathlib import Path
from PIL import Image

def resize_image(image_path, output_path):
    """
    Resize pack image to minecraft size
    Output into pack/
    """
    with Image.open(image_path) as image:
        resized_image = image.resize((128, 128))
        resized_image.save(output_path)

if __name__ == "__main__":
    pack_path = Path(sys.argv[1])
    pack_output = Path(sys.argv[2])

    resize_image(pack_path, pack_output)
