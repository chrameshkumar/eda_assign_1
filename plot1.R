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

##Storing the required data frame as CSV file in active directory that could be used for other graphs, if required to save time
##Write table below is commented for this assignment 
##write.table(req_dat_all,file ="./req_dat.csv",append = F,col.names=T)

##Capturing data for graph 1 and cleaning (removing invlid field such as "?")
as.character(req_dat_all[as.Date(strptime(req_dat_all$Date,format="%d/%m/%Y")) %between% dates_req,Global_active_power])->req_dat
req_dat[complete.cases(as.numeric(req_dat))]->req_dat

##Creating graph as .png file
png(filename = "plot1.png", width = 480, height = 480, units = "px")
hist(as.numeric(req_dat),axes = F,main = "Global Active Power",xlab = "Globa Active Power (kilowatts)", col = "red")

axis(1)
axis(2, at=seq(0,1200, by=200), labels=seq(0,1200, by=200))
dev.off()
