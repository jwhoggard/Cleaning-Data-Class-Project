# Project 2 Script and Codebook

This files describes the script `run_analysis.R` which processes the data set provided in `/UCI HAR Dataset`.

## The Goal

The script `run_analysis.R` is for processing of data on using a
smartphone accelerometer to recognize a set of activities by users.
The data set is described at
`http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones`.

The data we used was provided at 
`https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`,
and includes both testing data and training data.

The purpose of the script is to:
  * Read both testing and training data into R;
  * Combine the data sets, including labeling subjects and descriptions of the activies observed;
  * Select variables involving computed means or standard deviations of observed variables; 
  * For each such selected variable, compute the mean for each subject and each activity;
  * Return the data as a tidy data set (with one observation per row, and one variable per column).

For the purposes of the assignment, the results are written to a text file.

## The Script

The script assumes we are starting in the same directory containing
the folder `/UCI HAR Dataset`.  When run, it proceeds as follows:

### STEP 1:  Read in test and train data, and merge.

The script begins by using `read.table` (specifying the `colClasses` to speed up reading) to read in the following files:

    * `train/X_train.txt`: Reading for training set
    * `test/X_test.txt`: Same for test set
    * `train/y_train.txt`: Activities for training set
    * `test/y_test.txt`:  Same for test set

The first two and last files are merged.  Note here that the original
data set is not tidy in the sense that while different data is stored
in different tables (readings in X and activities in y), there is not
a variable in each table which links entries in one table to entries
in another; we must link the entries by position.  (Thankfully the
readings, activities, and subjects files within either test or
training data have the same number of entries.)

### STEP 2:  Fix all the labels

We have a number of fixes to make here to make sure all the data is labeled appropriately:

   * The file `features.txt` contains the names of the measurements.
     We read these in, then convert these to suitable names using
     `make.names`.  Note that there are 42 feature names which are
     actually repeated in the table, but none of these is a mean or
     standard deviation, so we will throw out these variables anyway.

     In making appropriate names for R, the characters `(`, `)`, and `-`, have been replaced with `.`.
     
     For completeness, the repeated variables are listed below:

`fBodyAcc-bandsEnergy()-1,16`      `fBodyAcc-bandsEnergy()-1,24`      `fBodyAcc-bandsEnergy()-1,8`       `fBodyAcc-bandsEnergy()-17,24`    
  `fBodyAcc-bandsEnergy()-17,32`     `fBodyAcc-bandsEnergy()-25,32`     `fBodyAcc-bandsEnergy()-25,48`     `fBodyAcc-bandsEnergy()-33,40`    
  `fBodyAcc-bandsEnergy()-33,48`     `fBodyAcc-bandsEnergy()-41,48`     `fBodyAcc-bandsEnergy()-49,56`     `fBodyAcc-bandsEnergy()-49,64`    
 `fBodyAcc-bandsEnergy()-57,64`     `fBodyAcc-bandsEnergy()-9,16`      `fBodyAccJerk-bandsEnergy()-1,16`  `fBodyAccJerk-bandsEnergy()-1,24` 
 `fBodyAccJerk-bandsEnergy()-1,8`   `fBodyAccJerk-bandsEnergy()-17,24` `fBodyAccJerk-bandsEnergy()-17,32` `fBodyAccJerk-bandsEnergy()-25,32`
 `fBodyAccJerk-bandsEnergy()-25,48` `fBodyAccJerk-bandsEnergy()-33,40` `fBodyAccJerk-bandsEnergy()-33,48` `fBodyAccJerk-bandsEnergy()-41,48`
 `fBodyAccJerk-bandsEnergy()-49,56` `fBodyAccJerk-bandsEnergy()-49,64` `fBodyAccJerk-bandsEnergy()-57,64` `fBodyAccJerk-bandsEnergy()-9,16` 
 `fBodyGyro-bandsEnergy()-1,16`     `fBodyGyro-bandsEnergy()-1,24`     `fBodyGyro-bandsEnergy()-1,8`      `fBodyGyro-bandsEnergy()-17,24`   
 `fBodyGyro-bandsEnergy()-17,32`    `fBodyGyro-bandsEnergy()-25,32`    `fBodyGyro-bandsEnergy()-25,48`    `fBodyGyro-bandsEnergy()-33,40`   
 `fBodyGyro-bandsEnergy()-33,48`    `fBodyGyro-bandsEnergy()-41,48`    `fBodyGyro-bandsEnergy()-49,56`    `fBodyGyro-bandsEnergy()-49,64`   
 `fBodyGyro-bandsEnergy()-57,64`    `fBodyGyro-bandsEnergy()-9,16``
     
   * We assign the column names by the features list retrieved
       above, then select only those names which include the strings
       "mean" or "std".  (The file `features_info.txt` included in the
       data set explains that these were estimated from the signals.)

   * Retrieve the subject labels from `subject_train.txt` and `subject_test.txt`.

   * Combine the subject, activity, and relevant readings (those that
     are a mean or standard deviation) into one table, called `data`.

   * Read the activity labels from the file `activity_labels.txt`,
       then do a simple lookup to replace each numeric code (1-6) with
       the descriptive activity label.

## STEP 3:  Group the data, and find the mean for each variable by subject and activity.       

We finally melt the data into a long data set indexed by subject and
activity, with a variable `measurement` (with values for each of the
features), and a value column.  Then we use `dplyr` to group the data
by `subject`, `activity`, and `measurement`, and `summarize` to get
the mean per subject and activity for each reading.

The result is a (long) tidy data table which is written to a file.
The long data set has columns `subject`, `activity`, `measurement`
(which feature is being measured), and `mean`.  Note that if you are
looking for a particular feature in the `feature_list.txt` document
included with the original data set, the characters `(`, `)`, and `-`,
have been replaced with `.`.

For the purposes of the assignment, the results are written to a file.

If you prefer a wide tidy data set, it can be recast to this form using 
`tidyAvg <- dcast(tidyAvg, subject+activity~variable)`

## The Codebook

Variables in the (long) tidy data set:  (None have NA values.)

  * `subject`: Indicates the subject who performed the experiment.
    Ranges from 1-30.

  * `activity`: This was originally given a value from 1-6 in the
    experiement, but we have used the descriptive values "LAYING",
    "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS",
    "WALKING_UPSTAIRS".  These values are from the file
    `activity_labels.txt` in the original data set.

  * `measure`: What is being measured.  One of 85 measurements listed
    in the file `features.txt` included in the original data set which
    involve a computed mean or standard deviation of data.  Note that
    when matching with a value in `features.txt`, we have replaced
    `(`, `)`, and `-` with `.` to make legal names in R.

  * `mean`: The mean value of the measurement (feature) listed in
    `measure` for the given subject and activity, across all
    tests. Note that all of the original data was normalized to be
    between -1 and 1 (see `README.txt` in the original data
    set), so all means are between -1 and 1 as well.
