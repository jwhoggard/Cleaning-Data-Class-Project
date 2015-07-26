## This script assumes you are in a directory containing "/UCI HAR Dataset"
##
## I'll use dplyr, data.table, and reshape2:  (Already installed on my system.)
library(dplyr)
library(data.table)
library(reshape2)

## Information from the website:
## Instances:10299
## Attributes:561
## Missing Values:N/A

######################################################
##
## STEP 1:  Read in test and train data, and merge.
## This assumes you are in a directory containing
## "/UCI HAR Dataset"
##
######################################################

## Retrieve data from /train, and from /test, and then merge:
Xdf <- read.table("UCI HAR Dataset/train/X_train.txt", colClasses="numeric")  # This has 561 variables: Features
temp <- read.table("UCI HAR Dataset/test/X_test.txt",  colClasses="numeric")
Xdf <- rbind(Xdf, temp)

## Now retrieve the test and train versions of y_train, merge, and name "activity":
ydf <- read.table("UCI HAR Dataset/train/y_train.txt", colClasses="integer")  # This has one variable, ranging 1-6: Activity
temp <- read.table("UCI HAR Dataset/test/y_test.txt", colClasses="integer")
ydf <- rbind(ydf, temp)
names(ydf) <- "activity"

######################################################
##
## STEP 2:  Fix all the labels
## (Add the names of variables and activites, add subject 
## labels, select only those variables representing a mean
## or a standard deviation.)  Make one big data table.
##
######################################################

## Read the feature list:
features <- read.table("UCI HAR Dataset/features.txt", sep = " ", stringsAsFactors = FALSE)
featlist <- features[,2]  # make a list of names for the variables from the provided feature list
featlist <- make.names(featlist, unique=TRUE)  # Some of the names are repeated, so we'll fix that
names(Xdf) <- featlist # rename columns for features
## We are only interested in those variables which are means
## or standard deviations.  Select only those columns (these are
## labeled with either "mean" or "std" in the data set):
Xdf <- select(Xdf, c(contains("mean"), contains("std")))  

# Get and merge subject labels; name this "subject":
subdf <- read.table("UCI HAR Dataset/train/subject_train.txt", colClasses="integer")  # This has one variable, 1-30: Subject
temp <- read.table("UCI HAR Dataset/test/subject_test.txt", colClasses = "integer")
subdf <- rbind(subdf, temp)
names(subdf) <- "subject"

## Combine everything into one data table:
data <- data.table(subdf, ydf, Xdf)
## Clean up extra data frames, no longer needed:
rm(subdf, Xdf, ydf, temp)

## Grab the activity labels:
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
## Replace each activity number with the label in column 2 of  
## the actLabels data frame.  We can do this with a simple lookup:
data$activity <- (activityLabels[, 2])[data$activity]

######################################################
##
## STEP 3:  Group the data, and find the mean for
## each variable by subject and activity.  Write the
## results to a file.
##
######################################################

## Start by melting into a long data set:
meltData <- melt(data, id.vars=c("subject", "activity"), variable.name = "measurement")
## Now use dplyr to group by subj, act, measurement, and 
## find mean per variable.  This gives a long data set 
tidyAvg <- group_by(meltData, subject, activity, measurement) %>% summarize(mean = mean(value))
## If you prefer a wide data set, tidyAvg can be converted to wide
## via "tidyAvg <- dcast(tidyAvg, subject+activity~variable)"

## Now write the result to a text file:
write.table(tidyAvg, "tidyAvg.txt", row.name=FALSE)

