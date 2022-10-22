library("tidyverse")

##You should create one R script called run_analysis.R that does the following:

## Merges the training and the test sets to create one data set

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]



# Load Test & Train data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Merge test and train data
X_data = rbind(X_test, X_train)
y_data = rbind(y_test, y_train)
subject_data = rbind(subject_test, subject_train)

## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## Proper Naming
names(X_data) = features
y_data[,2] = activity_labels[y_data[,1]]
names(y_data) = c("Activity_ID", "Activity_Label")
names(subject_data) = c("subject")

## Create one Dataset

global_data = cbind(subject_data, y_data, X_data)

## Extracts only the measurements on the mean and standard deviation for each measurement. 
# Extract the relevant data

relevant_data = global_data[,grepl("mean|std", features)] 

## Find mean Values
## and Write into File.
relevant_data %>% 
  group_by(Activity_ID, subject) %>% 
  summarise_all(mean) %>% 
  write.table(file="./tidy_data.txt")