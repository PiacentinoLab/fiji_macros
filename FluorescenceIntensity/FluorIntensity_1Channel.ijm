// Define channel to measure and what it represents
ch_measure = 3
ch_label = "TCF/Lef"

// Learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
rename("A");
setTool("freehand");

// Project and rotate image, if necessary
run("Z Project...", "projection=[Max Intensity]");
//run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack");
run("Rotate 90 Degrees Left");
run("Flip Horizontally", "stack");

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

//Optional: Input ROI File:
//	roi=File.openDialog("Select ROI file");
//	roiManager("Open",roi);

//Define ROIs Manually (background, experimental and control sides)
waitForUser("Draw BACKGROUND ROI, then press ok");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","background");
roiManager("Show All");
waitForUser("Draw EXPERIMENTAL ROI, then press ok");
roiManager("Add");
roiManager("Select",1);
roiManager("Rename","Expt");
waitForUser("Draw CONTROL ROI, then press ok");
roiManager("Add");
roiManager("Select",2);
roiManager("Rename","Cntl");

//Measure background then ROI IntDen
Stack.setChannel(ch_measure);
rename(ch_label);
resetMinAndMax();
roiManager("Show All");
roiManager("Select", 0);
run("Measure");
roiManager("Select", 2);
run("Measure");
roiManager("Select", 1);
run("Measure");
//close();

//Save out ROIs
waitForUser("Choose a directory to save ROIs, then press ok");
dir = getDirectory("Choose a directory to save ROI sets.");
roiManager("Save", dir+name+".zip");

//Save out Measurements as csv
waitForUser("Choose a directory to save measurements, then press ok");
dir = getDirectory("Choose a directory to save measurement results.");
saveAs("Results", dir+name+".csv");

//Close image windows
run("Close All");