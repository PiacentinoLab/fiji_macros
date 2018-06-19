indir=getDirectory("Choose a directory");
outdir=getDirectory("Choose a directory");
indirlist=getFileList(indir);

setBatchMode(true);

for(i=0;i<indirlist.length;i++){
	run("Bio-Formats Windowless Importer", "open=" + indir + indirlist[i]);
	name=File.nameWithoutExtension;
	print("Processing: " + name);

	//run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack");
	//run("Z Project...", "projection=[Max Intensity]");
	rename("A");
	run("Split Channels");

	//export each channel
	selectWindow("C1-A");
	run("Grays");
	run("Enhance Contrast", "saturated=0.35");
	saveAs("JPEG", outdir+name+"_Pax7");
	selectWindow("C2-A");
	run("Grays");
	run("Enhance Contrast", "saturated=0.35");
	saveAs("JPEG", outdir+name+"_Cas9-eGFP");
	selectWindow("C3-A");
	run("Grays");
	run("Enhance Contrast", "saturated=0.35");
	saveAs("JPEG", outdir+name+"_Laminin");
	//selectWindow("C4-A");
	//run("Grays");
	//run("Enhance Contrast", "saturated=0.15");
	//saveAs("JPEG", outdir+name+"_V5Smurf1");
	//selectWindow("C5-A");
	//run("Grays");
	//run("Enhance Contrast", "saturated=0.05");
	//saveAs("JPEG", outdir+name+"_DIC");


//merge channels
	//C1 = red, C2 = green, C3 = blue, 
	//C4 = gray, C5 = cyan, C6 = magenta, 
	//C7 = yellow
	
	run("Merge Channels...", "c2=C3-A c6=C1-A create");
	
	//rename("A");
	//selectWindow("A");
	run("RGB Color");
	saveAs("JPEG", outdir+name+"_composite");
	run("Close All");

}
