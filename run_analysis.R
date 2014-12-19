##download the zip file to local computer, and unzip the file.

temp <- tempfile() 
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp) 
unzip(temp,exdir=tempdir()) 
unlink(temp) 

## get work directory

workDirectory<-getwd()  
setwd(tempdir()) 

setwd("UCI HAR Dataset/") 

## read feature file and activity labels. 

features<-read.table("features.txt")["V2"] 

activity_labels<-read.table("activity_labels.txt")["V2"] 

measure_names<-features$V2

## get index of columns that have mean and std data  

index_mean_std<-grep("mean|std",features$V2) 

##read train X files and set the column name of the x training data to the feature file value.  

setwd("train") 

X_train<-read.table("X_train.txt") 

names(X_train)<-measure_names 

##read train Y files and set the column name of the y training data to 'labels'. 
 
y_train<-read.table("y_train.txt") 

names(y_train)<-"labels" 

##read train subject files and set the column name of the subject training data to 'subjects'. 

subject_train<-read.table("subject_train.txt") 

names(subject_train)<-"subjects" 

##read test X files and set the column name of the x training data to the feature file value. 

setwd("../test/") 

X_test<-read.table("X_test.txt") 

names(X_test)<-measure_names 

##read test Y files and set the column name of the y training data to 'labels'.  

y_test<-read.table("y_test.txt") 

names(y_test)<-"labels" 

##read test subject files and set the column name of the subject training data to 'subjects'. 

subject_test<-read.table("subject_test.txt") 

names(subject_test)<-"subjects" 

setwd(workDirectory) 

 
## gest only the measurements with the mean and standard deviation 

means_and_std_colnames<-colnames(X_test)[index_mean_std] 

X_test_subset<-cbind(subject_test,y_test,subset(X_test,select=means_and_std_colnames)) 

X_train_subset<-cbind(subject_train,y_train,subset(X_train,select=means_and_std_colnames)) 

 

##Merge the training and the test sets .  

All<-rbind(X_test_subset, X_train_subset) 

 
##Create tidy data set with the average of each variable for each activity and each subject 

tidy<-aggregate(All[,3:ncol(All)],list(Subject=All$subjects, Activity=All$labels), mean) 

tidy<-tidy[order(tidy$Subject),] 


##Use activity names to name the activities in the data set 

tidy$Activity<-activity_labels[tidy$Activity,] 

 


write.table(tidy, file="./tidydata.txt", sep="\t", row.names=FALSE) 