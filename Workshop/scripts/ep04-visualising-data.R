## Visualing data with ggplot2

# Load ggplot

library(ggplot2)
library(tidyverse)
# library(readr) alternative to loading all of tidyverse as it will read csv file

# Load the data

surveys_complete <- read_csv("data_raw/surveys_complete.csv")

# Create a plot - 3 important steps

ggplot(data = surveys_complete)   # the data you want to use

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))  # the axis for x and y

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))+
  geom_point()         # Tell how to display it, so the type of graph you want
                       # Any aesthetic applied here, is a base to everything, a 'global option'

# Assign a plot to a variable (aka an object)

surveys_plot <- ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))

# Draw the plot

surveys_plot +          # Remember, the + needs to go at end of line to join the line beneath
  geom_plot()           # That is to say, can't start this next line with the + sign and won't read together


# Challenge 1
# Change the mappings so weight is on the y-axis and hindfoot_length is on the x-axis

ggplot(data = surveys_complete, mapping = aes(x = hindfoot_length, y = weight))+
  geom_point() 


# Challenge 2
# How would you create a histogram of weights?

ggplot(data=surveys_complete, mapping = aes(x=weight)) + 
  geom_histogram(binwidth=10)   # Makes it tigther, adding binwidth and gets rid of error



