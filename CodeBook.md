# Code Book

This document contains information about the variables, the data and any transformations of the data.

## Purpose of the project

The goal of this project is come up with a R script and a clean dataset merged from several files containing the raw data. The raw data can be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The R script contains R code to perform several steps. It:
1. merges the training and the test sets to create one data set.
2. extracts only the measurements on the mean and standard deviation for each measurement.
3. uses descriptive activity names to name the activities in the dataset.
4. appropriately labels the dataset with descriptive variable names.
5. creates a second, independent tidy dataset from the dataset in step (4) with
the average of each variable for each activity and each subject.

## Raw Dataset
The raw datasets contain 3-axial linear acceleration and 3-axial angular velocity data measured by the embedded accelerometer and gyroscope of a Samsung Galaxy S II smartphone. The data were collected from a group of 30 volunteers. Each of them performed six activities (WALKING, WALKING_UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a Samsung Galaxy S II smartphone. The study contains training and test data. For  further explanations read the README.txt file that comes along with the dataset.

## Procedure
In the following the steps of the `run_analysis.R` file are explained.

##### Step 0
In the very first part of the `run_analysis.R` file, the raw data are downloaded, unzipped and stored. A data folder is created and the downloaded zip.file is stored in it called `Dataset.zip`. When the zip file is unzipped, a folder called `UCI HAR Dataset` is created. It contains all the relevant datasets.

##### Step 1
The `X_test.txt`, `y_test.txt`, `subject_test.txt` as well as the correspondent training data are read in and stored in variables called `X_test`, `Y_test`, `subject_test`, `X_train`, `Y_train`, `subject_train`. The test and training data are merged by `rbind()` and stored as `X_data`, `Y_data` and `subjected_data`. The observations in the `Y_data`, `subject_data` and `X_data` datasets are named. For the `X_data`set the file `features.txt` is used. Finally, the datasets are merged using `cbind()`to create a single dataset called `data`.

##### Step 2
In step 2 columns with column name containing the words „mean()“ or „std()“ are extracted. In order to find the columns the `grep()` command is used. The subset is created by running the `subset()` command. Finally, the dataset is stored as `data_sub`.

##### Step 3
In this section, the activities coded with 1, 2, 3, …, 6 in the `data_sub$activity` column are renamed using the information in the `activity_labels.txt` file. Explicitly, the numbers 1, 2, 3, 4, 5, 6 are replaced by WALKING, WALKING_UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING.

##### Step 4
Some of the variables of the `data_sub` dataset are labeled with abbreviations. This can make it hard to understand the meaning of the variables. In step 4, the abbreviation are substituted by the full names. These replacements are being made:

* t -> time
* f -> frequency
* Gyro -> Gyroscope
* Acc -> Accelerator
* Mag -> Magnitude

##### Step 5
Step 5 is the last step of the process. In this step, an independent tidy dataset with the average of each variable for each activity and each subject is created. The grouping is performed using the `aggregate()`command. The grouping is done by adding the column names „subject“ and „activity“ as arguments to the `aggregate`function. Further, the dataset is ordered by subject and activity and stored as `data_sub2`. Finally the dataset is exported as `Dataset_clean.txt` by applying the `write.table()` function and passing `row.name = F` as one of the arguments. The `Dataset_clean.txt` file consists of 180 rows and 81 columns.

The `Dataset_clean`file can be used for further analysis.

## Variables 
This section gives an overview over the most important variables. 

- `X_test`, `Y_test`, `subject_test`, `X_train`, `Y_train`, `subject_train` contain the original training and test data provided by `X_train.txt`, `y_train.txt`, `subject_train.txt`, `X_test.txt`, `y_test.txt` and `subject_test.txt`.
- `X_data`, `Y_data` and `subject_data` store the merged training and test datasets.
- `data` is the dataset that contains all the raw data.
- `data_sub` is the subset with only the measurements on the mean and the standard deviation
- `data_sub2`is the aggregated dataset after grouping the `data_sub` dataset by subject and activity.