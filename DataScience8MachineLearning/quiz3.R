## 1
library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)

inTrain <- createDataPartition(y = segmentationOriginal$Case,
                               p = 0.7, list = FALSE)
training <- segmentationOriginal[inTrain,]
testing <- segmentationOriginal[-inTrain,]
dim(training)
dim(testing)

set.seed(125)
modfit1 <- train(Class ~ ., method = "rpart", data=training)

plot(modfit1$finalModel, uniform = TRUE, main = "Classification Tree")
text(modfit1$finalModel, use.n = TRUE, all = TRUE, cex = 0.8)

library(rattle)
fancyRpartPlot(modfit1$finalModel)

modfit1$finalModel


## 2 

Explanatory

## 3

library(pgmm)
data(olive)
olive = olive[,-1]

newdata = as.data.frame(t(colMeans(olive)))

modolive <- train(Area ~ ., method = "rpart", data = olive)
predict(modolive, newdata = newdata)

## 4

library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]

set.seed(13234)
modelSA <- train(chd ~ age + alcohol + obesity + tobacco + typea + ldl, 
                 data = trainSA, method = "glm", family = "binomial")

missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}

missClass(testSA$chd, predict(modelSA, newdata = testSA))
missClass(trainSA$chd, predict(modelSA, newdata = trainSA))

## 5

library(ElemStatLearn)
data(vowel.train)
data(vowel.test)

vowel.train$y <- factor(vowel.train$y)
vowel.test$y <- factor(vowel.test$y)

set.seed(33833)
modfit2 <- randomForest(y ~ ., data=vowel.train)
library(randomForest)
library(caret)
order(varImp(modfit2))
