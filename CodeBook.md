# The code book 
It describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md

## Data Description
	Human Activity Recognition Using Smartphones Dataset , Version 1.0

>	Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
	Smartlab - Non Linear Complex Systems Laboratory
	DITEN - Università degli Studi di Genova.
	Via Opera Pia 11A, I-16145, Genoa, Italy.
	activityrecognition@smartlab.ws
	www.smartlab.ws

- The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

- The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

### For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### The dataset includes the following files

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

### Notes: 
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

> For more information about this dataset contact: activityrecognition@smartlab.ws

### License:

Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

# Script Transformation and Data Variables

- Here, It's commented script for my loacl work to set working directory 
`setwd("~/Desktop/03-Getting&Cleaning Data- Coursera/03-week-4")`


## Loading Training & testing Data
- `main.files.dir` this var i keep the main directory path `"./UCI HAR Dataset"` to use in reading/saving data
- `train.values` carries the data of features values read from `"/train/X_train.txt"` file
- `train.lables` carries the labels of training data read from `"/train/y_train.txt"` file
- `train.subject` carries the subject values of training data read from `"/train/subject_train.txt"` file

### combine training data
- `big.training.set` Binds the data in `train.values`,`train.lables` & `train.subject` by column using `cbind`
- `head(big.training.set,1)` used to make sure that data are bind correctly
- `dim(big.training.set)` used to keep traking dimensions of data `# 7352  563`

### load testing data
- `test.values` carries values fo features data of testing set which read from `"/test/X_test.txt"` file
- `test.lables` carries data labels of testing set which read from `"/test/y_test.txt"` file
-`test.subject` carries subjects data of testing set which read from `"/test/subject_test.txt"` file
 
### combine testing data
- `big.testing.set` Binds the data of `test.values` , `test.lables` & `test.subject` by column using `cbind` in one big set
- `head(big.testing.set,1)` used to make sure that data are bind correctly
- `dim(big.testing.set)` used to keep traking dimensions of data `# 2947  563`

> Target 1 : Merges the training and the test sets to create one data set
in `merged.set` using  `rbind` to merge data as rows in `big.training.set` and `big.testing.set`
, getting new set with dimensions `dim(merged.set)` `=` `10299 X 563`

- `features.names` carries the names of the features read from `"/features.txt"` file
  - Checking its dimentions `dim(features.names)` 
  - `561 X 2` ,  each name mapped to num of its column in dataset

- `target.features.indx` carries indecies of all feattures names that contains `mean` or `std` , using
`grep` function and Metacharacters `".*mean.*|.*std.*"`
  - checking the number of filtered features using `length(target.features.indx)` to be `79` feature

> Target 2 : Extract only the data on mean and standard deviation in `target.data.set` , get only columns of target features
with keeping lables and subject columns (last 2 columns) `merged.set[,c(target.features,562,563)]` , again lets check dimensions 
`dim(target.data.set)` we see it ` 10299  X  81 ` 

>  - NOTE : I did target 4 before target 3 :D

> Target 4 : Appropriately labels the data set with descriptive variable names, by using `colnames(target.data.set)`  we assign to it 
`c ( as.character(features.names[target.features,2]) , "activity","subject")` , we converted the selected features to character to use the value as names 

- `activitiy.names` carries the activity labels read from `"/activity_labels.txt"` file
  - By checking it's dimentions `dim(activitiy.names)` we get ` 6 X 2 `
  - Which means 6 types of activities each with its number representing it

> Target 3 : Uses descriptive activity names to name the activities in the data set, by mapping names to values in subject column (last column)
`target.data.set$activity` making it factor `factor(target.data.set$activity, levels = activitiy.names[,1], labels = activitiy.names[,2])`

- `View(target.data.set$activity[1:10])` used to check the change occured 
- Converting `target.data.set$subject` to a factor using  `as.factor`

> Target 5 :creates a second, independent tidy data set with the average of each variable for each activity 
and each subject called `data.sub.act.mean`, using `dplyr` library and `group_by` function
by applying `target.data.set %>% group_by(activity, subject) %>% summarize_each(funs(mean))`
, Then write it down as table in specific directory using `write.table` function keeping parameter 
`row.names = FALSE`, `col.names = TRUE` and `quote = FALSE` .
