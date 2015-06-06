This codebook describes the variables, data and transformations used for
the course project for "Getting and Cleaning Data", offered through
Coursera and Johns Hopkins.

Data Source
-----------

-   The original data can be found here:
    `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`
-   The original description of the dataset can be found here:
    `http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones`

Description of Data Set
-----------------------

According to the description of the data set, the experiments were
carried out with a group of 30 volunteers ranging from 19-48 years. Each
person performed six activities with a smartphone on his or her waist.
Using the smartphone's embedded accelerometer and gyroscope, the data
team captured 3-axial linear acceleration and 3-axial angular velocity
at a constant rate of 50Hz. The obtained dataset was randomly
partitioned into two sets, where 70% of the volunteers were selected for
generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by
applying noise filters and then sampled in fixed-width sliding windows
of 2.56 sec and 50% overlap (128 readings/window). The sensor
acceleration signal, which has gravitational and body motion components,
was separated using a Butterworth low-pass filter into body acceleration
and gravity. The gravitational force was assumed to have only low
frequency components, therefore a filter with 0.3 Hz cutoff frequency
was used. From each window, a vector of features was obtained by
calculating variables from the time and frequency domain.

Data Files
----------

The dataset includes the following files that were relevant for this
project:

-   'README.txt'
-   'features\_info.txt': Shows information about the variables used on
    the feature vector.
-   'features.txt': List of all features.
-   'activity\_labels.txt': Links the class labels with their activity
    name.
-   'train/X\_train.txt': Training set.
-   'train/y\_train.txt': Training labels.
-   'test/X\_test.txt': Test set.
-   'test/y\_test.txt': Test labels.
-   'subject\_test.txt': Subject ID for test set.
-   'subject\_train.txt': Subject ID for training set.

Overview of Transformations
---------------------------

There were five major components to the project: \* Merges the training
and the test sets to create one data set. \* Extracts only the
measurements on the mean and standard deviation for each measurement. \*
Uses descriptive activity names to name the activities in the data
set \* Appropriately labels the data set with descriptive activity
names. \* Creates a second, independent tidy data set with the average
of each variable for each activity and each subject. This can be found
in `tidy.txt`.

Basic Overview of `run_analysis.R`
----------------------------------

Running the file accomplishes the following steps:

-   Load both test and training data
-   Load the features and activity labels.
-   Extract the mean and standard deviation column names and data.
-   Process the test and training data.
-   Merge the data set and output to a text file.
