library(jsonlite)
library(triebeard)
library(doParallel)
library(zip)
library(devtools)


#drive_auth_config(api_key = "4/AABH3ajkslhNGe-VATAklt9PwCROqwzxJIGYTXCfhoeW0_FtPuiu0Es.apps.googleusercontent.com")

#start <-1514764800 <<-- INICIO
#start <- as.integer(1533463200) #  22 apr 16:00

final <- as.integer(2147483000) # "infinite" "max integer of actual server" (.Machine$integer.max)
diaIni <- 9999
#final <- 1514764800 <<<- final
#1   2    3    4    5    6    7    8    9    10   11   12
#vet     <- c("09","10","11","12","13","04","14","05","15","01","08","06")
#vetname <- c("A" ,"B" ,"C" ,"D" ,"E" ,"F" ,"G" ,"I" , "J","K" ,"L" ,"M" )
#vet     <- c("10","11","04","05","01","08")
#vetname <- c("B" ,"C" ,"F" ,"I" ,"K" ,"L" )

vet     <- c("10","01","08")
vetname <- c("B" ,"K" ,"L" )

setwd("/home/catchmentview/Documentos/Plataforma/backend/")
start <- readLines("start")
start <- as.integer(start)
leitura <- dget("leiturav4.R")

while(start <= final){
  now   <- as.numeric(as.POSIXct(Sys.time(), format="%Y-%m-%d", tz= "utc")) 
  sleep <- as.integer(start) +1800 - as.integer(now)
  if(sleep < 0)
    sleep = 0
  
  sleep <- as.integer(sleep)
  print(sleep)
  Sys.sleep(sleep+1)
  
  aux  <- as.POSIXct(start, origin="1970-01-01",tz = "GMT")
  date <- strsplit(  strsplit(as.character(aux)," ")[[1]][1] , "-")[[1]]
  dia <- as.numeric(date[3])
  year <- as.character(date[1])
  month <-as.character(date[2])
  
  
  day <- as.character(date[3])
  if (dia != diaIni){
    # url <- paste("https://ftp.ripe.net/ripe/atlas/probes/archive/",date[1],"/",date[2],"/",paste(date,collapse = ""),".json.bz2",sep="")    
    # temp <- tempfile()
    # download.file(url, temp)
    #json <- fromJSON(temp)
    temp <- tempfile()
    download.file("https://ftp.ripe.net/ripe/atlas/probes/archive/meta-latest",temp)
    folder <- paste0("/srv/shiny-server/CatchmentView/")
    json <- fromJSON(temp)
    setwd(folder)
    salvar <- toJSON(json)
    unlink(temp)
    write(salvar,file = "probes.json")
    probes <<- data.frame(ProbeID = json$objects$id, IPv4 = json$objects$prefix_v4,
                          IPv6 = json$objects$prefix_v6, Latitude = json$objects$latitude,
                          Longitude = json$objects$longitude, Country = json$objects$country_code, asnV6 = json$objects$asn_v6, asnV4 = json$objects$asn_v4)
    diaIni <- dia
  }
  day
  folder <- paste0("/srv/shiny-server/CatchmentView/Data/",year,"/",month,"/",day,"/")
  if (!dir.exists(folder))
    dir.create(folder,recursive = TRUE)
  setwd(folder)
  for (i in 1:length(vet)){
    #for( i in 1:1){
    time_ini <- Sys.time()
    dns  <- vetname[i]
    root <- vet[i] 
    
    print(paste("RESOLVING ",dns,"-", start))
    #print(paste("RESOLVING ",start))
    start_time <- Sys.time()
    usedProbes <<- list()
    usedAs <<- list()
    indTemp <- 0
    
    version <- "60"
    url<-paste("https://atlas.ripe.net/api/v2/measurements/",version,root,"/results/?start=",as.integer(start),"&stop=",as.integer(start)+1800,"&format=json",sep="")
    #print(url)
    datav6 <- leitura(url,6)
    datav6$from <- NULL
    datav6$result <- NULL
    
    version <- "50"
    url<-paste("https://atlas.ripe.net/api/v2/measurements/",version,root,"/results/?start=",as.integer(start),"&stop=",as.integer(start)+1800,"&format=json",sep="")
    #url<-"v4.json" 
    datav4 <- leitura(url,4)
    datav4$from <- NULL
    datav4$result <- NULL
    
    
    #setwd("C:/Users/leona/Desktop/Projeto v2/Plataforma/sep/arquivos") ## windows
    datav6 <- datav6[order(as.integer(datav6$ProbeID)),]
    jsonv6 <- toJSON(datav6)
    
    write(jsonv6, file = 'data.json') 
    
    save <- zip(zipfile = paste(dns,"datav6_",as.integer(start),".zip",sep=""),'data.json',recurse = TRUE, compression_level = 9)
    
    # x <- NULL
    # repeat{
    #   try(
    #     #x <- drive_upload(media = save)
    #     x <- drive_upload(as_dribble(paste(year,"/",month,"/",day,sep="")), media = save)
    #   )
    #   if(!is.null(x))
    #     break()
    # }
    datav4 <- datav4[order(as.integer(datav4$ProbeID)),]
    jsonv4 <- toJSON(datav4)
    write(jsonv4, file = 'data.json') 
    save <- zip(paste(dns,"datav4_",as.integer(start),".zip",sep=""),'data.json',recurse = TRUE, compression_level = 9)
    # x <- NULL
    # repeat{
    #   try(
    #     #x <- drive_upload(media = save)
    #     x <- drive_upload(as_dribble(paste(year,"/",month,"/",day,sep="")), media = save)
    #   )
    #   if(!is.null(x))
    #     break()
    # }
    
    time_fi <- Sys.time()   
  }
  start <- as.integer(start) + 3600
  setwd("/home/catchmentview/Documentos/Plataforma/backend/")
  write(start,file = "start")
  
  
}

