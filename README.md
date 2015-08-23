# getdata-031
# This file explains how all of the scripts work and how they are connected.

##
scripts: run_analysis.R
data input: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
data output: tidy_activity_average.txt in working directory.
libraries: data.table, dplyr
##

The script you need to run is run_analysis.R. It manipulates the "Human Activity Recognition Using Smartphones Dataset"" to produce the output tidy data set. 

If you have the data set downloaded, unzip it and set your working directory such
that it contains the unzipped "UCI HAR Dataset" direcory.

If you haven't downloaded the data set, you can uncomment the lines in step 0.1:
Download and unzip file. That will download and unzip the source.

To run in R at the command line do:
> source("run_analysis.R")

To run this script open it up in RStudio and click the "Source" button.

If the scrips finishes successfully, it will print out:
[1] "SUCCESS!"
[1] "output file written: tidy_activity_average.txt"
