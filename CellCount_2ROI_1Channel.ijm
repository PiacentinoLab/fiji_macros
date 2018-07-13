//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
rename("A");
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

//Input ROI File (un-comment out following two lines and remove block below that):
	//roi=File.openDialog("Select ROI file");
	//roiManager("Open",roi);

//Define ROIs (background, experimental and control sides)
waitForUser("Draw ROI 0 (Experimental side), then press ok");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","Expt");
roiManager("Show All");
waitForUser("Draw ROI 1 (Control side), then press ok");
roiManager("Add");
roiManager("Select",1);
roiManager("Rename","Cntl");


//Reset images for analysis
//resetMinAndMax();
run("Split Channels");

//Analyze cell counts
selectWindow("C1-MAX_A");
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
roiManager("Select", 1);
run("Analyze Particles...", "size=5-Infinity show=Nothing summarize");

selectWindow("ExptSide");
roiManager("Show All");
roiManager("Select", 0);
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
selectWindow("C2-MAX_A");
close();
selectWindow("C3-MAX_A");
close();