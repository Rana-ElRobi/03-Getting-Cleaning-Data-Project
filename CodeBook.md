# The code book 
It describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md

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

