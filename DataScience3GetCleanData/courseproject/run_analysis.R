setwd("/Users/ericweber/GitHub/datasciencecoursera/DataScience3GetCleanData/courseproject")

#Read in data and load datasets for cleaning

train = read.csv("UCI HAR Dataset/train/X_train.txt", sep ="", header = FALSE)
train[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep ="", header = FALSE)
train[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep ="", header = FALSE)

test = read.csv("UCI HAR Dataset/test/X_test.txt", sep ="", header = FALSE)
test[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep ="", header = FALSE)
test[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep ="", header = FALSE)

labels = read.csv("UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)

features = read.csv("UCI HAR Dataset/features.txt", sep = "", header = FALSE)

## Adjust features so they fit with subsequent analysis
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('-()', '', features[,2])

## Merge training and test sets to create one data set
merged = rbind(train,test)

## Extract mean and standard deviation for each measurement in data set
desiredcols<- grep(".*Mean.*|.*Std.*", features[,2])
## replace features with mean and standard deviation, then add subject/activity information
features<- features[desiredcols,]
desiredcols<- c(desiredcols, 562, 563)

##To make the file easier to work with, remove non-relevant columns from the merged set, then
## give the new names from the features file that was created earlier. Next, make the names
## lowercase.
merged<- merged[,desiredcols]
colnames(merged)<-c(features$V2, "Activity", "Subject")
colnames(merged)<-tolower(colnames(merged))

## Create independent tidy data set with average of each variable for each activity and subject

index = 1
for (currentlabel in labels$V2){
        merged$activity<- gsub(index,currentlabel,merged$activity)
        index<- index + 1
}

## Create activity and subject as factor levels in preparation for determining means

activityasfactor<- as.factor(merged$activity)
subjectasfactor <- as.factor(merged$subject)

## Determine means of each variable by activity and for each subject
cleaned = aggregate(merged, by=list(activity = activityasfactor, subject = subjectasfactor),mean)

## Remove subject and activity
cleaned[,90]=NULL
cleaned[,89]=NULL
write.table(cleaned,"tidy.txt", sep = '\t')