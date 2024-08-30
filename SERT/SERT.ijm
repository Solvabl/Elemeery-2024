Dialog.createNonBlocking("Measure SERT signal in brain slices");
 
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
	open(file, 3); SERT = getTitle(); title = replace(SERT, "/Images/", ""); title = split(SERT, "/"); title = replace(title[0], ".tif", "");
	newImage();
	setThreshold(450, 65535); // Change this
	run("Measure");
	setResult("Slice", nResults - 1, title); 

	close("*");
}

// Save files
saveAs("Results", masterDir + "/SERT.csv");
close("Results");

