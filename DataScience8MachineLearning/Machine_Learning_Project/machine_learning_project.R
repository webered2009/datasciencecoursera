
## Download and read in data

local_path <- "/Users/ericweber/Dropbox/datasciencecourseraPersonal/DataScience8MachineLearning/Machine_Learning_Project"
setwd(local_path)
library(caret, quietly=TRUE)

#url_train <- 'https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv'
#url_test <- 'https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv'
#download.file(url = url_train, destfile = 'data_train.csv')
#download.file(url = url_test, destfile = 'data_test.csv')

## Use data.table to read in the files (faster than read.csv)

library(data.table)

train <- fread('data_train.csv', 
                   na.strings = c('NA','#DIV/0!',''))
train <- as.data.frame(train)
test <- fread('data_test.csv', 
                  na.strings = c('NA','#DIV/0!',''))
test <- as.data.frame(test)


## Clean the dataset, keeping only columns where we have no missing values

train_complete <- train[, colSums(is.na(train)) == 0] 
test_complete <- test[, colSums(is.na(test)) == 0]

## Remove other columns that won't help the analysis (non-numeric or int types)

classe <- factor(train_complete$classe)
train_to_delete <- grepl("window|timestamp|^X", names(train_complete))
train_complete <- train_complete[,!train_to_delete]
train_for_analysis <- train_complete[,sapply(train_complete, is.numeric)]
train_for_analysis$classe <- classe

test_to_delete <- grepl("window|timestamp|^X", names(test_complete))
test_complete <- test_complete[,!test_to_delete]
test_for_analysis <- test_complete[,sapply(test_complete, is.numeric)]

## Split the training dataset into predictor and test subsets

set.seed(4444) 
inTrain <- createDataPartition(train_for_analysis$classe, p = 0.60, list = FALSE)
trainData <- train_for_analysis[inTrain, ]
testData <- train_for_analysis[-inTrain, ]

## Load packages necessary for model development 

library(AppliedPredictiveModeling)
library(caret)
library(ElemStatLearn)
library(pgmm)
library(rpart)
library(rpart.plot)
library(gbm)
library(lubridate)
library(forecast)
library(e1071)
library(randomForest)
library(rattle)

cross_val <- trainControl(method="cv", 5)

gbm <- train(classe ~ ., method = "gbm", trControl = cross_val, data = trainData)
lda <- train(classe ~ ., method = "lda", trControl = cross_val, data = trainData)
rf <- randomForest(classe ~ .,data= trainData , ntree=500, importance=TRUE)

gbm_pred <- predict(gbm, newdata = testData)
lda_pred <- predict(lda, newdata = testData)
rf_pred <- predict(rf, newdata = testData)

confusionMatrix(gbm_pred, testData$classe)
confusionMatrix(lda_pred, testData$classe)
confusionMatrix(rf_pred, testData$classe)
