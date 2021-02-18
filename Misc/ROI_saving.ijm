//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
rename("A");
setTool("freehand");
run("Channels Tool...");
Stack.setDisplayMode("composite");
Stack.setChannel(1);
setMinAndMax(300, 1000);
Stack.setChannel(2);
setMinAndMax(50, 2000);
Stack.setChannel(3);
run("Enhance Contrast", "saturated=0.2");
Stack.setActiveChannels("011");


//Optional: Input ROI File:
//roi=File.openDialog("Select ROI file");
//roiManager("Open",roi);

//Define ROIs Manually (background, experimental and control sides)
waitForUser("Background ROI", "Draw background ROI then press ok.");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","background");
roiManager("Show All");
waitForUser("ROIs", "Draw ROI for each desired location, and add to ROI manager with 't', then press ok after all ROIs drawn.");

Stack.setActiveChannels("110");
waitForUser("Puncta", "Count puncta, then press ok.");

//Save out ROIs
waitForUser("Choose a directory to save ROIs, then press ok");
dir = getDirectory("Choose a directory to save ROI sets.");
roiManager("Save", dir+name+".zip");

//Close image windows
selectWindow("A");
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