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

 attr(FullYears$DateTime, "tzone") <- "Europe/Lisbon"

FullYears <- pad(FullYears,break_above =  3)


library(zoo)

FullYears <- as.data.frame(lapply(FullYears, na.aggregate))


#### The Data-Sets ####

FullYears <- pre_function(FullYears)


# na_check_test_set <-FullYears %>% filter(year == 2008)  
# 
# sum(is.na(na_check_test_set))
# 
# na_check_test_set[which(TRUE),] 
# FullYears <- change_names(FullYears)

# FullYears <-ConversionFunction(FullYears)

#### Longformat #### 

Full_Years_long <- FullYears %>%  melt(id.vars= -c(2,3,4,5,15))



Full_Years_long_tableau <- Full_Years_long[,-c(2,3,4,5,6,7,8)] 


