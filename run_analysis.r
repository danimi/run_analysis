library("reshape2")

#load measures features and activities
features<-read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#filter types of measurements to keep data for only the means and standard deviations
mean_std_features<-grepl("mean|std", features[,2])

#load train data measurements
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")

#load train data activities
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

#load subjects of train measurements
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#set names of the columns according data from features.txt and activity_labels.txt for the train data
names(X_train) <- features[,2]
names(y_train) <-"activity"
names(subject_train)<-"subject"

#filter measurements that contain only the means and standard deviations of train data
X_train<-X_train[,mean_std_features]

#load test data measurements
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")

#load test data activities
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

#load subjects of test measurements
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#set names of the columns according data from features.txt and activity_labels.txt for the test data
names(X_test) <- features[,2]
names(y_test) <-"activity"
names(subject_test)<-"subject"

#filter measurements that contain only the means and standard deviations of test data
X_test<-X_test[,mean_std_features]

#merge train and test data into one dataset
train_data <- cbind(subject_train, y_train, X_train)
test_data <- cbind(subject_test, y_test, X_test)
dataset<-rbind(train_data,test_data)

#set descriptive activity names
dataset[,2]<-as.factor(dataset[,2])
levels(dataset[,2])<-activity_labels[,2]

#create tidy data set
ids <- names(dataset[1:2])
supervisors <- setdiff(colnames(dataset), ids)
m_data <- melt(dataset, id = ids, measure.vars = supervisors)
final_data <- dcast(melt_data, subject + activity ~ variable, mean)
