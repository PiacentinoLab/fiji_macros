//////////////////////////////////////
// Define directories (User-Input):
//indir_czi = getDirectory("Choose a directory for input CZIs");
//indir_roi = getDirectory("Choose a directory for input ROIs");
//outdir_puncta = getDirectory("Choose a Directory for output puncta CSVs");
//outdir_intensity = getDirectory("Choose a Directory for output intensity CSVs");
//outdir_ROI = getDirectory("Choose a Directory for output ROIs");
//indir_czi_list = getFileList(indir_czi);
//indir_roi_list = getFileList(indir_roi);

// Define directories (Hard-Coded):
indir_czi = getDirectory("home")+"Drive//git//fiji_macros//Endocytosis_Analysis//0_CZIs//"
indir_roi = getDirectory("home")+"Drive//git//fiji_macros//Endocytosis_Analysis//1_ROIs//"
outdir_puncta = getDirectory("home")+"Drive//git//fiji_macros//Endocytosis_Analysis//2_Puncta//"
outdir_intensity = getDirectory("home")+"Drive//git//fiji_macros//Endocytosis_Analysis//3_Intensity//"
indir_czi_list = getFileList(indir_czi);
indir_roi_list = getFileList(indir_roi);

//////////////////////////////////////

// Define measurement parameters
run("Set Measurements...", "area mean integrated display redirect=None decimal=3");

// Toggle batch mode
setBatchMode(true);

// Start for loop to go through each image for analysis
for(i=0;i<indir_czi_list.length;i++){
	// Open image
	run("Bio-Formats Windowless Importer", "open=" + indir_czi + indir_czi_list[i]);
	name=File.nameWithoutExtension;
	rename("A");
	print("Processing: " + name);
	// Open ROIs
	roiManager("open", indir_roi + name + ".zip");
	roiManager("show all");

	// Prepare image for thresholding
	run("Duplicate...", "duplicate channels=3");
	selectWindow("A");
	close();
	rename("A");
	run("Duplicate...", " ");
	rename("threshA");
	resetMinAndMax();
	run("Median...", "radius=2");
	run("8-bit");

	//// Threshold image //// 
	
	// Manual:
//	run("Threshold...");
//	waitForUser("Define threshold then click OK");
//	setOption("BlackBackground", true);
//	run("Convert to Mask");
//	run("Close");

	// Automatic:
//	run("Auto Threshold", "method=Default white");
//	run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=0 parameter_2=0 white"); 
	run("Auto Local Threshold", "method=Phansalkar radius=15 parameter_1=0 parameter_2=0 white"); 
//	setThreshold(5, 255);
//	run("Convert to Mask", "method=Default background=Dark calculate black");


//////////////////////////////////////

	// Loop through ROIs and count puncta within each ROI (SUMMARY)
	roiManager("Show All");
	for(roi=1;roi<roiManager("count");roi++){
		selectWindow("threshA");
		run("Duplicate...", "title=temp");
		rename(roi);
		roiManager("Select", roi);
		run("Analyze Particles...", "size=0.25-15.00 show=Nothing summarize exclude");
		run("Analyze Particles...", "size=0.1-15.00 show=Nothing summarize exclude");
		close();
	}
	saveAs("Results", outdir_puncta+name+"_PunctaSummary.csv");
	if (isOpen(name+"_PunctaSummary.csv")) { 
	         selectWindow(name+"_PunctaSummary.csv"); 
	         run("Close"); 
	    } 

//////////////////////////////////////


//	//Loop through ROIs and measure each puncta within each ROI (DETAILS)
//	for(roi=1;roi<roiManager("count");roi++){
//		selectWindow("threshA");
//		run("Duplicate...", "title=temp");
//		rename(roi);
//		roiManager("Select", roi);
//		run("Analyze Particles...", "size=0.25-15.00 display exclude");
//		close();
//	}
//	saveAs("Results", outdir_puncta+name+"_PunctaDetails.csv");
//	if (isOpen("Results")) { 
//	         selectWindow("Results"); 
//	         run("Close"); 
//	    } 

//////////////////////////////////////
	
//	// Go back to raw image and measure signal intensity
//	selectWindow("A");
//	roiManager("Show All");
//	roiManager("Deselect");
//	roiManager("Measure");
//	saveAs("Results", outdir_intensity+name+"_Intensity.csv");

//////////////////////////////////////
	
	// Close out analysis in preparation for the next run
	roiManager("Deselect");
	roiManager("Delete");
	if (isOpen("ROI Manager")) { 
	         selectWindow("ROI Manager"); 
	         run("Close"); 
	    } 
	if (isOpen("Results")) { 
	         selectWindow("Results"); 
	         run("Close"); 
	    } 
	if (isOpen("Summary")) { 
	         selectWindow("Summary"); 
	         run("Close"); 
	    } 
	if (isOpen(name+"_Puncta.csv")) { 
	         selectWindow(name+"_Puncta.csv"); 
	         run("Close"); 
	    } 
run("Close All");
}

