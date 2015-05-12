complete<- function(directory, id = 1:332){
  
  nobsNum<-numeric(0)
  
  for (cid in id){
    raw<-getmonitor(cid,directory)
    
    nobsNum<-c(nobsNum, nrow(na.omit(raw)))
  }
  
  data.frame(id=id, nobs=nobsNum)
}

getmonitor<-function(id, directory, summarize = FALSE){
  fileStr<- paste(directory, "/", sprintf("%03d", as.numeric(id)), ".csv", sep = "")
  raw <- read.csv(fileStr)
  if (summarize){
    print(summary(raw))
  }
  
  return(raw)
}
