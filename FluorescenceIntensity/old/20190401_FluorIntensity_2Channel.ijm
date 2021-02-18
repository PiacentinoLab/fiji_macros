//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
rename("A");
run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack");
//run("Z Project...", "projection=[Max Intensity]");
setTool("freehand");

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
waitForUser("Draw ROI 0 (Background), then press ok");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","background");
roiManager("Show All");
waitForUser("Draw ROI 1 (Background), then press ok");
roiManager("Add");
roiManager("Select",1);
roiManager("Rename","background");
waitForUser("Draw ROI 2 (Background), then press ok");
roiManager("Add");
roiManager("Select",2);
roiManager("Rename","background");

waitForUser("Draw ROI 3 (Experimental ROI), then press ok");
roiManager("Add");
roiManager("Select",3);
roiManager("Rename","Expt");
waitForUser("Draw ROI 4 (Control ROI), then press ok");
roiManager("Add");
roiManager("Select",4);
roiManager("Rename","Cntl");
run("Split Channels");

//Measure background then ROI IntDen
//Channel 2
selectWindow("C2-A");
rename("H2BRFP");
resetMinAndMax();
roiManager("Show All");
roiManager("Select", 0);
run("Measure");
roiManager("Select", 1);
run("Measure");
roiManager("Select", 2);
run("Measure");
roiManager("Select", 4);
run("Measure");
roiManager("Select", 3);
run("Measure");
selectWindow("H2BRFP");
close();

//Channel 3
selectWindow("C3-A");
rename("TCFLefd2eGFP");
resetMinAndMax();
roiManager("Show All");
roiManager("Select", 0);
run("Measure");
roiManager("Select", 1);
run("Measure");
roiManager("Select", 2);
run("Measure");
roiManager("Select", 4);
run("Measure");
roiManager("Select", 3);
run("Measure");
selectWindow("TCFLefd2eGFP");
close();


//Save out ROIs
waitForUser("Choose a directory to save ROIs, then press ok");
dir = getDirectory("Choose a directory to save ROI sets.");
roiManager("Save", dir+name+".zip");

//Save out Measurements as csv
waitForUser("Choose a directory to save measurements, then press ok");
dir = getDirectory("Choose a directory to save measurement results.");
saveAs("Results", dir+name+".csv");

//Close image windows
selectWindow("C1-A");
close();
selectWindow("C4-A");
close();
selectWindow("Results"); 
run("Close");
selectWindow("ROI Manager"); 
run("Close");