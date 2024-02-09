//Define channel to measure Neural Crest Area:
nc_channel = 2;

//learn file name, prepare file and Fiji for analysis
name=File.nameWithoutExtension;
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

//Input ROI File:
//roi=File.openDialog("Select ROI file");
//roiManager("Open",roi);

//Define ROIs
setTool("freehand");
waitForUser("Draw ROI 0 (Control Head), then press ok");
roiManager("Add");
roiManager("Select",0);
roiManager("Rename","Cntl");
roiManager("Show All");
waitForUser("Draw ROI 1 (Experimental Head), then press ok");
roiManager("Add");
roiManager("Select",1);
roiManager("Rename","Expt");
roiManager("Deselect");
setSlice(nc_channel);

//Filtering, thresholding, and mask
run("Median...", "radius=2 slice");
setOption("ScaleConversions", true);
run("8-bit");
run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=0 parameter_2=0 white");
run("Select None");
run("Analyze Particles...", "size=5-Infinity show=Masks slice");
run("Invert LUT");


//Measure Head Areas
roiManager("Show All");
roiManager("Deselect");
roiManager("Measure");

//Save out Measurements as csv
waitForUser("Choose a directory to save measurements, then press ok");
csv_dir = getDirectory("Choose a directory to save measurement results.");
saveAs("Results", csv_dir+name+"_HeadArea.csv");


//Measure NC Areas
rename("Mask of Cntl");
roiManager("Select", 0);
run("Analyze Particles...", "size=5-Infinity show=Nothing summarize");
rename("Mask of Expt");
roiManager("Select", 1);
run("Analyze Particles...", "size=5-Infinity show=Nothing summarize");
saveAs("Results", csv_dir+name+"_NCArea.csv");

//Save out ROIs and Mask/ROI Overlay
waitForUser("Choose a directory to save ROIs and overlay images, then press ok");
roi_dir = getDirectory("Choose a directory to save ROI sets.");
roiManager("Save", roi_dir+name+".zip");
run("Flatten");
saveAs("JPEG", roi_dir+name+"_MaskROIs.jpg");