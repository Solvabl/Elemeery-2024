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
		run("Set Measurements...", "mean limit redirect=None decimal=3");
		run("Select None");
}

for (i = 0; i < list.length; i++){	
	file = input_images + list[i];
	open(file, 3); SERT = getTitle(); title = replace(SERT, "/Images/", ""); title = split(SERT, "/"); title = replace(title[0], ".tif", "");
	newImage();
	setThreshold(16, 65535); 
	run("Measure");
	setResult("Slice", nResults - 1, title); 

	close("*");
}

saveAs("Results", masterDir + "/SERT.csv");
close("Results");

