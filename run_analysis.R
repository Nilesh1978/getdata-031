library(data.table)
library(dplyr)
# The input of this script is the Samsung data set.
# The output of this script is the "tidy" data set.

#############################
# RStudio Version 0.99.473 – © 2009-2015 RStudio, Inc.
# R version 3.2.0 (2015-04-16)
# Platform: x86_64-apple-darwin13.4.0 (64-bit)
# Running under: OS X 10.10.2 (Yosemite)
# dplyr_0.4.2, data.table_1.9.4
#############################
# 0.1 Download and unzip file. Since it takes a while to download, uncomment
# only if you don't have the data.

# dataSource = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(dataSource, destfile = "UCI HAR Dataset.zip", method="curl")
# unzip("UCI HAR Dataset.zip")
# file.remove("UCI HAR Dataset.zip")

# 0.2 Read in Data
# 0.2.1 Read in activity labels. Activity labels describe the type of activity 
#     performed by subjects. 
activity_labels_file = "UCI HAR Dataset/activity_labels.txt"
activity_labels <- read.csv2(activity_labels_file
                             , sep = " "
                             , col.names = c("Activity.Id", "Activity.Label")
                             , header = FALSE
                             , stringsAsFactors = FALSE)
print("Activity metadata:")
print(str(activity_labels))

# 0.2.2 Read in feature key-to-value table. This table maps a numeric key in the 
#     first column to a descriptive label in the second column. Name the columns
#     "Feature.Id", "Feature.Label".
features_file = "UCI HAR Dataset/features.txt"
features <- read.csv2(features_file
                             , sep = " "
                             , col.names = c("Feature.Id", "Feature.Label")
                             , header = F
                             , stringsAsFactors = FALSE)
print("Features metadata:")
print(str(features))

# 0.3 Read in train data
# 0.3.1 Read in train data y - the activity being recorded. A single column of
# int in a data.frame, give the column the name "Activity.Id". 
y_train_file = "UCI HAR Dataset/train/y_train.txt"
y_train <- read.csv2(y_train_file
                      , sep = " "
                      , col.names = c("Activity.Id")
                      , header = F)
print("Number of rows read in each activity category, training set:")
print(table(y_train))

# 0.3.2 Read in train data X - the measured values for the activity. Name the 
#       columns the values of features$Feature.Label.
x_train_file = "UCI HAR Dataset/train/X_train.txt"
x_train <- read.table(x_train_file
                     , header = FALSE
                     , nrows = 7352
                     , colClasses = "numeric"
                     , col.names = features$Feature.Label
                     )

print(paste("Number of rows read from training data set:", dim(x_train)[1])) 
print(paste("Number of columns read from training data set:", dim(x_train)[2])) 

# 0.3.3 Read in train data experimental subject list. This is the id of the 
#       subject to whom the data row belongs, a single column of integers.
subject_train_file = "UCI HAR Dataset/train/subject_train.txt"
subject_train <- read.csv2(subject_train_file
                           , header = FALSE
                           , col.names = c("Subject.Id")
                           , stringsAsFactors = FALSE)

print(paste("Number of rows read from subject training data set:", dim(subject_train)[1])) 


# 0.4 Read in test data:
# 0.4.1 Read in test data y - the activity being recorded. A single column of
# int in a data.frame, give the column the name "Activity.Id". 
y_test_file = "UCI HAR Dataset/test/y_test.txt"
y_test <- read.csv2(y_test_file
                     , sep = " "
                     , col.names = c("Activity.Id")
                     , header = F)
print("Number of rows read in each activity category, training set:")
print(table(y_test))

# 0.4.2 Read in test data X - the measured values for the activity. This is a 
#       large set of numbers in scientific notation, converted by read.table 
#       to numeric.
x_test_file = "UCI HAR Dataset/test/X_test.txt"
x_test <- read.table(x_test_file
                      , header = FALSE
                      , nrows = 7352
                      , colClasses = "numeric"
                      , col.names = features$Feature.Label
)

print(paste("Number of rows read from testing data set:", dim(x_test)[1])) 
print(paste("Number of columns read from testing data set:", dim(x_test)[2])) 

# 0.4.3 Read in test data experimental subject list. This is the id of the 
#       subject to whom the data row belongs.
subject_test_file = "UCI HAR Dataset/test/subject_test.txt"
subject_test <- read.csv2(subject_test_file
                           , header = FALSE
                           , col.names = c("Subject.Id")
                           , stringsAsFactors = FALSE)

print(paste("Number of rows read from subject testing data set:", dim(subject_test)[1])) 

# 1. Merges the training and the test sets to create one data set.
# 1.1 Bind y, subject_test and x data column-wise. This will allow grouping by
#     subject and activity. 
# 1.1.1 Add the y_train, subject_train data frames to the left of x_train
cbind(y_train, subject_train, x_train) -> x_train

# 1.1.2 Add the y_test, subject_test data frames to the left of x_test.
cbind(y_test, subject_test, x_test) -> x_test

# 1.2 Bind the train and test data row-wise to create one set of data. Assign to
#     x_combined.
rbind(x_train, x_test) -> x_combined

print("1. 1. Merges the training and the test sets to create one data set")
print(paste("Number of rows in combined data set: ", nrow(x_combined)))
print(paste("Number of columns in combined data set: ", ncol(x_combined)))

########################
# 2. Extracts only the measurements on the mean and standard deviation for each 
#    measurement. 
# 2.1 Find column names with mean and std data
names(x_combined) %like% "mean" | names(x_combined) %like% "std" -> mean_std
# 2.2 Column indices with mean and std data
which(mean_std) -> mean_std_ind
# 2.3 Add first and second column back to distinguish activity and subject
c(1, 2, mean_std_ind) -> mean_std_ind
# 2.4 The result for this point: data with mean and std for each measurement.
mean_std_data <- x_combined[,mean_std_ind]

print("2. Extracts only the measurements on the mean and standard deviation")
print(names(mean_std_data))

# 3. Uses descriptive activity names to name the activities in the data set
# 3.1 Add Activity.Label back to mean_std_data, joining on Activity.Id column
left_join(mean_std_data, activity_labels) -> mean_std_data
mean_data_cols = dim(mean_std_data)[2]
mean_std_data[1:6, c(1,2,3,mean_data_cols)]

# 3.1.1 Rearrange data frame so that labels are the first columns.
cbind(subset(mean_std_data, select = Activity.Id), 
      subset(mean_std_data, select = Activity.Label), 
      mean_std_data[, 2:(mean_data_cols-1)]) -> mean_std_data
print("3. Uses descriptive activity names")
print(mean_std_data[1:6, c(1,2,3,mean_data_cols)])


# 4. Appropriately labels the data set with descriptive variable names. 
#    This step has been accomplished in 0.3.2 and 0.4.2, when reading the
#    data and applying the column names from features list.
print("4. Appropriately labels the data set")
print(names(mean_std_data))

# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
#    Group by Activity.Id, Activity.Label, Subject.Id, and use the 
#    summarise_each function from dplyr to run the average function on each 
#    column.
summary_data <- mean_std_data  %>% group_by(Activity.Id, Activity.Label, Subject.Id) %>% summarise_each(funs(mean))

# Write output:
out_file = "tidy_activity_average.txt"
if(file.exists(out_file))
    file.remove(out_file)
write.table(summary_data, row.names = FALSE, file = out_file)
print("5. Independent tidy data set with the average of each variable")
summary_data[1:10,1:6]

print("SUCCESS!")
print(paste("output file written:", out_file))
