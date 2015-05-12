corr<- function(directory, threshold =0){
  corrs<-numeric(0)
  
  nobs<-complete("specdata", id=1:332)
  
  nobs<-nobs[nobs$nobs > threshold,]
  
  for (cid in nobs$id){
    mondfr <- getmonitor(cid,directory)
    
    corrs<- c(corrs, cor(mondfr$sulfate, mondfr$nitrate, use = "pairwise.complete.obs"))
  }

  return(corrs)
}