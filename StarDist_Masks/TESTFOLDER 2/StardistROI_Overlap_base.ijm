nc_channel = 2;
if (nImages!=1){
	exit("only one image can be opened!");
}
imgTitle = getTitle();

/*run("Z Project...", "projection=[Max Intensity]");
run("Duplicate...", "duplicate channels=nc_channel");
rename("A");
selectWindow("A");*/

// load the first set, indicating the ROI areas
roiManager("reset");
roi_dir = getDirectory("Choose large area directory.");
roi2_dir = getDirectory("Choose nuclei area directory.");
roilist=getFileList(roi_dir);
roi2list=getFileList(roi2_dir);
run("ROI Manager...");
for (count=0;count<roilist.length;count++){
	roiManager("Open", roi_dir + roilist[count]);
}

// convert the ROIs to a mask 0/1
run("ROIs to Label image"); //makes an image where each ROI is assigned an integer value
run("Max...", "value=1"); //this integer value is set to 1 for all ROIs. Everywhere outside of the ROIs is set to 0.
setMinAndMax(0, 1);
rename("Large_area_mask");

// load the second set, with the nuclei detected by StarDist
roiManager("reset");
run("ROI Manager...");
for (count=0;count<roi2list.length;count++){
	roiManager("Open", roi2_dir + roi2list[count]);
}

// convert the ROIs to label map
run("ROIs to Label image");
rename("nuclei");

// multiply the label map with the mask 
imageCalculator("Multiply create", "nuclei","Large_area_mask");
//areas outside the "large_area_masks" were given a value of 0. When multiplied with overlapping images of nuclei, nuclei are set to 0.
selectWindow("Result of nuclei");
rename("selected_nuclei");

// convert the result back to ROIs
roiManager("reset");
run("Label image to ROIs", "rm=[RoiManager[size=30, visible=true]]");

// cleanup
selectImage("Large_area_mask");
close();
selectImage("nuclei");
close();

// display ROIs on original image
selectImage(imgTitle);
roiManager("Show All");