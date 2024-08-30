Dialog.createNonBlocking("Count DAPI+ cells in brain slices");
 
Dialog.addDirectory("Select your directory ", "/");

Dialog.show();

masterDir = Dialog.getString();

close("*");

setBatchMode("hide");

input_images = masterDir + "/Images/"; 
list = getFileList(input_images);

for (i = 0; i < list.length; i++){	
	file = input_images + list[i];
	
	open(file, 1); DAPI = getTitle(); title = replace(DAPI, "/Images/", ""); title = split(title, "/"); title = replace(title[0], ".tif", "");
	run("Select None");
	run("Convoluted Background Subtraction", "convolution=Gaussian radius=20"); 
	run("Smooth");
	setThreshold(55, 65535); // Change this
	run("Convert to Mask");
	
	run("Gaussian Blur...", "sigma=10");
	
	run("Auto Threshold", "method=RenyiEntropy ignore_black white");
	run("Watershed");
	run("Analyze Particles...", "size=50-infinity pixel show=[Overlay Masks] summarize");
	
	close("*");
}

selectWindow("Summary");
saveAs("Results", masterDir + "/DAPI.csv");
close("DAPI.csv");