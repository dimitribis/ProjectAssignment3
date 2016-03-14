# Downloading and extracting files.

if (!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip")

unzip("./data/Dataset.zip", exdir = "./data")

list.files("./data")
# [1] "Dataset.zip"     "UCI HAR Dataset"
list.files("./data/UCI HAR Dataset")
# [1] "activity_labels.txt" "features.txt"        "features_info.txt"   "README.txt"          "test"                "train"              
list.files("./data/UCI HAR Dataset/train")
# [1] "Inertial Signals"  "subject_train.txt" "X_train.txt"       "y_train.txt"      
list.files("./data/UCI HAR Dataset/test")
# [1] "Inertial Signals" "subject_test.txt" "X_test.txt"       "y_test.txt"      

#------------------------------------------------------------------#
# 1. Merges the training and the test sets to create one data set. #
#------------------------------------------------------------------#

# According to the README file, the fata sets are in the files "train/X_train.txt" and "test/X_test.txt"
# We load the train and test data sets in order to merge them.

train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
dim(train)
# [1] 7352  561
# We see that we have 561 columns corresponding to the features.

test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
dim(test)
# [1] 2947  561
# Also 561 columns

# 1. We create a merged data set containg both train and test data sets
mergedData <- rbind(train, test)
dim(mergedData)
# [1] 10299   561

#--------------------------------------------------------------------------------------------#
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. #
#--------------------------------------------------------------------------------------------#

# The file features.txt contains the name of the 561 features.
# We'll load the file and extract the properties we want(std and mean).

features <- read.table("./data/UCI HAR Dataset/features.txt")
dim(features)
#[1] 561   2

head(features)
#   V1                V2
# 1  1 tBodyAcc-mean()-X
# 2  2 tBodyAcc-mean()-Y
# 3  3 tBodyAcc-mean()-Z
# 4  4  tBodyAcc-std()-X
# 5  5  tBodyAcc-std()-Y
# 6  6  tBodyAcc-std()-Z

# We see that the first column is the id and the second one is the name of the feature.
# We want to extract all the features containing the mean and the std functions.

# We test the regular expression to see if this is a match
grep("std\\(\\)|mean\\(\\)", features$V2, fixed = FALSE, value = TRUE)
#  [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"            "tBodyAcc-std()-Y"           
#  [6] "tBodyAcc-std()-Z"            "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"        "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
# [11] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"         "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"      
# [16] "tBodyAccJerk-std()-X"        "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"        "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
# [21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"           "tBodyGyroJerk-mean()-X"     
# [26] "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"       "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
# [31] "tBodyAccMag-mean()"          "tBodyAccMag-std()"           "tGravityAccMag-mean()"       "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"     
# [36] "tBodyAccJerkMag-std()"       "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
# [41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"           "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"            "fBodyAcc-std()-Y"           
# [46] "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"       "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
# [51] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"        "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"          "fBodyGyro-mean()-Z"         
# [56] "fBodyGyro-std()-X"           "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"           "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
# [61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-mean()"
# [66] "fBodyBodyGyroJerkMag-std()"

# It's a match
isStdOrMean <- grepl("std\\(\\)|mean\\(\\)", features$V2, fixed = FALSE)

head(isStdOrMean, 20)
# [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE

# 2. We extract only the measurements on the mean and standard deviation for each measurement.
tidyData <- mergedData[, isStdOrMean]
dim(tidyData)
# [1] 10299    66

#----------------------------------------------------------------------------#
# 3. Uses descriptive activity names to name the activities in the data set. #
#----------------------------------------------------------------------------#

# Activities are stored in the files "train/y_train.txt" and "test/y_test.txt".
# The name of the activities are stored in the file "activity_labels.txt".

# We load the data, merged them and then rename it.
activity_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
dim(activity_train)
# [1] 7352    1

activity_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
dim(activity_test)
# [1] 2947    1

activity_total = rbind(activity_train, activity_test)
dim(activity_total)
# [1] 10299     1

head(activity_total)
#   V1
# 1  5
# 2  5
# 3  5
# 4  5
# 5  5
# 6  5

activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
dim(activity_labels)
# [1] 6 2

activity_labels
#   V1                 V2
# 1  1            WALKING
# 2  2   WALKING_UPSTAIRS
# 3  3 WALKING_DOWNSTAIRS
# 4  4            SITTING
# 5  5           STANDING
# 6  6             LAYING

activities <- activity_labels$V2[activity_total$V1]
head(activities)
# [1] STANDING STANDING STANDING STANDING STANDING STANDING
tail(activities)
# [1] WALKING_UPSTAIRS WALKING_UPSTAIRS WALKING_UPSTAIRS WALKING_UPSTAIRS WALKING_UPSTAIRS WALKING_UPSTAIRS

length(activities)
# [1] 10299

# 3. We add the column activity with the data set
tidyData <- cbind(tidyData, activities)
dim(tidyData)
# [1] 10299    67

#-----------------------------------------------------------------------#
# 4. Appropriately labels the data set with descriptive variable names. #
#-----------------------------------------------------------------------#

# We need to extract the name of the features and inject it in the data set.

names <- features$V2[isStdOrMean]

length(names)
# [1] 66

# We add the name "activity" dor the 67th column
names <- c(as.character(names), "activity")
length(names)
# [1] 67

# The previous names of the fetures of the data set.
names(tidyData)
#  [1] "V1"         "V2"         "V3"         "V4"         "V5"         "V6"         "V41"        "V42"        "V43"        "V44"        "V45"        "V46"        "V81"       
# [14] "V82"        "V83"        "V84"        "V85"        "V86"        "V121"       "V122"       "V123"       "V124"       "V125"       "V126"       "V161"       "V162"      
# [27] "V163"       "V164"       "V165"       "V166"       "V201"       "V202"       "V214"       "V215"       "V227"       "V228"       "V240"       "V241"       "V253"      
# [40] "V254"       "V266"       "V267"       "V268"       "V269"       "V270"       "V271"       "V345"       "V346"       "V347"       "V348"       "V349"       "V350"      
# [53] "V424"       "V425"       "V426"       "V427"       "V428"       "V429"       "V503"       "V504"       "V516"       "V517"       "V529"       "V530"       "V542"      
# [66] "V543"       "activities"

names(tidyData) <- names

# 4. The new names
names(tidyData)
#  [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"            "tBodyAcc-std()-Y"           
#  [6] "tBodyAcc-std()-Z"            "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"        "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
# [11] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"         "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"      
# [16] "tBodyAccJerk-std()-X"        "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"        "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
# [21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"           "tBodyGyroJerk-mean()-X"     
# [26] "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"       "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
# [31] "tBodyAccMag-mean()"          "tBodyAccMag-std()"           "tGravityAccMag-mean()"       "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"     
# [36] "tBodyAccJerkMag-std()"       "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
# [41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"           "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"            "fBodyAcc-std()-Y"           
# [46] "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"       "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
# [51] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"        "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"          "fBodyGyro-mean()-Z"         
# [56] "fBodyGyro-std()-X"           "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"           "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
# [61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-mean()"
# [66] "fBodyBodyGyroJerkMag-std()"  "activity"

head(tidyData, 1)
#   tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z tGravityAcc-mean()-X tGravityAcc-mean()-Y tGravityAcc-mean()-Z
# 1         0.2885845       -0.02029417        -0.1329051       -0.9952786       -0.9831106       -0.9135264            0.9633961           -0.1408397            0.1153749
#   tGravityAcc-std()-X tGravityAcc-std()-Y tGravityAcc-std()-Z tBodyAccJerk-mean()-X tBodyAccJerk-mean()-Y tBodyAccJerk-mean()-Z tBodyAccJerk-std()-X tBodyAccJerk-std()-Y
# 1          -0.9852497          -0.9817084           -0.877625            0.07799634           0.005000803           -0.06783081           -0.9935191             -0.98836
#   tBodyAccJerk-std()-Z tBodyGyro-mean()-X tBodyGyro-mean()-Y tBodyGyro-mean()-Z tBodyGyro-std()-X tBodyGyro-std()-Y tBodyGyro-std()-Z tBodyGyroJerk-mean()-X
# 1            -0.993575       -0.006100849        -0.03136479          0.1077254        -0.9853103        -0.9766234        -0.9922053             -0.0991674
#   tBodyGyroJerk-mean()-Y tBodyGyroJerk-mean()-Z tBodyGyroJerk-std()-X tBodyGyroJerk-std()-Y tBodyGyroJerk-std()-Z tBodyAccMag-mean() tBodyAccMag-std() tGravityAccMag-mean()
# 1            -0.05551737             -0.0619858            -0.9921107            -0.9925193            -0.9920553         -0.9594339        -0.9505515            -0.9594339
#   tGravityAccMag-std() tBodyAccJerkMag-mean() tBodyAccJerkMag-std() tBodyGyroMag-mean() tBodyGyroMag-std() tBodyGyroJerkMag-mean() tBodyGyroJerkMag-std() fBodyAcc-mean()-X
# 1           -0.9505515             -0.9933059            -0.9943364          -0.9689591         -0.9643352              -0.9942478             -0.9913676        -0.9947832
#   fBodyAcc-mean()-Y fBodyAcc-mean()-Z fBodyAcc-std()-X fBodyAcc-std()-Y fBodyAcc-std()-Z fBodyAccJerk-mean()-X fBodyAccJerk-mean()-Y fBodyAccJerk-mean()-Z
# 1        -0.9829841        -0.9392687       -0.9954217        -0.983133        -0.906165            -0.9923325            -0.9871699            -0.9896961
#   fBodyAccJerk-std()-X fBodyAccJerk-std()-Y fBodyAccJerk-std()-Z fBodyGyro-mean()-X fBodyGyro-mean()-Y fBodyGyro-mean()-Z fBodyGyro-std()-X fBodyGyro-std()-Y
# 1           -0.9958207           -0.9909363           -0.9970517         -0.9865744         -0.9817615         -0.9895148        -0.9850326        -0.9738861
#   fBodyGyro-std()-Z fBodyAccMag-mean() fBodyAccMag-std() fBodyBodyAccJerkMag-mean() fBodyBodyAccJerkMag-std() fBodyBodyGyroMag-mean() fBodyBodyGyroMag-std()
# 1        -0.9940349         -0.9521547         -0.956134                 -0.9937257                 -0.993755              -0.9801349             -0.9613094
#   fBodyBodyGyroJerkMag-mean() fBodyBodyGyroJerkMag-std() activity
# 1                  -0.9919904                 -0.9906975 STANDING

#----------------------------------------------------------------------------#
# 5.From the data set in step 4, creates a second, independent tidy data set #
# with the average of each variable for each activity and each subject.      #
#----------------------------------------------------------------------------#

# The subjects are stored in the files "train/subject_train.txt" and "test/subject_test.txt".
# It's a range from 1 to 30.
# We need to create a new data set with this new column.

# First, we load the data.
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
dim(subject_train)
# [1] 7352    1

subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
dim(subject_test)
# [1] 2947    1

subject <- rbind(subject_train, subject_test)
dim(subject)
# [1] 10299     1

# We add this column to a new data set with the old one.
tidyData2 <- cbind(tidyData, subject)
dim(tidyData2)
# [1] 10299    68

# We set the name of this new column
names(tidyData2)
#  [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"            "tBodyAcc-std()-Y"           
#  [6] "tBodyAcc-std()-Z"            "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"        "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
# [11] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"         "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"      
# [16] "tBodyAccJerk-std()-X"        "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"        "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
# [21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"           "tBodyGyroJerk-mean()-X"     
# [26] "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"       "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
# [31] "tBodyAccMag-mean()"          "tBodyAccMag-std()"           "tGravityAccMag-mean()"       "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"     
# [36] "tBodyAccJerkMag-std()"       "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
# [41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"           "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"            "fBodyAcc-std()-Y"           
# [46] "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"       "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
# [51] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"        "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"          "fBodyGyro-mean()-Z"         
# [56] "fBodyGyro-std()-X"           "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"           "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
# [61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-mean()"
# [66] "fBodyBodyGyroJerkMag-std()"  "activity"                    "V1"

names2 <- names(tidyData2)
names2[68] <- "subject"
names(tidyData2) <- names2

names(tidyData2)
#  [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"            "tBodyAcc-std()-Y"           
#  [6] "tBodyAcc-std()-Z"            "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"        "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
# [11] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"         "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"      
# [16] "tBodyAccJerk-std()-X"        "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"        "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
# [21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"           "tBodyGyroJerk-mean()-X"     
# [26] "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"       "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
# [31] "tBodyAccMag-mean()"          "tBodyAccMag-std()"           "tGravityAccMag-mean()"       "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"     
# [36] "tBodyAccJerkMag-std()"       "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
# [41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"           "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"            "fBodyAcc-std()-Y"           
# [46] "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"       "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
# [51] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"        "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"          "fBodyGyro-mean()-Z"         
# [56] "fBodyGyro-std()-X"           "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"           "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
# [61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-mean()"
# [66] "fBodyBodyGyroJerkMag-std()"  "activity"                    "subject"

# We will now use the "dplyr" library to obtain the new data set with the average for each activity and each subject.

library(dplyr)
tidyData2gb <- group_by(tidyData2, activity, subject)

# 5. We use summarize_each to create the data set.
tidyDataAvg <- summarize_each(tidyData2gb, funs(mean))
dim(tidyDataAvg)
# [1] 180  68

head(tidyDataAvg, 10)
# Source: local data frame [10 x 68]
# Groups: activity [1]
# 
#    activity subject tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z tGravityAcc-mean()-X tGravityAcc-mean()-Y
#      (fctr)   (int)             (dbl)             (dbl)             (dbl)            (dbl)            (dbl)            (dbl)                (dbl)                (dbl)
# 1    LAYING       1         0.2215982       -0.04051395        -0.1132036       -0.9280565       -0.8368274       -0.8260614           -0.2488818            0.7055498
# 2    LAYING       2         0.2813734       -0.01815874        -0.1072456       -0.9740595       -0.9802774       -0.9842333           -0.5097542            0.7525366
# 3    LAYING       3         0.2755169       -0.01895568        -0.1013005       -0.9827766       -0.9620575       -0.9636910           -0.2417585            0.8370321
# 4    LAYING       4         0.2635592       -0.01500318        -0.1106882       -0.9541937       -0.9417140       -0.9626673           -0.4206647            0.9151651
# 5    LAYING       5         0.2783343       -0.01830421        -0.1079376       -0.9659345       -0.9692956       -0.9685625           -0.4834706            0.9548903
# 6    LAYING       6         0.2486565       -0.01025292        -0.1331196       -0.9340494       -0.9246448       -0.9252161           -0.4767099            0.9565938
# 7    LAYING       7         0.2501767       -0.02044115        -0.1013610       -0.9365136       -0.9262627       -0.9529784           -0.5028143            0.3934443
# 8    LAYING       8         0.2612543       -0.02122817        -0.1022454       -0.9430412       -0.9348912       -0.9324915           -0.4059300            0.5899224
# 9    LAYING       9         0.2591955       -0.02052682        -0.1075497       -0.9423331       -0.9162928       -0.9407073           -0.5802528           -0.1191542
# 10   LAYING      10         0.2802306       -0.02429448        -0.1171686       -0.9682837       -0.9464543       -0.9594715           -0.4530697           -0.1392977
# Variables not shown: tGravityAcc-mean()-Z (dbl), tGravityAcc-std()-X (dbl), tGravityAcc-std()-Y (dbl), tGravityAcc-std()-Z (dbl), tBodyAccJerk-mean()-X (dbl),
# tBodyAccJerk-mean()-Y (dbl), tBodyAccJerk-mean()-Z (dbl), tBodyAccJerk-std()-X (dbl), tBodyAccJerk-std()-Y (dbl), tBodyAccJerk-std()-Z (dbl), tBodyGyro-mean()-X (dbl),
# tBodyGyro-mean()-Y (dbl), tBodyGyro-mean()-Z (dbl), tBodyGyro-std()-X (dbl), tBodyGyro-std()-Y (dbl), tBodyGyro-std()-Z (dbl), tBodyGyroJerk-mean()-X (dbl),
# tBodyGyroJerk-mean()-Y (dbl), tBodyGyroJerk-mean()-Z (dbl), tBodyGyroJerk-std()-X (dbl), tBodyGyroJerk-std()-Y (dbl), tBodyGyroJerk-std()-Z (dbl), tBodyAccMag-mean() (dbl),
# tBodyAccMag-std() (dbl), tGravityAccMag-mean() (dbl), tGravityAccMag-std() (dbl), tBodyAccJerkMag-mean() (dbl), tBodyAccJerkMag-std() (dbl), tBodyGyroMag-mean() (dbl),
# tBodyGyroMag-std() (dbl), tBodyGyroJerkMag-mean() (dbl), tBodyGyroJerkMag-std() (dbl), fBodyAcc-mean()-X (dbl), fBodyAcc-mean()-Y (dbl), fBodyAcc-mean()-Z (dbl),
# fBodyAcc-std()-X (dbl), fBodyAcc-std()-Y (dbl), fBodyAcc-std()-Z (dbl), fBodyAccJerk-mean()-X (dbl), fBodyAccJerk-mean()-Y (dbl), fBodyAccJerk-mean()-Z (dbl),
# fBodyAccJerk-std()-X (dbl), fBodyAccJerk-std()-Y (dbl), fBodyAccJerk-std()-Z (dbl), fBodyGyro-mean()-X (dbl), fBodyGyro-mean()-Y (dbl), fBodyGyro-mean()-Z (dbl),
# fBodyGyro-std()-X (dbl), fBodyGyro-std()-Y (dbl), fBodyGyro-std()-Z (dbl), fBodyAccMag-mean() (dbl), fBodyAccMag-std() (dbl), fBodyBodyAccJerkMag-mean() (dbl),
# fBodyBodyAccJerkMag-std() (dbl), fBodyBodyGyroMag-mean() (dbl), fBodyBodyGyroMag-std() (dbl), fBodyBodyGyroJerkMag-mean() (dbl), fBodyBodyGyroJerkMag-std() (dbl)

tail(tidyDataAvg, 10)
# Source: local data frame [10 x 68]
# Groups: activity [1]
# 
#            activity subject tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z tGravityAcc-mean()-X tGravityAcc-mean()-Y
#              (fctr)   (int)             (dbl)             (dbl)             (dbl)            (dbl)            (dbl)            (dbl)                (dbl)                (dbl)
# 1  WALKING_UPSTAIRS      21         0.2651945       -0.02372187        -0.1254143      -0.24080828       0.10978747      -0.21970793            0.7811772           -0.4323096
# 2  WALKING_UPSTAIRS      22         0.2483915       -0.02686226        -0.1175509       0.08357386       0.25006752      -0.10961322            0.8894544           -0.3368269
# 3  WALKING_UPSTAIRS      23         0.2499952       -0.03238440        -0.1268906      -0.24388782       0.04484358       0.10080119            0.8434388           -0.2144818
# 4  WALKING_UPSTAIRS      24         0.2698811       -0.02519794        -0.1142486      -0.34439935      -0.11680449      -0.25560101            0.9063695           -0.2374984
# 5  WALKING_UPSTAIRS      25         0.2779954       -0.02698635        -0.1262104      -0.45977565      -0.22308681      -0.29652398            0.9276932           -0.2176413
# 6  WALKING_UPSTAIRS      26         0.2726914       -0.02816338        -0.1219435      -0.16900695      -0.04917263      -0.40459694            0.9420953           -0.2461697
# 7  WALKING_UPSTAIRS      27         0.2657703       -0.02009533        -0.1235304      -0.29543955      -0.09501041      -0.23070788            0.8680003           -0.2292787
# 8  WALKING_UPSTAIRS      28         0.2620058       -0.02794439        -0.1215140      -0.24206243      -0.14675388      -0.28598691            0.8545082           -0.3332240
# 9  WALKING_UPSTAIRS      29         0.2654231       -0.02994653        -0.1180006      -0.08677156      -0.12212829       0.09954435            0.9292590           -0.2271201
# 10 WALKING_UPSTAIRS      30         0.2714156       -0.02533117        -0.1246975      -0.35050448      -0.12731116       0.02494680            0.9318298           -0.2266473
