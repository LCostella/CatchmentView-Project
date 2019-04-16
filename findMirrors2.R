findDNS <- function(measurement,root,v){
  listdns <- NULL
  if(root == "K")
    dataframe <- k
  if(root == "C")
    dataframe <- cc
  if(root == "D")
    dataframe <- dd
  if(root == "E")
    dataframe <- e
  if(root == "F")
    dataframe <- f
  if(root == "G")
    dataframe <- g
  if(root == "I")
    dataframe <- i
  if(root == "J")
    dataframe <- j
  if(root == "L")
    dataframe <- l
  if(root == "M")
    dataframe <- m
  if(root == "B")
    dataframe <- bb
  
  if(v=="v6")
    dataframe <- dataframe[which(dataframe$IPv6 =="Yes"),]
  else
    dataframe <- dataframe[which(dataframe$IPv4 =="Yes"),]
  
  lat <- measurement[[1]]
  lon <- measurement[[2]]
  
  latData <- as.numeric(as.character(dataframe$lat[[1]]))
  lonData <- as.numeric(as.character(dataframe$lon[[1]]))
  
  dis <- distm (c(lon, lat), c(lonData, latData), fun = distHaversine)
  min <- dis[1]
  mirror <- as.character(dataframe$Name[[1]])
  listdns<- c(min,mirror)
  
  for (i in 1:length(dataframe$Name)){
    
    latData <- as.numeric(as.character(dataframe$lat[[i]]))
    lonData <- as.numeric(as.character(dataframe$lon[[i]]))
    
    dis <- distm (c(lon, lat), c(lonData, latData), fun = distHaversine)
    
    if(as.numeric(dis[1]) <  as.numeric(min[1])){
      
      min <- dis
      mirror <- as.character(dataframe$Name[[i]])
      listdns <- c(min,mirror)
      
      
    }
    
  }
  
  return(listdns)
}


findMirrors <- function(data,timee,root,v){
  listip <- data.frame()
  
  for ( i in 1:length(data$ProbeID)){
    print(data$ProbeID[[i]])
    data$resultado[[i]][[1]]
    ind <- length(data$resultado[[i]][[1]]$ip)-1
    ip <- data$resultado[[i]][[1]]$ip[[ind]]
    
    if(ip == "*"){
      cord <- c("undefined","undefined")
      dnsCopy <- "undefined"
    }
    else{
      if(ip %in% listip$ip){
        
        #cord <- listip[which(is.element(as.character(ip),as.character(listip$ip))),]
        cord <- listip[which(as.character(ip)== as.character(listip$ip)),]
        dnsCopy <- as.character(cord$name)
        cord <- c(cord$lat,cord$lon)
        print("ja existe")
        print(ip)
        print(dnsCopy)
        print("__________")
      }
      else{
        #url <- paste("http://ip-api.com/json/",ip,sep ="")
        #json <- fromJSON(url)
        #cord <- c(json$lat,json$lon)
        cord <- NULL
        
        try({
          url <- paste("https://stat.ripe.net/data/geoloc/data.json?resource=",ip,"&timestamp=",timee,sep="")
          json <- fromJSON(url)
          cord <- c(json$data$locations$latitude,json$data$locations$longitude)
          print(ip)
        })
        #print(cord)
        if(is.null(cord) || is.na(cord)){
          cord <- c("undefined","undefined")
          dnsCopy  <- "undefined"
        }
        else{
          if(length(cord) > 2){   #ANYCAST IP
            dnsMin <- NULL
            for (j in 1:(length(cord)/2)){
              newcord <- c(cord[j],cord[j+2])
              #print(newcord)
              dns <- findDNS(newcord,root,v)
              if(j == 1){
                dnsMin <- dns
                cordChecked <- newcord
              }
              else{
                if(as.numeric(dns[1]) < as.numeric(dnsMin[1])){
                  dnsMin <- dns 
                  cordChecked <- newcord
                }
              }
            }
            cord <- cordChecked
            dnsCopy <- as.character(dnsMin[2])
          }
          else{
            dns <- findDNS(cord,root,v)
            dnsCopy <- as.character(dns[2])
            print(dnsCopy)
          }
        }
        aux  <- data.frame(ip = ip, lat = cord[1], lon = cord[2],name = dnsCopy)
        listip <- rbind(listip,aux)
        
      }
    }
    
    data$mirrorCord[[i]] <- cord
    data$mirror[[i]] <- as.character(dnsCopy)
  }
  return(data)
  
}

