# Load package necessary for 'dcast' and 'melt' functions if not already installed
if(!("reshape2" %in% installed.packages()))
{
        print("Installing missing 'reshape2' package")
        install.packages("reshape2", quiet = TRUE)
}
library(reshape2)

# Download and extract the UCI HAR dataset if it does not already exist
zipName <- "UCI HAR Dataset.zip"
folderName <- "UCI HAR Dataset"
dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists(zipName))
{
        print("Downloading compressed UCI HAR dataset")
        download.file(dataURL, zipName, method = "curl")
}
if(!file.exists(folderName))
{
        print("Extracting compressed UCI HAR dataset")
        unzip(zipName)
}

# Load tables for activity labels and features, explicitly coerce data from factors to characters
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityFeatures <- read.table("UCI HAR Dataset/features.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
activityFeatures[,2] <- as.character(activityFeatures[,2])

# Apply regular expressions to extract 'mean' and 'std' values for each measurement (excludes 'angle' fields)
extractFeatures <- grep(".*mean.*|.*std.*", activityFeatures[,2])

# Tidy up activity feature labels
extractFeatures.names <- activityFeatures[extractFeatures,2]
extractFeatures.names <- gsub("mean", "Mean", extractFeatures.names)
extractFeatures.names <- gsub("std", "STD", extractFeatures.names)
extractFeatures.names <- gsub("[()-]", "", extractFeatures.names)

# Load data from the 'test' and 'train' datasets
trainRawData <- read.table("UCI HAR Dataset/train/X_train.txt")[,extractFeatures]
trainActivityData <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjectData <- read.table("UCI HAR Dataset/train/subject_train.txt")
testRawData <- read.table("UCI HAR Dataset/test/X_test.txt")[,extractFeatures]
testActivityData <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjectData <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Aggregate all data into one frame and add column names
trainData <- cbind(trainSubjectData, trainActivityData, trainRawData)
testData <- cbind(testSubjectData, testActivityData, testRawData)
mergedData <- rbind(trainData, testData)
colnames(mergedData) <- c("subject", "activity", extractFeatures.names)

# Coerce activities and subjects to factors, add activity labels
mergedData$activity <- factor(mergedData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
mergedData$subject <- factor(mergedData$subject)

# Melt and summarize aggregated dataset by mean for each activity and each subject
meltedData <- melt(mergedData, id = c("subject", "activity"))
summaryData <- dcast(meltedData, subject + activity ~ variable, mean)

# Export "tidy.txt" output file
write.table(summaryData, "tidy.txt", quote = FALSE, row.names = FALSE)

# Remove temporary files
rm(list = setdiff(ls(), "summaryData"))