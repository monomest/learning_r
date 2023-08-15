# --------------------------------------------
#             About
# --------------------------------------------
# Learn how to access / manipulate windows directories / files
# Source https://theautomatic.net/2018/07/11/manipulate-files-r/

# --------------------------------------------
#  Current working directory
# --------------------------------------------
# get current working directory
getwd()
# set working directory
setwd("C:/Users/rslaj/Documents/04_Projects/learn_r/Learn_RStudio")

# --------------------------------------------
#  Check if a file or directory exists
# --------------------------------------------
# check if a file exists
file.exists("folder_test/testfile.txt")
# check if a folder exists
file.exists("folder_test")
# alternatively, check if a folder exists with dir.exists
dir.exists("folder_test")

# --------------------------------------------
#  Creating Files and Directories
# --------------------------------------------
if(dir.exists("folder_test")){
  print("folder_test directory already exists.")
} else {
  dir.create("folder_test")
}
file.create("folder_test/testfile.txt")
file.create("folder_test/testfile.docx")
file.create("folder_test/testfile.csv")

# The one-liner below will create 100 empty text files:
sapply(paste0("folder_test/file", 1:100, ".txt"), file.create)

# Copying a file / folder
file.copy("README.md", "folder_test")

# --------------------------------------------
#  Read / write csv files
# --------------------------------------------
df <- data.frame(name = c("Jon", "Bill", "Maria", "Tom", "Emma"),
                 age = c(23,41,32,55,40)
)
df
write.csv(df, "folder_test/sample_df.csv", row.names=FALSE)
data <- read.csv("folder_test/sample_df.csv")
data

# --------------------------------------------
#  List all the files in a directory
# --------------------------------------------
# list all files in current directory
list.files()
# list all files in another directory
list.files("folder_test")

# --------------------------------------------
#  Delete files
# --------------------------------------------
# delete a file
unlink("folder_test/testfile.csv")
# delete another file
file.remove("folder_test/testfile.txt")

# delete a directory -- must add recursive = TRUE
unlink("folder_test", recursive = TRUE)

# --------------------------------------------
#  Physically open a file
# --------------------------------------------
# or file.show to launch a file
file.show("README.md")