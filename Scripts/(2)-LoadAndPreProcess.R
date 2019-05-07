library(RMySQL)
library(dplyr)
library(lubridate)
library(ggplot2)
library(reshape2)
library(tidyr)
library(padr)

 ##### Query Data ####

con = dbConnect(MySQL(), user='deepAnalytics', password='Sqltask1234!', dbname='dataanalytics2018', 
                host='data-analytics-2018.cbrosir2cswx.us-east-1.rds.amazonaws.com')



Year06<- dbGetQuery(con, "Select * FROM yr_2006")

Year07 <- dbGetQuery(con,"SELECT * FROM yr_2007")

Year08 <- dbGetQuery(con,"SELECT * FROM yr_2008")

Year09 <- dbGetQuery(con,"SELECT * FROM yr_2009")

Year10 <- dbGetQuery(con,"SELECT * FROM yr_2010")


#### Pre-Process #### 

FullYears <- bind_rows(Year07,Year08,Year09,Year10)

FullYears <-cbind(FullYears,paste(FullYears$Date,FullYears$Time), stringsAsFactors=FALSE)

colnames(FullYears)[11] <-"DateTime"

FullYears <- FullYears[,c(ncol(FullYears), 1:(ncol(FullYears)-1))]

FullYears$DateTime <- as.POSIXct(FullYears$DateTime, "%Y/%m/%d %H:%M:%S")

# attr(FullYears$DateTime, "tzone") <- "Europe/Paris"

FullYears <- pad(FullYears,break_above =  3)


FullYears[is.na(FullYears)] <- 0



#### The Data-Sets ####

FullYears <- pre_function(FullYears)


# FullYears <- change_names(FullYears)

# FullYears <-ConversionFunction(FullYears)

#### Longformat #### 
# FullYears_tidy <- FullYears %>%
#                   gather(Meter, KWatt_hr, `Kitchen`, `LaundryRoom`, `Heat`)  %>%  factor(FullYears_tidy$Meter)
# 
# 
# FullYears_tidy <- pre_function(FullYears_tidy)