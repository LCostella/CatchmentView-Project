performeGraph <- function(datav4,datav6,module,version){
  
  if(module =="Temp"){
    
    if(version == 6)
      version <-"IPv6"
    else
      version <- "IPv4"
    
    auxv6 <- datav6
    
    for(i in 1: length(datav6$ProbeID)){
      time <- 0
      asn <- length(auxv6$asn[[i]])
      #for (j in 1:length(auxv6$resultado[[i]][[1]]$tmin)){
      #timeHop <- auxv6$resultado[[i]][[1]]$tmin[[j]]
      time<-auxv6$resultado[[i]][[1]]$tmin[[length(auxv6$resultado[[i]][[1]]$tmin)]]
      
      if(!is.numeric(time) || time =="-Inf" || time =="Inf" || is.na(time) )
        time <- 0
      #time <- as.numeric(time) + as.numeric(timeHop)  
      #}
      #print("time")
      #print(time)
      
      hops<- nrow(auxv6$resultado[[i]][[1]])
      auxv6$performAsn[[i]]  <- asn
      auxv6$performTime[[i]] <- time
      auxv6$performHops[[i]] <- hops
    }
    as <-c(mean(auxv6$performAsn))
    hops <-c(mean(auxv6$performHops))
    time <-c(mean(auxv6$performTime[auxv6$performTime!=0]))
    
    performeGraph <- data.frame(as = as,hops = hops, time= time) 
    colnames(performeGraph) <- c("Mean of AS", "Mean of Hops","Mean of Time")
    rownames(performeGraph) <- c(version)
    return(performeGraph)
    
    
  }
  else{
    auxv6 <- datav6
    auxv4 <- datav4
    for(i in 1: length(datav6$ProbeID)){
      time <- 0
      asn <- length(auxv6$asn[[i]])
      #for (j in 1:length(auxv6$resultado[[i]][[1]]$tmin)){
      time<-auxv6$resultado[[i]][[1]]$tmin[[length(auxv6$resultado[[i]][[1]]$tmin)]]
      #timeHop <- auxv6$resultado[[i]][[1]]$tmin[[j]]
      if(!is.numeric(time) || time =="-Inf" || time =="Inf"||is.na(time))
        time <- 0
      #time <- as.numeric(time) + as.numeric(timeHop) 
      #}
      hops<- nrow(auxv6$resultado[[i]][[1]])
      auxv6$performAsn[[i]]  <- asn
      auxv6$performTime[[i]] <- time
      auxv6$performHops[[i]] <- hops
    }
    
    for(i in 1: length(datav4$ProbeID)){
      time <- 0
      asn <- length(auxv4$asn[[i]])
      #for (j in 1:length(auxv4$resultado[[i]][[1]]$tmin)){
      
      #timeHop <- auxv4$resultado[[i]][[1]]$tmin[[j]]
      time<- auxv4$resultado[[i]][[1]]$tmin[[length(auxv4$resultado[[i]][[1]]$tmin)]]
      if(!is.numeric(time) || time =="-Inf" || time =="Inf"|| is.na(time))
        time <- 0
      #time <- as.numeric(time) + as.numeric(timeHop) 
      #}
      hops<- nrow(auxv4$resultado[[i]][[1]])
      auxv4$performAsn[[i]]  <- asn
      auxv4$performTime[[i]] <- time
      auxv4$performHops[[i]] <- hops
    }
    
    
    as <-c(mean(auxv4$performAsn),mean(auxv6$performAsn))
    hops <-c(mean(auxv4$performHops),mean(auxv6$performHops))
    time <-c(mean(auxv4$performTime[auxv4$performTime!=0]),mean(auxv6$performTime[auxv6$performTime!=0]))
    
    performeGraph <- data.frame(as = as,hops = hops, time= time) 
    colnames(performeGraph) <- c("Mean of AS", "Mean of Hops","Mean of Time")
    rownames(performeGraph) <- c("IPv4","IPv6")
    return(performeGraph)
    
  }
}