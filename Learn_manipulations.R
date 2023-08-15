# --------------------------------------------
#             About
# --------------------------------------------
# Learning how to manipulate and combine multiple datasets and lists.
# Using: rbind, cbind, merge, data.table manipulations
# Source: https://bookdown.org/ndphillips/YaRrr/creating-matrices-and-dataframes.html

# --------------------------------------------
#             cbind
# --------------------------------------------
# Combine vectors as columns in a matrix
cbind_obj <- cbind(c(1, 2, 3, 4, 5),
      c("a", "b", "c", "d", "e"))
print(cbind_obj)

# --------------------------------------------
#             rbind
# --------------------------------------------
# Combine vectors as rows in a matrix
rbind_obj <- rbind(1:5, 6:10, 11:15)
print(rbind_obj)

# --------------------------------------------
#             merge
# --------------------------------------------
# Source: https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/merge

# Create sample dataframes
right.survey <- data.frame(
  "participant" = c("a", "b", "c", "d" , "e", "right_only"),
  "right.score" = c(3, 4, 5, 3, 1, 3))
left.survey <- data.frame(
  "participant" = c("b", "c", "e", "d", "a", "left_only"),
  "left.score" = c(20, 40, 50, 90, 53, 40))
new.survey <- data.frame(
  "name" = c("b", "c", "e", "d", "a", "left_only"),
  "left.score" = c(20, 40, 50, 90, 53, 40))

# Combine using a left join: all.x
combined.survey <- merge(x = right.survey,
                         y = left.survey,
                         by = "participant",
                         all.x = TRUE)
print(combined.survey)

# Combine using a right join: all.y
combined.survey <- merge(x = right.survey,
                         y = left.survey,
                         by = "participant",
                         all.y = TRUE)
print(combined.survey)

# Combine using a full join: all
combined.survey <- merge(x = right.survey,
                         y = left.survey,
                         by = "participant",
                         all = TRUE)

# Combine using column specifications and sorting using "by" column
combined.survey <- merge(x = right.survey,
                         y = new.survey,
                         by.x = "participant",
                         by.y = "name", 
                         all = TRUE,
                         sort = TRUE)
print(combined.survey)

# --------------------------------------------
#             data.frame
# --------------------------------------------
survey <- data.frame("index" = c(1, 2, 3, 4, 5),
                     "sex" = c("m", "m", "m", "f", "f"),
                     "age" = c(99, 46, 23, 54, 23))
print(survey)

# --------------------------------------------
#             data.table
# --------------------------------------------
# data.table is an R package that provides an enhanced version of data.frames, 
# which are the standard data structure for storing data in base R
# NOTE:
#   * Unlike data.frames, columns of character type are never converted to factors by default.
#   * Row numbers are printed with a : in order to visually separate the row number from the first column.
#   * When the number of rows to print exceeds the global option datatable.print.nrows (default = 100), 
#     it automatically prints only the top 5 and bottom 5 rows
#   * data.table doesn’t set or use row names

# DT[i, j, by] = Take DT, subset/reorder rows using i, then select/calculate j, grouped by by.
#                rows = i ; columns = j
# Source: https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html

# 1) Create sample data.table
library(data.table)
DT <- data.table(
  ID = c("b","b","b","a","a","c"),
  a = 1:6,
  b = 7:12,
  c = 13:18
)
print(DT)

# 2) Read in sample data
input <- if (file.exists("flights14.csv")) {
  "flights14.csv"
} else {
  "https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv"
}
flights <- fread(input)
flights

# 3) Subset rows in i
# Get all the flights with “JFK” as the origin airport in the month of June.
ans <- flights[origin == "JFK" & month == 6]
head(ans)
# Get the first two rows from flights.
ans <- flights[1:2]
ans
# Sort flights first by column origin in ascending order, and then by dest in descending order:
#  use the R function order() to accomplish this.
ans <- flights[order(origin, -dest)]
head(ans)

# 4) Select column(s) in j
# Select arr_delay column, but return it as a vector.
ans <- flights[, arr_delay]
head(ans)
# Select arr_delay column, but return as a data.table instead.
ans <- flights[, list(arr_delay)]
head(ans)
# Select both arr_delay and dep_delay columns.
# Option 1
ans <- flights[, .(arr_delay, dep_delay)]
head(ans)
# Option 2
ans <- flights[, list(arr_delay, dep_delay)]
head(ans)
# Select both arr_delay and dep_delay columns and rename them to delay_arr and delay_dep.
ans <- flights[, list(delay_arr = arr_delay, delay_dep = dep_delay)]
head(ans)

# 5) Compute or do in j
# How many trips have had total delay < 0?
ans <- flights[, sum( (arr_delay + dep_delay) < 0 )]
ans

# 6) Subset in i and do in j
# Calculate the average arrival and departure delay for all flights with “JFK”
# as the origin airport in the month of June.
ans <- flights[origin == "JFK" & month == 6,
               .(m_arr = mean(arr_delay), m_dep = mean(dep_delay))]
ans
# How many trips have been made in 2014 from “JFK” airport in the month of June?
ans <- flights[year == "2014" & origin == "JFK" & month == 6, length(dest)]
ans
# Special symbol .N: 
# .N is a special built-in variable that holds the number of observations in the current group.
ans <- flights[origin == "JFK" & month == 6L, .N]
ans

# 7) How can I refer to columns by names in j (like in a data.frame)?
ans <- flights[, c("arr_delay", "dep_delay")]
head(ans)
# Select columns named in a variable using the .. prefix
select_cols = c("arr_delay", "dep_delay")
flights[ , ..select_cols]
# returns all columns except arr_delay and dep_delay
ans <- flights[, !c("arr_delay", "dep_delay")]
ans

# 8) Grouping using by
# How can we get the number of trips corresponding to each origin airport?
ans <- flights[, list(num_trips = .N, avg_delay = mean(dep_delay)), by = "origin"]
ans
# How can we calculate the number of trips for each origin airport for carrier code "AA"?
ans <- flights[carrier == "AA", list(num_trips = .N), by = origin]
ans
# How can we get the total number of trips for each origin, dest pair for carrier code "AA"?
ans <- flights[carrier == "AA", list(num_trips = .N), by = list(origin, dest)]
ans
# How can we get the average arrival and departure delay for each orig,dest 
# pair for each month for carrier code "AA"?
ans <- flights[carrier == "AA", list(num_trips = .N, avg_arrdelay = mean(arr_delay),
                                     avg_depdelay = mean(dep_delay)), by = list(origin, dest, month)]
ans

# 9) Sorted by: keyby
# How can we directly order by all the grouping variables?
# (Change by to keyby.)
ans <- flights[carrier == "AA", list(num_trips = .N, avg_arrdelay = mean(arr_delay),
                                     avg_depdelay = mean(dep_delay)),
                                     keyby = list(origin, dest, month)]
ans

# 10) Chaining
# How can we order ans using the columns origin in ascending order, and dest in descending order?
ans <- flights[carrier == "AA", .N, by = .(origin, dest)][order(origin, -dest)]
ans

# 11) Expressions in by
# Can by accept expressions as well or does it just take columns?
ans <- flights[, .N, .(dep_delay>0, arr_delay>0)]
ans

# 12)  Multiple columns in j - .SD
# data.table provides a special symbol, called .SD. It stands for Subset of Data
# .SD contains all the columns except the grouping columns by default.
ans <- flights[carrier == "AA",                ## Only on trips with carrier "AA"
        lapply(.SD, mean),                     ## compute the mean
        by = .(origin, dest, month),           ## for every 'origin,dest,month'
        .SDcols = c("arr_delay", "dep_delay")] ## for just those specified in .SDcols
ans
