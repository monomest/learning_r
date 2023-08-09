# --------------------------------------------
#             About
# --------------------------------------------
# Learning to plot with ggplot and some skew removal.
# Using a music x mental health dataset.


# --------------------------------------------
#             Install packages
# --------------------------------------------
# install.packages("tidyverse")
# install.packages("ggplot2")

# --------------------------------------------
#          Load libraries
# --------------------------------------------
library(ggplot2)

# --------------------------------------------
#     Load music x mental health dataset
# --------------------------------------------
# Source: https://www.kaggle.com/datasets/catherinerasgaitis/mxmh-survey-results

# Method 1) read.csv and load into data frame
dataset <- read.csv("data/mxmh_survey_results.csv", header=TRUE, stringsAsFactors=TRUE)
head(dataset)
colnames(dataset)

# Method 2) read_csv
# library(readr)
# dataset <- read_csv("data/mxmh_survey_results.csv")
# head(dataset)

# --------------------------------------------
#  Plotting anxiety levels within music genres
# --------------------------------------------

# Convert "Anxiety" column into a factor for plotting
str(dataset)
dataset$"Anxiety.factor" <- as.factor(dataset$Anxiety)
str(dataset)

# Define the genre plot
GenrePlot <- ggplot(data = dataset,
                    aes(x=reorder(Fav.genre,Fav.genre,
                                  function(x)-length(x)), 
                        fill = Anxiety.factor)) + 
              geom_bar() +
              scale_y_continuous(n.breaks=20) +
              theme(axis.text.x = element_text(angle = 30,
                                   vjust = 0.5,
                                   hjust = 0.5)) 

# Plot with titles
print(GenrePlot + labs(
      title = "Anxiety levels within favourite music genres",
      y = "Count", x = "Favourite music genre", fill = "Anxiety level"
))

# --------------------------------------------
#  Distribution of age
# --------------------------------------------
AgeHistPlot <- ggplot(data = dataset,
                  aes(x=Age, fill = Anxiety.factor)) + 
            geom_histogram() +
            scale_x_continuous(n.breaks=20) +
            scale_y_continuous(n.breaks=20)

print(AgeHistPlot + labs(
  title = "Distribution of age and anxiety levels",
  y = "Count", x = "Age", fill = "Anxiety levels"
))

# --------------------------------------------
#  Plotting age vs. anxiety levels
# --------------------------------------------
AgePlot <- ggplot(data = dataset,
                  aes(x=Age, y=Anxiety, group=While.working)) + 
          geom_point(aes(color=While.working)) +
          scale_x_continuous(n.breaks=20) +
          scale_y_continuous(n.breaks=10)

print(AgePlot + labs(
  title = "Age and anxiety levels",
  y = "Anxiety", x = "Age"
))

# --------------------------------------------
#  Check skewness of age data
# --------------------------------------------
# Docs: https://medium.com/@TheDataGyan/day-8-data-transformation-skewness-normalization-and-much-more-4c144d370e55
# Install package
install.packages("e1071")
# Install library
library(e1071)

# Use skewness() :
# If skewness value lies above +1 or below -1, data is highly skewed. 
# If it lies between +0.5 to -0.5, it is moderately skewed. 
# If the value is 0, then the data is symmetric
cat("Skewness of Age: ", skewness(dataset$Age, na.rm = TRUE), "\n")

# --------------------------------------------
#  Remove skew through scaling
# --------------------------------------------
# Try log scaling and standard scaling
dataset$Age.scaled_log <- log(dataset$Age)
dataset$Age.scaled <- scale(dataset$Age, center= TRUE, scale=TRUE)

# Check skewness after scaling
cat("Skewness of scaled Age: ", skewness(dataset$Age.scaled, na.rm = TRUE), "\n")
cat("Skewness of log Age: ", skewness(dataset$Age.scaled_log, na.rm = TRUE), "\n")

# --------------------------------------------
#  Distribution of scaled age
# --------------------------------------------
AgeHistPlot <- ggplot(data = dataset,
                      aes(x=Age.scaled_log, fill = Anxiety.factor)) + 
  geom_histogram() +
  scale_x_continuous(n.breaks=20) +
  scale_y_continuous(n.breaks=20)

print(AgeHistPlot + labs(
  title = "Distribution of scaled age and anxiety levels",
  y = "Count", x = "Age scaled", fill = "Anxiety levels"
))


# --------------------------------------------
#  Plot age distribution use line and point
# --------------------------------------------
# Create count of Age
dataset$Age.character <- as.character(dataset$Age)
dataset$Age.count <- as.numeric(ave(dataset$Age.character, dataset$Age.character, FUN = length))
str(dataset)

# Plot
AgeHistPlot <- ggplot(data = dataset,
                      aes(x=Age, y=Age.count)) + 
  geom_line(linetype="dashed", colour="blue", size=0.5) +
  geom_point() +
  scale_x_continuous(n.breaks=20) +
  scale_y_continuous(n.breaks=20)

# Print
print(AgeHistPlot + labs(
  title = "Distribution of age",
  y = "Count", x = "Age"
))

# --------------------------------------------
#  Plotting popularity of music genres with age
# --------------------------------------------

# Define the genre plot
GenrePlot <- ggplot(data = dataset,
                    aes(x=reorder(Fav.genre,Fav.genre,
                                  function(x)-length(x)), 
                          fill = Age.character)) + 
            geom_bar() +
            scale_y_continuous(n.breaks=20) +
            theme(axis.text.x = element_text(angle = 30,
                                             vjust = 0.5,
                                             hjust = 0.5)) 

# Plot with titles
print(GenrePlot + labs(
  title = "Which music genres are popular by age",
  y = "Count", x = "Favourite music genre", fill = "Age"
))

# --------------------------------------------
#  Importing and exporting in R Data Formats
# --------------------------------------------
# Saving data into R data formats can reduce considerably the size of large files by compression.
# Source: http://www.sthda.com/english/wiki/saving-data-into-r-data-format-rds-and-rdata
#         https://bookdown.org/ndphillips/YaRrr/rdata-files.html

# Save an object to a file
saveRDS(dataset, file = "data/mxmh_survey_results.rds")
# Restore the object as a dataframe
dataset_rds <- readRDS(file = "data/mxmh_survey_results.rds")
str(dataset_rds)

# Saving on object in RData format
save(dataset, file = "data/mxmh_survey_results.RData")
# Save multiple objects
data2 <- c(0,1,2,3)
save(dataset, data2, file = "data/data.RData")
# To load the data again
load("data/data.RData")