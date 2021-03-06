### Plot nb. 4

### Get and extract the file, if not existing
if(!file.exists("household_power_consumption.txt")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                destfile = "household_power_consumption.zip")
  unzip("household_power_consumption.zip")
}

### I've identified the lines we want to read in:
# lines <- readLines("household_power_consumption.txt")
# first_line <- grep("^1/2/2007",lines)[1]
# last_line <- tail(grep("^2/2/2007",lines), n = 1)

first_line <- 66638
last_line <- 69517

# Read in the desired amount of lines via read.table, account for the header row (skip -1, nrows +1)
# Header has to be FALSE, we read in from the middle of the file
tab <- read.table(file = "household_power_consumption.txt", header = FALSE, sep = ";",
                 skip = first_line - 1,
                 nrows = (last_line - first_line) + 1,
                 stringsAsFactors = FALSE)
# Read in the column names - I use read.table with nrow = 1 and header = TRUE
names(tab) <- names(read.table(file = "household_power_consumption.txt", header = TRUE, sep = ";",
                        nrows = 1))
# Load the dplyr and lubridate to handle table/time
library(dplyr)
library(lubridate)
tbl = tbl_df(tab)
tbl <- mutate(tbl, Date_Time = dmy_hms(paste(Date,Time)))

# Create 2x2 lattice of plots
par(mfrow = c(2,2), mar = c(4,4,2,1))

### Subplot nb 1
# Plot the canvas and lines with given annotations
plot(Global_active_power ~ Date_Time, data = tbl, type = "n", 
     xlab = "", 
     ylab = "Global Active Power (kilowatts)")
lines(Global_active_power ~ Date_Time, data = tbl)

### Subplot nb 2
# Plot the canvas and lines with given annotations
plot(Voltage ~ Date_Time, data = tbl, type = "n", 
     xlab = "datetime", 
     ylab = "Voltage")
lines(Voltage ~ Date_Time, data = tbl)

### Subplot nb 3
# Plot the canvas and lines with given annotations
plot(Sub_metering_1 ~ Date_Time, data = tbl, type = "n", 
     xlab = "", 
     ylab = "Energy sub metering")
lines(Sub_metering_1 ~ Date_Time, data = tbl)
lines(Sub_metering_2 ~ Date_Time, data = tbl, col = "red")
lines(Sub_metering_3 ~ Date_Time, data = tbl, col = "blue")
legend("topright",
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       bty = "n",
       lty = 1,
       lwd = 1,
       col = c("black", "red", "blue"))

### Subplot nb 4
# Plot the canvas and lines with given annotations
plot(Global_reactive_power ~ Date_Time, data = tbl, type = "n", 
     xlab = "datetime")
lines(Global_reactive_power ~ Date_Time, data = tbl)

dev.copy(png, file = "plot4.png", width = 480, height = 480, units = "px")
dev.off()