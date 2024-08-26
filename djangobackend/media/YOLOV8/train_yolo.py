from ultralytics import YOLO
import os

def train_yolo():
    print("Training YOLO...")
    # Load a pre-trained YOLOv8 model
    model = YOLO("yolov8n.pt")

    source = "https://ultralytics.com/images/bus.jpg"

    # Make predictions
    results = model.predict(source, save=True, imgsz=320, conf=0.5)

    # Extract bounding box dimensions
    boxes = results[0].boxes.xywh.cpu()
    for box in boxes:
        x, y, w, h = box
        print(f"Width of Box: {w}, Height of Box: {h}")

    print('********************************************************************')
    print(os.getcwd())
    print('********************************************************************')

    # Example for dataset download and extraction (commented out for now)
    # os.system('curl -L "https://public.roboflow.com/ds/5EYxQJiUTb?key=Lr1mQYl8CA" -o roboflow.zip')
    os.system('tar -xf roboflow.zip')
    os.remove("roboflow.zip")

    # Training the YOLO model (commented out for now)
    model.train(data="data.yaml", epochs=1, lr0=0.01)

# This ensures the code below runs only when the script is executed directly
if __name__ == "__main__":
    train_yolo()
