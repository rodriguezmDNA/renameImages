# renameImages
An awk tool to rename images using data from a tab delimited file.

When I was working on the elevated CO<sub>2</sub> paper, I came across a small problem. In order to sort through the images of the cross sections I had to refer to a file where the file name (ie, R2_D7_12B_20x) indicated the characteristics of the sample (developmental day, species, treatment, biorep, plus other info).

I had to decide, did I want to go through the problem of going back and forth between the image I was looking at and the table or make life easier? 

For context, there were easily over 100 images and three files.

Did I want to spend an afternoon coding or painstakingly go through each image and rename it by hand?  Easy choice. I dusted off my bash scripting skills and spent an afternoon hacking this tool. In the end, I felt like cueball in this xkcd strip: https://xkcd.com/208/.

Long story short:

How do I go from a file named: 
> R1D12-1_A_20X.TIF

to something more user-friendly, human readable?
> ReplicateDay-measurement-Species_Day_Treatment_image_blabla.TIF

I wrote a bash script that took some arguments (not as input, but written in the file), like location of the TIF files and a destination, as well as the source of the information for each file. Then I used awk to parse the tab-delimited file, locate each image and create a new name. 

This saved me a huge amount of time and formatted the files very nicely. 
The good thing about this is that it can be applied to anything else, it doesn't have to be an image. As long as there is a table that links a file name to a description, the code is easily adaptable. If you end up using this tool let me know, my twitter handle is {at}rodriguezmDNA.

---

P.S.
The original train of thought while doing this is documented in the file _awk_the_shit_out_of_this.txt_ but this is the condensed version.





