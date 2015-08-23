# Code Book
# This code book that describes the variables, the data, and any transformations
# or work performed to clean up the data 

##
scripts: run_analysis.R
data input: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
from Human Activity Recognition Using Smartphones Dataset
Version 1.0
www.smartlab.ws

data output: tidy_activity_average.txt in working directory.
libraries: data.table, dplyr
##

Data Files: To the description of files and their content please refer to the README.txt
file in the original data set.

Script files: run_analysis.R
This script file reads in the data files in the data set and combines the separate
training and test data set into one data set. It applies labeling to columns from
the features.txt and activity_labels.txt metadata files.

It groups the data by the user id and activity and calculates group means for each.

The script prints out diagnostic messages as it progresses, and produces an output
file with the group mean.

The script is self-cocumenting, but you can read the outline of the steps here:

 0.1 Download and unzip file. Since it takes a while to download, uncomment
 only if you don't have the data.
 0.2 Read in Data
 0.2.1 Read in activity labels. Activity labels describe the type of activity 
     performed by subjects. 
 0.2.2 Read in feature key-to-value table. This table maps a numeric key in the 
     first column to a descriptive label in the second column. Name the columns
     "Feature.Id", "Feature.Label".
 0.3 Read in train data
 0.3.1 Read in train data y - the activity being recorded. A single column of
 int in a data.frame, give the column the name "Activity.Id". 
 0.3.2 Read in train data X - the measured values for the activity. Name the 
       columns the values of features$Feature.Label.
 0.3.3 Read in train data experimental subject list. This is the id of the 
       subject to whom the data row belongs, a single column of integers.
 0.4 Read in test data:
 0.4.1 Read in test data y - the activity being recorded. A single column of
 int in a data.frame, give the column the name "Activity.Id". 
 0.4.2 Read in test data X - the measured values for the activity. This is a 
       large set of numbers in scientific notation, converted by read.table 
       to numeric.
 0.4.3 Read in test data experimental subject list. This is the id of the 
       subject to whom the data row belongs.
 1. Merges the training and the test sets to create one data set.
 1.1 Bind y, subject_test and x data column-wise. This will allow grouping by
     subject and activity. 
 1.1.1 Add the y_train, subject_train data frames to the left of x_train using cbind.
 1.1.2 Add the y_test, subject_test data frames to the left of x_test.
 1.2 Bind the train and test data row-wise to create one set of data. Assign to
     x_combined.
 2. Extracts only the measurements on the mean and standard deviation for each 
    measurement. 
 2.1 Find column names with mean and std data
 2.2 Index columns with mean and std data
 2.3 Add first and second column back to distinguish activity and subject
 2.4 The result for this point: data with mean and std for each measurement.
 3. Uses descriptive activity names to name the activities in the data set
 3.1 Add Activity.Label back to mean_std_data, joining on Activity.Id column
 3.1.1 Rearrange data frame so that labels are the first columns.
 4. Appropriately labels the data set with descriptive variable names. 
    This step has been accomplished in 0.3.2 and 0.4.2, when reading the
    data and applying the column names from features list.
 5. From the data set in step 4, creates a second, independent tidy data set 
    with the average of each variable for each activity and each subject.
    Group by Activity.Id, Activity.Label, Subject.Id, and use the 
    summarise_each function from dplyr to run the average function on each 
    column.
 Write output to file.
