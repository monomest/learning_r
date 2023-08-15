# --------------------------------------------
#             About
# --------------------------------------------
# Learning how write basic loops (for / while)
# Source: https://bookdown.org/ndphillips/YaRrr/what-are-loops.html

# --------------------------------------------
#             Install packages
# --------------------------------------------
# install.packages("yarrr")
# install.packages("BayesFactor")

# --------------------------------------------
#          Load libraries
# --------------------------------------------
library(yarrr)

# --------------------------------------------
#             for loops
# --------------------------------------------
# Print the integers from 1 to 10
for(i in 1:10) {
  print(i)
}

# Loop to add integers from 1 to 100
current.sum <- 0 # The starting value of current.sum
for(i in 1:100) {
  current.sum <- current.sum + i # Add i to current.sum
}
print(current.sum)

# Add the integers from 1 to 100 without a loop
print(sum(1:100))
# --------------------------------------------
#             while loops
# --------------------------------------------
i <- 0
while(i < 100) {
  print(paste0("Renee is ", i, " years old."))
  if(i == 99){
    print("Renee is too old.")
  }
  i <- i + 1
}

# --------------------------------------------
#   Creating multiple plots with a loop
# --------------------------------------------
# Use data in yarrr package
head(examscores)

par(mfrow = c(2, 2), mar = c(5, 5, 5, 5))  # Set up a 2 x 2 plotting space with margins

# Create the loop.vector (all the columns)
loop.vector <- 1:4

for (i in loop.vector) { # Loop over loop.vector
  
  # store data in column.i as x
  x <- examscores[,i]
  
  # Plot histogram of x
  hist(x,
       main = paste("Question", i),
       xlab = "Scores",
       xlim = c(0, 100))
}

# --------------------------------------------
#   Updating a container object with a loop
# --------------------------------------------
# We’ll use a loop to calculate how many students failed each of the 4 exams – 
# where failing is a score less than 50.

# Create a container object of 4 NA values
failure.percent <- rep(NA, 4)

for(i in 1:4) { # Loop over columns 1 through 4

  # Get the scores for the ith column
  x <- examscores[,i] 
  
  # Calculate the percent of failures
  failures.i <- mean(x < 50)  
  
   # Assign result to the ith value of failure.percent
  failure.percent[i] <- failures.i 

}
failure.percent

# Calculate failure percent without a loop
failure.percent <- rep(NA, 4)
failure.percent[1] <- mean(examscores[,1] < 50)
failure.percent[2] <- mean(examscores[,2] < 50)
failure.percent[3] <- mean(examscores[,3] < 50)
failure.percent[4] <- mean(examscores[,4] < 50)
failure.percent

# --------------------------------------------
#     The list object
# --------------------------------------------
# Create a list with vectors of different lengths
number.list <- list(
  "a" = rnorm(n = 10),
  "b" = rnorm(n = 5),
  "c" = rnorm(n = 15))

number.list

# Create an empty list with 5 elements
samples.ls <- vector("list", 5)
samples.ls

# We’ll generate i random samples and assign them to the ith element in samples.ls
for(i in 1:5) {
  samples.ls[[i]] <- rnorm(n = i, mean = 0, sd = 1)
}
samples.ls