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
  count(year, genus)  # default is n, if you wanted to name it count(year, genus, name = "some_name") # Note the quotes


yearly_counts  # look at output, see there is a "n" variable now for this count (as seen in console output)

ggplot(data = yearly_counts, mapping = aes(x = year, y = n))+
  geom_line()                 # does not give individual outputs for each genus, just one single line


ggplot(data = yearly_counts, mapping = aes(x = year, y = n, group = genus))+
  geom_line()                 # this will give individual line for each genus, although still no legend 


# Challenge 8
# Modify the code for the yearly counts to colour by genus so we can clearly see the counts by genus. 

ggplot(data = yearly_counts, mapping = aes(x = year, y = n, colour = genus))+
  geom_line()          # Don't need to define group, just colour

# OR
ggplot(data = yearly_counts, mapping = aes(x = year, y = n, group = genus))+
  geom_line(aes(colour = as.factor(genus)))


# Integrating the pipe operator with ggplot

yearly_counts %>%
  ggplot(mapping = aes(x = year, y = n, colour = genus))+ 
           geom_line()

# OR

yearly_counts_graph <- surveys_complete %>%
  count(year, genus) %>% 
  ggplot(mapping = aes(x = year, y = n, color = genus)) +
  geom_line()



# Faceting

ggplot(data=yearly_counts, mapping = aes (x = year, y = n,)) +
  geom_line()+
  facet_wrap(facets = vars(genus))   # Provides multiple graphs for each genus, in this instance


# To add in sex to this, yearly doesn't currently contain this, so need more data

yearly_sex_counts <- surveys_complete %>%
  count(year, genus, sex)

yearly_sex_counts %>%
  ggplot(mapping = aes( x = year, y = n, colour = sex)) +
  geom_line()+
  facet_wrap( facets = vars(genus))

# Multiple Facets

yearly_sex_counts%>%
  ggplot(mapping = aes( x = year, y = n, colour = sex)) +
  geom_line()+
  facet_grid(rows = vars (sex), cols = vars(genus))


yearly_sex_counts%>%
  ggplot(mapping = aes( x = year, y = n, colour = sex)) +
  geom_line()+
  facet_grid(rows = vars(genus))


# Challenge 9
# How would you modify this code so the faceting is organised into only columns instead of only rows?

yearly_sex_counts%>%
  ggplot(mapping = aes( x = year, y = n, colour = sex)) +
  geom_line()+
  facet_grid(cols = vars(genus))

# Themes
# some are pre loaded

ggplot(data = yearly_sex_counts, mapping = aes(x=year, y = n, colour = sex))+
         geom_line()+
         facet_wrap(~genus)+
         theme_bw()


# Other examples
theme_classic()
theme_void ()



# Challenge 10
# Put together what you’ve learned to create a plot that depicts how the average weight of each species changes through the years.

# Hint: need to do a group_by() and summarize() to get the data before plotting

yearly_weight <- surveys_complete %>%
  group_by(year, species_id) %>%
  summarise(mean_weight = mean(weight))  # alternative mean_weight = mean(weight, na.rm = TRUE)), to remove NAs, if present

yearly_weight %>%
  ggplot(mapping = aes(x = year, y = mean_weight, colour = species_id))+
  geom_line()+
  theme_bw()
 
# To get individual graphs/plots for each species id
yearly_weight %>%
  ggplot(mapping = aes(x = year, y = mean_weight, colour = species_id))+
  geom_line()+
  facet_wrap(~species_id)+
  theme_bw()

# To remove colour and thus legend, as not needed for individual plots
yearly_weight %>%
  ggplot(mapping = aes(x = year, y = mean_weight))+
  geom_line()+
  facet_wrap(~species_id)+
  theme_bw()

# Customisation of graphs/plots

yearly_sex_counts %>%
  ggplot(mapping = aes(x = year, y = n, colour = sex))+
  geom_line()+
  facet_wrap(~genus)+
  labs(title = "Observed genera through time",  # Name of title
       x = "Year of observation",               # name of x-axis
       y = "Number of individuals")+            # name of y-axis
  theme_bw()+
  theme(text = element_text(size = 16),         # Increase text size, overall for all (different to do for each component individually)
        axis.text.x = element_text(colour = "grey20", 
                                   size = 12, angle = 90, 
                                   hjust = 0.5,
                                   vjust = 0.5),
        axis.text.y = element_text(colour = "grey20",
                                   size = 12),
        strip.text = element_text(face = "italic"))


# Creation of your own theme, by storing all these options into an object called "grey theme"
grey_theme <- theme(text = element_text(size = 16),          
      axis.text.x = element_text(colour = "grey20", 
                                 size = 12, angle = 90, 
                                 hjust = 0.5,
                                 vjust = 0.5),
      axis.text.y = element_text(colour = "grey20",
                                 size = 12),
      strip.text = element_text(face = "italic"))

yearly_sex_counts %>%
  ggplot(mapping = aes (x = year, y = n, colour = sex)) +
  geom_line()+
  facet_wrap(~genus)+
  theme_bw()+
  grey_theme


# Exporting Plots

ggsave("figures/my_plot.png", width = 15, height = 10) # default if unspecified in bracket, will be last plot you created
                                                       # can enter the level of resolution here
