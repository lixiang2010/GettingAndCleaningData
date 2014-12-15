setwd("~/Downloads/UCI HAR Dataset/")

# Load all relevant data
training = read.csv("X_train.txt", sep="", header=FALSE)
training[,562] = read.csv("Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("subject_train.txt", sep="", header=FALSE)
testing = read.csv("X_test.txt", sep="", header=FALSE)
testing[,562] = read.csv("Y_test.txt", sep="", header=FALSE)
testing[,563] = read.csv("subject_test.txt", sep="", header=FALSE)
activityLabels = read.csv("activity_labels.txt", sep="", header=FALSE)

# Load and refine the features names
features = read.csv("features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# Bind training and testing set by ROWs
allData = rbind(training, testing)


newCols <- grep(".*Mean.*|.*Std.*", features[,2])
features <- features[newCols,]
newCols <- c(newCols, 562, 563)
allData <- allData[,newCols]
colnames(allData) <- c(features$V2, "Activity", "Subject")
colnames(allData) <- tolower(colnames(allData))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  allData$activity <- gsub(currentActivity, currentActivityLabel, allData$activity)
  currentActivity <- currentActivity + 1
}

allData$activity <- as.factor(allData$activity)
allData$subject <- as.factor(allData$subject)

cleanData = aggregate(allData, by=list(activity = allData$activity, subject=allData$subject), mean)
cleanData[,90] = NULL
cleanData[,89] = NULL
write.table(cleanData, "tidy.txt", sep="\t")