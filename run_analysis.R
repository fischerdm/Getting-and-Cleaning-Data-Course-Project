# Getting and Cleaning Data -- Course Project 2
# run_analysis.R

# This script does the following:
# (1) Merges the training and the test sets to create one data set.
# (2) Extracts only the measurements on the mean and standard deviation for each measurement.
# (3) Uses descriptive activity names to name the activities in the dataset.
# (4) Appropriately labels the dataset with descriptive variable names.
# (5) From the dataset in step (4), create a second, independent tidy dataset with
#     the average of each variable for each activity and each subject.

# Step 0: Download and unzip files
###############################################################################

# set working directory
setwd("~/Documents/The_Data_Science_Specialization/Kurse/Getting_and_Cleaning_Data/Project")
getwd()

# download file
if(!file.exists("./data")) {
        dir.create("./data")
}
# check if file already exists
if(!file.exists("./data/Dataset.zip")) {
        url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url, destfile = "./data/Dataset.zip", method = "curl")
}

# unzip the file and put it into the data directory
unzip(zipfile = "./data/Dataset.zip", exdir = "./data")

# Step 1: create one dataset
############################################################################### 
# ----------------------------------------------------------------------------
# read files
# test files
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = F)
Y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = F)
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = F)

# train files
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = F)
Y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = F)
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = F)
# ----------------------------------------------------------------------------
# merge test and train datasets with rbind 
X_data <- rbind(X_test, X_train)
Y_data <- rbind(Y_test, Y_train)
subject_data <- rbind(subject_test, subject_train)

# name the variables
names(Y_data) <- "activity"
names(subject_data) <- "subject"
featureNames <- read.table("./data/UCI HAR Dataset/features.txt") # load features.txt to extract the names
names(X_data) <- featureNames$V2 
head(featureNames)

# merge the datasets with cbind
data <- cbind(subject_data, X_data, Y_data)
# ----------------------------------------------------------------------------

# Step 2: extract the measurements on the mean and standard deviation, i.e. 
# scan for the words "mean()" and "std()" in the column names of the merged dataset
# “data", which was produced in one step before
###############################################################################
# ----------------------------------------------------------------------------
# extract column names with "mean()" or "std()" in the column name
# first, get positions of variables with "mean()" or "std()" in featureNames
ind <- c(grep("mean()", featureNames$V2), grep("std()", featureNames$V2))

# second, extract the names that contains one of the snippets "mean()" or "std()". 
names <- featureNames$V2[ind] # names are of type factor

# add "subject" and "activity"
names <- c("subject", as.character(names), "activity")
# ----------------------------------------------------------------------------
# take a subset of the dataset "data". The dataset "data_sub" is the dataset with 
# the mean and standard deviation measurements
data_sub <- subset(data, select = names)
# ----------------------------------------------------------------------------

# Step 3: name the activities in the dataset. The activity names are taken from
# activity_labels.txt
###############################################################################
# ----------------------------------------------------------------------------
# name the activities
# first, load the activity names. The names are "WALKING", "WALKING_UPSTAIRS",
# "WALKING_DOWNSTAIRS", "SITTING", "STANDING" and"LAYING"
activityNames <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = F)

# transform values from factors to characters and replace the numbers in the 
# dataset "data_sub" with the names of the activities
activityNames$V2 <- as.character(activityNames$V2)
for(i in 1:6) {
        data_sub$activity <- sub(i, activityNames$V2[i], data_sub$activity)
}
# ----------------------------------------------------------------------------
# change back to factors
activityNames$V2 <- factor(activityNames$V2)
data_sub$activity <- factor(data_sub$activity)
# ----------------------------------------------------------------------------

# Step 4: in this step, the dataset is appropriately labeled with descriptive variable names
###############################################################################
# ----------------------------------------------------------------------------
# replace "t" with "time", "f" with "frequency", "Gyro" with "Gyroscope", "Acc" with
# "Accelerator" and "Mag" with "Magnitudes". The full names are found in README.txt
names(data_sub) <- sub("^t", "time",names(data_sub))
names(data_sub) <- sub("^f", "frequency",names(data_sub))
names(data_sub) <- sub("Gyro", "Gyroscope",names(data_sub))
names(data_sub) <- sub("Acc", "Accelerator",names(data_sub))
names(data_sub) <- sub("Mag", "Magnitude",names(data_sub))
# ----------------------------------------------------------------------------

# Step 5: an independent tidy dataset with the average of each variable 
# for each activity and each subject is created
###############################################################################
# ----------------------------------------------------------------------------
# take the mean of every variable gropued by every subject and activity
data_sub2 <- aggregate(. ~subject + activity, data = data_sub, mean)

# order the dataset
data_sub2 <- data_sub2[order(data_sub2$subject, data_sub2$activity),]

# write the values to a txt-file called Dataset_clean.txt
write.table(data_sub2, file = "./data/Dataset_clean.txt", row.name = F)
# ----------------------------------------------------------------------------