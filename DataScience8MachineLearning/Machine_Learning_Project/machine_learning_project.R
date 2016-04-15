
## Download and read in data

local_path <- "/Users/ericweber/Dropbox/datasciencecourseraPersonal/DataScience8MachineLearning/Machine_Learning_Project"
setwd(local_path)
library(caret, quietly=TRUE)
url_train <- 'https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv'
url_test <- 'https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv'
download.file(url = url_train, destfile = 'data_train.csv')
download.file(url = url_test, destfile = 'data_test.csv')

pml_train <- read.csv(file = 'data_train.csv',
                      na.strings = c('NA','#DIV/0!',''))

pml_test <- read.csv(file = 'data_test.csv',
                      na.strings = c('NA','#DIV/0!',''))