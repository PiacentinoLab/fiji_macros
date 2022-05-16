//Define directories (Hard-Coded):
indir_czi = getDirectory("home")+"Desktop//processing//czis//"
indir_roi = getDirectory("home")+"Desktop//processing//rois//"
outdir_intensity = getDirectory("home")+"Desktop//processing//csvs//"
indir_czi_list = getFileList(indir_czi);
indir_roi_list = getFileList(indir_roi);

//Define channels to measure and their names
measure_channel_1 = 3
measure_channel_1_name = "RFP"
measure_channel_2 = 4
measure_channel_2_name = "EGFP"

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
	roiManager("open", indir_roi + name + ".zip");

	//Add scale bar to define AP length for measurement
	run("Scale Bar...", "width=400 height=8 font=28 color=White background=None location=[Lower Right] bold overlay");

	run("Split Channels");
	
	//Measure background then ROI IntDen
	//Channel 2
	selectWindow("C" + toString(measure_channel_1) + "-A");
	rename(measure_channel_1_name);
	resetMinAndMax();
	run("Subtract Background...", "rolling=200");
	roiManager("Show All");
	roiManager("Select", 0);
	run("Measure");
	roiManager("Select", 1);
	run("Measure");
	roiManager("Select", 2);
	run("Measure");
	selectWindow(measure_channel_1_name);
	close();
	
	//Channel 3
	selectWindow("C" + toString(measure_channel_2) + "-A");
	rename(measure_channel_2_name);
	resetMinAndMax();
	run("Subtract Background...", "rolling=200");
	roiManager("Show All");
	roiManager("Select", 0);
	run("Measure");
	roiManager("Select", 1);
	run("Measure");
	roiManager("Select", 2);
	run("Measure");
	selectWindow(measure_channel_2_name);
	close();
	
	//Save out Measurements as csv
	saveAs("Results", outdir_intensity+name+".csv");
	
	//Close image windows
	run("Close All");

}