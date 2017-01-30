# Course Project (Getting and Cleaning Data)  

#### This repository contains critical files for the final project submission, including the run_analysis.R file, a code book .md file, and a sample "tidy.txt" output of the script.

#### The run_analysis.R script executes the following steps:

1. Installs and loads necessary packages if not already complete.
2. Installs and unzips the raw data if not already complete.
3. Loads and formats activity label and feature data, identifying measurement means and standard deviations.
4. Loads subject data, activity data, and all measurement data related to measurement means or standard deviations.
5. Combines subject, activity, and measurement data for the "train" and "test" datasets into a single frame.
6. Reshapes merged data into a summary of mean value for each measurement of each activity for each subject.
7. Exports tidy data as "tidy.txt".



