setwd("/Users/ericweber/Desktop/NewEducation/rstuff/explore/project2")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
library(lattice)


#4 Across the USA, how have emissions from coal combustion related sources changed from 1999 to 
# 2008?

png(filename = "plot4.png",
    width = 480, height = 480,
    units = "px")

coal<- grep("coal", SCC$Short.Name, ignore.case = T)
coal<- SCC[coal,]
coal<- NEI[NEI$SCC %in% coal$SCC, ]

coalAmount<- aggregate(coal$Emissions, list(coal$year), FUN = "sum")

plot(coalAmount, type = "l", xlab = "Year",
     main = "Total Emissions from Coal Combustion-related Sources from 1999 to 2008",
     ylab = expression('Total PM'[2.5]*" Emission"))

dev.off()