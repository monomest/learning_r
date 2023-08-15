# --------------------------------------------
#             About
# --------------------------------------------
# Learning to create a random forest model.
# Using the iris dataset.
# Source: https://www.r-bloggers.com/2021/04/random-forest-in-r/

# --------------------------------------------
#          Load libraries
# --------------------------------------------
library(randomForest)
library(datasets)
library(caret)

# --------------------------------------------
#          Load data
# --------------------------------------------
data<-iris
str(data)

# Check if data is balanced
data$Species <- as.factor(data$Species)
table(data$Species)

# --------------------------------------------
#   Data partition into train and test
# --------------------------------------------
set.seed(222)
ind <- sample(2, nrow(data), replace = TRUE, prob = c(0.7, 0.3))
train <- data[ind==1,]
test <- data[ind==2,]

str(train)
str(test)

# --------------------------------------------
#   Random Forest model
# --------------------------------------------
# Use all the features to predict which species the flower is
rf <- randomForest(Species~., data=train, proximity=TRUE)
print(rf)

# --------------------------------------------
#   Use model to predict train data
# --------------------------------------------
p1 <- predict(rf, train)
confusionMatrix(p1, train$ Species)

# --------------------------------------------
#   Use model to predict test data
# --------------------------------------------
p2 <- predict(rf, test)
confusionMatrix(p2, test$ Species)

# --------------------------------------------
#   Error rate of random forest
# --------------------------------------------
plot(rf)