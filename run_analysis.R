## Coursera Getting and Cleaning Data Project

library(reshape2)
library(plyr)

# load activity_labels.txt & features.txt
activityLabels <- read.table(file = "activity_labels.txt")
activityLabels$V2 = as.character(activityLabels$V2)
features <- read.table(file = "features.txt")
features$V2 <- as.character(features$V2)

# Extract
featuresSubRowNum <- grep(".*mean.*|.*std.*", features$V2)
featuresSub <- features[featuresSubRowNum,2]

# Change names
featuresSub = gsub("-mean", "Mean", featuresSub)
featuresSub = gsub("-std","Std", featuresSub)
featuresSub = gsub("[-()]", "", featuresSub)  # ???

# Load data
train <- read.table("train/X_train.txt")[featuresSubRowNum]
trainActivities <- read.table("train/Y_train.txt")
trainSubjects <- read.table("train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("test/X_test.txt")[featuresSubRowNum]
testActivities <- read.table("test/Y_test.txt")
testSubjects <- read.table("test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# Combine!

dataMerge <- rbind(train, test)
colnames(dataMerge) <- c("Subjects", "Activities", featuresSub)
dataMergeCopy <- dataMerge    # create a copy in case of error action

# A tidy data set
dataMerge$Subjects = as.factor(dataMerge$Subjects)
dataMerge$Activities = as.factor(dataMerge$Activities)
dataAverage <- ddply(dataMerge, .(Subjects, Activities), function(x) colMeans(x[, 3:81]))

# Save
write.table(dataAverage, "tidy_data_Average.txt", row.name=FALSE)
