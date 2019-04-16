# Catchment View
 A visualization tool to assist the understanding of anycast service catchment.


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

```
R 3.5.1 + 
R Studio 

To install all necessary libraries execute:
install.packages(c("devtools","shinydashboard","jsonlite","triebeard",
                  "leaflet","doParallel","geosphere","DT","shiny",
                  "shinyalert","shinyBS","curl","devtools","networkD3",
                  "ggplot2","plotly","plogr"))
```

### Installing

```
After download the project, replace the forceNetwork.js(networkD3\htmlwidgets)) file of  network D3 library to forceNetwork.js file  preset in the project. To discovery the path of R libraries, execute the follwing command on R Studio: '.libPaths()'.

```

## Running the tests
To execute the code. Open UI.R file on Rstudio and run. Select 01 april 2019 on input Date.


## Note

This example use some RIPE Atlas traceroute measurements of Root Server as input data. There are only data from 01  April 2019 on github. To view anothers measurements, access www.catchmntview.com

If you want use this project with another anycast/Dual Stack server, edit nodes.R file. and organize the input data according data.json file.


AsNLists.csv contains information about Autonomous Systems.
b.csv and bModal.csv contains information about the Root B mirrors.
ip2asnv4 and ip2asnv6 contains informations about IP and ASN to IPv4 and IPv6, respectively. These data are obtained in https://iptoasn.com/


## Authors
 **Leonardo Costella** - Help? write to me: 134383@upf.br