setwd("/Users/ericweber/Desktop/NewEducation/rstuff/explore/project2")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(plyr)
library(ggplot2)

#1 Total emission PM2.5 from 1999 to 2008. Base plot, show total PM2.5 emissions from all sources 
# for each year

#par("mar"=c(5.1,4.5,4.1,2.1))
png(filename = "plot1.png",
    width = 480, height = 480,
    units = "px")
totalEmissions <- aggregate(NEI$Emissions, list(NEI$year), FUN = "sum")

plot(totalEmissions, type = "l", xlab = "Year",
     main = "Total Emissions in USA from 1999 to 2008",
     ylab = expression('Total PM'[2.5]*" Emission"))
dev.off()
