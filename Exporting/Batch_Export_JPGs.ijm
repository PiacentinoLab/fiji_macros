indir=getDirectory("Choose a directory");    //navigate to "czi" folder
outdir=getDirectory("Choose a directory");  //navigate to "jpeg" folder
indirlist=getFileList(indir);				//makes a list of file names from in directory

setBatchMode(true);							//runs everything in the background (not displaying what it's doing)

for(i=0;i<indirlist.length;i++){
	run("Bio-Formats Windowless Importer", "open=" + indir + indirlist[i]);
	name=File.nameWithoutExtension;
	print("Processing: " + name);

//	run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack");
	run("Z Project...", "projection=[Max Intensity]");
//	run("Median...", "radius=1 stack");
	
	// NOTE: Imaging embryos on the LSM880 results in them being reflected 
	// with experimental side on left and control on right. Correcting that here.
//	run("Flip Vertically", "stack");

	rename("A");
	run("Split Channels");

	//export each channel
	selectWindow("C1-A");
	run("Grays");
	run("Enhance Contrast", "saturated=0.10");
	saveAs("JPEG", outdir+name+"_DAPI");
	selectWindow("C2-A");
	run("Grays");
	run("Enhance Contrast", "saturated=0.10");
	saveAs("JPEG", outdir+name+"_Enh2Citrine");
	selectWindow("C3-A");
	run("Grays");
	run("Enhance Contrast", "saturated=0.10");
	saveAs("JPEG", outdir+name+"_Enh3RFP");
	selectWindow("C4-A");
	run("Grays");
	run("Enhance Contrast", "saturated=0.10");
	saveAs("JPEG", outdir+name+"_Pax7");
	selectWindow("C5-A");
	run("Grays");
//	run("Enhance Contrast", "saturated=0.10");
//	setMinAndMax(50, 15000);
	saveAs("JPEG", outdir+name+"_BF");


//merge channels
	//c1 = red, c2 = green, c3 = blue, 
	//c4 = gray, c5 = cyan, c6 = magenta, 
	//c7 = yellow
	
	run("Merge Channels...", "c6=C3-A c5=C2-A c7=C4-A create");

	run("RGB Color");
	saveAs("JPEG", outdir+name+"_composite");
	run("Close All");

}
