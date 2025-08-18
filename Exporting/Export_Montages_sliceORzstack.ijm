// Choose input and output directories
indir = getDirectory("Choose input directory");
outdir = getDirectory("Choose output directory");

// Get list of files
indirlist = getFileList(indir);

setBatchMode(true);

for (i = 0; i < indirlist.length; i++) {
    filename = indirlist[i];

    // Skip hidden/system files and non-CZI files
    if (!endsWith(filename, ".czi")) continue;

    // Open file with Bio-Formats
    run("Bio-Formats Windowless Importer", "open=[" + indir + filename + "]");

    // Extract filename without extension for saving
    name = File.nameWithoutExtension;
    print("Processing: " + name);
    rename("A");
	
	// Get stack dimensions
	getDimensions(width, height, channels, slices, frames);
	
	// If Z-stack, perform max intensity projection
	if (slices > 1) {
	    run("Z Project...", "projection=[Max Intensity]");
	    selectWindow("MAX_A"); // Make projection active
	} else {
	    // Single slice, just use slice 1
	    setSlice(1);
	}
    // Enhance contrast for all channels
    run("Make Composite");
    for (c = 1; c <= channels; c++) {
        Stack.setChannel(c);
        run("Enhance Contrast", "saturated=0.15");
    }

    // Make montage
    run("Make Montage...", "columns=3 rows=2 scale=0.75 border=2");

    // Save JPEG
    saveAs("JPEG", outdir + name + "_montage.jpg");

    // Close all to free memory
    run("Close All");
}

setBatchMode(false);
print("Done!");
