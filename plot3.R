library(data.table)
##Downloading zip fileand extracting data text file from link if required input text file does not exist in working directory
if(!file.exists("./household_power_consumption.txt")){
  if(!file.exists("./household_power_consumption.zip")){
    fileUrl<- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" 
    download.file(fileUrl,destfile = "./household_power_consumption.zip")
    unlink(fileUrl)
  }
  
  unzip("./household_power_consumption.zip",files ="household_power_consumption.txt")
}


##Loading input data from text data file as data.table 
data.table(read.table("household_power_consumption.txt", header = TRUE, sep = ";",stringsAsFactor = F))->tbl_data


##capturing data for  required dates
dates_req<-as.Date(c("01/02/2007","02/02/2007"),format="%d/%m/%Y")
as.Date(dates_req,"%d/%m/%Y")->dates_req
tbl_data[as.Date(strptime(tbl_data$Date,format="%d/%m/%Y")) %between% dates_req]->req_dat_all


paste(as.character(as.Date(req_dat_all$Date,format("%d/%m/%Y"))),as.character(req_dat_all$Time),sep =" ")->Datetime

data.table(Datetime,Sub_metering_1=req_dat_all$Sub_metering_1,Sub_metering_2=req_dat_all$Sub_metering_2,Sub_metering_3=req_dat_all$Sub_metering_3)->req_detail

req_detail[complete.cases(as.numeric(Sub_metering_1),as.numeric(Sub_metering_2),as.numeric(Sub_metering_3))]->req_xy
png(filename = "plot3.png", width = 480, height = 480, units = "px")
plot(as.POSIXct(req_xy$Datetime),as.numeric(req_xy$Sub_metering_1),type ="l",xlab ="",col ="black",ylab="Energy sub metering")
par(col ="red")
lines(as.POSIXct(req_xy$Datetime),as.numeric(req_xy$Sub_metering_2,col = "red"))
par(col ="blue")
lines(as.POSIXct(req_xy$Datetime),as.numeric(req_xy$Sub_metering_3, col = "blue"))
par(col="black")
legend("topright", lty =1,col = c("black", "red",  "blue","black"),legend = c("sub_metering_1", "sub_metering_2",  "sub_metering_3"))
dev.off()

