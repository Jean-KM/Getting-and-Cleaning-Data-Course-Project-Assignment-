#Load required package

library(dplyr)

#download file, unzip and read files
download.file("https://d396qusza4,20orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile="Project.zip")
unzip("Project.zip")

activities <- read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("code","activity"))
features_title<-read.table("UCI HAR Dataset/features.txt",col.names=c("n","functions"))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
X_train<- read.table("UCI HAR Dataset/train/X_train.txt",col.names =features_title$functions)
y_train<- read.table("UCI HAR Dataset/train/y_train.txt",col.names = "code")
X_test<- read.table("UCI HAR Dataset/test/X_test.txt",col.names = features_title$functions)
y_test<- read.table("UCI HAR Dataset/test/y_test.txt",col.names = "code")

#Merges the training and the test sets to create one data set.
X <- rbind(X_train,X_test)
Y <- rbind(y_train,y_test)
subject <- rbind(subject_train, subject_test)
merge_data<- cbind(subject,Y,X)


#Extracts only the measurements on the mean and standard deviation for each measurement. 
tidy_data<- merge_data %>% 
        select(subject,code,contains("mean"),contains("std"))

#Uses descriptive activity names to name the activities in the data set
tidy_data$code <- activities[tidy_data$code, 2]

#Appropriately labels the data set with descriptive variable names
names(tidy_data)[2] = "activity"
names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub("^t", "Time", names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data) <- gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("-freq", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("angle", "Angle", names(tidy_data))
names(tidy_data) <- gsub("gravity", "Gravity", names(tidy_data))

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject
final_data <- tidy_data %>%
        group_by(subject,activity)%>%
        summarise_all(mean)

write.table(final_data, "final_data1.csv", row.name= FALSE)