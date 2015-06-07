setwd("/Users/ericweber/Desktop/NewEducation/rstuff/explore/project2")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
library(lattice)

#3 Of the four types of sources (point, nonpoint,onroad,nonroad), which have seen decreases
# in Baltimore City from 1999 to 2008? Whcih have seen increases? Use ggplot2

subsetBC <- NEI[NEI$fips == "24510", ]

png(filename = "plot3.png",
    width = 480, height = 480,
    units = "px")

g<- ggplot(subsetBC, aes(year,Emissions,color=type))
g + geom_line(stat = "summary", fun.y = "sum") +
        ylab(expression('Total PM'[2.5]*" Emissions")) + 
        ggtitle("Total Emissions in Baltimore City from 1999 to 2008")
dev.off()