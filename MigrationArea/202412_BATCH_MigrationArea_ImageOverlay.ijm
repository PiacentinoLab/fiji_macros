//Define directories (Hard-Coded):
indir_czi = getDirectory("Navigate to directory with raw images.");
indir_czi_list = getFileList(indir_czi);

outdir_csv = getDirectory("Choose a directory to save measurement results.");
outdir_roi = getDirectory("Choose a directory to save ROIs and overlays");

run("Set Measurements...", "area mean perimeter shape integrated display redirect=None decimal=3");

setBatchMode(false);

for(img=0;img<indir_czi_list.length;img++){

	//Close unnecessary windows from last analysis
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
	
	//learn file name, prepare file and Fiji for analysis
	
	run("Bio-Formats Windowless Importer", "open=" + indir_czi + indir_czi_list[img]);
	name=File.nameWithoutExtension;
	run("Z Project...", "projection=[Max Intensity]");
	rename("A");

	//Input ROI File:
	//roi=File.openDialog("Select ROI file");
	//roiManager("Open",roi);
	
	//Rotate image to horizontal or vertical
	waitForUser("Rotate image until horizontal or vertical, then press ok");
	
	//Add scale bar to define AP length for measurement
	run("Scale Bar...", "width=400 height=8 font=28 color=White background=None location=[Lower Right] bold overlay");
	
	//Define ROIs
	setTool("freehand");
	waitForUser("Draw ROI 0 (Control Area), then press ok");
	roiManager("Add");
	roiManager("Select",0);
	roiManager("Rename","CntlArea");
	roiManager("Show All");
	waitForUser("Draw ROI 1 (Experimental Area), then press ok");
	roiManager("Add");
	roiManager("Select",1);
	roiManager("Rename","ExptArea");
		
	//Measure areas
	roiManager("Show All");
	roiManager("Select", 0);
	run("Measure");
	roiManager("Select", 1);
	run("Measure");
	//Save out Measurements as csv
	saveAs("Results", outdir_csv+name+".csv");
	
	//Save out ROI/Image Overlay
	roiManager("Save", outdir_roi+name+".zip");
	selectWindow("A");
	roiManager("Show All");
	run("Flatten", "slice");
	saveAs("JPEG", outdir_roi+name+"_ROIOverlay.jpg");
	
	//Close image windows
	run("Close All");

}