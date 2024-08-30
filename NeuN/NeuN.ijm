Dialog.createNonBlocking("Count NeuN+ neurons in brain slices (oif files)");

Dialog.addDirectory("Select your directory ", "/");

Dialog.show();

masterDir = Dialog.getString();

close("*");

setBatchMode("hide");

input_images = masterDir + "/Images/"; 
list = getFileList(input_images);

overlayDir = dataDir + "/overlay/";
File.makeDirectory(overlayDir);

dataDir = masterDir + "/data/";
File.makeDirectory(dataDir);

for (i = 0; i < list.length; i++){	
	if(lengthOf(list[i]) < 12) {
		file = input_images + list[i];
		
		run("Bio-Formats Importer", "open=["+file+"] color_mode=Default rois_import=[ROI manager] specify_range view=Hyperstack stack_order=XYCZT c_begin=1 c_end=1 c_step=1 z_begin=6 z_end=7 z_step=1"); NeuN = getTitle(); title = replace(NeuN, "/Images/", ""); title = replace(title, ".oif", "");
		
		run("Z Project...", "projection=[Max Intensity]"); project = getTitle();rename(title);
		run("Convoluted Background Subtraction", "convolution=Gaussian radius=20"); 
		run("Smooth");
		run("Auto Threshold", "method=Li white");
		run("Convert to Mask");
		run("Erode");
		run("Fill Holes");
		
		run("Gaussian Blur...", "sigma=10");
		
		run("Auto Threshold", "method=RenyiEntropy ignore_black white");
		run("Analyze Particles...", "size=50-infinity pixel show=[Overlay Masks] summarize");
		
		saveAs("Jpeg", overlayDir + title +"_mask");
		close("*");
	}
	else { 
		i++;
	}
}

selectWindow("Summary");
saveAs("Results", dataDir + "NeuN-count.csv");
close("NeuN-count.csv");