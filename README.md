# Getting and Cleaning Data: Course Project
=========================================

## Introduction
------------
This repository contains my work for the course project for the Coursera course "Getting and Cleaning data", part of the Data Science specialization. 

## About the raw data
------------------

The features (561 of them) are unlabeled and can be found in the x_train.txt and the activity labels are in the y_train.txt file.
The subjects for training are in the subject_train.txt file.

The same is applied for the test set.

## About the script and the tidy dataset
-------------------------------------
A script called run_analysis.R is created to merge the training and test data sets together. Prerequisites for this script:

1. the UCI HAR Dataset must be downloaded and extracted and,
2. the UCI HAR Dataset must be availble in a directory called "UCI HAR Dataset"

After merging testing and training data sets, labels are added and only columns that have to do with "mean()" and "standard deviation (std())" are kept.

Lastly, the script will create a tidy data set containing the means of all the columns per test subject and per activity.

This resultant tidy dataset will be written to an output file called tidyData.txt.

## About the Code Book
-------------------
The CodeBook.md file explains the transformations performed and the resulting data and variables.

