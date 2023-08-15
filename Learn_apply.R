# --------------------------------------------
#             About
# --------------------------------------------
# Learning to use apply functions
# i.e., apply, lapply, sapply, tapply
# The apply collection can be viewed as a substitute to the loop.
# he purpose of apply() is primarily to avoid explicit uses of loop constructs.
# They can be used for an input list, matrix or array and apply a function. 
# Any function can be passed into apply().
# Source: https://www.guru99.com/r-apply-sapply-tapply.html
#         https://ademos.people.uic.edu/Chapter4.html

# --------------------------------------------
#             APPLY()
# --------------------------------------------
# apply() takes Data frame or matrix as an input and gives output in vector, list or array
# apply(X, MARGIN, FUN)
# Here:
#   -x: an array or matrix
# -MARGIN:  take a value or range between 1 and 2 to define where to apply the function:
# -MARGIN=1`: the manipulation is performed on rows
# -MARGIN=2`: the manipulation is performed on columns
# -MARGIN=c(1,2)` the manipulation is performed on rows and columns
# -FUN: tells which function to apply. Built functions 
# like mean, median, sum, min, max and even user-defined functions can be applied>

# 1) Sum a matrix over all the columns
m <- matrix(c(1:10), nrow=10, ncol=10)
m
m_sum_cols <- apply(m, 2, sum)
m_sum_cols
m_sum_rows <- apply(m, 1, sum)
m_sum_rows

# 2) Sum a dataframe over the columns
df <- data.frame(
  grapes = c(9,8,7,6),
  apples = c(1,2,3,4)
)
df
df_sum <- apply(df, 2, sum)
df_sum

# --------------------------------------------
#          LAPPLY(): list apply
# --------------------------------------------
# lapply() function is useful for performing operations on list 
# objects and returns a list object of same length of original set.
# lapply(X, FUN)
# Arguments:
# -X: A vector or an object
# -FUN: Function applied to each element of x	

# 1) Turn list into lowercase
movies <- c("SPYDERMAN","BATMAN","VERTIGO","CHINATOWN")
movies_lower <-lapply(movies, tolower)
str(movies_lower)

#2) Convert list into a vector using unlist()
movies_lower <-unlist(lapply(movies,tolower))
str(movies_lower)

# --------------------------------------------
#                 SAPPLY()
# --------------------------------------------
# sapply() function takes list, vector or data frame as input and gives output in vector or matrix. 
# sapply(X, FUN)
# Arguments:
# -X: A vector or an object
# -FUN: Function applied to each element of x

# 1) Find minimum speed from cars dataset
dt <- cars
dt
lmn_cars <- lapply(dt, min)
print(lmn_cars) # Returns a list
str(lmn_cars)
smn_cars <- sapply(dt, min)
print(smn_cars) # Returns matrix
str(smn_cars)

# --------------------------------------------
#                 TAPPLY()
# --------------------------------------------
# tapply() computes a measure (mean, median, min, max, etc..) or a function
# for each factor variable in a vector. It is a very useful function that lets you 
# create a subset of a vector and then apply some functions to each of the subset.
# tapply(X, INDEX, FUN = NULL)
# Arguments:
#   -X: An object, usually a vector
# -INDEX: A list containing factor
# -FUN: Function applied to each element of x

# 1) Median length of flower species in iris dataset
data(iris)
head(iris)
tapply(iris$Sepal.Width, iris$Species, median)
