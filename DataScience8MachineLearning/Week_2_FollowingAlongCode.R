library(caret)
library(kernlab)
data(spam)
inTrain <- createDataPartition(y=spam$type, p = 0.75, list = FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]
dim(training)

set.seed(32343)
modelFit <- train(type ~., data=training, method = "glm")
modelFit$finalModel
predictions <- predict(modelFit, newdata = testing)
predictions

confusionMatrix(predictions,testing$type)

set.seed(32323)
folds <- createFolds(y=spam$type, k = 10, list = TRUE, returnTrain = FALSE)
sapply(folds,length)

folds2 <- createResample(y=spam$type, times = 10, list = TRUE)
sapply(folds2,length)

tme = 1:1000
folds3 <- createTimeSlices(y=tme, initialWindow = 20, horizon = 10)
names(folds3)

## Plotting predictors

library(ISLR)
library(ggplot2)
library(caret)
data(Wage)
summary(Wage)

inTrain <- createDataPartition(y=Wage$wage, p = 0.7, list = FALSE)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]
dim(training)
dim(testing)

featurePlot(x=training[,c("age", "education", "jobclass")],
            y = training$wage,
            plot = "pairs")

qplot(age, wage, colour = jobclass, data=training)
qq <- qplot(age, wage, colour=education, data=training)
qq + geom_smooth(method='lm', formula=y~x)

library(Hmisc)
cutWage <- cut2(training$wage, g=3)
table(cutWage)

library(gridExtra)
p2 <- qplot(cutWage, age, data=training, fill=cutWage,geom=c("boxplot", "jitter"))
p1 <- qplot(cutWage, age, data=training, fill=cutWage,geom=c("boxplot"))
grid.arrange(p1,p2,ncol=2)

t1 <- table(cutWage, training$jobclass)
prop.table(t1,1)
qplot(wage, colour=education, data=training, geom="density")

## PreProcessing (when using model based approaches)

library(caret)
library(kernlab)
data(spam)

inTrain <- createDataPartition(y=spam$type, p = 0.75, list = FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]

hist(training$capitalAve, main = "", xlab = "ave. capital run length")
mean(training$capitalAve)
sd(training$capitalAve)

trainCapAve <- training$capitalAve
trainCapAveS <- (trainCapAve - mean(trainCapAve))/sd(trainCapAve)
mean(trainCapAveS)
sd(trainCapAveS)

## Note, must use mean from training set for standardization! (Won't be exactly zero or one)

testCapAve <- testing$capitalAve
testCapAveS <- (testCapAve - mean(trainCapAve))/sd(trainCapAve)
mean(testCapAveS)
sd(testCapAveS)

## does all the pre processing for us! 

preObj <- preProcess(training[,-58], method = c("center", "scale"))
trainCapAveS <- predict(preObj, training[,-58])$capitalAve
mean(trainCapAveS)

## Apply to training set

testCapAveS <- predict(preObj, testing[,-58])$capitalAve
mean(testCapAveS)

## Pass pre process commands to training set
set.seed(32343)
modelFit <- train(type~., data = training,
                  preProcess = c("center", "scale"), method = "glm")
modelFit

## Centering and scaling, but then beyond as well

preObj <- preProcess(training[,-58], method = c("BoxCox"))
trainCapAveS <- predict(preObj,training[,-58])$capitalAve
par(mfrow = c(1,2))
hist(trainCapAveS)
qqnorm(trainCapAveS)

## Imputing data

library(RANN)
set.seed(13343)

training$capAve <- training$capitalAve
selectNA <- rbinom(dim(training)[1], size=1, prob = 0.05) == 1
training$capAve[selectNA] <- NA

preObj <- preProcess(training[,-58], method = "knnImpute")
capAve <- predict(preObj, training[,-58])$capAve

capAveTruth <- training$capitalAve
capAveTruth <- (capAveTruth - mean(capAveTruth))/sd(capAveTruth)

## prediction algoriths don't do well with missing data

quantile(capAve - capAveTruth)
## we can tell it went relatively well as the values imputed were differed by close to zero
quantile((capAve - capAveTruth)[selectNA])
quantile((capAve - capAveTruth)[!selectNA])

## Training and test sets must be processed in the same way
## Factor variables, more difficult to know right transformation

## Covariate creation (feature creation)

library(kernlab)
data(spam)

spam$capitalAveSq <- spam$capitalAve^2

library(ISLR)
library(caret)
data(Wage)
inTrain <- createDataPartition(y=Wage$wage,
                               p = 0.7, 
                               list = FALSE)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]

## turning factors variables to indicator variables
table(training$jobclass)
dummies <- dummyVars(wage ~ jobclass, data = training)
head(predict(dummies, newdata = training))

nsv <- nearZeroVar(training, saveMetrics = TRUE)

library(splines)
bsBasis <- bs(training$age, df = 3)
bsBasis

lm1 <- lm(wage ~ bsBasis, data = training)
plot(training$age, training$wage, pch = 19, cex = 0.5)
points(training$age, predict(lm1, newdata=training), col = "red", pch = 19, cex = 0.5)

predict(bsBasis, age=testing$age)

## create covariates on test dataset using same procedure as in first time

## Preprocessing with Prin. Comp. Analysis
library(caret)
library(kernlab)
data(spam)

inTrain <- createDataPartition(y=spam$type, p = 0.75, list = FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]

M <- abs(cor(training[,-58]))
diag(M) <- 0
which(M > 0.8, arr.ind = T)

names(spam)[c(32, 34, 40)]
plot(spam[,32],spam[,32])

## Basic PCA idea - weighted combination of predictors (PCA)
## Reduce number of predictors, reducing noise (gain quite a bit)
## Figure out a combination of variables that explains most of the variability

## statistical goal, then data compression, use fewer variables to explain almost everything going on

## SVD and PCA

smallSpam <- spam[,c(34,32)]
prComp <- prcomp(smallSpam)
plot(prComp$x[,1],prComp$x[,2])

typeColor <- ((spam$type == "spam")*1 + 1)
prComp <- prcomp(log10(spam[,-58]+1))
plot(prComp$x[,1],prComp$x[,2], col = typeColor, xlab = "PC1", ylab = "PC2")

## PCA in carat

library(caret)
inTrain <- createDataPartition(y=spam$type,p=0.75, list=FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]
# create preprocess object
preProc <- preProcess(log10(training[,-58]+1),method="pca",pcaComp=2)
# calculate PCs for training data
trainPC <- predict(preProc,log10(training[,-58]+1))
# run model on outcome and principle components
modelFit <- train(training$type ~ .,method="glm",data=trainPC)
# calculate PCs for test data
testPC <- predict(preProc,log10(testing[,-58]+1))
# compare results
confusionMatrix(testing$type,predict(modelFit,testPC))

## set number of PCs
modelFit <- train(training$type ~ ., method = "glm", preProcess = "pca", data = training)
confusionMatrix(testing$type,predict(modelFit,testing))

data("faithful")
set.seed(333)

inTrain <- createDataPartition(y=faithful$waiting, p = 0.5, list = FALSE)
trainFaith <- faithful[inTrain,]
testFaith <- faithful[-inTrain,]
head(trainFaith)

## Didn't write down stuff for basic regression

## Reg with Covariates

library(ISLR)
library(ggplot2)
library(caret)
data(Wage)
Wage <- subset(Wage, select = -c(logwage))
summary(Wage)

inTrain <- createDataPartition(y=Wage$wage,
                               p = 0.7, list = FALSE)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]

qplot(age, wage, data = training)
qplot(age,wage,colour = jobclass, data=training)
qplot(age, wage, colour=education, data=training)

modFit <- train(wage ~ age + jobclass + education, method = "lm", data = training)
finMod <- modFit$finalModel
print

plot(finMod, 1, pch = 19, cex = 0.5, col = "#00000010")
qplot(finMod$fitted, finMod$residuals, colour = race, data = training)
plot(finMod$residuals, pch = 19)

pred <- predict(modFit, testing)
qplot(wage, pred, colour = year, data = testing)
