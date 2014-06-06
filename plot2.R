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




##as.character(tbl_data[as.Date(strptime(tbl_data$Date,format="%d/%m/%Y")) %between% dates_req,Global_active_power])->req_dat
as.character(req_dat_all[as.Date(strptime(req_dat_all$Date,format="%d/%m/%Y"))%between% dates_req, Global_active_power])->req_dat
##as.Date(req_dat_all$Date,format=("%d/%m/%Y"))
paste(as.character(as.Date(req_dat_all$Date,format("%d/%m/%Y"))),as.character(req_dat_all$Time),sep =" ")->Datetime

data.table(cbind(Datetime,Req_dat=as.character(req_dat)))->req_detail
##req_detail[complete.cases(as.character(req_detail$Req_dat))]->req_xy
req_detail[complete.cases(as.numeric(as.character(req_detail$Req_dat)))]->req_xy
png(filename = "plot2.png", width = 480, height = 480, units = "px")
plot(as.POSIXct(req_xy$Datetime),as.numeric(as.character((req_xy$Req_dat))),type ="l",xlab ="",ylab="Global Active Power (kilowatts)")
dev.off()

