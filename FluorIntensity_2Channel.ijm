//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
rename("A");
run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack");
run("Z Project...", "projection=[Max Intensity]");
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
	//roi=File.openDialog("Select ROI file");
	//roiManager("Open",roi);

//Define ROIs Manually (background, experimental and control sides)
waitForUser("Draw ROI 0 (Background Channel 1), then press ok");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","back1a");
roiManager("Show All");
waitForUser("Draw ROI 1 (Background Channel 1), then press ok");
roiManager("Add");
roiManager("Select",1);
roiManager("Rename","back1b");
waitForUser("Draw ROI 2 (Background Channel 1), then press ok");
roiManager("Add");
roiManager("Select",2);
roiManager("Rename","back1c");

waitForUser("Draw ROI 3 (Background Channel 2), then press ok");
roiManager("Add");
roiManager("Select",3);
roiManager("Rename","back2a");
waitForUser("Draw ROI 4 (Background Channel 2), then press ok");
roiManager("Add");
roiManager("Select",4);
roiManager("Rename","back2b");
waitForUser("Draw ROI 5 (Background Channel 2), then press ok");
roiManager("Add");
roiManager("Select",5);
roiManager("Rename","back2c");

waitForUser("Draw ROI 6 (Experimental ROI), then press ok");
roiManager("Add");
roiManager("Select",6);
roiManager("Rename","Expt");
waitForUser("Draw ROI 7 (Control ROI), then press ok");
roiManager("Add");
roiManager("Select",7);
roiManager("Rename","Cntl");
run("Split Channels");

//Measure background then ROI IntDen
//Channel 2
selectWindow("C2-MAX_A");
rename("TCFLef");
resetMinAndMax();
run("Median...", "radius=3");
roiManager("Show All");
roiManager("Select", 0);
run("Measure");
roiManager("Select", 1);
run("Measure");
roiManager("Select", 2);
run("Measure");
roiManager("Select", 7);
run("Measure");
roiManager("Select", 6);
run("Measure");
selectWindow("TCFLef");
close();

//Channel 3
selectWindow("C3-MAX_A");
rename("pCIG");
resetMinAndMax();
run("Median...", "radius=3");
roiManager("Show All");
roiManager("Select", 3);
run("Measure");
roiManager("Select", 4);
run("Measure");
roiManager("Select", 5);
run("Measure");
roiManager("Select", 7);
run("Measure");
roiManager("Select", 6);
run("Measure");
selectWindow("pCIG");
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
selectWindow("C1-MAX_A");
close();
selectWindow("C4-MAX_A");
close();
selectWindow("A");
close();
selectWindow("Results"); 
run("Close")