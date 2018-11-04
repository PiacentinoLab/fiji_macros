//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
rename("A");
//run("Z Project...", "projection=[Max Intensity]");

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

//Rotate image to horizontal or vertical
waitForUser("Rotate image until horizontal or vertical, then press ok");

//Add scale bar to define AP length for measurement
run("Scale Bar...", "width=400 height=8 font=28 color=White background=None location=[Lower Right] bold overlay");

//Define ROIs
setTool("freehand");
waitForUser("Draw ROI 0 (Control Area), then press ok");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","CntlArea");
roiManager("Show All");
waitForUser("Draw ROI 1 (Experimental Area), then press ok");
roiManager("Add");
roiManager("Select",1);
roiManager("Rename","ExptArea");

//Save out ROIs
waitForUser("Choose a directory to save ROIs, then press ok");
dir = getDirectory("Choose a directory to save ROI sets.");
roiManager("Save", dir+name+".zip");

//Measure areas
roiManager("Show All");
roiManager("Select", 0);
run("Measure");
roiManager("Select", 1);
run("Measure");

//Save out Measurements as csv
waitForUser("Choose a directory to save measurements, then press ok");
dir = getDirectory("Choose a directory to save measurement results.");
saveAs("Results", dir+name+".csv");