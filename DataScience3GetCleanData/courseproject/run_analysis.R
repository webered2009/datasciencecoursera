setwd("/Users/ericweber/GitHub/datasciencecoursera/DataScience3GetCleanData/courseproject")

#1 Read in data and load datasets for cleaning

basepath<- file.path("UCI HAR Dataset")
files<- list.files(basepath, recursive = TRUE)

#train
trainLabel<- read.table(file.path(basepath, "train", "Y_train.txt"), header = FALSE)
trainData<- read.table(file.path(basepath, "train", "X_train.txt"), header = FALSE)
trainSubject<- read.table(file.path(basepath, "train", "subject_train.txt"), header = FALSE)
#test
testSubject<- read.table(file.path(basepath, "test", "subject_test.txt"), header = FALSE)
testData<- read.table(file.path(basepath, "test", "X_test.txt"), header = FALSE)
testLabel<- read.table(file.path(basepath, "test", "Y_test.txt"), header = FALSE)
#others
features = read.table(file.path(basepath, "features.txt"), header = FALSE)
activity = read.table(file.path(basepath, "activity_labels.txt"), header = FALSE)

#Merge files
mergedData<- rbind(trainData, testData)
dim(mergedData)
mergedLabel<- rbind(trainLabel,testLabel)
dim(mergedLabel)
mergedSubject<- rbind(trainSubject,testSubject)
dim(mergedSubject)

#2 Extract measurements on the mean and median, clean up names
dim(features)
relevantMeasures<- grep("mean\\(\\)|std\\(\\)", features[,2])
length(relevantMeasures)
mergedData <- mergedData[,relevantMeasures]
dim(mergedData)
names(mergedData)<- gsub("\\(\\)","", features[relevantMeasures,2])
names(mergedData)<- gsub("mean", "Mean", names(mergedData))
names(mergedData)<- gsub("std", "Std", names(mergedData))
names(mergedData)<- gsub("-", "", names(mergedData))

#3 Use descriptive activity names to name activities in the dataset
activity[,2]<- tolower(gsub("_","",activity[,2]))
substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8))
substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8))
activityLabels<- activity[mergedLabel[,1],2]
mergedLabel[,1]<- activityLabels
names(mergedLabel)<- "activity"

#4 Label data set with descriptive activity names
names(mergedSubject)<- "subject"
allData<- cbind(mergedSubject,mergedLabel,mergedData)
dim(allData)
names(allData)<-gsub("^t", "time", names(allData))
names(allData)<-gsub("^f", "frequency", names(allData))
names(allData)<-gsub("Acc", "Accelerometer", names(allData))
names(allData)<-gsub("Gyro", "Gyroscope", names(allData))
names(allData)<-gsub("Mag", "Magnitude", names(allData))
names(allData)<-gsub("BodyBody", "Body", names(allData))
write.table(allData, "merged.txt")

#5 Create a second, independent tidy data set with the average of each variable for each activity
#  and each subject
library(plyr); library(dplyr)
tidy<- ddply(allData, .(subject, activity), function(x) colMeans(x[, 3:68]))
write.table(tidy, "tidy.txt", row.name=FALSE)