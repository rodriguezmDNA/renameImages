#!/bin/sh
####  run this as a normal bash file (./gatherImages_general.sh).
#### Don't forget to modify the user variables below
## J Rodriguez Medina (2018)
# github/twitter @rodriguezmDNA
## Script to parse a tab delimited file containing info on a image from which data was collected.
# 	Use awk to combine columns and generate a sample name and a file "basename".
#   Use the basenme as a regex to find the original image  (in a given directory with a collection of images).
#	Save these results as a table.
#	Parse this new file to copy the image


echo "\n----------"
#### User variables
shortName="yourShortDescription" #This will be the name of the folder where the modified data will live. 
pathToImg="path/to/Images" 
dataSource="path/to/DataInfo.txt" #Doesn't have to be tab separated. If it's comma, modify the FS and OFS fields of awk below.


### The only other bit that you should modify are the field calls in the firs awk portion. $1 is the first column in the DataInfo table, $4 is the 4th and so on.

#### Create variables
outPath=Images/$shortName
outRawPath=Images/$shortName/RawImages
logPath=log
outTable="SampleNames"_$shortName.txt
log=$logPath/$shortName.log


#echo "Reading:\n\t" $dataSource
echo "Finding images in:\n\t" $pathToImg
echo "----------"
### Create directories to save data
echo `mkdir -p $outRawPath;mkdir -p $logPath;mkdir -p $outRawPath`
#echo `` # Make log dir
echo "----------"

echo "Saving data to" $outTable 
echo "log file:" $log
echo "----------"


echo "Reading" $dataSource 2>&1 | tee $log

awk -v quote="'" '
			BEGIN{
				FS="\t";	#Input field separator
				OFS="\t"; 	#Output field separator
				a=0; #For debugging, used as a counter
				print "sample_name\tsample_group\tfigure_regex\tpath" #Write a header 
			}  
			### Main part of the script
			NR>1 { #Skip the header of the file being read
			path="empty"; #If path not found set default as empty
			if($1 == "3") {gsub(13,12,$3)} # For this dataset, samples from rep 3, D13 is marked as D12
			a+=1; #For debugging, used as a counter 
			figure_basename="R"$1"D"$3"[-_]"$4"_"$5; #Basename of the figure filename
			sample_name="R"$1"_"$6"_"$7"_D"$3; 	#Sample name: Rep_geno_treatment_day
			sample_group=$6"_"$7"_D"$3; 		#Sample group:    geno_treatment_day
			findComm="find '$pathToImg' -iname " figure_basename"*"; #Set the find function
			findComm | getline path; close(findComm);  #Call and close the find function.
			print sample_name,sample_group,figure_basename,quote path quote #Write to file
		}' $dataSource  > $outTable  2>$log


echo "Copying files to\n" $outPath "\n" $outRawPath 2>&1 | tee -a $log


awk 'BEGIN {OFS=" ";FS="\t";a=0;} NR>1 { 

					## Get basename original
					getBasename="basename "$4; #What is going to be called 
					getBasename | getline originalFName; close(getBasename); #Call ot
					gsub(".TIF","",originalFName); # Remove extension and save
					## Set what will be called
					copyRaw="cp "$4" '$outRawPath'"; 
					copyNewName="cp "$4" '$outPath'/"$1"_"originalFName".TIF"; #Add to new name
					print copyRaw;
					print copyNewName;
					print "---"; 
					system(copyRaw);
					system(copyNewName);
				}' $outTable >> $log 2>&1 

echo "Compressing RawImages --" 2>&1 | tee -a $log
tar -czvf $outRawPath.tar.gz $outRawPath 2>&1 | tee -a $log
rm -r $outRawPath 2>&1 | tee -a $log

echo "Done --" 2>&1 | tee -a $log
echo "jrm | github: rodriguezmDNA" 2>&1 | tee -a $log
echo `date '+%Y%M%d_%X'` 2>&1 | tee -a $log
