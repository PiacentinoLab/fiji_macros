//////////////////////////////////////
// Define directories (User-Input):
indir_czi = getDirectory("Choose a directory for input CZIs");
indir_roi = getDirectory("Choose a directory for input ROIs");
outdir_intensity = getDirectory("Choose a Directory for output intensity CSVs");
//outdir_ROI = getDirectory("Choose a Directory for output ROIs");
indir_czi_list = getFileList(indir_czi);
indir_roi_list = getFileList(indir_roi);

// Specify channels to measure:
channel_1_number = 1;
channel_1_name = "GFP";
channel_2_number = 2;
channel_2_name = "Tf633";


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

	// Split channels and measure intensity from both channels
	run("Split Channels");
	selectWindow("C" + channel_1_number + "-A");
	rename(channel_1_name);
	roiManager("Deselect");
	roiManager("Measure");
	selectWindow("C" + channel_2_number + "-A");
	rename(channel_2_name);
	roiManager("Deselect");
	roiManager("Measure");
	saveAs("Results", outdir_intensity+name+"_Intensity.csv");

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

