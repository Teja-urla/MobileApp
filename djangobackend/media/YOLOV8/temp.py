import subprocess
import os
import shutil # To move the file
print("Running the script...")

source_directory = r"C:\Users\USMM TEJA\Desktop\IITH\7th Sem\Flutter_Projects\Login\djangobackend\media\YOLOV8"
filename = 'roboflow.zip'
source_path = os.path.join(source_directory, filename)

destination_dircetory = r"C:\Users\USMM TEJA\Desktop\IITH\7th Sem\Flutter_Projects\Login\djangobackend"

destination_path = os.path.join(destination_dircetory, filename)

shutil.move(source_path, destination_path)
print('*-**-----------***************************************')
print("File moved successfully")
print('*-**-----------***************************************')

# Command to run the script
# command = ['python', 'media/YOLOV8/../../../../../YOLOV8/temp.py']
command = ['python', 'media/YOLOV8/train_yolo.py']

# Run the script
subprocess.Popen(command)