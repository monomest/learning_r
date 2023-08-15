# --------------------------------------------
#             About
# --------------------------------------------
# Learning how to use basic conditional logic
# Sources: https://learnr.usu.edu/base_r/data_manipulation/4_5_conditionals.php
# NOTES:
# * ) and if() else should not be applied when the Condition being evaluated 
# is a vector. It is best used only when meeting a single element condition

#--------------------------------------------
#   Install packages and load libraries
# --------------------------------------------

install.packages("data.table")
library("data.table")

# --------------------------------------------
#     IF(), ELSE(): Checking if file exists
# --------------------------------------------
# Example 1)
# Source: https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html
input <- if (file.exists("flights14.csv")) {
  "flights14.csv"
} else {
  "https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv"
}
print(input)
flights <- fread(input)
flights

# Example 2)
if (sum(is.na(flights[, distance])) != 0) {
  print(paste0("There are ", sum(is.na(flights[, distance]), " nulls in the 'distance' column")))
} else {
  print("The 'distance' column has no nulls.")
}

# --------------------------------------------
#       IFELSE()
# --------------------------------------------
# Unlike if(), ifelse() works with vectors. 
# Thus it can be applied to a column of data within a data object
input <- ifelse(file.exists("flights14.csv"), "flights14.csv", 
                "https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv")

flights$arrdelay_type <- ifelse(flights$arr_delay < 0, "Early", "Late")
flights

# --------------------------------------------
#       WHICH()
# --------------------------------------------
#  which() returns row number(s) from a data object meeting Condition. 
# It is a useful call for extracting observations or identifying observations meeting the condition.

# Get early flights in 2014, by carrier and origin
which(flights$year == "2014" & flights$arrdelay_type == "Early")
earlyFLights <- flights[which(flights$year == "2014" & flights$arrdelay_type == "Early"), ]
earlyFLights[, list(num_trips = .N), by = list(carrier, origin)][order(-num_trips)]

# --------------------------------------------
#       SWITCH()
# --------------------------------------------
# switch(WhichStatement2Use, Statement1, Statement2, ... , StatementN) 
# applies different Statement(s) depending on the switch condition. 
# Note that switch values outside the number of statements return a NULL of no answer

switch(2,"red","green","blue")