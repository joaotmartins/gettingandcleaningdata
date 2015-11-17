
# Reads either the CUI HAR training or test set, and builds a data frame out of
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
        X <- setNames(X, featureNames$Name)
        
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
        for (n in actvlab$Index) {
                actChars[actNums == activityLabels$Index[n]] <- actvlab$Label[n]
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
