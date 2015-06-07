setwd("/Users/ericweber/Desktop/NewEducation/rstuff/explore/project2")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
library(lattice)


#6 Compare emissions from motor vehicle sources in Baltimore City with those in Los Angeles
# county (fips = 06037). Which city has seen greater changes over time in MV emissions?

png(filename = "plot6.png",
    width = 480, height = 480,
    units = "px")

subsetBCLA <- NEI[NEI$fips == "24510" | NEI$fips == "06037", ]

car2<- grep("motor", SCC$Short.Name, ignore.case = T)
car2<- SCC[car2,]
car2<- subsetBCLA[subsetBCLA$SCC %in% car2$SCC, ]

g<- ggplot(car2, aes(year,Emissions,color=fips))
g + geom_line(stat = "summary", fun.y = "sum") +
        ylab(expression('Total PM'[2.5]*" Emissions")) + 
        ggtitle("Comparison of Total Emissions From Motor\n Vehicle Sources in Baltimore City\n and Los Angeles County from 1999 to 2008") +
        scale_color_discrete(name = "Group", label = c("Los Angeles","Baltimore"))
dev.off()