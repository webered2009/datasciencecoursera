setwd("/Users/ericweber/Desktop/NewEducation/rstuff/explore/project2")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
library(lattice)


#5 How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

png(filename = "plot5.png",
    width = 480, height = 480,
    units = "px")

subsetBC <- NEI[NEI$fips == "24510", ]

car<- grep("motor", SCC$Short.Name, ignore.case = T)
car<- SCC[car,]
car<- subsetBC[subsetBC$SCC %in% car$SCC, ]
carAmount<- aggregate(car$Emissions, list(car$year), FUN = "sum")

plot(carAmount, type = "l", xlab = "Year",
     main = "Total Emissions from Motor Vehicle Sources\n in Baltimore City from 1999 to 2008",
     ylab = expression('Total PM'[2.5]*" Emission"))

dev.off()
