//Define directories
indir_czi = getDirectory("Choose a directory for input CZIs");
indir_czi_list = getFileList(indir_czi);
indir_roi = getDirectory("Choose a directory for input ROIs");
indir_roi_list = getFileList(indir_roi);

//Go through images and open ROIs
for(i=0;i<indir_czi_list.length;i++){
	run("Bio-Formats Windowless Importer", "open=" + indir_czi + indir_czi_list[i]);
	name=File.nameWithoutExtension;

	if (isOpen("ROI Manager")) { 
    	     selectWindow("ROI Manager"); 
        	 run("Close"); 
    	} 

	run("8-bit");
	run("Brightness/Contrast...");
	run("Channels Tool...");
	Stack.setDisplayMode("composite");
	Stack.setChannel(1);
	setMinAndMax(0, 75);
	Stack.setChannel(2);
	setMinAndMax(0, 150);
	Stack.setActiveChannels("110");

	roiManager("open", indir_roi + name + ".zip")
	roiManager("Show All");

	waitForUser("Confirm ROIs, delete any ambiguous cells");

	//Save out ROIs
	roiManager("Save", indir_roi+name+".zip");

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