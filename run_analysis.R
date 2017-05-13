## This is the run_analysis.R for the course Getting & Cleaning Data
## The script will combine 7,352 training records and 2,947 test records into 1 big data set 

## 1. Create a directory to store the downloaded zipped file

if(!file.exists("./data")) {
    dir.create("./data")
}

## 2. Download the zipped file and unzip the zipped file

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/prj-data.zip", method="curl")

unzip(zipfile = "./data/prj-data.zip", exdir="./data")

## 3 The project requires processing three types of files: Features, Subject and Activities
## Load the files for both train & test accordingly
## Files have no header

dataFeaturesTrain <- read.table(file.path("./data", "UCI HAR Dataset", "train", "X_train.txt"), header = FALSE)
dataFeaturesTest <- read.table(file.path("./data", "UCI HAR Dataset", "test", "X_test.txt"), header = FALSE)

dataSubjectTrain <- read.table(file.path("./data", "UCI HAR Dataset", "train", "subject_train.txt"), header = FALSE)
dataSubjectTest <- read.table(file.path("./data", "UCI HAR Dataset", "test", "subject_test.txt"), header = FALSE)

dataActivityTrain <- read.table(file.path("./data", "UCI HAR Dataset", "train", "Y_train.txt"), header = FALSE)
dataActivityTest <- read.table(file.path("./data", "UCI HAR Dataset", "test", "Y_test.txt"), header = FALSE)

## 4. Merge the training and the test sets, set their names and combine them

## merge by rows
mergedFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)
featureNames = read.table(file.path("./data", "UCI HAR Dataset", "features.txt"), head=FALSE)

# For feature name, take the second column because first column is a running sequence #
names(mergedFeatures) <- featureNames$V2

## merge by rows
mergedSubject <- rbind(dataSubjectTrain, dataSubjectTest)
names(mergedSubject) <- c("Subject")

## merge by rows
mergedActivity <- rbind(dataActivityTrain, dataActivityTest)
names(mergedActivity) <- c("Activity")

## merge all data, by columns
mergedData1 <- cbind(mergedFeatures, mergedActivity)
fullData <- cbind(mergedSubject, mergedData1)

## 5. Extracts only the measurements on the mean and standard deviation for each measurement.

## Referring features.txt, "mean()" and "std()" are identifier to denote these fields 
## Use the result to subset the full data frame 
nameMeanStd <- featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)]
nameMeanStdSA <- c(as.character(nameMeanStd), "Subject", "Activity")
meanstdData <- subset(fullData, select=nameMeanStdSA)

## 6. Uses descriptive activity names to name the activities in the data set
## Re-use names from activity_labels.txt

activityLabels <- read.table(file.path("./data", "UCI HAR Dataset", "activity_labels.txt"), head=FALSE)

fullData$Activity <- factor(fullData$Activity)
fullData$Activity <- factor(fullData$Activity, labels=as.character(activityLabels$V2))

## 7. Appropriately labels the data set with descriptive variable names
## Refers to features_info text, where it indicates t=time, f=frequency, acc=Accelerometer, gyro=Gyroscope
## use gsub to substitute the naming

names(fullData) <- gsub("^t", "time", names(fullData))
names(fullData) <- gsub("^f", "frequency", names(fullData))
names(fullData) <- gsub("Acc", "Accelerometer", names(fullData))
names(fullData) <- gsub("Gyro", "Gyroscope", names(fullData))

## 8. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## Use plyr package learnt from previous module

library(plyr)
newData <- aggregate(. ~Subject + Activity, fullData, mean)
newData <- newData[order(newData$Subject, newData$Activity),]
write.table(newData, file = "tidyData.txt", row.names=FALSE)


