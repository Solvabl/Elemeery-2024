Dialog.createNonBlocking("Measure brain slice area");

Dialog.addDirectory("Select your directory ", "/");

Dialog.show();

masterDir = Dialog.getString();

close("*");

setBatchMode("hide");

input_images = masterDir + "/Images/"; 
list = getFileList(input_images);

function newImage() {
		resetMinAndMax(); 
		run("Set Measurements...", "area limit redirect=None decimal=3");
		run("Select None");
}

for (i = 0; i < list.length; i++){	
	file = input_images + list[i];
	open(file, 1); DAPI = getTitle(); title = replace(DAPI, "/Images/", ""); title = split(title, "/"); title = replace(title[0], ".tif", "");
	newImage();
	setThreshold(1, 65535); 
	run("Measure");
	setResult("Slice", nResults - 1, title); 

	close("*");
}

saveAs("Results", masterDir + "/DAPI-area.csv");
close("Results");

