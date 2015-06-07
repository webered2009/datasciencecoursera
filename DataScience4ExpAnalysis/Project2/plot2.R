setwd("/Users/ericweber/Desktop/NewEducation/rstuff/explore/project2")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
library(lattice)


#2 Have total emissions from PM2.5 decreased in Baltimore City (fips = 24510) from 1999 to 2008?
# Use base plotting system to make a plot to answer the question

png(filename = "plot2.png",
    width = 480, height = 480,
    units = "px")

subsetBC <- NEI[NEI$fips == "24510", ]
totalEmissionsBC <- aggregate(subsetBC$Emissions, list(subsetBC$year), FUN = "sum")

plot(totalEmissionsBC, type = "l", xlab = "Year",
     main = "Total Emissions Baltimore City from 1999 to 2008",
     ylab = expression('Total PM'[2.5]*" Emission"))
dev.off()
