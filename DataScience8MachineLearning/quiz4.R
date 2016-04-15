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


## 1

data("vowel.train")
data("vowel.test")

vowel.train$y <- factor(vowel.train$y)
vowel.test$y <- factor(vowel.test$y)

set.seed(33833)

rf_1 <- train(y ~ ., method = "rf", data = vowel.train)
gbm_1 <- train(y ~ ., method = "gbm", data = vowel.train)

rf_1_test <- predict(rf_1, newdata = vowel.test)
gbm_1_test <- predict(gbm_1, newdata = vowel.test)

agreed_test <- rf_1_test [rf_1_test == gbm_1_test]
confusionMatrix(rf_1_test,vowel.test$y)
confusionMatrix(gbm_1_test, vowel.test$y)
confusionMatrix(gbm_1_test, rf_1_test)

confusionMatrix(agreed_test, vowel.test$y[rf_1_test == gbm_1_test])

## 2

set.seed(3433)
data(AlzheimerDisease)

adData = data.frame(diagnosis,predictors)
inTrain_2 = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training_2 = adData[ inTrain,]
testing_2 = adData[-inTrain,]

set.seed(62433)

rf_2 <- train(diagnosis ~ ., method = "rf", data = training_2)
gbm_2 <- train(diagnosis ~ ., method = "gbm", data = training_2)
lda_2 <- train(diagnosis ~ ., method = "lda", data = training_2)

rf_2_pred <- predict(rf_2, newdata = training_2)
gbm_2_pred <- predict(gbm_2, newdata = training_2)
lda_2_pred <- predict(lda_2, newdata = training_2)

comb_data <- data.frame(rf = rf_2_pred, gbm = gbm_2_pred, lda = lda_2_pred, diagnosis = training_2$diagnosis)
model_comb <- train(diagnosis ~ ., method = "rf", data = comb_data)

rf_2_test <- predict(rf_2, newdata = testing_2)
gbm_2_test <- predict(gbm_2, newdata = testing_2)
lda_2_test <- predict(lda_2, newdata = testing_2)
comb_data_2_test <- data.frame(rf = rf_2_test, gbm = gbm_2_test, lda = lda_2_test, diagnosis = testing_2$diagnosis)
comb_2_test <- predict(model_comb, comb_data_2_test)

confusionMatrix(rf_2_test, testing_2$diagnosis)
confusionMatrix(gbm_2_test, testing_2$diagnosis)
confusionMatrix(lda_2_test, testing_2$diagnosis)
confusionMatrix(comb_2_test, testing_2$diagnosis)

comb_data <- data.frame(rf = rf_2, gbm = gbm_2, lda = lda_2_test, diagnosis = training_2$diagnosis)

## 3


set.seed(3523)
library(elasticnet)
library(AppliedPredictiveModeling)
data(concrete)
inTrain_3 = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training_3 = concrete[ inTrain,]
testing_3 = concrete[-inTrain,]

set.seed(233)
lassoFit <- train(training_3$CompressiveStrength ~ ., method="lasso", data=training_3)
lassoPred <- predict(lassoFit,testing_3)
plot.enet(lassoFit$finalModel, xvar="penalty", use.color=T)

## 4

library(lubridate) # For year() function below
dat = read.csv("/Users/ericweber/Dropbox/datasciencecourseraPersonal/DataScience8MachineLearning/gaData.csv")
training_4 = dat[year(dat$date) < 2012,]
testing_4 = dat[(year(dat$date)) > 2011,]
tstrain_4 = ts(training_4$visitsTumblr)

bats_4 <- bats(tstrain_4)
pred_4 <- forecast(bats_4, level = 95, h = dim(testing_4)[1])
sum(pred_4$lower < testing_4$visitsTumblr & testing_4$visitsTumblr < pred_4$upper) / 
    dim(testing_4)[1]

## 5

set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain_5 = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training_5 = concrete[ inTrain,]
testing_5 = concrete[-inTrain,]

set.seed(325)
library(e1071)
mod_svm<- svm(CompressiveStrength ~ ., data = training_5) 
pred_svm<- predict(pred_5,testing_5)
accuracy(pred_svm, testing_5$CompressiveStrength)

plot(pred_svm, testing_5$CompressiveStrength, 
     pch=20, cex=1, 
     col=testing_5$Age,
     main="Relationship between the svm forecast and actual values")
