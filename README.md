# ImageJ and Python Analysis for Brain Slice Measurement
This repository contains scripts for analyzing confocal brain slice images using ImageJ and Python. The scripts measure TH and DAT signals and compile results into a comprehensive format.

**File Structure**
The project has the following directory structure:

project-root :
1.  TH DAT.ijm             # ImageJ 
2. Compile csv.py          # Python script to compile results
3. /Images folder containing the .oif or .tif images.

**How to Use**
Step 1: Image Acquisition
Place your confocal brain slice images in the /Images folder. Supported formats include .oif (for TH and DAT images) or can be adapted to.tif files using open(file,x) x being the channel number.

Step 2: Running the ImageJ Macro
Open ImageJ.
Load the macro .ijm.
Execute the macro by following these steps:
The dialog will prompt you to select the directory containing the images. Select the project-root folder.
The macro will process the images in the /Images folder and measure the TH and DAT signals.
Results will be saved as intensity-whole-img.csv in the respective brain slice folders.

Step 3: Running the Python Script
Make sure you have Python installed along with the required libraries: pandas and numpy.
Run the .py script in Visual Studio Code.

The script will read all intensity-whole-img.csv files and compile the results into compilation-whole-img.xlsx, which will be saved in the project-root directory.

Step 4: Analyzing Results
Open compilation-whole-img.xlsx using Excel or any spreadsheet application.
Review the compiled results.

**Notes**
Ensure all images follow the naming conventions required by the scripts.
The scripts are designed to work in a batch mode to process multiple images efficiently.
You may adapt the macro and Python script for other analyses by following a similar structure.

**License**
This project is licensed under the MIT License - see the LICENSE file for details.

**Acknowledgments**
This work is built upon the ImageJ and Python ecosystems. Special thanks to the developers of these platforms for their invaluable tools.
