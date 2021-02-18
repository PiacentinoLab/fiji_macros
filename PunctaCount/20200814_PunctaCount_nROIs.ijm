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
Stack.setActiveChannels("111");


//Optional: Input ROI File:
//roi=File.openDialog("Select ROI file");
//roiManager("Open",roi);

//Define ROIs Manually
roiManager("Show All");
waitForUser("ROIs", "Draw ROI for each desired location, and add to ROI manager with 't', then press ok after all ROIs drawn.");
run("Split Channels");

//Puncta counts - Channel 3
selectWindow("C3-A");
rename("Tf633");
selectWindow("Tf633");
resetMinAndMax();
run("Median...", "radius=2");
run("8-bit");
//run("Apply LUT");
run("Auto Local Threshold", "method=Phansalkar radius=15 parameter_1=0 parameter_2=0 white");
//setThreshold(15, 100);
//setOption("BlackBackground", true);
//run("Convert to Mask");

roiManager("Show All");
run("Analyze Particles...", "size=0.10-15.00 show=Masks exclude");
run("Invert LUT");
rename("AllROIs");

//Loop through ROIs and count puncta within each ROI
for(i=0;i<roiManager("count");i++){
	selectWindow("AllROIs");
	run("Duplicate...", "title=temp");
	rename(i);
	selectWindow(i);
	roiManager("Select", i);
	run("Analyze Particles...", "size=0.50-10.00 show=Nothing summarize exclude");
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
selectWindow("AllROIs");
close();
selectWindow("Tf633");
close();
selectWindow("C1-A");
close();
selectWindow("C2-A");
close();

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