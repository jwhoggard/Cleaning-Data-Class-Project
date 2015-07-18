# I'll use dplyr:
library(dplyr)

## Start from /UCI HAR Dataset
features <- read.table("features.txt", sep = " ", stringsAsFactors = FALSE)
featlist <- features[,2]  # make a list of names for the variables from the provided feature list
featlist <- make.names(featlist, unique=TRUE)  # Some of the names are repeated, so we'll fix that
setwd("train")
## Start from training directory
Xdf <- read.table("X_train.txt", nrows=10)  # This has 561 variables, so the features?
names(Xdf) <- featlist # rename columns for features
Xdf <- select(Xdf, c(contains("mean"), contains("std")))  # Grab only those columns with name cont. "mean" or "std"
ydf <- read.table("y_train.txt", nrows=10)  # This has one variable, ranging 1-6; probably activity?
subdf <- read.table("subject_train.txt", nrows=10)  # This has one variable, 1-30; probably subject?
setwd("Inertial Signals")
baxdf <- read.table("body_acc_x_train.txt", nrows=10)
baydf <- read.table("body_acc_y_train.txt", nrows=10)
bazdf <- read.table("body_acc_z_train.txt", nrows=10)
bgxdf <- read.table("body_gyro_x_train.txt", nrows=10)
bgydf <- read.table("body_gyro_y_train.txt", nrows=10)
bgzdf <- read.table("body_gyro_z_train.txt", nrows=10)
taxdf <- read.table("total_acc_x_train.txt", nrows=10)
taydf <- read.table("total_acc_y_train.txt", nrows=10)