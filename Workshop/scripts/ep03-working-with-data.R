#####################
# MANIPULATING DATA #
#       using       #
#     TIDYVERSE     #
#####################
#
#
# Based on: https://datacarpentry.org/R-ecology-lesson/03-dplyr.html

# Data is available from the following link (we should already have it)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

#---------------------
# Learning Objectives
#---------------------

#    Describe the purpose of the dplyr and tidyr packages.
#    Select certain columns in a data frame with the dplyr function select.
#    Select certain rows in a data frame according to filtering conditions with the dplyr function filter .
#    Link the output of one dplyr function to the input of another function with the ‘pipe’ operator %>%.
#    Add new columns to a data frame that are functions of existing columns with mutate.
#    Use the split-apply-combine concept for data analysis.
#    Use summarize, group_by, and count to split a data frame into groups of observations, apply summary statistics for each group, and then combine the results.
#    Describe the concept of a wide and a long table format and for which purpose those formats are useful.
#    Describe what key-value pairs are.
#    Reshape a data frame from long to wide format and back with the pivit_wider and pivit_longer commands from the tidyr package.
#    Export a data frame to a .csv file.
#----------------------

#------------------
# Lets get started!
#------------------

install.packages("tidyverse")
library(tidyverse)
#dplyr and tidyr will be discussed today

# Load the dataset
surveys <- read_csv("data_raw/portal_data_joined.csv")

# check the structure - taking note of the classes in output in Consule screen
str(surveys)



#-----------------------------------
# Selecting columns & filtering rows
#-----------------------------------
select(surveys, plot_id, species_id, weight)

# Alt way to leave things out of data frame you are shown in Console output
select(surveys, -record_id, -species_id)

# Filter for a particular year
filter(surveys, year == 1995)

# To save filters for later (run and then it will show up in your environment window to right)
surveys_1995 <- filter(surveys, year == 1995)

surveys2 <- filter(surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)

# combine together to reduce confusion (will give you same outcome as the above)
surveys_sml <- select(filter(surveys, weight <5), species_id, sex, weight)


#-------
# Pipes
#-------
# The pipe --> %>%
# Shortcut --> Ctrl + shift + m

surveys %>% 
  filter(weight <5) %>% 
  select(species_id, sex, weight)

# Assign the above to surveys_sml
surveys_sml <- surveys %>% 
  filter(weight <5) %>% 
  select(species_id, sex, weight)

# If you put select first - Errors and performance inpact. As ...
# Will provide same output, but may end up removing or filtering twice - therefore, avoid doing this way
# If you removed weight from line 86, if you filter from weight on line 87, it can no longer find as no longer exists!
surveys_sml2 <- surveys %>% 
  select(species_id, sex, weight) %>% 
  filter(weight < 5)

#-----------
# CHALLENGE
#-----------

# Using pipes, subset the ```surveys``` data to include animals collected before 1995 and 
# retain only the columns ```year```, ```sex```, and ```weight```.

# ordering of your columns DOES matter!
surveys_1995 <- surveys %>% 
  filter(year < 1995) %>%   
  select(year, sex, weight)



#--------
# Mutate
#--------
# add new columns weight_kg and weight_lb
surveys_weights <- surveys %>% 
  mutate(weight_kg = weight / 1000,
         weight_lb = weight_kg * 2.2) %>% 
  
  surveys %>% 
  mutate(weight_kg = weight / 1000,
         weight_lb = weight_kg * 2.2) %>% 
  head()

# Remove na's in weight column then add new col weight_kg
surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg = weight/1000) %>% 
  head()

filter(length != "")

#-----------
# CHALLENGE
#-----------

# Create a new data frame from the ```surveys``` data that meets the following criteria: 
# contains only the ```species_id``` column and a new column called ```hindfoot_cm``` containing 
# the ```hindfoot_length``` values converted to centimeters. In this hindfoot_cm column, 
# there are no ```NA```s and all values are less than 3.

# Hint: think about how the commands should be ordered to produce this data frame!

surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  mutate(hindfoot_cm = hindfoot_length / 10) %>% 
  filter(hindfoot_cm < 3) %>% 
  select(species_id, hindfoot_cm)

surveys_hindfoot <- surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  mutate(hindfoot_cm = hindfoot_length / 10) %>% 
  filter(hindfoot_cm < 3) %>% 
  select(species_id, hindfoot_cm)


#---------------------
# Split-apply-combine
#---------------------

# Summarise weight

# Group weight by sex after removing NAs in weight column 
surveys %>% 
  group_by(sex) %>% 
  summarise(mean_weight = mean(weight, na.rm = TRUE))

summary(surveys)
?summarize # find out information on summarize

surveys$sex <- as.factor(surveys$sex)

# Summarise weights by sex and species_id afte removing 
# nas from sex and weight.
surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight)) %>% 
  print(n=20) # print 20 rows to console

# Group the weights by sex and species_id
# Order the table by min_weight and in descending order
surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),
            min_weight = min(weight)) %>% 
  arrange(desc(min_weight))

# Obtain the counts of each sex
surveys %>% 
  group_by(sex) %>% 
  summarise(count = n())

surveys_new <- surveys %>% 
  group_by(sex, species, taxa) %>% 
  summarise(count = n()) %>% 
  ungroup


#-----------
# CHALLENGE
#-----------

# 1. How many animals were caught in each ```plot_type``` surveyed?

surveys %>% count(plot_type)

num_animals <- surveys %>% 
  group_by(plot_type) %>% 
  summarise(number_of_animals = n())

# 2. Use ```group_by()``` and ```summarize()``` to find the mean, min, and max hindfoot length 
#    for each species (using ```species_id```). Also add the number of observations 
#    (hint: see ```?n```).

hindfoot_info <- surveys %>%
  filter(!is.na(hindfoot_length)) %>% 
  group_by(species_id) %>% 
  summarise(mean_length = mean(hindfoot_length),
            min_length = min(hindfoot_length), 
            max_length = max(hindfoot_length),
            count = n())


# 3. What was the heaviest animal measured in each year? 
#    Return the columns ```year```, ```genus```, ```species_id```, and ```weight```.

heaviest_year <- surveys %>% 
  group_by(year) %>% 
  mutate(max_weight = max(weight,na.rm = TRUE)) %>% 
  ungroup()


surveys %>%
  filter(!is.na(weight)) %>%
  group_by(year) %>%
  filter(weight == max(weight)) %>%
  select(year, genus, species, weight) %>%
  arrange(year)


#-----------
# Reshaping
#-----------







#-----------
# CHALLENGE
#-----------

# 1. Spread the surveys data frame with year as columns, plot_id as rows, 
#    and the number of genera per plot as the values. You will need to summarize before reshaping, 
#    and use the function n_distinct() to get the number of unique genera within a particular chunk of data. 
#    It’s a powerful function! See ?n_distinct for more.

# 2. Now take that data frame and pivot_longer() it again, so each row is a unique plot_id by year combination.

# 3. The surveys data set has two measurement columns: hindfoot_length and weight. 
#    This makes it difficult to do things like look at the relationship between mean values of each 
#    measurement per year in different plot types. Let’s walk through a common solution for this type of problem. 
#    First, use pivot_longer() to create a dataset where we have a key column called measurement and a value column that 
#    takes on the value of either hindfoot_length or weight. 
#    Hint: You’ll need to specify which columns are being pivoted.

# 4. With this new data set, calculate the average of each measurement in each year for each different plot_type. 
#    Then pivot_wider() them into a data set with a column for hindfoot_length and weight. 
#    Hint: You only need to specify the key and value columns for pivot_wider().





#----------------
# Exporting data
#----------------












