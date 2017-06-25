#Check if necessary libraries are installed or not.
list.of.packages <- c("dplyr","sqldf")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(dplyr)
library(sqldf)

# Download the file.
if(!file.exists("./Exploratory Data Analysis/Ass4_1/data")){dir.create("./Exploratory Data Analysis/Ass4_1/data",recursive = TRUE)}
file_URL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file_URL,destfile="./Exploratory Data Analysis/Ass4_1/data/power_consumption_data.zip",mode='wb')

# Unzip the file.
unzip(zipfile="./Exploratory Data Analysis/Ass4_1/data/household_power_consumption.zip",exdir="./Exploratory Data Analysis/Ass4_1/data")

# Read the data, load it into a DF, and convert this one into an enhanced DF.
file_PATH="./Exploratory Data Analysis/Ass4_1/data/household_power_consumption.txt"
data_DF1<-read.csv.sql(file = file_PATH,header = TRUE, sep = ";",sql = "select * from file where Date=='1/2/2007'")
data_DF2<-read.csv.sql(file = file_PATH,header = TRUE, sep = ";",sql = "select * from file where Date=='2/2/2007'")
data_DF<-rbind(data_DF1,data_DF2)

#Transform "?" values into NA values
data_DF[data_DF=="?"]<-NA

# Clean the data
Cdata_DF<-data_DF[complete.cases(data_DF),]

# # Format column classes
# cols_to_change<-seq(3,9)
# for(i in cols_to_change){
#   class(Cdata_DF[,i])<-"numeric"  #También valdría Cdata_DF[,3]<-as.numeric(Cdata_DF[,3])
# }

Cdata_TBL<-tbl_df(data_DF)

#PLOT 4

png(filename ="plot4.png", width = 480, height = 480, units = "px")

old_par<-par()
par(mfrow=c(2,2))

##a)
plot(Cdata_TBL$Global_active_power,
     type = "l",
     ann=FALSE,
     axes = FALSE,
     frame.plot = TRUE)
title(ylab = "Global Active Power (kilowatts)")
axis(side = 1,at = c(0,1500,3000),labels = c("Thu","Fri","Sat"))
axis(side = 2,at = seq(0,6,2),labels = seq(0,6,2))


##b)
plot(Cdata_TBL$Voltage,
     type = "l",
     ann=FALSE,
     axes = FALSE,
     frame.plot = TRUE)
title(ylab = "Voltage",xlab = "datetime")
axis(side = 1,at = c(0,1500,2880),labels = c("Thu","Fri","Sat"))
axis(side = 2,at = seq(234,246,4),labels = c(234,238,242,246),tick = seq(234,246,2))

##c)
plot(Cdata_TBL$Sub_metering_1,
     type = "l",
     ann = FALSE,
     axes=FALSE,
     frame.plot = TRUE)
lines(Cdata_TBL$Sub_metering_2,
      col="red")
lines(Cdata_TBL$Sub_metering_3,
      col="blue")
axis(side = 1,at = c(0,1500,2880),labels = c("Thu","Fri","Sat"))
axis(side = 2,at = seq(0,30,10),labels = seq(0,30,10))
title(ylab = "Energy sub mterering")
legend("topright",
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty = c(1,1,1), 
       fill =c("Black","Red","Blue"),
       bty = "o" )

##d)
plot(Cdata_TBL$Global_reactive_power,
     type = "l",
     ann=FALSE,
     axes = FALSE,
     frame.plot = TRUE)
title(ylab = "Global_reactive_power",xlab = "datetime")
axis(side = 1,at = c(0,1500,2880),labels = c("Thu","Fri","Sat"))
axis(side = 2,at = c(0.1,0.2,0.3,0.4,0.5),labels = c(0.1,0.2,0.3,0.4,0.5),tick = c(0.1,0.2,0.3,0.4,0.5))
dev.off()


par(old_par)
