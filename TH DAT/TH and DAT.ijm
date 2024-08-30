Dialog.createNonBlocking("Measure TH and DAT signal in brain slices");
 
Dialog.addDirectory("Select your directory ", "/");

Dialog.show();

masterDir = Dialog.getString();

close("*");

setBatchMode("hide");

function newImage() {
		resetMinAndMax();
		run("Set Measurements...", "mean area_fraction limit redirect=None decimal=3");
		run("Select None");
}

dirList = getFileList(masterDir);
for (f = 0; f < dirList.length; f++){
	parentFile = masterDir + dirList[f];
	if(lengthOf(dirList[f]) < 8) { 
		input_images = masterDir + dirList[f] + "Images/"; 
		list = getFileList(input_images);
		for (i = 0; i < list.length; i++){	
			file = input_images + list[i];
			
			// DAT 
			open(file, 1); DAT = getTitle(); title = replace(DAT, ".tif", "");
			newImage();
			run("Enhance Contrast...", "saturated=0.35");
			run("Apply LUT");
			setThreshold(12000, 65535); // Change this
			
			run("Create Selection");
			roiManager("Add");
			close("*");
			
			open(file, 1);
			newImage();
			roiManager("Select", 0);
			run("Make Inverse");
			run("Subtract...", "value=100000 slice");
			run("Select None");
			
			roiManager("Deselect");
			roiManager("Delete");
				
			setThreshold(1, 65535);
			run("Measure"); 
			setResult("Slice", nResults - 1, title); 
			IJ.renameResults("Summary");
			
			// TH
			open(file, 2); TH = getTitle(); 
			newImage();
			run("Enhance Contrast...", "saturated=0.35");
			run("Apply LUT");
			setThreshold(6250, 65535); // Change this
			
			run("Create Selection");
			roiManager("Add");
			close("*");
			
			open(file, 2);
			newImage();
			roiManager("Select", 0);
			run("Make Inverse");
			run("Subtract...", "value=100000 slice");
			run("Select None");
			
			roiManager("Deselect");
			roiManager("Delete");
				
			setThreshold(1, 65535);
			run("Measure"); THIntensity = getResult("Mean", 0); THArea = getResult("%Area", 0);
			close("Results");
			selectWindow("Summary"); IJ.renameResults("Results");
			setResult("TH", nResults - 1, THIntensity); 
			setResult("TH Area", nResults - 1, THArea); 
			
			close("*");
		}
		
		// Save files
		saveAs("Results", parentFile + "intensity.csv");
		close("Results");
	}
}