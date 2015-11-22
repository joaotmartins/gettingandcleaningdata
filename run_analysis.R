# This script is designed to read in the entire UCI HAR dataset, and make a new,
# cleaned up and smmarized data set out of it, outputting it to a file named
# "tidy.csv"

library(data.table)
library(dplyr)


# The columns to select from the original data set.
interestingFeatCols <- 
        c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,
          125,126,161,162,163,164,165,166,201,202,214,215,227,228,240,241,
          253,254,266,267,268,269,270,271,345,346,347,348,349,350,424,425,
          426,427,428,429,503,504,516,517,529,530,542,543,555,556,557,558,
          559,560,561,562,563)

# The new names for the resulting dataset's columns
interestingFeatNames <-
        c("tBodyAcc.mean.X","tBodyAcc.mean.Y","tBodyAcc.mean.Z",
          "tBodyAcc.std.X","tBodyAcc.std.Y","tBodyAcc.std.Z",
          "tGravityAcc.mean.X","tGravityAcc.mean.Y","tGravityAcc.mean.Z",
          "tGravityAcc.std.X","tGravityAcc.std.Y","tGravityAcc.std.Z",
          "tBodyAccJerk.mean.X","tBodyAccJerk.mean.Y","tBodyAccJerk.mean.Z",
          "tBodyAccJerk.std.X","tBodyAccJerk.std.Y","tBodyAccJerk.std.Z",
          "tBodyGyro.mean.X","tBodyGyro.mean.Y","tBodyGyro.mean.Z",
          "tBodyGyro.std.X","tBodyGyro.std.Y","tBodyGyro.std.Z",
          "tBodyGyroJerk.mean.X","tBodyGyroJerk.mean.Y","tBodyGyroJerk.mean.Z",
          "tBodyGyroJerk.std.X","tBodyGyroJerk.std.Y","tBodyGyroJerk.std.Z",
          "tBodyAccMag.mean","tBodyAccMag.std","tGravityAccMag.mean",
          "tGravityAccMag.std","tBodyAccJerkMag.mean","tBodyAccJerkMag.std",
          "tBodyGyroMag.mean","tBodyGyroMag.std","tBodyGyroJerkMag.mean",
          "tBodyGyroJerkMag.std","fBodyAcc.mean.X","fBodyAcc.mean.Y",
          "fBodyAcc.mean.Z","fBodyAcc.std.X","fBodyAcc.std.Y",
          "fBodyAcc.std.Z","fBodyAccJerk.mean.X","fBodyAccJerk.mean.Y",
          "fBodyAccJerk.mean.Z","fBodyAccJerk.std.X","fBodyAccJerk.std.Y",
          "fBodyAccJerk.std.Z","fBodyGyro.mean.X","fBodyGyro.mean.Y",
          "fBodyGyro.mean.Z","fBodyGyro.std.X","fBodyGyro.std.Y",
          "fBodyGyro.std.Z","fBodyAccMag.mean","fBodyAccMag.std",
          "fBodyBodyAccJerkMag.mean","fBodyBodyAccJerkMag.std",
          "fBodyBodyGyroMag.mean","fBodyBodyGyroMag.std",
          "fBodyBodyGyroJerkMag.mean","fBodyBodyGyroJerkMag.std",
          "angle.tBodyAccMean.gravity","angle.tBodyAccJerkMean..gravityMean",
          "angle.tBodyGyroMean.gravityMean",
          "angle.tBodyGyroJerkMean.gravityMean","angle.X.gravityMean",
          "angle.Y.gravityMean","angle.Z.gravityMean",
          "activity", "subject")


# Reads either the UCI HAR training or test set, and builds a data frame out of
# it.
#
# Arguments:
#       dataset: one of "test" or "train"
#       featureNames: a data frame with columns Index and Name, holding the
#               names of the features in the data set
#       activityLabels: a data frame with columns Index and Label, holding the
#               levels of the activity factor.
# Value:
#       a data frame, with columns named after the featureNames data, plus an
#       extra factor column named activity holding the "y" data. 
readDataSet <- function(dataset, featureNames, activityLabels) {
        
        xfile = paste0(dataset, "/X_", dataset, ".txt")
        yfile = paste0(dataset, "/y_", dataset, ".txt")
        sfile = paste0(dataset, "/subject_", dataset, ".txt")
        
        # read in X data
        X <- fread(input = xfile, sep=" ", header = FALSE)
        
        # assign proper names to data
        X <- setNames(X, make.names(featureNames$Name, unique=TRUE))
        
        #
        # transform activity data into a factor column
        #
        
        # read in the activity data
        y <- fread(yfile, col.names = c("Activity"))
        
        # split out the index
        actNums <- as.vector(y$Activity)
        
        # build a temp char column
        actChars <- character(length(actNums))
        
        # fill in char column with activity names
        for (n in activityLabels$Index) {
                actChars[actNums == activityLabels$Index[n]] <- activityLabels$Label[n]
        }
        
        # transform into factor
        activities <- as.factor(actChars)
        
        # read in subject data and transform to vector
        subj <- fread(sfile)
        subj <- as.vector(subj$V1)
        
        # combine activity and subject with remaining data
        data <- cbind(X, activity = activities, subject = subj)
        
        # return data frame
        data
}

# Reads the full CUI HAR data set, combining the test and training sets into
# a single, condensed set, with proper column names.
#
# Value:
#       a data frame, containing the 561 features of the HAR data set, plus the
#       activity and subject index for each line.
readAndCombineDataSet <- function() {
        # Read in feature names
        fnames <- fread(input="features.txt", header=FALSE,
                        col.names = c("Index", "Name"))
        
        # Read in activity labels
        actvlab <- fread(input="activity_labels.txt", header = FALSE,
                         col.names = c("Index", "Label"))
        
        trainSet <- readDataSet("train", fnames, actvlab)
        testSet <- readDataSet("test", fnames, actvlab)
        
        # join the two data sets into one
        fullSet <- rbind(trainSet, testSet)        
        
        # return full data set
        fullSet
}

fs <- readAndCombineDataSet()

# Select only interesting columns
trimmedSet <- select(fs, interestingFeatCols)
trimmedSet <- setNames(trimmedSet, interestingFeatNames)

# summarize by taking the average of each variable by activity and subject
summarizedSet <- group_by(trimmedSet, subject, activity) %>% 
        summarise_each(funs(mean)) %>% arrange(subject)

write.table(summarizedSet, file = "tidy_data.txt", row.names = FALSE)

