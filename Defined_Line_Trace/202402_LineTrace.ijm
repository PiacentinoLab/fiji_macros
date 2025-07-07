//learn file name, prepare file and Fiji for analysis
name = File.nameWithoutExtension;
run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
run("Z Project...", "projection=[Max Intensity]");
rename("A");

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

//Rotate image to horizontal or vertical
waitForUser("Rotate image until vertical, then press OK");

// Add scale bar to define AP length for measurement
run("Scale Bar...", "width=400 height=8 font=28 color=White background=None location=[Lower Right] bold overlay");

// Define ROIs
setTool("line");

// Draw the first line (Control Area)
run("Specify...", "width=400 height=250");
waitForUser("Draw the first line (Control Area), then press OK");
roiManager("Add");
roiManager("Select", 0);
roiManager("Rename", "CntlArea");

// Draw the second line (Experimental Area)
run("Specify...", "width=400 height=250");
waitForUser("Draw the second line (Experimental Area), then press OK");
roiManager("Add");
roiManager("Select", 1);
roiManager("Rename", "ExptArea");

// Save out ROIs
waitForUser("Choose a directory to save ROIs and overlay images, then press OK");
roi_dir = getDirectory("Choose a directory to save ROI sets.");
roiManager("Save", roi_dir + name + ".zip");

// Perform linescan for Control Area
roiManager("Select", 0);
run("Plot Profile");
plotProfile1 = getTitle();
rename(plotProfile1, "Linescan_CntlArea");

// Perform linescan for Experimental Area
roiManager("Select", 1);
run("Plot Profile");
plotProfile2 = getTitle();
rename(plotProfile2, "Linescan_ExptArea");

// Save out Measurements as csv
waitForUser("Choose a directory to save measurements, then press OK");
csv_dir = getDirectory("Choose a directory to save measurement results.");
selectWindow("Linescan_CntlArea");
saveAs("Results", csv_dir + name + "_Linescan_CntlArea.csv");
selectWindow("Linescan_ExptArea");
saveAs("Results", csv_dir + name + "_Linescan_ExptArea.csv");

// Save out ROI/Image Overlay
selectWindow("A");
roiManager("Show All");
run("Flatten", "slice");
saveAs("JPEG", roi_dir + name + "_ROIOverlay.jpg");
