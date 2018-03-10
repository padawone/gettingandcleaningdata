

# **Introduction**

## Getting and Cleaning Data Course Project

The purpose of this project is collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Raw Data Source

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Transformation Process

The complete transformation of above raw data is made on the R script run_analisys.R. This file does the following:

- Load required libraries for this project. (dplyr, data.table)
- Set filename and directory where raw data will be stored and unzipped.
- Check if destination file exists, if exists  file is extracted  else file will be downloaded and extracted.
- Individual data sets are generated with all needed information
- Assign data of features to each subject that performs it.
- Remove unused objects. (This action is made every few steps to improve performace)
- Assign activity code for each record to each data set block (TEST - TRAINING)
- Assign activity description for each record to each data set block.
- Merge two data set in only one tidy data set. 
- Fix columns names for better understanding of information.
- Remove columns not needed, only have interest in Activity, Subject, mean and standard deviation of each measurement. The rest of datacolumns are removed.
- Creation of new independent data set (newtidy.dataset) that has mean and standard deviation calculation for each measurement by activity and subject.
- Order new tidy data set.
- Creation and export file "clon_tidy_data.txt" with all information.
- Read of new file created for verification purposes.
- Recover final column names for use in codebook.md

