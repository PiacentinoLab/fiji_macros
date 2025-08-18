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
roioutput_dir = getDirectory("Choose a directory to save ROI sets.");
csv_dir = getDirectory("Choose a directory to save measurement results.");


// load the first set, with the nuclei detected by StarDist
run("Duplicate...", "duplicate channels=" + nc_channel);
rename("NC_img");
run("Z Project...", "projection=[Max Intensity]");
rename("Nuclei_projection");
selectWindow("Nuclei_projection");
roiManager("Deselect");
run("Median...", "radius=3");
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'Nuclei_projection', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'100.0', 'probThresh':'0.5', 'nmsThresh':'1.0', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
selectImage("Label Image");

// convert the ROIs to label map
run("ROIs to Label image");
rename("nuclei");
run("Max...", "value=1"); //this integer value is set to 1 for all ROIs. Everywhere outside of the ROIs is set to 0.
setMinAndMax(0, 1);
rename("nuclei_mask");
selectWindow("Nuclei_projection");
close();
selectWindow("Label Image");
close();

roiManager("reset");
	
selectImage(imgTitle);
run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
run("Z Project...", "projection=[Max Intensity]");
rename("A");
selectWindow("A");
	
//Input ROI File:
//roi=File.openDialog("Select ROI file");
//roiManager("Open",roi);
	
//Define ROIs
setTool("freehand");
waitForUser("Draw ROI 0 (Control Forebrain), then press ok");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","Cntl");
roiManager("Show All");
waitForUser("Draw ROI 1 (Experimental Forebrain), then press ok");
roiManager("Add");
roiManager("Select",1);
roiManager("Rename","Expt");

selectImage("NC_img");
run("Z Project...", "projection=[Max Intensity]");
roiManager("Show All");
rename("TEMP");
run("Enhance Contrast", "saturated=2");
run("Flatten");
saveAs("JPEG", roioutput_dir+imgTitle + "_largeNCROIs.jpg");

for (count=0;count<2;count++){
	
	// convert the ROIs to a mask 0/1
	roiManager("Select", count);
    run("Create Mask");
    rename("Large_roi_mask"+count);
	run("Max...", "value=1"); //this integer value is set to 1 for all ROIs. Everywhere outside of the ROIs is set to 0.
	setMinAndMax(0, 1);
	
	//roiManager("Select", count);
}

for (roi=0;roi<2;roi++){

	// multiply the label map with the mask 
	imageCalculator("Multiply create", "nuclei_mask","Large_roi_mask"+roi);
	//areas outside the "large_area_masks" were given a value of 0. When multiplied with overlapping images of nuclei, nuclei are set to 0.
	selectWindow("Result of nuclei_mask");
	rename("selected_nuclei");
	
	// convert the result back to ROIs
	roiManager("reset");
	run("Label image to ROIs", "rm=[RoiManager[size=30, visible=true]]");
	
	roiManager("Show All");
	roiManager("Deselect");
	roiManager("Measure");
	
	if (roi==0){
		saveAs("Results", csv_dir+imgTitle+"_CntlNCAreas.csv");
		selectImage("selected_nuclei");
		run("Add Image...", "image=A x=0 y=0 opacity=50");
    	run("Flatten");
		saveAs("JPEG", roioutput_dir+imgTitle + "_CntlNCROIs.jpg");
		run("Clear Results");
	}
	else{
		saveAs("Results", csv_dir+imgTitle+"_ExptNCAreas.csv");
		selectImage("selected_nuclei");
		run("Add Image...", "image=A x=0 y=0 opacity=50");
    	run("Flatten");
		saveAs("JPEG", roioutput_dir+imgTitle + "_ExptNCROIs.jpg");
		run("Clear Results");
		}
	selectWindow("Large_roi_mask"+roi);
	close();
	selectWindow("selected_nuclei");
	close();
	selectWindow("selected_nuclei-1");
	close();
}
selectWindow("A");
close();
selectWindow("NC_img");
close();
selectWindow("nuclei_mask");
close();
selectWindow("TEMP");
close();
selectWindow("TEMP-1");
close();
roiManager("reset");
// display ROIs on original image
selectImage(imgTitle);
roiManager("Show All");