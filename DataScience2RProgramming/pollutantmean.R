pollutantmean <- function(directory, pollutant, id = 1:332) {
  # create file name to be read in based on given id
  newvector <- c()
  newvector <- c(newvector, paste(directory, "/", formatC(id, width=3, flag="0"), ".csv", sep=""))  
  # read in the identified files and bind together the files into a single large file
  data <- lapply(newvector, read.csv)
  data <- do.call(rbind, data)
  
  #identify sulfate or nitrate mean while removing any missing values from the calculation 
  if (pollutant == colnames(data)[2]) {
    sulfate <- mean(data[,2], na.rm = TRUE)
    return(sulfate)
  } else {
    nitrate <- mean(data[,3], na.rm = TRUE)
    return(nitrate) 
  }       
}
