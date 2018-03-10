##Laro Navamuel 2018

##This scripts follows step to step procedure to create a tidy.dataset
## as part of Getting and Cleaning Data project for Coursera.
##Original data are retrieved from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
##The data are downloaded from this URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##Fist we load required libraries

library(dplyr)
library(data.table)


#Check if exists datafile or not to skip download every time.
#Set data directory as extraction folder.

destinationFile ="/UCI_HAR_Dataset.zip"
extractDir ="./data"

if (!file.exists(destinationFile)) 
{
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl,destfile=destinationFile,method = "auto")
        unzip(destinationFile,exdir = extractDir)
} else {
        unzip(destinationFile,exdir = extractDir)
}


##Load each data set.
##'features_info.txt': Shows information about the variables used on the feature vector.
##''features.txt': List of all features.
##''activity_labels.txt': Links the class labels with their activity name.
##'train/X_train.txt': Training set.
##'train/y_train.txt': Training labels.
##''test/X_test.txt': Test set.
##''test/y_test.txt': Test labels.

training.dataset <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
training.labels <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
training.subjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
 
test.dataset <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test.labels <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test.subjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

activity.labels <-read.table("./data/UCI HAR Dataset/activity_labels.txt")
features.labels <- read.table("./data/UCI HAR Dataset/features.txt")
 
#Assign variable name to each column
names(test.dataset) <- features.labels$V2
names(training.dataset) <- features.labels$V2
 
#Assign each activity row record to each subject
training.dataset <- cbind("Subject"=training.subjects$V1,training.dataset)
test.dataset <- cbind("Subject"=test.subjects$V1,test.dataset)

#Remove Unused Objects from workspace
rm(training.subjects)
rm(test.subjects)
 
 
#Merge each data set labels with activity labels.
mergedtraining.labels <- merge.data.frame(training.labels,activity.labels,by.x = "V1",by.y = "V1",all=TRUE)
mergedtest.labels <- merge.data.frame(test.labels,activity.labels,by.x = "V1",by.y = "V1",all=TRUE)

#Remove Unused Objects from workspace
rm(activity.labels)
rm(test.labels)
rm(training.labels)

#Assign Activity column name and values to each data set.
combinedtest.dataset <- cbind("Activity"=mergedtest.labels$V2,test.dataset)
combinedtraining.dataset <- cbind("Activity"=mergedtraining.labels$V2,training.dataset)
 
#Remove Unused Objects from workspace
rm(test.dataset)
rm(training.dataset)
rm(features.labels)
rm(mergedtest.labels)
rm(mergedtraining.labels)

#Creation of tidy DataSet with training and test data.
tidy.dataset <- rbind(combinedtest.dataset,combinedtraining.dataset)
 
#Remove Unused Objects from workspace
rm(combinedtest.dataset)
rm(combinedtraining.dataset)

# Fix column names to understandable name ####
names(tidy.dataset) <- gsub('\\(|\\)', '', names(tidy.dataset))
names(tidy.dataset) <- gsub('-|,', '.', names(tidy.dataset))
names(tidy.dataset) <- gsub('BodyBody', 'Body', names(tidy.dataset))
names(tidy.dataset) <- gsub('^f', 'Frequency.', names(tidy.dataset))
names(tidy.dataset) <- gsub('^t', 'Time.', names(tidy.dataset))
names(tidy.dataset) <- gsub('^angle', 'Angle.', names(tidy.dataset))
names(tidy.dataset) <- gsub('mean', 'Mean', names(tidy.dataset))
names(tidy.dataset) <- gsub('tBody', 'TimeBody', names(tidy.dataset))


#Once that we have tidy data set then extract only std and mean for each measure.
final.dataset <- subset(tidy.dataset, select = grep("Activity|Subject|std|Mean", names(tidy.dataset)))
final.dataset <- subset(final.dataset, select = -grep ("MeanFreq", names(final.dataset)))
final.dataset <- subset(final.dataset, select = -grep ("gravityMean", names(final.dataset)))
final.dataset <- subset(final.dataset, select = -grep ("Angle", names(final.dataset)))

#Remove unused Objects
rm(tidy.dataset)

#Create a second independent tidy data set with mean and sd of each measurment and subject and activity
setDT(final.dataset)
newtidy.dataset <- final.dataset[,lapply(.SD,mean),by="Activity,Subject"]

#Order new tidy data set for subect and activity.
newtidy.dataset <- newtidy.dataset[order(newtidy.dataset$Subject, newtidy.dataset$Activity),]

#creation of a file with this new tidy data set
write.table(newtidy.dataset, file="./data/clon_tidy_data.txt", row.names=FALSE)

# Reading new file created for verification purposses
clonedtidy.dataset <- read.csv("./data/clon_tidy_data.txt", sep=' ')

#Recover colnames for using later on codebook.md
write.table(colnames(final.dataset), './data/new_tidy_data_set_cols.txt', row.names=FALSE)




