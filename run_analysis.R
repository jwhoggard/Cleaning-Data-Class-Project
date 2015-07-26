# I'll use dplyr:
library(dplyr)
library(data.table)
library(reshape2)

# Information from the website:
# Instances:10299
# Attributes:561
# Missing Values:N/A

## Start from directory containing /UCI HAR Dataset
##
features <- read.table("UCI HAR Dataset/features.txt", sep = " ", stringsAsFactors = FALSE)
featlist <- features[,2]  # make a list of names for the variables from the provided feature list
featlist <- make.names(featlist, unique=TRUE)  # Some of the names are repeated, so we'll fix that

#setwd("train") 
## Rows to read in:  (temporary, so I can adjust for fast reads)
numrow <- -1
## Retrieve from train, and from test, and then merge:
Xdf <- read.table("UCI HAR Dataset/train/X_train.txt", colClasses="numeric", nrows=numrow)  # This has 561 variables, so the features?
temp <- read.table("UCI HAR Dataset/test/X_test.txt",  colClasses="numeric", nrows=numrow)
Xdf <- rbind(Xdf, temp)
names(Xdf) <- featlist # rename columns for features
Xdf <- select(Xdf, c(contains("mean"), contains("std")))  # Grab only those columns with name cont. "mean" or "std"

## Now retrieve the test and train versions of y_train, merge, and name "activity":
ydf <- read.table("UCI HAR Dataset/train/y_train.txt", colClasses="integer", nrows=numrow)  # This has one variable, ranging 1-6; probably activity?
temp <- read.table("UCI HAR Dataset/test/y_test.txt", colClasses="integer", nrows=numrow)
ydf <- rbind(ydf, temp)
names(ydf) <- "activity"

# Get and merge subject labels; name this "subject":
subdf <- read.table("UCI HAR Dataset/train/subject_train.txt", colClasses="integer", nrows=numrow)  # This has one variable, 1-30; probably subject?
temp <- read.table("UCI HAR Dataset/test/subject_test.txt", colClasses = "integer", nrows =numrow)
subdf <- rbind(subdf, temp)
names(subdf) <- "subject"
## No longer require the temp dataframe, so get rid of it
rm(temp)

## Combine everything into one data table:
data <- data.table(subdf, ydf, Xdf)
## Clean up extra data frames
rm(subdf, Xdf, ydf)

## Grab the activity labels:
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
## Replace each activity number with the label in column 2 of  
## the actLabels data frame.  We can do this with a simple lookup:
data$activity <- (actLabels[, 2])[data$activity]

## Start with a melt approach:
meltData <- melt(data, id.vars=c("subject", "activity"), variable.name = "measurement")
## Now use dplyr to group by subj, act, measurement, and 
## find mean per variable.  This gives a long data set 
tidyAvg <- group_by(meltData, subject, activity, measurement) %>% summarize(mean = mean(value))
## If you prefer a wide data set, tidyAvg can be converted to wide
## via "tidyAvg <- dcast(tidyAvg, subject+activity~variable)"

## Now write the result to a text file:
write.table(tidyAvg, "tidyAvg.txt", row.name=FALSE)

