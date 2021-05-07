indir=getDirectory("Choose a directory");
outdir=getDirectory("Choose a directory");
indirlist=getFileList(indir);

setBatchMode(true);

for(i=0;i<indirlist.length;i++){
	run("Bio-Formats Windowless Importer", "open=" + indir + indirlist[i]);
	name=File.nameWithoutExtension;
	print("Processing: " + name);
	run("Z Project...", "projection=[Max Intensity]");
//	run("Flip Horizontally", "stack");
	run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack");
	rename("A");
	run("Enhance Contrast", "saturated=0.15");
	run("Magenta");
	run("Next Slice [>]");
	run("Enhance Contrast", "saturated=0.15");
	run("Red");
	run("Next Slice [>]");
	run("Enhance Contrast", "saturated=0.15");
	run("Green");
	run("Next Slice [>]");
	run("Enhance Contrast", "saturated=0.15");
	run("Blue");
	run("Split Channels");
//	run("Merge Channels...", "c1=C2-A c2=C3-A c3=C4-A c6=C1-A create keep");
	run("Merge Channels...", "c1=C2-A c2=C3-A c6=C1-A create keep");
	run("Flatten");
	run("Images to Stack", "name=Stack title=[] use");
	run("Make Montage...", "columns=5 rows=1 scale=0.5 border=2");
	saveAs("JPEG", outdir+name+"_montage");
	run("Close All");
}