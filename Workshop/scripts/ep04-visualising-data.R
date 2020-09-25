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
  geom_histogram(binwidth=10)   # Makes it tigther, adding binwidth, and gets rid of error ' Pick better value with 'binwidth''


# Building plots iteratively

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))+
  geom_point(alpha = 0.1, colour = "blue")   # Alpha changed transparency and colour of points, so better see when dense overlapping data

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))+
  geom_point(alpha = 0.1, aes(colour = species_id)) # Coloured according to species ID - very cool!
                                                    # No inverted commas needed as already column headings and from data set



# Challenge 3
# Use what you just learned to create a scatter plot of weight over species_id with the 
# plot type showing in different colours. 


  
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight))+
  geom_jittert(alpha = 0.2, aes(colour = plot_type))   # jitter skews so it is not overlapping directly points, and thus alpha a bit darker at 0.2

# Is this a good way to show this type of data?
# No, better to use a box plot


# Boxplots - discrete (x) on one and continuous on other axis (y)
# One discrete, one continuous variable

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight))+
  geom_boxplot()

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight))+
  geom_boxplot(alpha = 0)+
  geom_jitter(alpha = 0.3, colour = "tomato")

# Challenge 4
# Notice how the boxplot layer is behind the jitter layer? 
# What do you need to change in the code to put the boxplot in front of the points such that it’s not hidden?

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight))+
  geom_jitter(alpha = 0.3, colour = "tomato")+
  geom_boxplot(alpha = 0)                       # So reverse the order, with jitter first and boxplot second


# Challenge 5
# Boxplots are useful summaries but hide the shape of the distribution. 
# For example, if there is a bimodal distribution, it would not be observed with a boxplot. 
# An alternative to the boxplot is the violin plot (sometimes known as a beanplot), where the shape (of the density of points) is drawn.

# Replace the box plot with a violin plot


ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight))+
  geom_violin(alpha = 0.5, colour = "tomato") 


# Challenge 6
# So far, we’ve looked at the distribution of weight within species. 
# Make a new plot to explore the distribution of hindfoot_length within each species.
# Add color to the data points on your boxplot according to the plot from which the sample was taken (plot_id).

# Hint: Check the class for plot_id. Consider changing the class of plot_id from integer to factor. 
# How and why does this change how R makes the graph?
  
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length))+
  geom_jitter(alpha = 0.3, colour = "tomato")+
  geom_boxplot(alpha = 0)

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length))+
  geom_jitter(alpha = 0.1, aes(colour = plot_id))+
  geom_boxplot(alpha = 0)   # Not good as reading discrete data as continuous

class(surveys_complete$plot_id)   # select particular portion of our data frame, look in surveys complete for plot id
                                  # answer is "numeric"

as.factor(surveys_complete$plot_id) # first run this code
surveys_complete$plot_id <- as.factor(surveys_complete$plot_id)  # then alter to this, to switch back into your dataframe
  
class(surveys_complete$plot_id) # now tells you it is a factor


ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length))+
  geom_jitter(alpha = 0.1, aes(colour = plot_id))+
  geom_boxplot(alpha = 0)                            # Now this data has instead of continuous scale with blue, 
                                                     # now factor with discrete ID by plot

# To not permanently alter the plot id to a factor, and just generate a plot and not alter your entire data set, do this...
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length))+
  geom_jitter(alpha = 0.1, aes(colour = as.factor( plot_id)))+
  geom_boxplot(alpha = 0) 



# Challenge 7
# In many types of data, it is important to consider the scale of the observations. 
# For example, it may be worth changing the scale of the axis to better distribute the observations in the space of the plot. 
# Changing the scale of the axes is done similarly to adding/modifying other components (i.e., by incrementally adding commands). 

# Make a scatter plot of species_id on the x-axis and weight on the y-axis with a log10 scale

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_jitter(alpha = 0.3, aes(color = as.factor(plot_id))) +
  scale_y_log10() 
# OR 
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_point()+
  scale_y_log10()                         # This gives a more solid looking line output, jitter above makes it bulkier


# Plotting Time Series Data

# Activity - Counts per year for each genus

# First step, do some groupings

yearly_counts <- surveys_complete %>% 
  count(year, genus)

yearly_counts  # look at output, see there is a "n" variable now (in console output)

ggplot(data = yearly_counts, mapping = aes(x = year, y = n))+
  geom_line()                 # does not give individual outputs for each genus, just one single line

# 
ggplot(data = yearly_counts, mapping = aes(x = year, y = n, group = genus))+
  geom_line()                 # this will give individual line for each genus, although still no legend 

# Challenge 8
# Modify the code for the yearly counts to colour by genus so we can clearly see the counts by genus. 


# Challenge 9
# How would you modify this code so the faceting is organised into only columns instead of only rows?


# Challenge 10
# Put together what you’ve learned to create a plot that depicts how the average weight of each species changes through the years.

# Hint: need to do a group_by() and summarize() to get the data before plotting



