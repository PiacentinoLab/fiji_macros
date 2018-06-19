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

setTool("line");
waitForUser("Draw ROI 2 (Control Line 1), then press ok");
roiManager("Add");
roiManager("Select",2);
roiManager("Rename","Cntl1");
waitForUser("Draw ROI 3 (Experimental Line 1), then press ok");
roiManager("Add");
roiManager("Select",3);
roiManager("Rename","Exp1");
waitForUser("Draw ROI 4 (Control Line 2), then press ok");
roiManager("Add");
roiManager("Select",4);
roiManager("Rename","Cntl2");
waitForUser("Draw ROI 5 (Experimental Line 2), then press ok");
roiManager("Add");
roiManager("Select",5);
roiManager("Rename","Exp2");
waitForUser("Draw ROI 6 (Control Line 3), then press ok");
roiManager("Add");
roiManager("Select",6);
roiManager("Rename","Cntl3");
waitForUser("Draw ROI 7 (Experimental Line 3), then press ok");
roiManager("Add");
roiManager("Select",7);
roiManager("Rename","Exp3");
waitForUser("Draw ROI 8 (Control Line 4), then press ok");
roiManager("Add");
roiManager("Select",8);
roiManager("Rename","Cntl4");
waitForUser("Draw ROI 9 (Experimental Line 4), then press ok");
roiManager("Add");
roiManager("Select",9);
roiManager("Rename","Exp4");

//Save out ROIs
dir = getDirectory("Choose a directory to save ROI sets.");
roiManager("Save", dir+name+".zip");