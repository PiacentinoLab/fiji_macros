//Define directories (Hard-Coded):
indir_czi = getDirectory("home")+"Drive//BronnerLab//Data//ImageData//20200820_Tf633_Rep1;2//DF1//0_Optimization//"
indir_roi = getDirectory("home")+"Drive//BronnerLab//Data//ImageData//20200820_Tf633_Rep1;2//DF1//1_ROIs//"
outdir_puncta = getDirectory("home")+"Drive//BronnerLab//Data//ImageData//20200820_Tf633_Rep1;2//DF1//2_Puncta_GlobalThresh//"
outdir_intensity = getDirectory("home")+"Drive//BronnerLab//Data//ImageData//20200820_Tf633_Rep1;2//DF1//3_Intensity//"
indir_czi_list = getFileList(indir_czi);
indir_roi_list = getFileList(indir_roi);

//Define directories (User-Input):
//indir_czi = getDirectory("Choose a directory for input CZIs");
//indir_roi = getDirectory("Choose a directory for input ROIs");
//outdir_puncta = getDirectory("Choose a Directory for output puncta CSVs");
//outdir_intensity = getDirectory("Choose a Directory for output intensity CSVs");
//outdir_ROI = getDirectory("Choose a Directory for output ROIs");
//indir_czi_list = getFileList(indir_czi);
//indir_roi_list = getFileList(indir_roi);


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
	
	
	
	run("Split Channels");
	
	//Puncta counts - Channel 3
	selectWindow("C3-A");
	run("Duplicate...", " ");
	rename("Tf633-puncta");
	selectWindow("Tf633-puncta");
	resetMinAndMax();
	run("Median...", "radius=2");
	run("8-bit");
	run("Auto Threshold", "method=Triangle white");
//	setAutoThreshold("Huang dark");
//	setThreshold(55, 255);
//	setOption("BlackBackground", true);
//	run("Convert to Mask");

	roiManager("Show All");
	run("Analyze Particles...", "size=0.25-15.00 show=Masks exclude");
	run("Invert LUT");
	rename("AllROIs");

	//Loop through ROIs and count puncta within each ROI
	for(roi=1;roi<roiManager("count");roi++){
		selectWindow("AllROIs");
		run("Duplicate...", "title=temp");
		rename(roi);
		selectWindow(roi);
		roiManager("Select", roi);
//		run("Analyze Particles...", "size=0.25-15.00 show=Nothing summarize exclude");
		run("Analyze Particles...", "size=0.25-15.00 display exclude");
		selectWindow(roi);
		close();
	}
	
	//Save particle counts, then close results window
	saveAs("Results", outdir_puncta+name+"_Puncta.csv");
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


	//Measure Intensity
	selectWindow("C3-A");
	run("Duplicate...", " ");
	rename("Tf633-intensity");
	selectWindow("Tf633-intensity");
	resetMinAndMax();
	roiManager("Show All");
	roiManager("Deselect");
	run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
	roiManager("Measure");
	
	//Save intensity measurements
	saveAs("Results", outdir_intensity+name+"_Intensity.csv");
//	roiManager("Save", outdir_ROI+name+".zip");
	
	//Close image and results windows
	run("Close All");
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

//	 waitForUser("Click OK when ready");
 }