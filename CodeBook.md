# Tidy and summarized version of Human Activity Recognition Using Smartphones Data Set CodeBook

This data set is a transformation of the following original data set:

> ==================================================================
> Human Activity Recognition Using Smartphones Dataset
> Version 1.0
> ==================================================================
> Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
> Smartlab - Non Linear Complex Systems Laboratory
> DITEN - Università degli Studi di Genova.
> Via Opera Pia 11A, I-16145, Genoa, Italy.
> activityrecognition@smartlab.ws
> www.smartlab.ws
> ==================================================================

The dataset was retrieved from its website at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


The tidy dataset consists of a selection of the mean and standard deviation variables of the original feature set. Additionally, the activity and subject columns were added to the dataset, and all the variables were subsequently aggregated (averaged) for each distinct subject and activity.



The transformation is done by running the run_analysis.R script. The script assumes the original dataset has been decompressed into the current directory.
The resulting data set is written into a file named 'tidy_data.txt'.

## Description of resulting data set

The resulting "tidy_data.txt" contains 75 columns.

The first column, subject, contains the subject's unique id.
The second column, activity, contains one of the values `LAYING`, `SITTING`, `STANDING`, `WALKING`, `WALKING_DOWNSTAIRS`, `WALKING_UPSTAIRS` that identifies the activity the subject was performing at the time the measurements were taken.

From the 3rd to 75th columns, they correspond to the average of the original dataset's corresponding measurements for that subject and activity combination.

The variables taken from the original dataset are the mean and standard deviation variables for the tri-axial frequency and time measurements of body acceleration (`tBodyAcc-XYZ-mean()`, `tBodyAcc-XYZ-std()`, `tGravityAcc-XYZ-mean()`, `tGravityAcc-XYZ-mean()`), jerk and jerk magnitude (`tBodyAccJerk-XYZ-mean/std()` and `tBodyGyroJerk-XYZ-mean/std()`), as well as the corresponding FFT transformed signals (`fBodyAcc-XYZ-mean/std()`, etc.)

Finally, the angle vectors variables (`angle(...,...)`) are also included.

In order to make the data set more amenable to processing in R, the names of the columns were changed by replacing all of the dash and comma characters with dots, and eliminating the empty parenthesis pairs. Therefore, the original name `tBodyAcc-mean()-X` is transformed into `tBodyAcc.mean.X`, etc.

## Transformation steps

The transformation steps automated by the `run_analysis.R` script are as follows:

1. For each of the `train` and `test` sets: 
1.1 Reading in the data set.
1.2. Associate the subject and activity from the `subject_xxx.txt` and `activity_xxx.txt` files. The activity variable is converted into a factor by converting the numeric variables into the appropriate factor level. 
2. Both data sets are then combined into a single data set by joining them, row-wise.
3. The full data set is then trimmed down to the columns of interest, decribed in the previous section.
4. Finally, the data set is grouped by activity and subject; each of the remaining columns will contain the average value for all observations of a particular activity for a particular subject.
5. Finally, this resulting aggregated set is written out to the `tidy_data.txt` variable.






