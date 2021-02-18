//Determine input directory
indir=getDirectory("Choose a directory");
//Determine output directory
outdir=getDirectory("Choose a directory");
indirlist=getFileList(indir);

setBatchMode(true);

for(i=0;i<indirlist.length;i++){
	run("Bio-Formats Windowless Importer", "open=" + indir + indirlist[i]);
	name=File.nameWithoutExtension;
	print("Processing: " + name);

	//Include next line if you want to perform maximum intensity projection
	//run("Z Project...", "projection=[Max Intensity]");

	saveAs("TIFF", outdir+name);
	run("Close All");

}
