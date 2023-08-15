# --------------------------------------------
#             About
# --------------------------------------------
# Learning to create a random forest model.
# Using the titanic dataset.
# Source: https://bookdown.org/gmli64/do_a_data_science_project_in_10_days/titanic-prediciton-with-a-random-forest.html

# --------------------------------------------
#             Install packages
# --------------------------------------------
install.packages("ggplot2")
install.packages("gridExtra")
install.packages("randomForest")
install.packages("Rcpp")
install.packages('e1071', dependencies=TRUE)
install.packages('caret', dependencies=TRUE)
install.packages("dplyr") 
install.packages("magrittr") # package installations are only needed the first time you use it
install.packages("dplyr")    # alternative installation of the %>%

# --------------------------------------------
#          Load libraries
# --------------------------------------------
library(ggplot2)
library(magrittr) # needs to be run every time you start R and want to use %>%
library(dplyr)    # alternatively, this also loads %>%

# --------------------------------------------
#     Load titanic dataset
# --------------------------------------------
# Source: https://www.kaggle.com/competitions/titanic/overview

# Read.csv and load into data frame
train <- read.csv("data/titanic/train.csv", header=TRUE, stringsAsFactors=TRUE)
test <- read.csv("data/titanic/test.csv", header=TRUE, stringsAsFactors=TRUE)

# Assess data quantity
str(train)
str(test)

# --------------------------------------------
#     Examine data
# --------------------------------------------

data <- train
# check out data with a summary
summary(data)

# --------------------------------------------
#     Data exploration
# --------------------------------------------

# Examine PassengerID
# PassengerID has no missing value and duplication.
length(data$PassengerId)
length(unique(data$PassengerId))

# Examine Survived
data$Survived <- as.factor(data$Survived)
table(data$Survived, dnn = "Number of Survived in the Data")
# Calculate the survive rate in train data is 38% and the death rate is 62%
prop.table(table(as.factor(train$Survived), dnn = "Survive and death ratio in the Train"))

# Examine Pclass value,
# Look into Kaggle's explanation about Pclass: it is a proxy for social class i.e. rich or poor
# It should be factor rather than int.
data$Pclass <- as.factor(data$Pclass)

# Distribution across classes into a table
table(data$Pclass, dnn = "Pclass values in the Data")

# Distribution across classes with survive
table(data$Pclass, data$Survived)

# Calculate the distribution on Pclass
# Overall passenger distribution on classes.
prop.table(table(as.factor(data$Pclass), dnn = "Pclass percentage in the Data"))

# Train data passenger distribution on classes.
prop.table(table(as.factor(train$Pclass),dnn = "Pclass percentage in the Train"))

# Calculate death distribution across classes with Train data
SurviveOverClass <- table(train$Pclass, train$Survived)
# Convert SurviveOverClass into data frame
SoC.data.fram <- data.frame(SurviveOverClass) 
# Retrieve death distribution in classes
Death.distribution.on.class <- SoC.data.fram$Freq[SoC.data.fram$Var2==0]
prop.table(Death.distribution.on.class)

# Load up ggplot2 package to use for visualizations
library(ggplot2)

ggplot(train, aes(x = Pclass, fill = factor(Survived))) +
  geom_bar(width = 0.3) +
  xlab("Pclass") +
  ylab("Total Count") +
  labs(fill = "Survived")

# Convert Name type
data$Name <- as.character(data$Name)
# Find the two duplicate names. First used which function to # get the duplicate names and store them in a vector dup.names 
# check it up ?which.
dup.names <- data[which(duplicated(data$Name)), "Name"]
dup.names

# Use summary to check numbers and distribution
summary(data$Sex)

# plot Survived over Sex on dataset train
ggplot(data[1:891,], aes(x = Sex, fill = Survived)) +
  geom_bar(width = 0.3) +
  xlab("Sex") +
  ylab("Total Count") +
  labs(fill = "Survived")

# It makes sense to change age type to Factor to see distribution
summary(as.factor(data$Age))

# plot Survived on age group using train dataset
ggplot(data[1:891,], aes(x = Age, fill = Survived)) +
  geom_histogram(binwidth = 10) +
  xlab("Age") +
  ylab("Total Count")

# Plot on the survive on SibSp
ggplot(data[1:891,], aes(x = SibSp, fill = Survived)) +
  geom_bar(width = 0.5) +
  xlab("SibSp") +
  ylab("Total Count")  +
  labs(fill = "Survived")

# Plot on the survive on Parch
ggplot(data[1:891,], aes(x = Parch, fill = Survived)) +
  geom_bar(width = 0.5) +
  xlab("Parch") +
  ylab("Total Count")  +
  labs(fill = "Survived")

# Plot on the survive on Ticket
ggplot(data[1:891,], aes(x = Ticket, fill = Survived)) +
  geom_bar() +
  xlab("Ticket Number") +
  ylab("Total Count")  +
  labs(fill = "Survived")

# plot fare relation with survive
ggplot(data[1:891,], aes(x = Fare, fill = Survived)) +
  geom_histogram(binwidth = 5) +
  xlab("Fare") +
  ylab("Total Count") +
  ylim(0,50) + 
  labs(fill = "Survived")

# Take a look at just the first char as a factor and add to data as a new attribute
data$cabinfirstchar<- as.factor(substr(data$Cabin, 1, 1))
# first cabin letter survival plot
ggplot(data[1:891,], aes(x = cabinfirstchar, fill = Survived)) +
  geom_bar() +
  xlab("First Cabin Letter") +
  ylab("Total Count") +
  ylim(0,750) +
  labs(fill = "Survived")

# Plot data distribution and the survival rate for analysis
ggplot(data[1:891,], aes(x = Embarked, fill = Survived)) +
  geom_bar(width=0.5) +
  xlab("Embarked port") +
  ylab("Total Count") +
  labs(fill = "Survived")

# Calculate death distribution over Embarked port with Train data
# create Embarked and Survived contingency table
SurviveOverEmbarkedTable <- table(train$Embarked, train$Survived)
# Death-0/survived-1 value distribution (percentage) based on embarked ports
# prop.table(mytable, 2) give us column (Survived) percentages
Deathandsurvivepercentage <- prop.table(SurviveOverEmbarkedTable, 2)
# Plot
M <- c("c-Cherbourg", "Q-Queenstown", "S-Southampton")
## Calculate survived RATE distribution based on embarked ports
# Death-0/survived-1 value distribution (percentage) based on embarked ports
# prop.table(mytable, 1) give us row (Port) percentages
# col-1 (Survived=0, perished) and col-2 (Survived =1, survived)
DeathandsurviveRateforeachport <- prop.table(SurviveOverEmbarkedTable, 1)
#plot
barplot(Deathandsurvivepercentage[2:4,1]*100, xlab =(""), ylim=c(0,100), ylab="Death rate in percentage %",  names.arg = M, col="red", main="Death rate comparison among embarked ports", border="black", beside=TRUE)

# --------------------------------------------
#     Data preparation - missing values
# --------------------------------------------
library(rpart)
library(gridExtra)

# 1) Missing values

# Define a function to check missing values
missing_vars <- function(x) {
  var <- 0
  missing <- 0
  missing_prop <- 0
  for (i in 1:length(names(x))) {
    var[i] <- names(x)[i]
    missing[i] <- sum(is.na(x[, i])|x[, i] =="" )
    missing_prop[i] <- missing[i] / nrow(x)
  }
  # order   
  missing_data <- data.frame(var = var, missing = missing, missing_prop = missing_prop) %>% 
    arrange(desc(missing_prop))
  # print out
  missing_data
}

missing_vars(data)

# 1.1) Missing Cabin values
# Dealing with missing values in Cabin
# add newly created attribute and assign it with new values
data$HasCabinNum <- ifelse((data$Cabin != ""), "Yes", "No")

# 1.2) Deal with missing Age
# confirm Age missing values
data$Age_RE3 <- data$Age
summary(data$Age_RE3)

# Construct a decision tree with selected attributes and ANOVA method
Agefit <- rpart(Age_RE3 ~ Survived + Pclass + Sex + SibSp + Parch + Fare + Embarked,
                data=data[!is.na(data$Age_RE3),], 
                method="anova")
#Fill AGE missing values with prediction made by decision tree prediction
data$Age_RE3[is.na(data$Age_RE3)] <- predict(Agefit, data[is.na(data$Age_RE3),])
#confirm the missing values have been filled
summary(data$Age_RE3)
# Set missing age to the predicted age
data$Age <- data$Age_RE3
data <- subset(data, select = -c(Age_RE3))
str(data)

# 1.3) Deal with missing Fare value
# Replacing na with the median value
data[is.na(data$Fare), ]
data$Fare[is.na(data$Fare)] <- median(data$Fare, na.rm = T)

# 1.4) Deal with missing Embarked values
# list the missing records to figure out the fare and the ticket?
data[(data$Embarked==""), c("Embarked", "PassengerId",  "Fare", "Ticket")]
# we need to find out is there other passenger share the ticket?
data[(data$Ticket=="113572"), c("Ticket", "PassengerId", "Embarked", "Fare")]

# calculate fare_PP per person
fare_pp <- data %>%
  group_by(Ticket, Fare) %>%
  dplyr::summarize(Friend_size = n()) %>%
  mutate(Fare_pp = Fare / Friend_size)

data <- left_join(data, fare_pp, by = c("Ticket", "Fare"))
data %>%
  filter((Embarked != "")) %>%
  ggplot(aes(x = Embarked, y = Fare_pp)) + 
  geom_boxplot() + 
  geom_hline(yintercept = 40, col = "deepskyblue4")

# Price 40 (per person) is an outlier in embarked group S and Q. 
# However, if they embarked from C the price only just falls into the upper 
# quartile. So, we can reasonably the pare are embarked from C, so we want to 
# assign C to the embarked missing value.
data$Embarked[(data$Embarked)==""] <- "C"

# --------------------------------------------
# Data preparation - attribute re-engineering
# --------------------------------------------

# 2) Attribute re-engineering
# 2.1) Abstract Title out
data$Title <- gsub('(.*, )|(\\..*)', '', data$Name)
data %>%
  group_by(Title) %>%
  dplyr::count() %>%
  arrange(desc(n))

# Group those less common title’s into an ‘Other’ category.
data$Title <- ifelse(data$Title %in% c("Mr", "Miss", "Mrs", "Master"), data$Title, "Other")
L<- table(data$Title, data$Sex)
knitr::kable(L, digits = 2, booktabs = TRUE, caption = "Title and sex confirmation")
# Plot
data %>%
  filter(!is.na(Survived)) %>%
  ggplot(aes(x = factor(Title), fill = factor(Survived))) + 
  geom_bar(position = "fill") + 
  scale_y_continuous(labels = scales::percent, breaks = seq(0, 1, 0.1)) +
  scale_fill_discrete(name = "Survived") +
  labs(x = "Title", y = "Survival Percentage") + 
  ggtitle("Title attribute (Proportion Survived)")

# 2.2) Deck from Cabin
data$Cabin <- as.character(data$Cabin)
data$Deck <- ifelse((data$Cabin == ""), "U", substr(data$Cabin, 1, 1))
# plot our newly created attribute relation with Survive
p1 <- ggplot(data[1:891,], aes(x = Deck, fill = factor(Survived))) +
  geom_bar(width = 0.5) +
  labs(x = "Deck number", y = "Total account") + 
  labs(fill = "Survived")

# plot percentage of survive
p2 <- data %>%
  filter(!is.na(Survived)) %>%
  ggplot(aes(x = factor(Deck), fill = factor(Survived))) + 
  geom_bar(position = "fill") + 
  scale_y_continuous(labels = scales::percent, breaks = seq(0, 1, 0.1)) +
  scale_fill_discrete(name = "Survived") +
  labs(x = "Deck number", y = "Percentage") + 
  ggtitle("Newly created Deck number (Proportion Survived)")

grid.arrange(p1, p2, ncol = 2)

# 2.3) Ticket class from ticket number
data$Ticket <- as.character(data$Ticket)
data$Ticket_class <- ifelse((data$Ticket != " "), substr(data$Ticket, 1, 1), "")
data$Ticket_class <- as.factor(data$Ticket_class)
# plot our newly created attribute relation with Survive
p1 <- data %>%
  filter(!is.na(Survived)) %>%
  ggplot(aes(x = Ticket_class, fill = factor(Survived))) +
  geom_bar(width = 0.5) +
  labs(x = "Ticket_class", y = "Total account") + 
  labs(fill = "Survived value over Ticket class")
# plot percentage of survive
p2 <- data %>%
  filter(!is.na(Survived)) %>%
  ggplot(aes(x = factor(Ticket_class), fill = factor(Survived))) + 
  geom_bar(position = "fill") + 
  scale_y_continuous(labels = scales::percent, breaks = seq(0, 1, 0.1)) +
  scale_fill_discrete(name = "Survived") +
  labs(x = "Ticket_class", y = "Percentage") + 
  ggtitle("Survived percentage over Newly created Ticket_class")

grid.arrange(p1, p2, ncol = 2)

# 2.4) Travel in groups
data$Family_size <- data$SibSp + data$Parch + 1
data$Group_size <- pmax(data$Family_size, data$Friend_size)

# 2.5) Age in groups
Age_labels <- c('0-9', '10-19', '20-29', '30-39', '40-49', '50-59', '60-69', '70-79')

data$Age_group <- cut(data$Age, c(0, 10, 20, 30, 40, 50, 60, 70, 80), include.highest=TRUE, labels= Age_labels)

p1 <- data %>%
  filter(!is.na(Survived)) %>%
  ggplot(aes(x = Age_group, y = ..count.., fill = factor(Survived))) +
  geom_bar() +
  ggtitle("Survived value ove newly created Age_group")

# plot percentage of survive
Age_labels <- c('0-9', '10-19', '20-29', '30-39', '40-49', '50-59', '60-69', '70-79')

data$Age_group <- cut(data$Age, c(0, 10, 20, 30, 40, 50, 60, 70, 80), include.highest=TRUE, labels= Age_labels)

p1 <- data %>%
  filter(!is.na(Survived)) %>%
  ggplot(aes(x = Age_group, y = ..count.., fill = factor(Survived))) +
  geom_bar() +
  ggtitle("Survived value ove newly created Age_group")

# plot percentage of survive
p2 <- data %>%
  filter(!is.na(Survived)) %>%
  ggplot(aes(x = Age_group, fill = factor(Survived))) + 
  geom_bar(position = "fill") + 
  scale_y_continuous(labels = scales::percent, breaks = seq(0, 1, 0.1)) +
  scale_fill_discrete(name = "Survived") +
  labs(x = "Age group", y = "Percentage") + 
  ggtitle("Survived percentage ove newly created Age_group")

grid.arrange(p1, p2, ncol = 2)

# 2.6) Fare per passenger
data$Fare_pp <- data$Fare/data$Friend_size
# plot Fare_PP against Survived
p1<- data %>%
  filter(!is.na(Survived)) %>%
  ggplot(aes(x = Fare_pp, fill = factor(Survived))) + 
  geom_histogram(binwidth = 2) +
  scale_y_continuous(breaks = seq(0, 500, 50)) + 
  scale_fill_discrete(name = "Survived") + 
  labs(x = "Fare (per person)", y = "Count") + 
  ggtitle("Survived value over Fare_pp")
p1

# plot in box plot
# We can see that the perished passenger tend to pay less (around 8 pounds) 
# and the average survived passenger appeared paid something around 14 pounds.
data %>%
  filter(!is.na(Survived)) %>%
  filter(Fare > 0) %>%
  ggplot(aes(factor(Survived), Fare_pp)) +
  geom_boxplot(alpha = 0.2) +
  scale_y_continuous(trans = "log2") +
  geom_point(show.legend = FALSE) + 
  geom_jitter()

# 3) Build re-engineered dataset
RE_data <- subset(data, select = -c(Name, Cabin, Fare))

# --------------------------------------------
#   Random Forest model - key predictors
# --------------------------------------------
library(randomForest)
library(caret)

train <- RE_data
# convert variables into factor
# convert other attributes which really are categorical data but in form of numbers
train$Group_size <- as.factor(train$Group_size)
#confirm types
sapply(train, class)

# Build the random forest model uses pclass, sex, HasCabinNum, Deck and Fare_pp
set.seed(1234) #for reproduction 
RF_model1 <- randomForest(as.factor(Survived) ~ Sex + Pclass + HasCabinNum + Deck + Fare_pp, data=train, importance=TRUE)
save(RF_model1, file = "./data/RF_model1.rda")

# Check model accuracy
load("./data/RF_model1.rda")
RF_model1

# Make your prediction using the validate dataset
RF_prediction1 <- predict(RF_model1, train)
#check up
conMat<- confusionMatrix(RF_prediction1, train$Survived)
conMat$table
# Misclassification error
paste('Accuracy =', round(conMat$overall["Accuracy"],2))

# --------------------------------------------
#   Random Forest model - more variables
# --------------------------------------------
# RE_model2 with more predictors
set.seed(2222)
RF_model2 <- randomForest(as.factor(Survived) ~ Sex + Fare_pp + Pclass + Title + Age_group + Group_size + Ticket_class  + Embarked,
                          data = train,
                          importance=TRUE)
save(RF_model2, file = "./data/RF_model2.rda")

# Check model accuracy
load("./data/RF_model2.rda")
RF_model2

# RF_model2 Prediction on train
RF_prediction2 <- predict(RF_model2, train)
#check up
conMat<- confusionMatrix(RF_prediction2, train$Survived)
conMat$table
# Misclassification error
paste('Accuracy =', round(conMat$overall["Accuracy"],2))

# --------------------------------------------
#   Random Forest model - all variables
# --------------------------------------------
# RF_model3 construction with the maximum predictors
set.seed(2233)
RF_model3 <- randomForest(Survived ~ Sex + Pclass + Age
                          + SibSp + Parch + Embarked +
                            HasCabinNum + Friend_size +
                            Fare_pp + Title + Deck +
                            Ticket_class + Family_size +
                            Group_size + Age_group,
                          data = train, importance=TRUE)
save(RF_model3, file = "./data/RF_model3.rda")

# Display RE_model3's details
load("./data/RF_model3.rda")
RF_model3

# Make a prediction on Train
RF_prediction3 <- predict(RF_model3, train)
#check up
conMat<- confusionMatrix(RF_prediction3, train$Survived)
conMat$table

# Misclassification error
paste('Accuracy =', round(conMat$overall["Accuracy"],2))
