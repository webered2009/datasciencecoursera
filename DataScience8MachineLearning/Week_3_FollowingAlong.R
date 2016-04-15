## Predicting with trees

data(iris)
library(ggplot2)
names(iris)

table(iris$Species)

inTrain <- createDataPartition(y = iris$Species,
                               p = 0.7, list = FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]
dim(training)
dim(testing)

qplot(Petal.Width, Sepal.Width, colour = Species, data = training)
library(caret)
modFit <- train(Species ~ ., method = "rpart", data = training)

plot(modFit$finalModel, uniform = TRUE, main = "Classification Tree")
text(modFit$finalModel, use.n = TRUE, all = TRUE, cex = 0.8)

library(rattle)
fancyRpartPlot(modFit$finalModel)

predict(modFit, newdata = testing)

## trees can also be built for regression problems

## Bagging

library(ElemStatLearn)
data(ozone, package= "ElemStatLearn")
ozone <- ozone[order(ozone$ozone),]
head(ozone)

ll <- matrix(NA, nrow=10, ncol=155)
for(i in 1:10) {
    # resample 10 times, sample with replacement, create ozone0 new resample, reorder by ozone,
    # fit loess (smooth curve, like spline) of temp and ozone, using resampled dataset each time
    # predict for each, an outcome for each
    ss <- sample(1:dim(ozone)[1], replace=T)
    ozone0 <- ozone[ss,]
    ozone0 <- ozone0[order(ozone0$ozone),]
    loess0 <- loess(temperature ~ ozone, data=ozone0, span=0.2)
    ll[i,] <- predict(loess0, newdata=data.frame(ozone=1:155))
}
plot(ozone$ozone, ozone$temperature, pch=19, cex=0.5)
for(i in 1:10) {lines(1:155, ll[i,], col='grey', lwd=2)} # 10 grey curvy lines - overcapturing variability
lines(1:155, apply(ll, 2, mean), col='red', lwd=2) # 1 red curvy line = bagged loess curve

## Random forest

data(iris)
library(ggplot2)
names(iris)

table(iris$Species)

inTrain <- createDataPartition(y = iris$Species,
                               p = 0.7, list = FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]

library(caret)
modFit <- train(Species ~ ., data=training, method = "rf", prox = TRUE)
modFit

irisP <- classCenter(training[, c(3,4)], training$Species, modFit$finalModel$prox) # from prox=TRUE
irisP <- as.data.frame(irisP)
irisP$Species <- rownames(irisP)
p <- qplot(Petal.Width, Petal.Length, col=Species, data=training)
p + geom_point(aes(x=Petal.Width, y=Petal.Length, col=Species), size=5, shape=4, data=irisP)

pred <- predict(modFit, testing)
testing$predRight <- pred == testing$Species
table(pred, testing$Species) # 2 missed
qplot(Petal.Width, Petal.Length, color=predRight, data=testing, main='newdata Predictions')

table(pred, testing$Species)


## Boosting

library(ISLR); library(ggplot2); library(caret);
data(Wage)
summary(Wage) # year, age, sex, maritl, race, education, region, jobclass, health
Wage <- subset(Wage, select=-c(logwage)) # remove the logwage variable, the one we are trying to predict
inTrain <- createDataPartition(y=Wage$wage, p=0.7, list=F)
training <- Wage[inTrain, ]
testing <- Wage[-inTrain, ]

modFit <- train(wage ~ ., method='gbm', data=training, verbose=FALSE) # would be lots of output
print(modFit)

qplot(predict(modFit, testing), wage, data=testing) # has group up above, as was seen in earlier data
###

data(iris)
library(ggplot2)
names(iris)

table(iris$Species)

inTrain <- createDataPartition(y = iris$Species,
                               p = 0.7, list = FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]


modlda = train(Species ~ ., data=training, method='lda')
modnb = train(Species ~ ., data=training, method='nb')
plda = predict(modlda, testing)
pnb = predict(modnb, testing)
table(plda, pnb)

equalPredictions = (plda==pnb)
qplot(Petal.Width, Sepal.Width, color=equalPredictions, data=testing)