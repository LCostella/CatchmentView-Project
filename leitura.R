leitura <- function(url,day,month,year){
  # download <- NULL
  # temp <- tempfile(fileext = ".zip")
  # temp2 <- tempfile()
  # 
  # try({
  #   drive_download(file = url, temp)
  #   download <- "ok"
  # })
  # if(!is.null(download)){ 
  #   zip <- unzip(temp,exdir = temp2)
  #   data <- fromJSON(zip)
  #   unlink(temp)
  #   unlink(temp2)
  #   return(data)
  # } 
  # else{
  #   return(download)
  # }
  # 
  
  download <- NULL
  temp <- tempfile(fileext = ".zip")
  temp2 <- tempfile()
  
  try({
    folder <- paste0("Data/",year,"/",month,"/",day,"/",url)
    #setwd(folder)
    zip <- unzip(folder,exdir = temp2)
    data <- fromJSON(zip)
    unlink(temp)
    unlink(temp2)
    download <- "ok"
  })
  if(!is.null(download)){ 
    
    return(data)
  } 
  else{
    return(download)
  }
  
}