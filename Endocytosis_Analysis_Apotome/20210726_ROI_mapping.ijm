//Macro to define ROIs for subsequent batch analysis//
//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
run("Z Project...", "projection=[Max Intensity]");
rename("A");
setTool("freehand");
run("Channels Tool...");
Stack.setDisplayMode("composite");
Stack.setChannel(1);
run("Magenta");
run("Enhance Contrast", "saturated=0.3");
Stack.setChannel(2);
run("Green");
run("Enhance Contrast", "saturated=0.2");
Stack.setChannel(3);
run("Green");
run("Enhance Contrast", "saturated=0.3");
Stack.setActiveChannels("110");

//Define ROIs Manually (background, then each cell for analysis)
waitForUser("Background ROI", "Draw background ROI then press ok.");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","background");
roiManager("Show All");
waitForUser("ROIs", "Draw ROI for each desired location, and add to ROI manager with 't', then press ok after all ROIs drawn.");

//Save out ROIs
roi_dir = getDirectory("home")+"Drive//git//fiji_macros//Endocytosis_Analysis_Apotome//1_ROIs//"
//roi_dir = getDirectory("Choose a directory to save ROI sets.");
roiManager("Save", roi_dir+name+".zip");

//Close unnecessary windows from last analysis
run("Close All");
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
