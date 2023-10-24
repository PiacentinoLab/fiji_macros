//Define channel numbers and names to measure
channels_list = newArray (2,3,4);
channels_names_list = newArray("smpd3_intron", "tfap2b", "gfp");

//Define directories
indir_czi = getDirectory("Navigate to CZI input directory");
indir_czi_list = getFileList(indir_czi);
dir_roi = getDirectory("Navigate to ROI directory");
//dir_roi_list = getFileList(dir_roi);
dir_csv = getDirectory("Navigate to CSV directory");

setBatchMode(false);

for(img=0;img<indir_czi_list.length;img++){

	//Close any leftover windows
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
	run("Bio-Formats Windowless Importer", "open=" + indir_czi + indir_czi_list[img]);
	name=File.nameWithoutExtension;
	rename("A");
	print("Processing: " + name);
	
	////Import Pre-saved ROIs
	//roiManager("open", dir_roi + name + ".zip");

	//Define ROIs Manually
	setTool("freehand");
	waitForUser("Draw ROI 0 (Background), then press ok");
	roiManager("Add");
	roiManager("Select",0);
	roiManager("Rename","Background");
	roiManager("Show All");
	waitForUser("Draw ROI 1 (Control Area), then press ok");
	roiManager("Add");
	roiManager("Select",1);
	roiManager("Rename","CntlArea");
	waitForUser("Draw ROI 2 (Experimental Area), then press ok");
	roiManager("Add");
	roiManager("Select",2);
	roiManager("Rename","ExptArea");

	// Loop through channels defined above
	run("Split Channels");
	for(chan=0;chan<channels_list.length;chan++){
		selectWindow("C"+channels_list[chan]+"-A");
		rename(channels_names_list[chan]);
		resetMinAndMax();
		//run("Subtract Background...", "rolling=200");
		roiManager("Show All");
		// Loop through each ROI and measure intensity
		for (i = 0; i < roiManager('count'); i++) {
		    roiManager('select', i);
		    run("Measure");
			run("Flatten", "slice");
			saveAs("JPEG", dir_roi+name+"_"+channels_names_list[chan]+"_ROIOverlay.jpg");
			close();
		}
		//Save out ROIs and results
		roiManager("Save", dir_roi+name+".zip");
		saveAs("Results", dir_csv+name+".csv");
	}
	//Close image windows
	run("Close All");
}
