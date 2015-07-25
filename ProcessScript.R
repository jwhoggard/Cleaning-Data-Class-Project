# I'll use dplyr:
library(dplyr)
library(data.table)

# Information from the website:
# Instances:10299
# Attributes:561
# Missing Values:N/A

## Start from /UCI HAR Dataset
## For convenience:
setwd("/Users/hoggard/Google Drive/Classes/Data Science/Clean/Project/UCI HAR Dataset")
##
features <- read.table("features.txt", sep = " ", stringsAsFactors = FALSE)
featlist <- features[,2]  # make a list of names for the variables from the provided feature list
featlist <- make.names(featlist, unique=TRUE)  # Some of the names are repeated, so we'll fix that

#setwd("train") 
## Rows to read in:  (temporary, so I can adjust for fast reads)
numrow <- -1
## Retrieve from train, and from test, and then merge:
Xdf <- read.table("train/X_train.txt", colClasses="numeric", nrows=numrow)  # This has 561 variables, so the features?
temp <- read.table("test/X_test.txt",  colClasses="numeric", nrows=numrow)
Xdf <- rbind(Xdf, temp)
names(Xdf) <- featlist # rename columns for features
Xdf <- select(Xdf, c(contains("mean"), contains("std")))  # Grab only those columns with name cont. "mean" or "std"

## Now retrieve the test and train versions of y_train, merge, and name "activity":
ydf <- read.table("train/y_train.txt", colClasses="integer", nrows=numrow)  # This has one variable, ranging 1-6; probably activity?
temp <- read.table("test/y_test.txt", colClasses="integer", nrows=numrow)
ydf <- rbind(ydf, temp)
names(ydf) <- "activity"

# Get and merge subject labels; name this "subject":
subdf <- read.table("train/subject_train.txt", colClasses="integer", nrows=numrow)  # This has one variable, 1-30; probably subject?
temp <- read.table("test/subject_test.txt", colClasses = "integer", nrows =numrow)
subdf <- rbind(subdf, temp)
names(subdf) <- "subject"
## No longer require the temp dataframe, so get rid of it
rm(temp)

## Combine everything into one data table:
data <- data.table(subdf, ydf, Xdf)
## Clean up extra data frames
rm(subdf, Xdf, ydf)



## I am reasonably certain that the following are garbage, and not needed:
#setwd("Inertial Signals")
#baxdf <- read.table("body_acc_x_train.txt", nrows=10)
#baydf <- read.table("body_acc_y_train.txt", nrows=10)
#bazdf <- read.table("body_acc_z_train.txt", nrows=10)
#bgxdf <- read.table("body_gyro_x_train.txt", nrows=10)
#bgydf <- read.table("body_gyro_y_train.txt", nrows=10)
#bgzdf <- read.table("body_gyro_z_train.txt", nrows=10)
#taxdf <- read.table("total_acc_x_train.txt", nrows=10)
#taydf <- read.table("total_acc_y_train.txt", nrows=10)
## End garbage