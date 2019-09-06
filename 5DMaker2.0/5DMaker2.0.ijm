//Author: Steven Wilbert 
//Last Updated: 20180921

//Input:
//	1. Unmixed image stack
//	2. Template 5D

//Output: 
//	1. Image 5D
//	2. RGB merge of unmixed channels 
//	3. RGB channel montage
//	4. txt file containing display values 

//Options:
//  1. Specify min and max display values for each channel and apply to all files
//	2. Allow user to set min/max manually 
//	3. Automatically set min/max values based on measured pixel intensity

//Set directories (main folder of macros needs to be on your desktop)
inDir = getDirectory("home")+"Desktop//5DMaker2.0//Input//"
outDir = getDirectory("home")+"Desktop//5DMaker2.0//Output//"
templateDir = getDirectory("home")+"Desktop//5DMaker2.0//Template//"
inDirList = getFileList(inDir);
templateDirList = getFileList(templateDir);
chOptions = newArray("Apply specified min and max display values per channel for all files", "Manually adjust brightness and contrast for each channel", "Automatically adjust brightness and contrast for each channel");  

//Run and open dialog box to get user input 
Dialog.create("5DMaker Parameters");
Dialog.addMessage("Please choose one of the available templates:");
Dialog.addRadioButtonGroup("", templateDirList, templateDirList.length, 1, 1);
Dialog.addMessage("Please choose a channel handling option:");
Dialog.addRadioButtonGroup("", chOptions, chOptions.length, 1, 1);
Dialog.show();
template = Dialog.getRadioButton()
chOption = Dialog.getRadioButton()

//Loop the following for all files 
for(i=0;i<inDirList.length;i++){	
	
	//Open first unmixed stack 
	open(inDir + inDirList[i]);
	name = File.nameWithoutExtension;

	//Ensure image is displayed at full 16bit range 
	call("ij.ImagePlus.setDefault16bitRange", 16);
	setMinAndMax(0, 65535);
	
	//Ensure correct measurements are set 
	run("Set Measurements...", "mean min redirect=None decimal=3");

	//Channels are read as either channels or slices depending on if the
	//file is a CZI or a tiff, this makes it not matter which it is 
	Stack.getDimensions(width, height, channels, slices, frames);
	if (channels==1){ 
		run("Stack to Image5D", "3rd=ch 4th=z 3rd_dimension_size=slices 4th_dimension_size=channels assign");
	} else {
		run("Stack to Image5D", "3rd=ch 4th=z 3rd_dimension_size=channels 4th_dimension_size=slices assign");
	}

	rename("cur5D");

	//Opens 5D temnplate from template folder
	run("Open Image5D", "open=" + templateDir + template);
	rename("curTemplate");

	//Transfer name and color code from template 	
	selectImage("cur5D");
	run("Transfer Channel Settings", "colormaps labels density_calibrations transfer_settings_from=curTemplate");
	close("curTemplate");

	if (channels==1){ 
			chList = newArray(slices);
		}else {
			chList = newArray(channels);
		}

	//if (specifyAdjust == true)
	if (chOption == "Apply specified min and max display values per channel for all files"){

		if (i<=0){
			
			Dialog.create("Display Values");
			Dialog.addMessage("Please specify min and max display values for each channel");

			for(q=1;q<chList.length+1;q++){
				Dialog.addNumber("Channel " + q + " Min", 0)
				Dialog.addNumber("Channel " + q + " Max", 65535)
			}
		
			Dialog.show();

			displayValues = newArray(chList.length*2);
		
			for(z=0;z<displayValues.length;z++){
				displayValues[z] = Dialog.getNumber();
			}
		}
	}


	//if (specifyAdjust == true )
	if (chOption == "Apply specified min and max display values per channel for all files"){
		w = 0;
		for(p=1;p<chList.length+1;p++){
			run("Set Position", "x-position=1 y-position=1 channel=p slice=1 frame=1 display=color");
			setMinAndMax(displayValues[w], displayValues[w+1]);
			w = w+2;
			
			getMinAndMax(min, max);
			chNum = p;
			print("ch"+chNum+" Max:"+ max);
			print("ch"+chNum+" Min:"+ min);
		}
		
		selectWindow("Log");
		saveAs("txt", outDir + name + "_DisplayValues");
		close("Log");
	}
	
	//if (manualAdjust == true )
	if (chOption == "Manually adjust brightness and contrast for each channel"){
		
		waitForUser("Manually adjust contrast for each channel. Click OK when finished");

		
		for(j=1;j<chList.length+1;j++){
			run("Set Position", "x-position=1 y-position=1 channel=j slice=1 frame=1 display=color");
			getMinAndMax(min, max);
			chNum = j;
			print("ch"+chNum+" Max:"+ max);
			print("ch"+chNum+" Min:"+ min);
			}
			
		selectWindow("Log");
		saveAs("txt", outDir + name + "_DisplayValues");
		close("Log");
	}

	//if (autoAdjust == true )
	if (chOption == "Automatically adjust brightness and contrast for each channel"){	
		
		for(j=1;j<chList.length+1;j++){
			run("Set Position", "x-position=1 y-position=1 channel=j slice=1 frame=1 display=color");
	
			//Make copy to threshold
			run("Duplicate...", " ");

			//Adjust image for better tresholding, and threshold 
			run("Median...", "radius=2");
			run("Enhance Contrast...", "saturated=0.1 normalize");
			run("8-bit");
			run("Auto Threshold", "method=MaxEntropy white");
			rename("Mask");

			//Create selection based on threshold image
			selectWindow("Mask");
			run("Create Selection");
			roiManager("Add");

			//Apply the selections to the raw image and measure values 
			selectWindow("cur5D");
			roiManager("Select", 0);
			run("Measure");
		
			//Close ROI manager
			selectWindow("ROI Manager");
			run("Select None");
			run("Close"); 

			//Get measured values
			sigMax = getResult("Max", 0);
			sigMin = getResult("Min", 0);
			//sigMea = getResult("Mean", 0);
			
			//Add mesurements to log
			chNum = j;
			print("ch"+chNum+" Max:"+ sigMax*0.5);
			print("ch"+chNum+" Min:"+ sigMin);
			//print("ch"+chNum+" Mean:"+ sigMea);

			//Set min and max display values 
			selectWindow("cur5D");
			setMinAndMax(sigMin, sigMax*0.5);

			selectWindow("Mask");
			run("Close");
			
			selectWindow("Results");
			run("Close");	

			//Select Image5D for next loop
			selectImage("cur5D");
		}
		
		//Save display values 
		selectWindow("Log");
		saveAs("txt", outDir + name + "_DisplayValues");
		close("Log");
	}
		
	for(k=1;k<chList.length+1;k++){

		//Sets selection to kth channel
		run("Set Position", "x-position=1 y-position=1 channel=[k] slice=1 frame=1 display=color");	
		run("Image5D Stack to RGB");
		selectWindow("cur5D");
	}

	//Comment out if you do not want a merge
	run("Set Position", "x-position=1 y-position=1 channel=[1] slice=1 frame=1 display=overlay");
	run("Image5D Stack to RGB");
	saveAs("Jpeg", outDir + name + "_Merge");
	close();

	selectWindow("cur5D");
	run("Save Image5D", "save=" + outDir + name + "_5D.tif");
	close();

	//Create montage 
	run("Images to Stack", "name=Stack title=[] use");
	rowFactor = -floor(-(chList.length/5));
	run("Make Montage...", "columns=5 rows=rowFactor scale=1 first=1 last=slices increment=1 border=10 font=12");
	saveAs("Jpeg", outDir + name + "_Montage");
	run("Close All");
}
	




