import os, glob 
import pandas as pd 

masterDir = os.path.dirname(__file__)

#
# Fix issue with some images not being processed by the Fiji macro
#

folder_paths = []
for entry_name in os.listdir(masterDir):
    entry_path = os.path.join(masterDir, entry_name)
    if os.path.isdir(entry_path):
        folder_paths.append(entry_path)

for(i, folder_path) in enumerate(folder_paths):
    fileName = folder_path.split('\\')[-1] # For PC
    overlayCount = len(glob.glob1(folder_path + "/data/overlay", "*.jpg"))
    imageCount = len(glob.glob1(folder_path + "/Images", "*.oif")) 

    if (overlayCount < imageCount):
        print(fileName + ": " + str(overlayCount) + "/" + str(imageCount)) 
        for(i, image) in enumerate(glob.glob1(folder_path + "/Images", "*.oif")):
            os.rename(folder_path + "/Images/" + image, folder_path + image)
            os.rename(folder_path + image, folder_path + "/Images/" + image)
        print("Fixed:" + fileName)

    # Number depends on number of images taken per brain.
    if (imageCount != 28):
        print("Warning - There are only " + str(imageCount) + " images in " + fileName + ".")
