
#   Step A : download files from folders.
#   test_sub/train_sub identify the subject who perform the activiey(1,2,3...)
#   test_x/train_x record the feature vectors
#   test_y/train_y identify the activities(Walking,laying...)
#   featurename contain the vector of feature names(true column names of text_x/train_x)

test_sub  <- read.table("./test/subject_test.txt")
test_x <- read.table("./test/X_test.txt")
test_y <- read.table("./test/y_test.txt")

train_sub  <- read.table("./train/subject_train.txt")
train_x <- read.table("./train/X_train.txt")
train_y <- read.table("./train/y_train.txt")

features <- read.table("./features.txt")
featurename <- features[,2]


#   Step B: Use descriptive activity names in test_y and train_y

test_y[,1] <-as.factor(test_y[,1])
levels(test_y[,1]) <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                        "SITTING","STANDING","LAYING")


train_y[,1] <-as.factor(train_y[,1])
levels(train_y[,1]) <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                         "SITTING","STANDING","LAYING")



#   Step c: Label the data set with descriptive variable names
#   Map feature names to corresponding columns in test_x and train_x 

colnames(test_sub) <- c("participant")
colnames(train_sub) <- c("participant")
colnames(test_y)<- c("activity")
colnames(train_y)<- c("activity")
colnames(test_x) <- featurename
colnames(train_x) <- featurename


#   Step D: Subset test_x and train_x, keeping columns with "mean()" or 
#   "std()" in column names only

selectindex <-grep("mean\\(\\)|std\\(\\)",featurename)
test_x_selected <- test_x[,selectindex]
train_x_selected <- train_x[,selectindex]


#   Step E: Column bind test_y,test_sub, test_x_selected to create a clean test table
#   Create a clean train table in the same way

test <- cbind(test_y,test_sub, test_x_selected)
train <- cbind(train_y, train_sub, train_x_selected)



#   Step F: Row bind the test table and train table to create  one dataset
#   make participant column factors

dataset <-rbind(test,train)
dataset[,2] <- as.factor(dataset[,2])


#   Step G: Create the second, independent tidy data set(average of each variable for 
#   each activity and each subject)based on the last step. 

newtable <- aggregate( .~ activity + participant, data = dataset, FUN = mean)
library(dplyr)
newtable <- arrange(newtable, activity, participant)


#   Step H: save the file

write.table(newtable,file="./secondset.txt",row.name=FALSE )




























