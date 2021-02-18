//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
rename("A");
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

//Input ROI File:
	//roi=File.openDialog("Select ROI file");
	//roiManager("Open",roi);

//Define ROIs (background, experimental and control sides)
waitForUser("Draw ROI 0 (Background Channel 1), then press ok");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","background");
roiManager("Show All");
waitForUser("Draw ROI 1 (Background Channel 1), then press ok");
roiManager("Add");
roiManager("Select",1);
roiManager("Rename","background");
waitForUser("Draw ROI 2 (Background Channel 1), then press ok");
roiManager("Add");
roiManager("Select",2);
roiManager("Rename","background");

waitForUser("Draw ROI 3 (Background Channel 2), then press ok");
roiManager("Add");
roiManager("Select",3);
roiManager("Rename","background");
waitForUser("Draw ROI 4 (Background Channel 2), then press ok");
roiManager("Add");
roiManager("Select",4);
roiManager("Rename","background");
waitForUser("Draw ROI 5 (Background Channel 2), then press ok");
roiManager("Add");
roiManager("Select",5);
roiManager("Rename","background");

waitForUser("Draw ROI 6 (Experimental side), then press ok");
roiManager("Add");
roiManager("Select",6);
roiManager("Rename","Expt");
waitForUser("Draw ROI 7 (Control side), then press ok");
roiManager("Add");
roiManager("Select",7);
roiManager("Rename","Cntl");

//Reset images for analysis
resetMinAndMax();
run("Split Channels");

//Measure background then ROI IntDen
//Channel 1
run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
selectWindow("C1-A");
resetMinAndMax();
rename("CntlSide1");
run("Duplicate...", "title=ExptSide1");
selectWindow("CntlSide1");
run("Duplicate...", "title=Background1a");
selectWindow("CntlSide1");
run("Duplicate...", "title=Background1b");
selectWindow("CntlSide1");
run("Duplicate...", "title=Background1c");
selectWindow("Background1a");
roiManager("Show All");
roiManager("Select", 0);
run("Measure");
selectWindow("Background1b");
roiManager("Show All");
roiManager("Select", 1);
run("Measure");
selectWindow("Background1c");
roiManager("Show All");
roiManager("Select", 2);
run("Measure");
selectWindow("CntlSide1");
roiManager("Show All");
roiManager("Select", 7);
run("Measure");
selectWindow("ExptSide1");
roiManager("Show All");
roiManager("Select", 6);
run("Measure");

//Save out CSVs
waitForUser("Choose a directory to save measurements, then press ok");
dir = getDirectory("Choose a directory to save measurement results.");
saveAs("Results", dir+name+".csv");

//Close windows
if (isOpen("Results")) { 
         selectWindow("Results"); 
         run("Close"); 
    } 
if (isOpen("Summary")) { 
         selectWindow("Summary"); 
         run("Close"); 
    } 

//Channel 2
selectWindow("C3-A");
run("Duplicate...", "title=C3-B");
selectWindow("C3-A");
resetMinAndMax();
rename("CntlSide2");
run("Duplicate...", "title=ExptSide2");
selectWindow("CntlSide2");
run("Duplicate...", "title=Background2a");
selectWindow("CntlSide2");
run("Duplicate...", "title=Background2b");
selectWindow("CntlSide2");
run("Duplicate...", "title=Background2c");
selectWindow("Background2a");
roiManager("Show All");
roiManager("Select", 3);
run("Measure");
selectWindow("Background2b");
roiManager("Show All");
roiManager("Select", 4);
run("Measure");
selectWindow("Background2c");
roiManager("Show All");
roiManager("Select", 5);
run("Measure");
selectWindow("CntlSide2");
roiManager("Show All");
roiManager("Select", 7);
run("Measure");
selectWindow("ExptSide2");
roiManager("Show All");
roiManager("Select", 6);
run("Measure");

//Save out CSVs
waitForUser("Choose a directory to save measurements, then press ok");
dir = getDirectory("Choose a directory to save measurement results.");
saveAs("Results", dir+name+".csv");

//Close windows
if (isOpen("Results")) { 
         selectWindow("Results"); 
         run("Close"); 
    } 
if (isOpen("Summary")) { 
         selectWindow("Summary"); 
         run("Close"); 
    } 
selectWindow("Background1a");
close();
selectWindow("Background1b");
close();
selectWindow("Background1c");
close();
selectWindow("Background2a");
close();
selectWindow("Background2b");
close();
selectWindow("Background2c");
close();
selectWindow("ExptSide1");
close();
selectWindow("CntlSide1");
close();
selectWindow("ExptSide2");
close();
selectWindow("CntlSide2");
close();
selectWindow("C2-A");
close();

//Analyze cell counts
selectWindow("C3-B");
run("Median...", "radius=3 slice");
resetMinAndMax();
//setMinAndMax(75, 150);
run("8-bit");
rename("RAW");
run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=0 parameter_2=0 white");
roiManager("Show All");
run("Analyze Particles...", "size=20.00-Infinity show=Masks");
run("Invert LUT");
rename("CntlSide");
run("Duplicate...", "title=ExptSide");

selectWindow("CntlSide");
roiManager("Show All");
roiManager("Select", 7);
run("Analyze Particles...", "size=5-Infinity show=Nothing summarize");

selectWindow("ExptSide");
roiManager("Show All");
roiManager("Select", 6);
run("Analyze Particles...", "size=5-Infinity show=Nothing summarize");

//Save out CSVs
waitForUser("Choose a directory to save measurements, then press ok");
dir = getDirectory("Choose a directory to save measurement results.");
saveAs("Results", dir+name+".csv");

//Save out ROIs
waitForUser("Choose a directory to save ROIs, then press ok");
dir = getDirectory("Choose a directory to save ROI sets.");
roiManager("Save", dir+name+".zip");

//Close image windows
selectWindow("CntlSide");
close();
selectWindow("ExptSide");
close();
selectWindow("RAW");
close();