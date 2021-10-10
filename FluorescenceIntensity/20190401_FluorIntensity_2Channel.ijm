//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
rename("A");

//run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack");
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

//Rotate image to horizontal or vertical
waitForUser("Rotate image until horizontal or vertical, then press ok");

//Add scale bar to define AP length for measurement
run("Scale Bar...", "width=300 height=8 font=28 color=White background=None location=[Lower Right] bold overlay");

//Define ROIs
setTool("freehand");
waitForUser("Draw ROI 0 (Background), then press ok");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","Background");
roiManager("Show All");
waitForUser("Draw ROI 1 (Control Area), then press ok");
roiManager("Add");
roiManager("Select",1);
roiManager("Rename","CntlArea");
waitForUser("Draw ROI 2 (Experimental Area), then press ok");
roiManager("Add");
roiManager("Select",2);
roiManager("Rename","ExptArea");

run("Split Channels");

//Measure background then ROI IntDen
//Channel 2
selectWindow("C2-A");
rename("SMPD3Enh3");
resetMinAndMax();
roiManager("Show All");
roiManager("Select", 0);
run("Measure");
roiManager("Select", 1);
run("Measure");
roiManager("Select", 2);
run("Measure");
selectWindow("SMPD3Enh3RFP");
close();

//Channel 3
selectWindow("C3-A");
rename("Citrine");
resetMinAndMax();
roiManager("Show All");
roiManager("Select", 0);
run("Measure");
roiManager("Select", 1);
run("Measure");
roiManager("Select", 2);
run("Measure");
selectWindow("Citrine");
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
close run("Close All");