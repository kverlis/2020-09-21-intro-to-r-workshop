#   _____ _             _   _                        _ _   _       _____        _        
#  / ____| |           | | (_)                      (_| | | |     |  __ \      | |       
# | (___ | |_ __ _ _ __| |_ _ _ __   __ _  __      ___| |_| |__   | |  | | __ _| |_ __ _ 
#  \___ \| __/ _` | '__| __| | '_ \ / _` | \ \ /\ / | | __| '_ \  | |  | |/ _` | __/ _` |
#  ____) | || (_| | |  | |_| | | | | (_| |  \ V  V /| | |_| | | | | |__| | (_| | || (_| |
# |_____/ \__\__,_|_|   \__|_|_| |_|\__, |   \_/\_/ |_|\__|_| |_| |_____/ \__,_|\__\__,_|
#                                    __/ |                                               
#                                   |___/                                                
#
# Based on: https://datacarpentry.org/R-ecology-lesson/02-starting-with-data.html



# Lets download some data (make sure the data folder exists)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

# now we will read this "csv" into an R object called "surveys"
surveys <- read.csv("data_raw/portal_data_joined.csv")

# and take a look at it
surveys
head(surveys)
View(surveys)

# BTW, we assumed our data was comma separated, however this might not
# always be the case. So we may been to tell read.csv more about our file.



# So what kind of an R object is "surveys" ?
class(surveys)


# ok - so what are dataframes ?
str(surveys)
dim(surveys)
nrow(surveys)
ncol(surveys) # 

head(surveys) # start of the table, first six enteries
tail(surveys) # shows you end of the table

head(surveys,2) # modify to show you number of entries, first 2 or 20 or whatever, by giving number


names(surveys)
rownames(surveys)

summary(surveys)

# --------
# Exercise
# --------
#
# What is the class of the object surveys?
#run class(surveys)
# Answer:
data.frame

# How many rows and how many columns are in this survey ?
#
# Answer:
rows 34786
columns 13

# What's the average weight of survey animals
#
# run the summary(surveys) and it will show you the mean for weight
# Answer:
42.67

# Are there more Birds than Rodents ?
# again run summary(surveys) 
# shows us that there are bird are 450 and rodents 34247
#
# Answer:
No

# 
# Topic: Sub-setting
#

# first element in the first column of the data frame (as a vector)
surveys[1 , 1]

# first element in the 6th column (as a vector)
surveys[1 , 6]

# first column of the data frame (as a vector)
surveys[ , 6] # leave row space blank, as you want all so do not specify

# first column of the data frame (as a data frame)
surveys[1]      #subset of dataframe with no comma, get column itself as a dataframe
head(surveys[1])
head(surveys[ ,1]) # basically gives same results as function before, but horizontal display

# first row (as a data frame)
surveys[1 ,]

# first three elements in the 7th column (as a vector)
surveys[1:3, 7]   # use a colon for a range

# the 3rd row of the data frame (as a data.frame)
surveys[3, ]    

# equivalent to head(metadata)
head(surveys)
surveys[1:6, ]   # same output as by using the head(surveys) command

# looking at the 1:6 more closely
1:6
5:10
# when you run, it tells you that you mean the sequence of numbers between the range

surveys[ c(1,2,3,4,5,6)]
surveys [ c(2,4,6)] #odd numbers only

# we also use other objects to specify the range
rows <- 6
surveys[1:6, 3] # gives first 6 values from column 3 in the data set
surveys[1:rows, 3] # this gives same output as one above


#
# Challenge: Using slicing, see if you can produce the same result as:
#
#   tail(surveys)
#
# i.e., print just last 6 rows of the surveys dataframe
#
# Solution:
surveys[34781:34786, ] # if more data is added, this may give you error msg later on...
nrow(surveys)          # calculate no. of rows in table ahead of time, therefore, use this number...
end <- nrow(surveys)   # or can be defined this way as a value
surveys[34781:nrow(surveys), ]
surveys[(nrow(surveys)-6):nrow(surveys), ]   # this is best, remove the exact line
surveys[end-6:end, ]  # gets to the same output as above, using a defined value of 'end'

length(surveys)       # shows number of columns we have
length(surveys[ ,1])  # another way to get to end value of number of rows

# We can omit (leave out) columns using '-'
surveys[-1]     # give me all output apart from column 1. Make that column disapear
head( surveys [c(-1,-2,-3)] )   # head shows first six ouput. C is combine, so multiple columns removed
head( surveys[c(-2, -3, -4, -5)])

head( surveys [-(1:3)]) # remove a range using negative number in front of bracketed sequence
-(1:3)
head (surveys [ -(1:3)])

-1:3                  # is not the same as -(1:3)
head (surveys [-1:3]) # can not do this! As it cannot have negative subscript

# column "names" can be used in place of the column numbers
# use column name instead of number to find
head ( surveys["month"])   #use head to make output smaller, first six output instead all of it



#
# Topic: Factors (for categorical data) - not continuous, like a temp
#
# eg. ranking: high medium low OR sex: male female non binary 
# eg. Likert scales: very likely, neutral, unlikely, etc
# eg. country: Australia, New Zealand, australia - not having capital or format

gender <- c("male", "male", "female")

gender <- factor (c("male", "male", "female"))   # A vector of factors
gender

class(gender)     # when run this, tells me is a factor
levels(gender)    # when run, tells me "female" and "male"
nlevels(gender)   # when run, tells me there are 2 levels (male and female)

# factors have an order
temperature <- factor (c ("hot", "cold", "hot", "warm"))
temperature[1]
temperature[2]

levels(temperature)   # will tell me number of levels and what they are as output, so cold, hot and warm
temperature <- factor (c ("hot", "cold", "hot", "warm"),  # to tell the order more logical than alphabetically
                       level = c ("cold", "warm", "hot"))  # NOTE pressed enter and still one line of code

levels(temperature)     # now the levels are in the sensible, not alphabetical order
                      

# Converting factors
as.numeric(temperature)
as.character(temperature)

# can be tricky if the levels are numbers
year <- factor ( c (1990, 1993, 1997, 1998, 1990))
year
as.numeric(year)    # to convert back do this
                    # but this doesn't really make sense to make numbers
as.character(year)  # gives string, but not readily able to use, therefore...
as.numeric( as.character(year)) # turn into characters, and then back into numbers

# so does our survey data have any factors


#
# Topic:  Dealing with Dates
#

# R has a whole library for dealing with dates ...



# R can concatenated things together using paste()


# 'sep' indicates the character to use to separate each component


# paste() also works for entire columns


# let's save the dates in a new column of our dataframe surveys$date 


# and ask summary() to summarise 


# but what about the "Warning: 129 failed to parse"


