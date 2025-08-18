nc_channel = 2;
if (nImages!=1){
	exit("only one image can be opened!");
}
imgTitle = getTitle();

/*run("Z Project...", "projection=[Max Intensity]");
run("Duplicate...", "duplicate channels=nc_channel");
rename("A");
selectWindow("A");*/

roiManager("reset");
roi_dir = getDirectory("Choose large area directory.");
nuclei_dir = getDirectory("Choose nuclei area directory.");
roilist=getFileList(roi_dir);
nucleilist=getFileList(nuclei_dir);

roioutput_dir = getDirectory("Choose a directory to save ROI sets.");
csv_dir = getDirectory("Choose a directory to save measurement results.");


// load the first set, with the nuclei detected by StarDist

run("ROI Manager...");
for (count=0;count<nucleilist.length;count++){
	roiManager("Open", nuclei_dir + nucleilist[count]);
}

// convert the ROIs to label map
run("ROIs to Label image");
rename("nuclei");
run("Max...", "value=1"); //this integer value is set to 1 for all ROIs. Everywhere outside of the ROIs is set to 0.
setMinAndMax(0, 1);
rename("nuclei_mask");


for (count=0;count<roilist.length;count++){
	
	//selectImage(imgTitle);
	//run("Duplicate...", "title=temp_large_mask");
	
	roiManager("reset");
	run("ROI Manager...");
	roiManager("Open", roi_dir + roilist[count]);
	// convert the ROIs to a mask 0/1
	run("ROIs to Label image"); //makes an image where each ROI is assigned an integer value
	run("Max...", "value=1"); //this integer value is set to 1 for all ROIs. Everywhere outside of the ROIs is set to 0.
	setMinAndMax(0, 1);
	rename("Large_area_mask");

	
	// multiply the label map with the mask 
	imageCalculator("Multiply create", "nuclei_mask","Large_area_mask");
	//areas outside the "large_area_masks" were given a value of 0. When multiplied with overlapping images of nuclei, nuclei are set to 0.
	selectWindow("Result of nuclei_mask");
	rename("selected_nuclei");
	
	// convert the result back to ROIs
	roiManager("reset");
	run("Label image to ROIs", "rm=[RoiManager[size=30, visible=true]]");
	
	roiManager("Show All");
	roiManager("Deselect");
	roiManager("Measure");
	
	if (count==0){
		saveAs("Results", csv_dir+imgTitle+"_CntlNCAreas.csv");
		roiManager("Open", roi_dir + roilist[count]);
		run("Flatten");
		saveAs("JPEG", roioutput_dir+imgTitle + "_CntlNCROIs.jpg");
		run("Clear Results");
	}
	else{
		saveAs("Results", csv_dir+imgTitle+"_ExptNCAreas.csv");
		roiManager("Open", roi_dir + roilist[count]);
		run("Flatten");
		saveAs("JPEG", roioutput_dir+imgTitle + "_ExptNCROIs.jpg");
		run("Clear Results");
		}
	selectWindow("Large_area_mask");
	close();
	selectWindow("selected_nuclei");
	close();
	selectWindow("selected_nuclei-1");
	close();
}

// display ROIs on original image
selectImage(imgTitle);
roiManager("Show All");