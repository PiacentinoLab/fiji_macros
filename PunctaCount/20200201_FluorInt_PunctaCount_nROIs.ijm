//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
rename("A");
setTool("freehand");
run("Channels Tool...");
Stack.setDisplayMode("composite");
Stack.setChannel(1);
run("Enhance Contrast", "saturated=0.3");
Stack.setChannel(2);
run("Enhance Contrast", "saturated=0.2");
Stack.setChannel(3);
run("Enhance Contrast", "saturated=0.2");
Stack.setActiveChannels("011");


//Optional: Input ROI File:
roi=File.openDialog("Select ROI file");
roiManager("Open",roi);

//Define ROIs Manually (background, experimental and control sides)
//waitForUser("Background ROI", "Draw background ROI then press ok.");
//roiManager("Add");
//roiManager("Select",0);
//roiManager("Rename","background");
//roiManager("Show All");
//waitForUser("ROIs", "Draw ROI for each desired location, and add to ROI manager with 't', then press ok after all ROIs drawn.");
run("Split Channels");

//Measure background then ROI IntDen
//Channel 1
selectWindow("C1-A");
rename("pHrodo-FITC");
resetMinAndMax();
//run("Median...", "radius=1");
roiManager("Show All");
roiManager("Deselect");
roiManager("Measure");

//Save out CSV for intensity
waitForUser("Choose a directory to save intensity measurements, then press ok");
dir = getDirectory("Choose a directory to save measurement results.");
saveAs("Results", dir+name+"_Intensity.csv");

//Puncta counts
//Channel 1
selectWindow("pHrodo-FITC");
run("8-bit");
setMinAndMax(5, 50);
run("Apply LUT");
run("Auto Local Threshold", "method=Bernsen radius=10 parameter_1=0 parameter_2=0 white");
roiManager("Show All");
run("Analyze Particles...", "size=0.20-Infinity show=Masks");
run("Invert LUT");
rename("AllROIs");

//Important note: this for loop skips ROI 0 (background) for ease of later data processing
for(i=1;i<roiManager("count");i++){
	selectWindow("AllROIs");
	run("Duplicate...", "title=temp");
	rename(i);
	selectWindow(i);
	roiManager("Select", i);
	run("Analyze Particles...", "size=0.5-Infinity show=Nothing summarize");
	selectWindow(i);
	close();
}

//Save out CSV for puncta
waitForUser("Choose a directory to save puncta counts, then press ok");
dir = getDirectory("Choose a directory to save measurement results.");
saveAs("Results", dir+name+"_Puncta.csv");

//Save out ROIs
waitForUser("Choose a directory to save ROIs, then press ok");
dir = getDirectory("Choose a directory to save ROI sets.");
roiManager("Save", dir+name+".zip");

//Close image windows
selectWindow("pHrodo-FITC");
close();
selectWindow("AllROIs");
close();
selectWindow(name+"_Puncta.csv");
close();
selectWindow("C2-A");
close();
//selectWindow("C3-A");
//close();

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