# --------------------------------------------
#             About
# --------------------------------------------
# Learning to plot using base functions (plot, hist, lines)
# Using Austin Animal Center Shelter Intakes and Outcomes dataset.

# --------------------------------------------
#             Install packages
# --------------------------------------------
# install.packages("tidyverse")

# --------------------------------------------
#     Load animal dataset
# --------------------------------------------
# Source: https://www.kaggle.com/datasets/aaronschlegel/austin-animal-center-shelter-intakes-and-outcomes

# Method 1) read.csv and load into data frame
# dataset <- read.csv("data/aac_intakes_outcomes.csv", header=TRUE, stringsAsFactors=TRUE)
# head(dataset)
# colnames(dataset)

# Method 2) read_csv
library(readr)
dataset <- as.data.frame(read_csv("data/aac_intakes_outcomes.csv"))
head(dataset)

# Structure of dataset
str(dataset)

# --------------------------------------------
#     Plot
# --------------------------------------------
# Plot Age of animal vs. Time spent in shelter
plot(dataset$"age_upon_outcome_(years)", dataset$time_in_shelter_days,
     main="Age of animal vs. Time spent in shelter",
     ylab="Days spent in shelter",
     xlab="Age",
     col="blue",
     type="p"
     )
# Add to the existing graph
points(dataset$"age_upon_intake_(years)", dataset$time_in_shelter_days, col="red")
# Add legend
legend("topright",
       c("Age upon outcome","Age upon intake"),
       fill=c("blue","red")
)


# Plot Age of animal upon intake vs. upon outcomes
plot(dataset$"age_upon_intake_(years)", dataset$"age_upon_outcome_(years)",
     main="Age of animal upon intake vs. upon outcomes",
     ylab="Age upon outcome (Years)",
     xlab="Age upon intake (Years)",
     type="p"
)
# Add new line to plot
x_line=c(0,25, 25)
y_line=c(0,25, 25)
lines(x_line, y_line, col="red", lwd=3, lty="dashed")
# Add new line to plot
x_line2=c(1,5,10,15,20)
y_line2=2 * x_line2
lines(x_line2, y_line2, col="blue", lwd=3, lty="dotted")
# Add legend
legend("bottomright",
       c("Age", "Trend", "Test line"),
       fill=c("black", "red", "blue")
)

# --------------------------------------------
#     Hist
# --------------------------------------------
# hist can only be used for numerical vectors

# Plot Histogram of animal age upon intake
hist(dataset$"age_upon_intake_(years)", 
     breaks = 30,
     xlim=c(0, 15),
     xaxp=c(0,15,15),
     xlab="Age upon intake (years)",
     ylab="Frequency",
     main="Histogram of animal age upon intake",
     col = 'black', border = "white")

# Plot Histogram of intake hour of animals
hist(dataset$intake_hour, 
     breaks = 24,
     xlim=c(0, 25),
     xaxp=c(0,25,25),
     ylim=c(0, 15000),
     yaxp=c(0, 15000, 20),
     xlab="Intake hour",
     ylab="Frequency",
     main="Histogram of intake hour of animals",
     col = 'black', border = "white"
     )