# The Codebook

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
    set), so all means are normalized between -1 and 1 as well.

    Further details on the variables measured, from the file
    `features_info.txt`, provided with the original data set:

    * Values obtained from the accelerometer (marked with "Acc") and the Gyrometer (marked "Gyro"), in each of the x, y, and z directions:
       * tBodyAcc-XYZ
       * tGravityAcc-XYZ
       * tBodyAccJerk-XYZ
       * tBodyGyro-XYZ
       * tBodyGyroJerk-XYZ
       * tBodyAccMag
       * tGravityAccMag
       * tBodyAccJerkMag
       * tBodyGyroMag
       * tBodyGyroJerkMag
       * fBodyAcc-XYZ
       * fBodyAccJerk-XYZ
       * fBodyGyro-XYZ
       * fBodyAccMag
       * fBodyAccJerkMag
       * fBodyGyroMag
       * fBodyGyroJerkMag

    Here, "t" indicates a time variable, and "f" for signals that a
    Fast Fourier Transform was applied to.  For each variable, we have
    a mean (marked with "mean") and a standard deviation ("std"), in
    each direction (X, Y, or Z).  All readings are normalized between
    -1 and 1.  

    * Additionally, we have readings obtained from averaging the signals in a signal window sample:
      * gravityMean
      * tBodyAccMean
      * tBodyAccJerkMean
      * tBodyGyroMean
      * tBodyGyroJerkMean
      These are also given in the X, Y, and Z directions.

For full details on the processing of the signals, see `features_info.txt`, or go to `http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones`
