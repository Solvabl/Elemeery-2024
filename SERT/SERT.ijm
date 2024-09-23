Dialog.createNonBlocking("Measure SERT signal in brain slices (confocal)");
 
Dialog.addDirectory("Select your directory ", "/");


Dialog.show();

masterDir = Dialog.getString();

close("*");

setBatchMode("hide");

input_images = masterDir + "/Images/"; 
list = getFileList(input_images);

function newImage() {
		resetMinAndMax(); 
		run("Set Measurements...", "area mean limit redirect=None decimal=3");
		run("Select None");
}

for (i = 0; i < list.length; i++){	
	file = input_images + list[i];
	open(file, 2); SERT = getTitle(); title = replace(SERT, "/Images/", ""); title = split(SERT, "/"); title = replace(title[0], ".tif", "");
	newImage();
	run("Enhance Contrast...", "saturated=0.35");
	run("Apply LUT");
	setThreshold(27000, 65535); // Change this
	
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
	run("Measure");
	setResult("Slice", nResults - 1, title); 
	
	close("*");
}

saveAs("Results", masterDir + "/SERT-intensity-area.csv");
close("Results");

