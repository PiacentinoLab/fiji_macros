//Define directories
indir_czi = getDirectory("Choose a directory for input CZIs");
indir_czi_list = getFileList(indir_czi);
indir_roi = getDirectory("Choose a directory for input ROIs");
indir_roi_list = getFileList(indir_roi);
outdir_puncta = getDirectory("Choose a Directory for output Puncta");

setBatchMode(true);

for(i=0;i<indir_czi_list.length;i++){
	run("Bio-Formats Windowless Importer", "open=" + indir_czi + indir_czi_list[i]);
	name=File.nameWithoutExtension;
	print("Processing: " + name);

	if (isOpen("ROI Manager")) { 
    	     selectWindow("ROI Manager"); 
        	 run("Close"); 
    	} 

	rename("A");
	run("Split Channels");
	roiManager("open", indir_roi + name + ".zip")

	//Puncta counts
	//Channel 1
	selectWindow("C1-A");
	run("8-bit");
//	setMinAndMax(5, 500);
	run("Median...", "radius=3");


	

// Auto Local Threshold	
//	run("Apply LUT");
//	run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=0 parameter_2=0 white");

// Solid Threshold
//	run("Threshold...");
	setAutoThreshold("Huang dark");
//	waitForUser("Manually set threshold, hit apply, then hit OK");
	setThreshold(25, 255);
	setOption("BlackBackground", true);
	run("Convert to Mask");




	
	roiManager("Show All");
	run("Analyze Particles...", "size=0.30-5.00 show=Masks");
	run("Invert LUT");
	rename("AllROIs");
	
	//Important note: this for loop skips ROI 0 (background) for ease of later data processing
	for(j=1;j<roiManager("count");j++){
		selectWindow("AllROIs");
		run("Duplicate...", "title=temp");
		rename(j);
		selectWindow(j);
		roiManager("Select", j);
		run("Analyze Particles...", "size=0.30-5.00 show=Nothing summarize");
		selectWindow(j);
		close();
		}

	//Save out CSV for puncta
	selectWindow("Summary"); 
	saveAs("Results", outdir_puncta + name + "_Puncta.csv");
	close();
	run("Close All");
		
	//Close image windows
	roiManager("Deselect");
	roiManager("Delete");
	
	if (isOpen("Results")) { 
    	     selectWindow("Results"); 
        	 run("Close"); 
    	} 
	if (isOpen("Summary")) { 
    	     selectWindow("Summary"); 
        	 run("Close"); 
    	} 
	if (isOpen("ROI Manager")) { 
    	     selectWindow("ROI Manager"); 
        	 run("Close"); 
    	} 
    	
}