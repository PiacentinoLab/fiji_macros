//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
run("Z Project...", "projection=[Max Intensity]");
rename("A");
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
roi=File.openDialog("Select ROI file");
roiManager("Open",roi);

//Define ROIs (experimental and control sides)
//waitForUser("Circle EXPERIMENTAL neural crest, then press ok");
//roiManager("Add");
//roiManager("Select",0);
//roiManager("Rename","NC Expt");
//roiManager("Show All");
//waitForUser("Circle CONTROL neural crest, then press ok");
//roiManager("Add");
//roiManager("Select",1);
//roiManager("Rename","NC Cntl");
//waitForUser("Circle EXPERIMENTAL neural tube, then press ok");
//roiManager("Add");
//roiManager("Select",2);
//roiManager("Rename","NT Expt");
//roiManager("Show All");
//waitForUser("Circle CONTROL neural tube, then press ok");
//roiManager("Add");
//roiManager("Select",3);
//roiManager("Rename","NT Cntl");


//Reset images for analysis
//resetMinAndMax();
run("Split Channels");

//Analyze cell counts
selectWindow("C3-A");
run("Median...", "radius=3 slice");
resetMinAndMax();
//setMinAndMax(75, 150);
run("8-bit");
rename("RAW");
run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=0 parameter_2=0 white");
roiManager("Show All");
run("Analyze Particles...", "size=20.00-Infinity show=Masks");
run("Invert LUT");
rename("Cntl_NC");

selectWindow("Cntl_NC");
roiManager("Show All");
roiManager("Select", 1);
run("Analyze Particles...", "size=5-Infinity show=Nothing summarize");

rename("Expt_NC");
roiManager("Select", 0);
run("Analyze Particles...", "size=5-Infinity show=Nothing summarize");

rename("Cntl_NT");
roiManager("Select", 3);
run("Analyze Particles...", "size=5-Infinity show=Nothing summarize");

rename("Expt_NT");
roiManager("Select", 2);
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
run("Close All");