library(UsingR)
library(galton)

diabetesRisk <- function(glucose) glucose / 200

shinyServer(
    function(input,output){
        output$newHist<- renderPlot({
            hist(galton$child)
        })
    }
)