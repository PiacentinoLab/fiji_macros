indir=getDirectory("Choose a directory");
outdir=getDirectory("Choose a directory");
indirlist=getFileList(indir);

setBatchMode(true);

for(i=0;i<indirlist.length;i++){
	run("Bio-Formats Windowless Importer", "open=" + indir + indirlist[i]);
	name=File.nameWithoutExtension;
	print("Processing: " + name);
	
	rename("A");
	run("Split Channels");
	
	selectWindow("C2-A");
	run("Duplicate...", "duplicate slices=4");

	selectWindow("C1-A");
	run("Z Project...", "projection=[Max Intensity] all");
	
	run("Merge Channels...", "c2=MAX_C1-A c4=C2-A-1 create");
	saveAs("Tiff", outdir+name+"_MIP");
	run("Close All");

}
