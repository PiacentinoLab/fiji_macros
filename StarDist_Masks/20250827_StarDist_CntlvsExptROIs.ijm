// Ask for input/output dirs
indir = getDirectory("Choose input directory");
outdir = getDirectory("Choose output directory");

// Ask for channel index (1-based) for neural crest nuclei
NCChannel = 2; // Define NC channel before starting
//NCChannel = getNumber("Enter channel number for neural crest nuclei:", 1);

// List files
list = getFileList(indir);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".czi")) {
        
        // Open CZI with Bio-Formats
        run("Bio-Formats Importer", "open=[" + indir + list[i] + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        name = File.nameWithoutExtension;

        // Max intensity projection
        run("Z Project...", "projection=[Max Intensity]");
        rename("A");

        // Close original stack
        selectWindow(list[i]);
        close();
        
        // Clear out ROI Manager
        roiManager("reset");

        // --- Manual ROI drawing ---
        // Prompt for Control ROI
        waitForUser("Draw the Control ROI using the freehand tool, then click OK.");
        roiManager("Add");
        roiManager("Select", 0);
        roiManager("Rename", "Control");

        // Prompt for Experimental ROI
        waitForUser("Draw the Experimental ROI using the freehand tool, then click OK.");
        roiManager("Add");
        roiManager("Select", 1);
        roiManager("Rename", "Experimental");
		roiManager("Deselect");
        
        // Save out ROIs
        selectWindow("A");
		roiManager("Show All with labels");
        roiManager("Save", outdir + name + "_areas.zip");
		if (isOpen("ROI Manager")) { 
	         selectWindow("ROI Manager"); 
	         run("Close"); 
	    } 
        // --- End manual ROI section ---
        
		// Hard-coded ROI names
		roiNames = newArray(2);
		roiNames[0] = "Control";
		roiNames[1] = "Experimental";
		
		// Go to neural crest channel
		Stack.setChannel(NCChannel);
		run("Duplicate...", "title=NeuralCrestChannel");
		//run("Median...", "radius=3"); 
		
		// Process each ROI individually
		for (r = 0; r < roiNames.length; r++) {
		    roiManager("reset");
		    roiManager("Open", outdir + name + "_areas.zip");
		    
		    // Duplicate the ROI region
		    selectWindow("NeuralCrestChannel");
		    run("Duplicate...", "ignore");
		    rename(roiNames[r]);
		    roiManager("Select", r);
		    
		    // Mask ROI
		    run("Create Mask");
		    run("32-bit");
		    run("Divide...", "value=255");
		    imageCalculator("Multiply create", roiNames[r], "Mask");
		    
		    // Run StarDist
			run("StarDist 2D", 
			    "normalize=true percentile_bottom=1.0 percentile_top=99.8 " +
			    "prob_thresh=0.5 nms_thresh=0.4 output_type=Label " +
			    "model=[Versatile (fluorescent nuclei)]");
			rename(roiNames[r]+"_NC");
			
			// --- Save StarDist segmentation image ---
			segName = outdir + name + "_StarDistSeg_" + roiNames[r] + ".tif";
			saveAs("JPEG", segName);
			close();
			
			// Then measure using the ROIs
			roiManager("Select All");
			run("Set Measurements...", "area mean integrated display centroid shape feret redirect=NeuralCrestChannel decimal=3");
			roiManager("Measure");
			saveAs("Results", outdir + name + "_" + roiNames[r] + "_NeuralCrest_Measurements.csv");
			
			// Close Results window
			if (isOpen("Results")) {
			    selectWindow("Results");
			    run("Close");
			}
		    		    
		    // Save ROI
		    roiManager("Save", outdir + name + "_" + roiNames[r] + "_NeuralCrest_ROIs.zip");
		    
			// Close only the duplicate/StarDist images for this ROI
			if (isOpen("Result of "+roiNames[r])) close("Result of "+roiNames[r]);
			if (isOpen(roiNames[r])) close(roiNames[r]);
			if (isOpen("A")) close("A");
			if (isOpen("Mask")) close("Mask");
		}
	// --- Cleanup
	if (isOpen("NeuralCrestChannel")){selectWindow("NeuralCrestChannel"); run("Close");}
	
	if (isOpen("ROI Manager")) { 
	         selectWindow("ROI Manager"); run("Close");} 
    }       
}
