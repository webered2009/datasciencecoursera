library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(1000)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

hist(concrete$Superplasticizer)

modFit <- train(wage ~ age + jobclass + education, method = "lm", data = training)
finMod <- modFit$finalModel
print

plot(finMod, 1, pch = 19, cex = 0.5, col = "#00000010")
qplot(finMod$fitted, finMod$residuals, colour = race, data = training)
plot(finMod$residuals, pch = 19)


library(caret)
library(AppliedPredictiveModeling)
set.seed(3435)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

training <- training[,c("diagnosis",colnames(adData)[grep("^IL", colnames(adData))])]
testing <- testing[,c("diagnosis",colnames(adData)[grep("^IL", colnames(adData))])]

preProc <- preProcess(training[,-1],method="pca", thresh=0.8)
trainPC <- predict(preProc,training[,-1])
modelFit <- train(training$diagnosis ~ ., method = "glm", preProcess = "pca", data = trainPC)
testPC <- predict(preProc,testing[,-1])
confusionMatrix(testing$diagnosis,predict(modelFit,testPC))

ModelFit2 <- train(diagnosis ~ ., method="glm", preProcess="pca", data=training)
confusionMatrix(testing$diagnosis, predict(ModelFit2, testing))

library(caret)
data(faithful)
set.seed(333)

