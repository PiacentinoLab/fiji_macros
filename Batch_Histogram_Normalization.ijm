indir=getDirectory("Choose a directory");
outdir=getDirectory("Choose a directory");
indirlist=getFileList(indir);

setBatchMode(true);

for(i=0;i<indirlist.length;i++){
	run("Bio-Formats Windowless Importer", "open=" + indir + indirlist[i]);
	name=File.nameWithoutExtension;
	print("Processing: " + name);

	rename("A");
	run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
	run("Duplicate...", "duplicate channels=2");
	run("Enhance Contrast...", "saturated=0.05 normalize process_all");
	saveAs("Tiff", outdir+name+"_norm");
	run("Close All");

}
