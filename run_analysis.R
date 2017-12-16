# this is script for 03-Getting and cleaning data course project
#------------------------------------------------------------------
#setwd("~/Desktop/03-Getting&Cleaning Data- Coursera/03-week-4")

# Load Training & testing Data
#``````````````````````````````
main.files.dir <- "./UCI HAR Dataset"

# load training data
train.values <- read.table(paste0(main.files.dir,"/train/X_train.txt"))
train.lables <- read.table(paste0(main.files.dir,"/train/y_train.txt"))
train.subject <- read.table(paste0(main.files.dir,"/train/subject_train.txt"))

# combine training data
big.training.set <- cbind(train.values,train.lables,train.subject)
head(big.training.set,1)
dim(big.training.set) # 7352  563

# load testing data
test.values <- read.table(paste0(main.files.dir,"/test/X_test.txt"))
test.lables <- read.table(paste0(main.files.dir,"/test/y_test.txt"))
test.subject <-read.table(paste0(main.files.dir,"/test/subject_test.txt"))

# combine testing data
big.testing.set <- cbind(test.values,test.lables,test.subject)
head(big.testing.set,1)
dim(big.testing.set) # 2947  563

# Target 1 : Merges the training and the test sets to create one data set
#==========
merged.set <- rbind(big.training.set,big.testing.set) 
dim(merged.set) # 10299   563

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Target 2 : Extract only the data on mean and standard deviation
# ==========
features.names <- read.table(paste0(main.files.dir,"/features.txt"))
dim(features.names) # 561   2 # each name mapped to num of its column in dataset

target.features.indx <- grep(".*mean.*|.*std.*", features.names[,2])
length(target.features.indx) # 79 feature

# get only coumns of target features with keeping lables and subject columns (last 2 columns) 
target.data.set <-  merged.set[,c(target.features,562,563)] 
dim(target.data.set) # 10299    81 

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# NOTE : I did target 4 before target 3 :D
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Target 4 : Appropriately labels the data set with descriptive variable names
#=========
# lets name features first
colnames(target.data.set) <- c ( as.character(features.names[target.features,2]) , "activity","subject")

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Target 3 : Uses descriptive activity names to name the activities in the data set
# =========
activitiy.names <- read.table(paste0(main.files.dir,"/activity_labels.txt"))
dim(activitiy.names) # 6 X 2 #  6 types of activities each with its number representing it

# map names to values in subject column (last column)
target.data.set$activity <- factor(target.data.set$activity, levels = activitiy.names[,1], labels = activitiy.names[,2])
#View(target.data.set$activity[1:10]) # lables changed ;)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Target 5 :creates a second, independent tidy data set with the average of each variable 
# ========== for each activity and each subject.

# make subject factor type
target.data.set$subject <- as.factor(target.data.set$subject)

library(dplyr)
# group by 
data.sub.act.mean <- target.data.set %>% group_by(activity, subject) %>% summarize_each(funs(mean))
data.sub.act.mean
write.table(data.sub.act.mean, file = paste0(main.files.dir,"/tidydata.txt"), row.names = FALSE, col.names = TRUE , quote = FALSE)

# %%%%%%%%%%%%% The End %%%%%%%%%%%%%%%%%%%