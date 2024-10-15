Dialog.createNonBlocking("Measure TH and DAT signal in brain slices (confocal)");
 
Dialog.addDirectory("Select your directory ", "/");

Dialog.show();

masterDir = Dialog.getString();

close("*");

setBatchMode("hide");

dirList = getFileList(masterDir);
for (f = 0; f < dirList.length; f++){
	parentFile = masterDir + dirList[f];
	if(lengthOf(dirList[f]) < 4) { 
		input_images = masterDir + dirList[f] + "/Images/"; 
		list = getFileList(input_images);
		
		function newImage() {
				resetMinAndMax(); 
				run("Set Measurements...", "mean redirect=None decimal=3");
		}
		
		for (i = 0; i < list.length; i++){	
			if(lengthOf(list[i]) < 12) {
				file = input_images + list[i];
				run("Bio-Formats Importer", "open=["+file+"]"); DAT = getTitle(); title = split(DAT, "/"); title = replace(title[2], ".oif", "");
				newImage();
				run("Measure");
				setResult("Slice", nResults - 1, title); 
				IJ.renameResults("Summary");
				
				run("Next Slice [>]"); TH = getTitle(); 
				newImage();
				run("Measure"); THIntensity = getResult("Mean", 0);
				close("Results");
				selectWindow("Summary"); IJ.renameResults("Results");
				setResult("TH", nResults - 1, THIntensity); 
		
				close("*");
			} else { 
				i++;
			}
		}
		
		saveAs("Results", parentFile + "intensity-whole-img.csv");
		close("Results");
	}
}