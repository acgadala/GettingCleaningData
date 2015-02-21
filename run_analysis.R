library(plyr)
#Setting appropriate data path
setwd("C:/Users/Cristina/Documents/DataScience/Module 3/UCI HAR Dataset")
path<-getwd()

#Reading Files
#Activity Files
ActTrain<-read.table(file.path(path,"train", "Y_train.txt"), header=FALSE)
ActTest<-read.table(file.path(path,"test", "y_test.txt"), header=FALSE)
ActNames<-read.table(file.path(path, "activity_labels.txt"), header=FALSE)

#Subject Files
SubTrain<-read.table(file.path(path,"train", "subject_train.txt"), header=FALSE)
SubTest<-read.table(file.path(path,"test", "subject_test.txt"), header=FALSE)

#Features Files
FeatTrain<-read.table(file.path(path,"train", "X_train.txt"), header=FALSE)
FeatTest<-read.table(file.path(path,"test", "X_test.txt"), header=FALSE)
FeatNames<-read.table(file.path(path, "features.txt"), header=FALSE)

#Merging two data sets
activitySet<-rbind(ActTrain, ActTest)
subjectSet<-rbind(SubTrain, SubTest)
featureSet<-rbind(FeatTrain, FeatTest)

#Rename variables
names(activitySet)<-c("Activity")
names(subjectSet)<-c("Subject")
names(featureSet)<-FeatNames$V2

#Merge all
dataset<-cbind(featureSet, subjectSet, activitySet)

#Extract mean and standard deviation
extract<-FeatNames$V2[grep("mean\\(\\)|std\\(\\)", FeatNames$V2)]
ext_names<-as.character(extract)
subData<-subset(dataset, select=c(ext_names, "Subject", "Activity"))

#Uses descriptive activity names to name the activities in the data set
subData$Activity <- ActNames[subData$Activity, 2]
factor(subData$Activity)


#Appropriately labels the data set with descriptive variable names.
names(subData)<-gsub("^t", "time", names(subData))
names(subData)<-gsub("^f", "freq", names(subData))
names(subData)<-gsub("Acc", "Accelerometer", names(subData))
names(subData)<-gsub("Gyro", "Gyroscope", names(subData))
names(subData)<-gsub("Mag", "Magnitude", names(subData))
names(subData)<-gsub("BodyBody", "Body", names(subData))

#Creates a second, independent tidy data set with the average of each variable for 
#each activity and each subject.
tidy<-aggregate(.~Subject+Activity, subData, mean)
tidy<-tidy[order(tidy$Subject, tidy$Activity),]
write.table(tidy, file="TidyDataSet.txt", row.name=FALSE)

